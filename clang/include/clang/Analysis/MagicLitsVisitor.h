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

  bool VisitIntegerLiteral(IntegerLiteral *Literal);

  bool VisitFloatingLiteral(FloatingLiteral *Literal);

  bool VisitCXXNullPtrLiteralExpr(CXXNullPtrLiteralExpr *Literal);

  bool VisitStringLiteral(StringLiteral *Literal);

  bool VisitCharacterLiteral(CharacterLiteral *Literal);

  bool VisitCXXBoolLiteralExpr(CXXBoolLiteralExpr *Literal);
};