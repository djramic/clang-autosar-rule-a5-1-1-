#include "clang/AST/Stmt.h"
#include "clang/AST/ASTConsumer.h"
#include "clang/AST/RecursiveASTVisitor.h"
#include "clang/Analysis/MagicLitsVisitor.h"
#include "clang/Analysis/MagicLitsMch.h"
#include "clang/Basic/Diagnostic.h"
#include "clang/Basic/SourceLocation.h"
#include "clang/Basic/SourceManager.h"
#include "clang/Frontend/CompilerInstance.h"
#include "clang/Frontend/FrontendAction.h"
#include "clang/Tooling/Tooling.h"
#include "clang/Tooling/CommonOptionsParser.h"
#include "clang/AST/ParentMapContext.h"
#include "clang/AST/RawCommentList.h"
#include "string.h"
#include <algorithm>

using namespace clang;
using namespace clang::tooling;
using namespace llvm;

static llvm::cl::OptionCategory MyToolCategory("find-magic-lits options");
bool useMchOpt = false;

class FindMagicLitsConsumer : public clang::ASTConsumer {
public:
  explicit FindMagicLitsConsumer(ASTContext *Context){}

  virtual void HandleTranslationUnit(clang::ASTContext &Context){
    if(useMchOpt){
      MagicLitsMch Matcher(&Context);
      MatchFinder Finder;
      for(StatementMatcher LM : LitMatcher)
        Finder.addMatcher(LM, &Matcher);
      Finder.matchAST(Context);
      Warnings = Matcher.getWarnings();
    }

    else{
      MagicLitsVisitor Visitor(&Context);
      Visitor.TraverseDecl(Context.getTranslationUnitDecl()); 
      Warnings = Visitor.getWarnings();
    }
    
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
  CreateASTConsumer(clang::CompilerInstance &Compiler, llvm::StringRef InFile) {
    return std::make_unique<FindMagicLitsConsumer>(&Compiler.getASTContext());
  }
};

int main(int argc, const char **argv) {
  cl::opt<bool> usingMatcher("useMatcher",
                  cl::desc("Use matcher to search literals over the AST"),
                  cl::cat(MyToolCategory));
                  
  auto ExpectedParser = tooling::CommonOptionsParser::create(argc, argv, MyToolCategory);
  if (!ExpectedParser) {
    llvm::errs() << ExpectedParser.takeError();
    return 1;
  }

  useMchOpt =  usingMatcher.getValue();
  llvm::outs() << "Use matcher option  : " << useMchOpt << "\n"; 

  tooling::CommonOptionsParser& OptionsParser = ExpectedParser.get();
  tooling::ClangTool Tool(OptionsParser.getCompilations(),
                 OptionsParser.getSourcePathList());

  return Tool.run(newFrontendActionFactory<FindMagicLitsAction>().get());
}