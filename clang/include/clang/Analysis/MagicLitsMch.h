#include "clang/Frontend/FrontendActions.h"
#include "clang/Tooling/CommonOptionsParser.h"
#include "clang/Tooling/Tooling.h"
#include "llvm/Support/CommandLine.h"
#include "clang/ASTMatchers/ASTMatchers.h"
#include "clang/ASTMatchers/ASTMatchFinder.h"
#include "clang/AST/ASTContext.h"
#include "clang/Analysis/Core.h"
#include <vector>


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
  explicit FindMagicLits(ASTContext *Context) : CLG(Context) {}
  virtual void run(const MatchFinder::MatchResult &Result){
    if (const IntegerLiteral *IL = Result.Nodes.getNodeAs<clang::IntegerLiteral>("IntLiteral")){
      CLG.CheckLiteral(IL);  
    }
    if (const FloatingLiteral *FL = Result.Nodes.getNodeAs<clang::FloatingLiteral>("FloatLiteral")){
      CLG.CheckLiteral(FL);  
    }
     if (const CXXNullPtrLiteralExpr *NPL = Result.Nodes.getNodeAs<clang::CXXNullPtrLiteralExpr>("NptLiteral")){
      CLG.CheckLiteral(NPL);  
    }
     if (const clang::StringLiteral *SL = Result.Nodes.getNodeAs<clang::StringLiteral>("StrLiteral")){
      CLG.CheckLiteral(SL);  
    }
     if (const CharacterLiteral *CL = Result.Nodes.getNodeAs<clang::CharacterLiteral>("CharLiteral")){
      CLG.CheckLiteral(CL);  
    }
     if (const CXXBoolLiteralExpr *BL = Result.Nodes.getNodeAs<clang::CXXBoolLiteralExpr>("boolLiteral")){
      CLG.CheckLiteral(BL);  
    }
  }

  const std::vector<FullSourceLoc> &getWarnings() const{
    return CLG.getWarnings();
  }

private:
  std::vector<FullSourceLoc> warnings;
  ASTContext *Context;
  CoreLogic CLG;
};