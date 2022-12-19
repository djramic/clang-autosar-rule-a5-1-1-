#include "clang/Analysis/FindMagicLits.h"
#include "clang/Basic/Diagnostic.h"

using namespace clang;

return_state FindMagicLits::CheckParents(DynTypedNode parent){
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

bool FindMagicLits::VisitIntegerLiteral(IntegerLiteral* Literal){
  if(Literal->getLocation().isMacroID()){
    return true;
  }
  return CheckLiteral(Literal);
}

bool FindMagicLits::VisitFloatingLiteral(FloatingLiteral *Literal) {
  if(Literal->getLocation().isMacroID()){
    return true;
  }
  return CheckLiteral(Literal);
}

bool FindMagicLits::VisitCXXNullPtrLiteralExpr(CXXNullPtrLiteralExpr *Literal){
  if(Literal->getLocation().isMacroID()){
    return true;
  }
  return CheckLiteral(Literal);
}

bool FindMagicLits::VisitStringLiteral(StringLiteral *Literal) {
  return CheckLiteral(Literal);
}

bool FindMagicLits::VisitCharacterLiteral(CharacterLiteral *Literal) {
  if(Literal->getLocation().isMacroID()){
    return true;
  }
  constexpr char EscapeSequences[] = {
      '\b', '\f', '\n', '\r', '\t', '\v', '\\', '\'', '\"', '\?', '\0'
  };
  if(std::find(std::begin(EscapeSequences), std::end(EscapeSequences), Literal->getValue()) != std::end(EscapeSequences))
    return true;
  return CheckLiteral(Literal);
}

bool FindMagicLits::VisitCXXBoolLiteralExpr(CXXBoolLiteralExpr *Literal){
  if(Literal->getLocation().isMacroID()){
    return true;
  }
  return CheckLiteral(Literal);
}

const std::vector<FullSourceLoc> &FindMagicLits::getWarnings() const{ 
  return warnings;
}

bool FindMagicLits::diagIgnore(SourceLocation WL){
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

std::pair<size_t, size_t> FindMagicLits::getLineStartAndEnd(StringRef Buffer,
                                                    size_t From) {
  size_t StartPos = Buffer.find_last_of('\n', From) + 1;
  size_t EndPos = std::min(Buffer.find('\n', From), Buffer.size());
  return std::make_pair(StartPos, EndPos);
}

bool FindMagicLits::lineHasIgnore(StringRef Buffer, std::pair<size_t, size_t> LineStartAndEnd){
  Buffer = Buffer.slice(LineStartAndEnd.first, LineStartAndEnd.second);
  std::string Buffer1 = removeSpace(Buffer);
  static constexpr llvm::StringLiteral IGNORE = "//ignore:autosar[a5-1-1]";
  if(Buffer1.find(IGNORE)!= StringRef::npos)
    return true;
  return false;
}

std::string FindMagicLits::removeSpace(StringRef buffer){
  std::string buf = buffer.str();
  auto end_pos = std::remove(buf.begin(), buf.end(), ' ');
  buf.erase(end_pos,buf.end());
  for(auto &elem : buf){
    elem = tolower(elem);
  }
  return buf;
}