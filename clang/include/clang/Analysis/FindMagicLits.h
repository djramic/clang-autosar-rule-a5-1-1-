
#ifndef FIND_MAGIC_LITS_H
#define FIND_MAGIC_LITS_H
#include "clang/AST/Stmt.h"
#include "clang/AST/RecursiveASTVisitor.h"
#include "clang/AST/ParentMapContext.h"
#include "clang/Basic/SourceManager.h"
#include "clang/Basic/SourceLocation.h"
#include "clang/Basic/TargetInfo.h"

#include <vector>
#include <string.h>

enum return_state {compliant, non_compliant};

namespace clang {

class FindMagicLits
    : public RecursiveASTVisitor<FindMagicLits> {
public:
  explicit FindMagicLits(clang::ASTContext *Context)
    : Context(Context){}

  return_state CheckParents(DynTypedNode parent);

  template<typename T> 
  bool CheckLiteral(T *Literal);

  bool VisitIntegerLiteral(IntegerLiteral *Literal);

  bool VisitFloatingLiteral(FloatingLiteral *Literal);

  bool VisitCXXNullPtrLiteralExpr(CXXNullPtrLiteralExpr *Literal);

  bool VisitStringLiteral(StringLiteral *Literal);

  bool VisitCharacterLiteral(CharacterLiteral *Literal);

  bool VisitCXXBoolLiteralExpr(CXXBoolLiteralExpr *Literal);

  bool isIgnored(FullSourceLoc FL);

  const std::vector<FullSourceLoc> &getWarnings() const;

  bool diagIgnore(SourceLocation WL);

  std::string removeSpace(StringRef buffer);

  std::pair<size_t, size_t> getLineStartAndEnd(StringRef Buffer,
                                                    size_t From);

  bool lineHasIgnore(StringRef Buffer, std::pair<size_t, size_t> LineStartAndEnd);

private:
  clang::ASTContext* Context;
  std::vector<FullSourceLoc> warnings;
};

} //namespace clang

#endif //FIND_MAGIC_LITS_H