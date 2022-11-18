#include "clang/Frontend/FrontendActions.h"
#include "clang/Tooling/CommonOptionsParser.h"
#include "clang/Tooling/Tooling.h"
#include "llvm/Support/CommandLine.h"
#include "clang/ASTMatchers/ASTMatchers.h"
#include "clang/ASTMatchers/ASTMatchFinder.h"
#include "clang/AST/ASTContext.h"
#include <vector>

enum return_state {compliant, non_compliant, manual_check};

using namespace llvm;
using namespace clang;
using namespace clang::tooling;
using namespace clang::ast_matchers;

StatementMatcher LitMatcher[] = {
  integerLiteral().bind("IntLiteral"),
  floatLiteral().bind("FloatLiteral"),
  cxxNullPtrLiteralExpr().bind("NptLiteral"),
  stringLiteral().bind("StrLiteral"),
  characterLiteral().bind("CharLiteral"),
  cxxBoolLiteral().bind("boolLiteral")
};

class FindMagicLits : public MatchFinder::MatchCallback {
public:

  virtual void run(const MatchFinder::MatchResult &Result) {
    Context = Result.Context;
    if (const IntegerLiteral *IL = Result.Nodes.getNodeAs<clang::IntegerLiteral>("IntLiteral")){
      VisitLiteral(IL);  
    }
    if (const FloatingLiteral *FL = Result.Nodes.getNodeAs<clang::FloatingLiteral>("FloatLiteral")){
      VisitLiteral(FL);  
    }
     if (const CXXNullPtrLiteralExpr *NPL = Result.Nodes.getNodeAs<clang::CXXNullPtrLiteralExpr>("NptLiteral")){
      VisitLiteral(NPL);  
    }
     if (const clang::StringLiteral *SL = Result.Nodes.getNodeAs<clang::StringLiteral>("StrLiteral")){
      VisitLiteral(SL);  
    }
     if (const CharacterLiteral *CL = Result.Nodes.getNodeAs<clang::CharacterLiteral>("CharLiteral")){
      VisitLiteral(CL);  
    }
     if (const CXXBoolLiteralExpr *BL = Result.Nodes.getNodeAs<clang::CXXBoolLiteralExpr>("boolLiteral")){
      VisitLiteral(BL);  
    }
  }


  template<typename T> 
  bool VisitLiteral(T* Literal){
    const auto& parents = Context->getParents(*Literal);
    DynTypedNode parent = parents[0];
    if(CheckLiteral(parent) == non_compliant){
        if(!diagIgnore(Literal->getBeginLoc())){
            //warnings.push_back(Context->getFullLoc(Literal->getBeginLoc()));
    clang::DiagnosticsEngine &DE = Context->getDiagnostics();
    const auto ID = DE.getCustomDiagID(clang::DiagnosticsEngine::Warning,
                                   "Autosar[A5-1-1]: Use symbolic names instead of "
                                   "literal values in code.");
    auto DB = DE.Report(Literal->getBeginLoc(), ID);
    auto Range = Context->getSourceManager().getExpansionRange(Literal->getBeginLoc());
    DB.AddSourceRange(Range);
    }
  }
  return true;
  }

  bool CheckLiteral(DynTypedNode parent){
    const Stmt* ST = parent.get<Stmt>();
  if(!ST){
    return compliant;
  }
  constexpr Stmt::StmtClass non_compliant_classes[] = {
    Stmt::CallExprClass,
    Stmt::ForStmtClass,
    Stmt::IfStmtClass,
    Stmt::SwitchStmtClass,
    Stmt::ConditionalOperatorClass,
    Stmt::CaseStmtClass,
    Stmt::ReturnStmtClass,
    Stmt::DoStmtClass,
    Stmt::WhileStmtClass,
    Stmt::CXXFunctionalCastExprClass,
    Stmt::ArraySubscriptExprClass,
    Stmt::CXXMemberCallExprClass
      //
  };

  constexpr Stmt::StmtClass compliant_classes[] = {
    Stmt::CXXConstructExprClass,
    Stmt::InitListExprClass,
    Stmt::CompoundAssignOperatorClass
      //
  };
  while(ST){
    Stmt::StmtClass class_id = ST->getStmtClass();  
    if(class_id == Stmt::BinaryOperatorClass){
      const BinaryOperator* BO = parent.get<BinaryOperator>();
      if(BO->getOpcode() == BinaryOperator::Opcode::BO_Assign){ 
        return compliant;
      }
      return non_compliant;  
    }

    if(class_id == Stmt::CXXOperatorCallExprClass){
      const CXXOperatorCallExpr* OC = parent.get<CXXOperatorCallExpr>();
      if(OC->getOperator() == OverloadedOperatorKind::OO_LessLess) { 
        return compliant;
      }
      return non_compliant;
    }

    if(std::find(std::begin(compliant_classes),std::end(compliant_classes),class_id) != std::end(compliant_classes)){
      return compliant;
    }

    if(std::find(std::begin(non_compliant_classes),std::end(non_compliant_classes),class_id) != std::end(non_compliant_classes)){
      return non_compliant;
    }

    const auto& parents = Context->getParents(*ST);
    parent = parents[0];
    ST = parent.get<Stmt>();
  }
  return compliant;
  }

  const std::vector<FullSourceLoc> &getWarnings() const{
    return warnings;
  }
  bool diagIgnore(SourceLocation WL){
  FileID File;
  unsigned int Pos = 0;
  std::tie(File, Pos) =  Context->getSourceManager().getDecomposedSpellingLoc(WL);
  Optional<StringRef> Buffer = Context->getSourceManager().getBufferDataOrNone(File);
  if(!Buffer){
    return false;
  }
  auto ThisLine = getLineStartAndEnd(*Buffer, Pos);
  auto PrevLine = getLineStartAndEnd(*Buffer, ThisLine.first - 1);
  return lineHasIgnore(*Buffer, PrevLine);
}

std::pair<size_t, size_t> getLineStartAndEnd(StringRef Buffer,
                                                    size_t From) {
  size_t StartPos = Buffer.find_last_of('\n', From) + 1;
  size_t EndPos = std::min(Buffer.find('\n', From), Buffer.size());
  return std::make_pair(StartPos, EndPos);
}

bool lineHasIgnore(StringRef Buffer, std::pair<size_t, size_t> LineStartAndEnd){
  Buffer = Buffer.slice(LineStartAndEnd.first, LineStartAndEnd.second);
  std::string Buffer1 = removeSpace(Buffer);
  llvm::outs() << "Final buffer : \n" << Buffer1;
  static constexpr llvm::StringLiteral IGNORE = "//ignore:autosar[a5-1-1]";
  if(Buffer1.find(IGNORE)!= StringRef::npos)
    return true;
  return false;
}

std::string removeSpace(StringRef buffer){
  std::string buf = buffer.str();
  auto end_pos = std::remove(buf.begin(), buf.end(), ' ');
  buf.erase(end_pos,buf.end());
  for(auto &elem : buf){
    elem = tolower(elem);
  }
  return buf;
}

ASTContext* getContext(){
    return Context;
}

private:
  std::vector<FullSourceLoc> warnings;
  ASTContext *Context;
};