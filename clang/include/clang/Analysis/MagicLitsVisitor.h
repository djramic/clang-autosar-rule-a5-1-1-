#ifndef MAGIC_LITS_VISITOR_H
#define MAGIC_LITS_VISITOR_H
#include "clang/AST/Stmt.h"
#include "clang/AST/RecursiveASTVisitor.h"
#include "clang/AST/ParentMapContext.h"
#include "clang/Basic/SourceManager.h"
#include "clang/Basic/SourceLocation.h"
#include "clang/Basic/TargetInfo.h"
#include "clang/Analysis/FindMagicLits.h"

#include <vector>
#include <string.h>

using namespace clang;


class MagicLitsVisitor
    : public RecursiveASTVisitor<MagicLitsVisitor>, public FindMagicLits {
public:
  explicit MagicLitsVisitor(clang::ASTContext *Context) : FindMagicLits(Context){}

  bool VisitIntegerLiteral(IntegerLiteral *Literal){
    if(Literal->getLocation().isMacroID()){
      return true;
    } 
    return CheckLiteral(Literal);
  }

  bool VisitFloatingLiteral(FloatingLiteral *Literal){
    if(Literal->getLocation().isMacroID()){
      return true;
    } 
    return CheckLiteral(Literal);
  }

  bool VisitCXXNullPtrLiteralExpr(CXXNullPtrLiteralExpr *Literal){
    return CheckLiteral(Literal);
  }

  bool VisitStringLiteral(StringLiteral *Literal){
    return CheckLiteral(Literal);
  }

  bool VisitCharacterLiteral(CharacterLiteral *Literal){
    constexpr char EscapeSequences[] = {
      '\b', '\f', '\n', '\r', '\t', '\v', '\\', '\'', '\"', '\?', '\0'
    };
    if(std::find(std::begin(EscapeSequences), std::end(EscapeSequences), Literal->getValue()) != std::end(EscapeSequences))
      return true;
    return CheckLiteral(Literal);
  }

  bool VisitCXXBoolLiteralExpr(CXXBoolLiteralExpr *Literal){
     return CheckLiteral(Literal);
  }
};
#endif //MAGIC_LITS_VISITOR_H