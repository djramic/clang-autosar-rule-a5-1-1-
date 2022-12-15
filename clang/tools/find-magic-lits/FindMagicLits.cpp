#include "clang/Frontend/FrontendActions.h"
#include "clang/Tooling/CommonOptionsParser.h"
#include "clang/Tooling/Tooling.h"
#include "llvm/Support/CommandLine.h"
#include "clang/ASTMatchers/ASTMatchers.h"
#include "clang/ASTMatchers/ASTMatchFinder.h"
#include "clang/AST/ASTContext.h"
#include "clang/Analysis/FindMagicLits.h"
#include "clang/Frontend/CompilerInstance.h"

using namespace llvm;
using namespace clang;
using namespace clang::tooling;
using namespace clang::ast_matchers;



class FindMagicLitsConsumer : public clang::ASTConsumer {
public:
  explicit FindMagicLitsConsumer(ASTContext *Context) {}

  virtual void HandleTranslationUnit(clang::ASTContext &Context) override{
    FindMagicLits Matcher(&Context);
    Warnings = Matcher.getWarnings();
    clang::DiagnosticsEngine &DE = Context.getDiagnostics();
    const auto ID = DE.getCustomDiagID(clang::DiagnosticsEngine::Warning,
                                   "Autosar[A5-1-1]: Use symbolic names instead of "
                                   "literal values in code.");
    for(FullSourceLoc WL : Warnings){
      auto DB = DE.Report(WL, ID);
      auto Range = Context.getSourceManager().getExpansionRange(WL);
      DB.AddSourceRange(Range);
    }
 }
private:
  std::vector<FullSourceLoc> Warnings;
};

class FindMagicLitsAction : public clang::ASTFrontendAction {
public:
  virtual std::unique_ptr<clang::ASTConsumer>
  CreateASTConsumer(clang::CompilerInstance &Compiler, llvm::StringRef InFile) override {
    return std::make_unique<FindMagicLitsConsumer>(&Compiler.getASTContext());
  }
};

static llvm::cl::OptionCategory MyToolCategory("my-tool options");

int main(int argc, const char **argv) {
  auto ExpectedParser = tooling::CommonOptionsParser::create(argc, argv, MyToolCategory);
  if (!ExpectedParser) {
    llvm::errs() << ExpectedParser.takeError();
    return 1;
  }
  
  tooling::CommonOptionsParser& OptionsParser = ExpectedParser.get();
  tooling::ClangTool Tool(OptionsParser.getCompilations(),
                 OptionsParser.getSourcePathList());

  return Tool.run(newFrontendActionFactory<FindMagicLitsAction>().get());
}
