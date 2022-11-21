#include "clang/StaticAnalyzer/Core/BugReporter/BugType.h"
#include "clang/StaticAnalyzer/Core/Checker.h"
#include "clang/StaticAnalyzer/Core/CheckerManager.h"
#include "clang/StaticAnalyzer/Core/PathSensitive/CheckerContext.h"
#include "clang/StaticAnalyzer/Checkers/BuiltinCheckerRegistration.h"
#include "clang/AST/Stmt.h"
#include "clang/AST/ASTContext.h"
#include "clang/Tooling/Tooling.h"
#include "clang/ASTMatchers/ASTMatchers.h"
#include "clang/ASTMatchers/ASTMatchFinder.h"

using namespace llvm;
using namespace clang;
using namespace clang::tooling;
using namespace clang::ast_matchers;
using namespace ento;

StatementMatcher LoopMatcher[] = {
  integerLiteral().bind("IntLiteral"),
  floatLiteral().bind("FloatLiteral"),
  cxxNullPtrLiteralExpr().bind("NptLiteral"),
  stringLiteral().bind("StrLiteral"),
  characterLiteral().bind("CharLiteral"),
  cxxBoolLiteral().bind("boolLiteral")
};

class LoopPrinter : public MatchFinder::MatchCallback {

  BugReporter &BR;
  const CheckerBase * Checker;
  AnalysisDeclContext *AC;

public:
  explicit LoopPrinter(BugReporter &B, const CheckerBase *Checker,
                       AnalysisDeclContext *A)
        : BR(B), Checker(Checker), AC(A) {}

  virtual void run(const MatchFinder::MatchResult &Result) {
    Context = Result.Context;
    if (const IntegerLiteral *IL = Result.Nodes.getNodeAs<clang::IntegerLiteral>("IntLiteral")){
      VisitLiteral(IL);  
    }
    if (const FloatingLiteral *FL = Result.Nodes.getNodeAs<clang::FloatingLiteral>("FloatLiteral")){
      VisitLiteral(FL);  
    }
     if (const CXXNullPtrLiteralExpr *NPL = Result.Nodes.getNodeAs<clang::CXXNullPtrLiteralExpr>("NptLiteral")){
      VisitLiteral(NPL);  
    }
     if (const clang::StringLiteral *SL = Result.Nodes.getNodeAs<clang::StringLiteral>("StrLiteral")){
      VisitLiteral(SL);  
    }
     if (const CharacterLiteral *CL = Result.Nodes.getNodeAs<clang::CharacterLiteral>("CharLiteral")){
      VisitLiteral(CL);  
    }
     if (const CXXBoolLiteralExpr *BL = Result.Nodes.getNodeAs<clang::CXXBoolLiteralExpr>("boolLiteral")){
      VisitLiteral(BL);  
    }
  }
  

  template<typename T> 
  bool VisitLiteral(T* Literal){
    if(!Context->getSourceManager().isInMainFile(Literal->getBeginLoc())){
      return true;
    }
    const auto& parents = Context->getParents(*Literal);
    DynTypedNode parent = parents[0];
    SourceRange Sr[1] = {Literal->getSourceRange()};
    PathDiagnosticLocation Loc(Literal, BR.getSourceManager(), AC);
    if(!CheckLiteral(parent)){
        BR.EmitBasicReport(
        AC->getDecl(), Checker, "Autosar a5-1-1 rule",
        categories::LogicError, "Autosar[A5-1-1]: Use symbolic names instead of "
                                "literal values in code.",
        Loc, Sr);
    }
    return true;
  }

  bool CheckLiteral(DynTypedNode parent){
    const Stmt* ST = NULL;
    ST = parent.get<Stmt>();
    if(!ST){
      return true;
    }
    constexpr Stmt::StmtClass Classes[] = {
      Stmt::CallExprClass,
      Stmt::ForStmtClass,
      Stmt::IfStmtClass,
      Stmt::SwitchStmtClass,
      Stmt::ConditionalOperatorClass,
      Stmt::CaseStmtClass,
      Stmt::ReturnStmtClass,
      Stmt::DoStmtClass,
      Stmt::CXXOperatorCallExprClass,
      Stmt::WhileStmtClass,
      Stmt::CXXFunctionalCastExprClass,
      Stmt::ArraySubscriptExprClass
        //
    };
    while(ST){
      const Stmt::StmtClass class_id = ST->getStmtClass();

      if(class_id == Stmt::BinaryOperatorClass){
          const BinaryOperator* BO = parent.get<BinaryOperator>();
          if(BO->getOpcode() == BinaryOperator::Opcode::BO_Assign){ 
            return true;
          }  
      }
      if(class_id == Stmt::CXXConstructExprClass){
        return true;
      }
      if(class_id == Stmt::CXXOperatorCallExprClass){
        const CXXOperatorCallExpr* OC = parent.get<CXXOperatorCallExpr>();
        if(OC->getOperator() == OverloadedOperatorKind::OO_LessLess) { 
          return true;
        }
        return false;
      }

      if(std::find(std::begin(Classes),std::end(Classes),class_id) != std::end(Classes)){
        return false;
      }

      const auto& parents = Context->getParents(*ST);
      parent = parents[0];
      ST = parent.get<Stmt>();
    }
  return true;
  }

  
private:
  ASTContext *Context;
};


namespace {
class MagicLitsMchChecker : public Checker<check::ASTCodeBody> {
public:
  void checkASTCodeBody(const Decl *D, AnalysisManager &Mgr,
                        BugReporter &BR) const{
    LoopPrinter Printer(BR,this, Mgr.getAnalysisDeclContext(D));
    MatchFinder Finder;
    for(StatementMatcher LM : LoopMatcher)
        Finder.addMatcher(LM, &Printer);
    Finder.matchAST(Mgr.getASTContext());
  }
};
} // end anonymous namespace

void ento::registerMagicLitsMchChecker(CheckerManager &mgr) {
  mgr.registerChecker<MagicLitsMchChecker>();
}

bool ento::shouldRegisterMagicLitsMchChecker(const CheckerManager &mgr) {
  return true;
}