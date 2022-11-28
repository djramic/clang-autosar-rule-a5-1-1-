#include "clang/Frontend/FrontendActions.h"
#include "clang/Tooling/CommonOptionsParser.h"
#include "clang/Tooling/Tooling.h"
#include "llvm/Support/CommandLine.h"
#include "clang/ASTMatchers/ASTMatchers.h"
#include "clang/ASTMatchers/ASTMatchFinder.h"
#include "clang/AST/ASTContext.h"
#include "clang/AST/ASTConsumer.h"
#include "clang/Analysis/MagicLitsMch.h"
#include "clang/Frontend/CompilerInstance.h"

using namespace llvm;
using namespace clang;
using namespace clang::tooling;
using namespace clang::ast_matchers;

static llvm::cl::OptionCategory MyToolCategory("my-tool options");


class FindMagicLitsConsumer : public clang::ASTConsumer {
public:
  FindMagicLitsConsumer(ASTContext *Context) : Matcher(Context){
    for(StatementMatcher LM : LitMatcher)
      Finder.addMatcher(LM, &Matcher);
  }

  virtual void HandleTranslationUnit(clang::ASTContext &Context){
    Finder.matchAST(Context);
    std::vector<FullSourceLoc> Warnings = Matcher.getWarnings();
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
  FindMagicLits Matcher;
  MatchFinder Finder;
 };

class FindMagicLitsAction : public clang::ASTFrontendAction {
public:
  virtual std::unique_ptr<clang::ASTConsumer>
  CreateASTConsumer(clang::CompilerInstance &Compiler, llvm::StringRef InFile){
    return std::make_unique<FindMagicLitsConsumer>(&Compiler.getASTContext());
  }
};

int main(int argc, const char **argv) {
  auto ExpectedParser = CommonOptionsParser::create(argc, argv, MyToolCategory);
  if (!ExpectedParser) {
    llvm::errs() << ExpectedParser.takeError();
    return 1;
  }
  CommonOptionsParser& OptionsParser = ExpectedParser.get();
  ClangTool Tool(OptionsParser.getCompilations(),
                 OptionsParser.getSourcePathList());
                 
  return Tool.run(newFrontendActionFactory<FindMagicLitsAction>().get());
  }
