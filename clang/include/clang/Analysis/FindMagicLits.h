#ifndef FIND_MAGIC_LITS_H
#define FIND_MAGIC_LITS_H 
#include "clang/AST/Stmt.h"
#include "clang/Frontend/FrontendActions.h"
#include "clang/Tooling/CommonOptionsParser.h"
#include "clang/Tooling/Tooling.h"
#include "llvm/Support/CommandLine.h"
#include "clang/AST/ASTContext.h"
#include "clang/AST/ASTTypeTraits.h"
#include "clang/AST/ParentMapContext.h"
#include "clang/AST/ExprCXX.h"
#include <vector>
#include <string.h>


namespace clang{
enum return_state {compliant, non_compliant, manual_check};

class FindMagicLits {
public:
  explicit FindMagicLits(ASTContext *Context) : Context(Context) {}

  template<typename T>
  bool CheckLiteral(T* Literal){
    const auto& parents = Context->getParents(*Literal);
    DynTypedNode parent = parents[0];
    if(CheckParents(parent) == non_compliant){
      if(!diagIgnore(Literal->getBeginLoc())){
        warnings.push_back(Context->getFullLoc(Literal->getBeginLoc()));
      } 
    }
    return true;
  }

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
}
#endif //FIND_MAGIC_LITS_H