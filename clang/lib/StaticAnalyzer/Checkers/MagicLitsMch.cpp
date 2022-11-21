#include "clang/StaticAnalyzer/Core/BugReporter/BugType.h"
#include "clang/StaticAnalyzer/Core/Checker.h"
#include "clang/StaticAnalyzer/Core/CheckerManager.h"
#include "clang/StaticAnalyzer/Core/PathSensitive/CheckerContext.h"
#include "clang/StaticAnalyzer/Checkers/BuiltinCheckerRegistration.h"
#include "clang/AST/Stmt.h"
#include "clang/AST/ASTContext.h"
#include "clang/Analysis/MagicLitsMch.h"
#include "clang/Tooling/Tooling.h"
#include "clang/ASTMatchers/ASTMatchers.h"
#include "clang/ASTMatchers/ASTMatchFinder.h"
#include <vector>

namespace {
class MagicLitsMchChecker : public Checker<check::ASTCodeBody> {
public:
  void checkASTCodeBody(const Decl *D, AnalysisManager &Mgr,
                        BugReporter &BR) const{
    FindMagicLits Printer;
    MatchFinder Finder;
    for(StatementMatcher LM : LitMatcher)
        Finder.addMatcher(LM, &Printer);
    Finder.matchAST(Mgr.getASTContext());
    std::vector<FullSourceLoc> warnings = Printer.getWarnings();
    for(FullSourceLoc FL : warnings){
      BR.EmitBasicReport(D, this, "Autosar a5-1-1 rule", categories::LogicError,
                      "Autosar[A5-1-1]: Use symbolic names instead of "
                      "literal values in code.",
                       PathDiagnosticLocation(FL, Mgr.getSourceManager()), static_cast<SourceRange>(FL));
    }
  }
};
} 

void ento::registerMagicLitsMchChecker(CheckerManager &mgr) {
  mgr.registerChecker<MagicLitsMchChecker>();
}

bool ento::shouldRegisterMagicLitsMchChecker(const CheckerManager &mgr) {
  return true;
}