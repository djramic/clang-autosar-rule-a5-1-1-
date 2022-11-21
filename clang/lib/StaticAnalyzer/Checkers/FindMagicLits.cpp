#include "clang/Basic/Diagnostic.h"
#include "clang/StaticAnalyzer/Checkers/BuiltinCheckerRegistration.h"
#include "clang/AST/Stmt.h"
#include "clang/AST/RecursiveASTVisitor.h"
#include "clang/AST/ParentMapContext.h"
#include "clang/Analysis/FindMagicLits.h"
#include "clang/StaticAnalyzer/Core/BugReporter/BugType.h"
#include "clang/StaticAnalyzer/Core/Checker.h"
#include "clang/StaticAnalyzer/Core/CheckerManager.h"
#include "clang/StaticAnalyzer/Core/PathSensitive/CheckerContext.h"

using namespace clang;
using namespace ento;


class FindMagicLitsChecker : public Checker<check::ASTCodeBody> {
public:
  void checkASTCodeBody(const Decl *D, AnalysisManager &Mgr,
                        BugReporter &BR) const {
    ASTContext &Context = Mgr.getAnalysisDeclContext(D)->getASTContext();
    FindMagicLits1 Visitor(&Context);
    Visitor.TraverseDecl(const_cast<Decl *>(D));
    std::vector<FullSourceLoc> warningsLocs = Visitor.getWarnings();
    for(FullSourceLoc FL : warningsLocs){
      BR.EmitBasicReport(D, this, "Autosar a5-1-1 rule", categories::LogicError,
                      "Autosar[A5-1-1]: Use symbolic names instead of "
                      "literal values in code.",
                       PathDiagnosticLocation(FL, Mgr.getSourceManager()), static_cast<SourceRange>(FL));
    }
  }
};


void ento::registerFindMagicLitsChecker(CheckerManager &mgr) {
  mgr.registerChecker<FindMagicLitsChecker>();
}

bool ento::shouldRegisterFindMagicLitsChecker(const CheckerManager &mgr) {
  return true;
}