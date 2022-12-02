#ifndef FIND_MAGIC_LITS_H
#define FIND_MAGIC_LITS_H 
#include "clang/Frontend/FrontendActions.h"
#include "clang/Tooling/CommonOptionsParser.h"
#include "clang/Tooling/Tooling.h"
#include "llvm/Support/CommandLine.h"
#include "clang/AST/ASTContext.h"
#include <vector>
#include <string.h>

enum return_state {compliant, non_compliant, manual_check};
using namespace clang;

class FindMagicLits {
public:
  explicit FindMagicLits(ASTContext *Context) : Context(Context) {}

  template<typename T>
  bool CheckLiteral(T* Literal);

  bool CheckParents(DynTypedNode parent);

  const std::vector<FullSourceLoc> &getWarnings() const{
    return warnings;
  }
  bool diagIgnore(SourceLocation WL);

  std::pair<size_t, size_t> getLineStartAndEnd(StringRef Buffer, size_t From);

  bool lineHasIgnore(StringRef Buffer, std::pair<size_t, size_t> LineStartAndEnd);

  std::string removeSpace(StringRef buffer);
  private:
    ASTContext *Context;
    std::vector<FullSourceLoc> warnings;
};
#endif //FIND_MAGIC_LITS_H