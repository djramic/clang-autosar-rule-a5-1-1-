#include "clang/Frontend/FrontendActions.h"
#include "clang/Tooling/CommonOptionsParser.h"
#include "clang/Tooling/Tooling.h"
#include "llvm/Support/CommandLine.h"
#include "clang/ASTMatchers/ASTMatchers.h"
#include "clang/ASTMatchers/ASTMatchFinder.h"
#include "clang/AST/ASTContext.h"
#include "clang/Analysis/FindMagicLits.h"
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

class MagicLitsMch : public MatchFinder::MatchCallback, public FindMagicLits{
public:
  explicit MagicLitsMch(ASTContext *Context) : FindMagicLits(Context){}
  virtual void run(const MatchFinder::MatchResult &Result) override{
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
};