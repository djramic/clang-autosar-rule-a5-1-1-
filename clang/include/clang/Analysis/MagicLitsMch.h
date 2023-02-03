#ifndef MAGIC_LITS_MCH
#define MAGIC_LITS_MCH 
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
  traverse(TK_IgnoreUnlessSpelledInSource,integerLiteral()).bind("IntLiteral"),
  traverse(TK_IgnoreUnlessSpelledInSource,floatLiteral()).bind("FloatLiteral"),
  traverse(TK_IgnoreUnlessSpelledInSource,cxxNullPtrLiteralExpr()).bind("NptLiteral"),
  traverse(TK_IgnoreUnlessSpelledInSource,stringLiteral()).bind("StrLiteral"),
  traverse(TK_IgnoreUnlessSpelledInSource,characterLiteral()).bind("CharLiteral"),
  traverse(TK_IgnoreUnlessSpelledInSource,cxxBoolLiteral()).bind("boolLiteral")
};

class MagicLitsMch : public MatchFinder::MatchCallback, public FindMagicLits{
public:
  explicit MagicLitsMch(ASTContext *Context) : FindMagicLits(Context){}
  virtual void run(const MatchFinder::MatchResult &Result) override{
    if (const IntegerLiteral *IL = Result.Nodes.getNodeAs<clang::IntegerLiteral>("IntLiteral")){
      if(!IL->getLocation().isMacroID()){
        CheckLiteral(IL);  
      }
    }
    if (const FloatingLiteral *FL = Result.Nodes.getNodeAs<clang::FloatingLiteral>("FloatLiteral")){
      if(!FL->getLocation().isMacroID()){
        CheckLiteral(FL);  
      }
    }
     if (const CXXNullPtrLiteralExpr *NPL = Result.Nodes.getNodeAs<clang::CXXNullPtrLiteralExpr>("NptLiteral")){
      if(!NPL->getLocation().isMacroID()){
        CheckLiteral(NPL);  
      }
    }
     if (const clang::StringLiteral *SL = Result.Nodes.getNodeAs<clang::StringLiteral>("StrLiteral")){
      CheckLiteral(SL);  
    }
     if (const CharacterLiteral *CL = Result.Nodes.getNodeAs<clang::CharacterLiteral>("CharLiteral")){
      if(!CL->getLocation().isMacroID()){
        constexpr char EscapeSequences[] = {
          '\b', '\f', '\n', '\r', '\t', '\v', '\\', '\'', '\"', '\?', '\0'
        };
      if(std::find(std::begin(EscapeSequences), std::end(EscapeSequences), CL->getValue()) == std::end(EscapeSequences))
        CheckLiteral(CL); 
      } 
    }
     if (const CXXBoolLiteralExpr *BL = Result.Nodes.getNodeAs<clang::CXXBoolLiteralExpr>("boolLiteral")){
      if(!BL->getLocation().isMacroID()){
        CheckLiteral(BL); 
      } 
    }
  }
};

#endif //MAGIC_LITS_MCH