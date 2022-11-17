#include "clang/Frontend/FrontendActions.h"
#include "clang/Tooling/CommonOptionsParser.h"
#include "clang/Tooling/Tooling.h"
#include "llvm/Support/CommandLine.h"
#include "clang/ASTMatchers/ASTMatchers.h"
#include "clang/ASTMatchers/ASTMatchFinder.h"
#include "clang/AST/ASTContext.h"

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
  void PrintWarning(FullSourceLoc FullLocation){
    llvm::outs()<<FullLocation.getExpansionLineNumber() 
                <<":"<< FullLocation.getExpansionColumnNumber()
                <<": warning: use of magic number ' - "
                //<<value
                << "'\n"; 
  }

  template<typename T> 
  bool VisitLiteral(T* Literal){
    if(!Context->getSourceManager().isInMainFile(Literal->getBeginLoc())){
      return true;
    }
    const auto& parents = Context->getParents(*Literal);
    DynTypedNode parent = parents[0];
    FullSourceLoc FullLocation = Context->getFullLoc(Literal->getBeginLoc());
    if(!CheckLiteral(parent)){
        PrintWarning(FullLocation);
    }
    return true;
  }

  bool CheckLiteral(DynTypedNode parent){
    const Stmt* ST = NULL;
    ST = parent.get<Stmt>();
    if(!ST){
      return true;
    }
    constexpr Stmt::StmtClass Classes[] = {
      Stmt::CallExprClass,
      Stmt::ForStmtClass,
      Stmt::IfStmtClass,
      Stmt::SwitchStmtClass,
      Stmt::ConditionalOperatorClass,
      Stmt::CaseStmtClass,
      Stmt::ReturnStmtClass,
      Stmt::DoStmtClass,
      Stmt::CXXOperatorCallExprClass,
      Stmt::WhileStmtClass,
      Stmt::CXXFunctionalCastExprClass,
      Stmt::ArraySubscriptExprClass
        //
    };
    while(ST){
      const Stmt::StmtClass class_id = ST->getStmtClass();

      if(class_id == Stmt::BinaryOperatorClass){
          const BinaryOperator* BO = parent.get<BinaryOperator>();
          if(BO->getOpcode() == BinaryOperator::Opcode::BO_Assign){ 
            return true;
          }  
      }
      if(class_id == Stmt::CXXConstructExprClass){
        return true;
      }
      if(class_id == Stmt::CXXOperatorCallExprClass){
        const CXXOperatorCallExpr* OC = parent.get<CXXOperatorCallExpr>();
        if(OC->getOperator() == OverloadedOperatorKind::OO_LessLess) { 
          return true;
        }
        return false;
      }

      if(std::find(std::begin(Classes),std::end(Classes),class_id) != std::end(Classes)){
        return false;
      }

      const auto& parents = Context->getParents(*ST);
      parent = parents[0];
      ST = parent.get<Stmt>();
    }
  return true;
  }

  
private:
  ASTContext *Context;
};

static llvm::cl::OptionCategory MyToolCategory("my-tool options");

int main(int argc, const char **argv) {
  auto ExpectedParser = CommonOptionsParser::create(argc, argv, MyToolCategory);
  if (!ExpectedParser) {
    llvm::errs() << ExpectedParser.takeError();
    return 1;
  }
  CommonOptionsParser& OptionsParser = ExpectedParser.get();
  ClangTool Tool(OptionsParser.getCompilations(),
                 OptionsParser.getSourcePathList());
                 
  FindMagicLits Matcher;
  MatchFinder Finder;
  for(StatementMatcher LM : LitMatcher)
    Finder.addMatcher(LM, &Matcher);

  return Tool.run(newFrontendActionFactory(&Finder).get());
}
