#include "clang/Analysis/FindMagicLits.h"
#include "clang/Basic/Diagnostic.h"


bool FindMagicLits1::VisitIntegerLiteral(IntegerLiteral* Literal){
  if(Literal->getLocation().isMacroID()){
    return true;
  }
  return CheckLiteral(Literal);
}

bool FindMagicLits1::VisitFloatingLiteral(FloatingLiteral *Literal) {
  if(Literal->getLocation().isMacroID()){
    return true;
  }
  return CheckLiteral(Literal);
}

bool FindMagicLits1::VisitCXXNullPtrLiteralExpr(CXXNullPtrLiteralExpr *Literal){
  return CheckLiteral(Literal);
}

bool FindMagicLits1::VisitStringLiteral(StringLiteral *Literal) {
  return CheckLiteral(Literal);
}

bool FindMagicLits1::VisitCharacterLiteral(CharacterLiteral *Literal) {
  constexpr char EscapeSequences[] = {
      '\b', '\f', '\n', '\r', '\t', '\v', '\\', '\'', '\"', '\?', '\0'
  };
  if(std::find(std::begin(EscapeSequences), std::end(EscapeSequences), Literal->getValue()) != std::end(EscapeSequences))
    return true;
  return CheckLiteral(Literal);
}

bool FindMagicLits1::VisitCXXBoolLiteralExpr(CXXBoolLiteralExpr *Literal){
  return CheckLiteral(Literal);
}