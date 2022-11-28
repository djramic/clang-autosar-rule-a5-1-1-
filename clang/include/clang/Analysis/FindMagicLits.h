#include "clang/AST/Stmt.h"
#include "clang/AST/RecursiveASTVisitor.h"
#include "clang/AST/ParentMapContext.h"
#include "clang/Basic/SourceManager.h"
#include "clang/Basic/SourceLocation.h"
#include "clang/Basic/TargetInfo.h"
#include "clang/Analysis/Core.h"

#include <vector>
#include <string.h>

using namespace clang;


class FindMagicLits1
    : public RecursiveASTVisitor<FindMagicLits1>, public CoreLogic {
public:
  explicit FindMagicLits1(clang::ASTContext *Context) : CoreLogic(Context){}

  bool VisitIntegerLiteral(IntegerLiteral *Literal);

  bool VisitFloatingLiteral(FloatingLiteral *Literal);

  bool VisitCXXNullPtrLiteralExpr(CXXNullPtrLiteralExpr *Literal);

  bool VisitStringLiteral(StringLiteral *Literal);

  bool VisitCharacterLiteral(CharacterLiteral *Literal);

  bool VisitCXXBoolLiteralExpr(CXXBoolLiteralExpr *Literal);
};