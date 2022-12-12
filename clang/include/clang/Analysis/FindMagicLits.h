#ifndef FIND_MAGIC_LITS_H
#define FIND_MAGIC_LITS_H
#include "clang/Frontend/FrontendActions.h"
#include "clang/Tooling/CommonOptionsParser.h"
#include "clang/Tooling/Tooling.h"
#include "llvm/Support/CommandLine.h"
#include "clang/ASTMatchers/ASTMatchers.h"
#include "clang/ASTMatchers/ASTMatchFinder.h"
#include "clang/AST/ASTContext.h"
#include <vector>

enum return_state {compliant, non_compliant};

using namespace llvm;
using namespace clang;
using namespace clang::tooling;
using namespace clang::ast_matchers;

class FindMagicLits : public MatchFinder::MatchCallback {
public:

  FindMagicLits(ASTContext* Context) : Context(Context) {
    StatementMatcher LitMatcher[] = {
      integerLiteral().bind("IntLiteral"),
      floatLiteral().bind("FloatLiteral"),
      cxxNullPtrLiteralExpr().bind("NptLiteral"),
      stringLiteral().bind("StrLiteral"),
      characterLiteral().bind("CharLiteral"),
      cxxBoolLiteral().bind("boolLiteral")
    };

    for(StatementMatcher LM : LitMatcher)
      Finder.addMatcher(LM, this);

    Finder.matchAST(*Context);
  }

  virtual void run(const MatchFinder::MatchResult &Result) {

    if (const IntegerLiteral *IL = Result.Nodes.getNodeAs<clang::IntegerLiteral>("IntLiteral")){
      CheckLiteral(IL);  
    }
    if (const FloatingLiteral *FL = Result.Nodes.getNodeAs<clang::FloatingLiteral>("FloatLiteral")){
      CheckLiteral(FL);  
    }
     if (const CXXNullPtrLiteralExpr *NPL = Result.Nodes.getNodeAs<clang::CXXNullPtrLiteralExpr>("NptLiteral")){
      CheckLiteral(NPL);  
    }
     if (const clang::StringLiteral *SL = Result.Nodes.getNodeAs<clang::StringLiteral>("StrLiteral")){
      CheckLiteral(SL);  
    }
     if (const CharacterLiteral *CL = Result.Nodes.getNodeAs<clang::CharacterLiteral>("CharLiteral")){
      CheckLiteral(CL);  
    }
     if (const CXXBoolLiteralExpr *BL = Result.Nodes.getNodeAs<clang::CXXBoolLiteralExpr>("boolLiteral")){
      CheckLiteral(BL);  
    }
  }


  template<typename T> 
  bool CheckLiteral(T* Literal){
    const auto& parents = Context->getParents(*Literal);
    DynTypedNode parent = parents[0];
    if(CheckParents(parent) == non_compliant){
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

  return_state CheckParents(DynTypedNode parent);

  const std::vector<FullSourceLoc> &getWarnings() const{
    return warnings;
  }
  bool diagIgnore(SourceLocation WL);

  std::pair<size_t, size_t> getLineStartAndEnd(StringRef Buffer, size_t From) ;

  bool lineHasIgnore(StringRef Buffer, std::pair<size_t, size_t> LineStartAndEnd);

  std::string removeSpace(StringRef buffer);

private:
  std::vector<FullSourceLoc> warnings;
  ASTContext *Context;
  MatchFinder Finder;
};

#endif //FIND_MAGIC_LITS_H