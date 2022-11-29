#include "clang/Analysis/MagicLitsVisitor.h"
#include "clang/Basic/Diagnostic.h"


bool MagicLitsVisitor::VisitIntegerLiteral(IntegerLiteral* Literal){
  if(Literal->getLocation().isMacroID()){
    return true;
  }
  return CheckLiteral(Literal);
}

bool MagicLitsVisitor::VisitFloatingLiteral(FloatingLiteral *Literal) {
  if(Literal->getLocation().isMacroID()){
    return true;
  }
  return CheckLiteral(Literal);
}

bool MagicLitsVisitor::VisitCXXNullPtrLiteralExpr(CXXNullPtrLiteralExpr *Literal){
  return CheckLiteral(Literal);
}

bool MagicLitsVisitor::VisitStringLiteral(StringLiteral *Literal) {
  return CheckLiteral(Literal);
}

bool MagicLitsVisitor::VisitCharacterLiteral(CharacterLiteral *Literal) {
  constexpr char EscapeSequences[] = {
      '\b', '\f', '\n', '\r', '\t', '\v', '\\', '\'', '\"', '\?', '\0'
  };
  if(std::find(std::begin(EscapeSequences), std::end(EscapeSequences), Literal->getValue()) != std::end(EscapeSequences))
    return true;
  return CheckLiteral(Literal);
}

bool MagicLitsVisitor::VisitCXXBoolLiteralExpr(CXXBoolLiteralExpr *Literal){
  return CheckLiteral(Literal);
}