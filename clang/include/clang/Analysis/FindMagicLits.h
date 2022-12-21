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



namespace clang{
namespace ast_matchers{

enum return_state {compliant, non_compliant};

class FindMagicLits : public MatchFinder::MatchCallback {
public:

  FindMagicLits(ASTContext* Context) : Context(Context) {
    StatementMatcher LitMatcher[] = {
      traverse(TK_IgnoreUnlessSpelledInSource,integerLiteral()).bind("IntLiteral"),
      traverse(TK_IgnoreUnlessSpelledInSource,floatLiteral()).bind("FloatLiteral"),
      traverse(TK_IgnoreUnlessSpelledInSource,cxxNullPtrLiteralExpr()).bind("NptLiteral"),
      traverse(TK_IgnoreUnlessSpelledInSource,stringLiteral()).bind("StrLiteral"),
      traverse(TK_IgnoreUnlessSpelledInSource,characterLiteral()).bind("CharLiteral"),
      traverse(TK_IgnoreUnlessSpelledInSource,cxxBoolLiteral()).bind("boolLiteral")
    };

    for(StatementMatcher LM : LitMatcher)
      Finder.addMatcher(LM, this);

    Finder.matchAST(*Context);
  }

  virtual void run(const ast_matchers::MatchFinder::MatchResult &Result) override {

    if (const IntegerLiteral *IL = Result.Nodes.getNodeAs<clang::IntegerLiteral>("IntLiteral")){
      if(!IL->getLocation().isMacroID()){
        CheckLiteral(IL);  
      }
    }
    if (const FloatingLiteral *FL = Result.Nodes.getNodeAs<clang::FloatingLiteral>("FloatLiteral")){
      if(!FL->getLocation().isMacroID())
        CheckLiteral(FL);    
    }
     if (const CXXNullPtrLiteralExpr *NPL = Result.Nodes.getNodeAs<clang::CXXNullPtrLiteralExpr>("NptLiteral")){
      if(!NPL->getLocation().isMacroID())
        CheckLiteral(NPL);    
    }
     if (const clang::StringLiteral *SL = Result.Nodes.getNodeAs<clang::StringLiteral>("StrLiteral")){
        CheckLiteral(SL);    
    }
     if (const CharacterLiteral *CL = Result.Nodes.getNodeAs<clang::CharacterLiteral>("CharLiteral")){
      if(!CL->getLocation().isMacroID()){
        CheckLiteral(CL);    
      }
    }
     if (const CXXBoolLiteralExpr *BL = Result.Nodes.getNodeAs<clang::CXXBoolLiteralExpr>("boolLiteral")){
      if(!BL->getLocation().isMacroID())
        CheckLiteral(BL);   
    }
  }

  template<typename T> 
  bool CheckLiteral(T* Literal){
    const auto& parents = Context->getParents(*Literal);
    DynTypedNode parent = parents[0];
    if(CheckParents(parent) == non_compliant){
      if(!diagIgnore(Literal->getBeginLoc())){
        warnings.push_back(Context->getFullLoc(Literal->getBeginLoc()));
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
  ast_matchers::MatchFinder Finder;
};

}
}

#endif //FIND_MAGIC_LITS_H