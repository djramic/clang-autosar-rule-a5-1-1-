//===- unittests/Frontend/TextDiagnosticTest.cpp - ------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
#include "clang/AST/ASTConsumer.h"
#include "clang/Analysis/FindMagicLits.h"
#include "clang/Frontend/TextDiagnostic.h"
#include "clang/Frontend/FrontendAction.h"
#include "clang/Frontend/CompilerInstance.h"
#include "clang/Basic/FileManager.h"
#include "clang/Basic/LangOptions.h"
#include "clang/Basic/SourceManager.h"
#include "clang/Tooling/Tooling.h"
#include "llvm/Support/SmallVectorMemoryBuffer.h"

#include "gtest/gtest.h"

using namespace llvm;
using namespace clang;

class FindMagicLitsConsumer : public clang::ASTConsumer {
public:
  explicit FindMagicLitsConsumer(ASTContext *Context, std::vector<int> ExpWarnings ) : Visitor(Context), ExpWarningsLines(ExpWarnings) {}

  virtual void HandleTranslationUnit(clang::ASTContext &Context){
    
    Visitor.TraverseDecl(Context.getTranslationUnitDecl()); 
    Warnings = Visitor.getWarnings();
   
    for(FullSourceLoc WL: Warnings){
      llvm::outs()<< WL.getSpellingLineNumber();
      WarningsLines.push_back(WL.getSpellingLineNumber());
    }
     EXPECT_TRUE(WarningsLines == ExpWarningsLines);
 }
private:
  FindMagicLits1 Visitor;
  std::vector<FullSourceLoc> Warnings;
  std::vector<int>WarningsLines;
  std::vector<int>ExpWarningsLines;
};

class FindMagicLitsAction : public clang::ASTFrontendAction {
public:
  explicit FindMagicLitsAction(std::vector<int> ExpWarnings) : ExpWarnings(ExpWarnings) {}
  virtual std::unique_ptr<clang::ASTConsumer>
  CreateASTConsumer(clang::CompilerInstance &Compiler, llvm::StringRef InFile) {
    return std::make_unique<FindMagicLitsConsumer>(&Compiler.getASTContext(), ExpWarnings);
  }
private:
  std::vector<int> ExpWarnings;
};

TEST(AutosarTest,if_for_while) {
  char main_file_contents[] = "int foo(void) {\n"
                                  "int a = 5;\n"
                                  "float b = 10.0f;\n"
                                  "int * ptr = nullptr;\n"
                                  "if(a < 10){}\n"
                                  "for(int i = 0; i < a ; i=5) {}\n"
                                  "if(5.0f < b) {}\n"
                                  "if(true) {}\n"
                                  "if(ptr == nullptr){}\n"
                                  "return 0;}";

  std::vector<int> ExpWarningsLines = {5,7,8,9,10}; 

  tooling::runToolOnCode(std::make_unique<FindMagicLitsAction>(ExpWarningsLines), main_file_contents);
}

TEST(AutosarTest, lambda) {
  char main_file_contents[] = "int foo()\n"
                              "{\n"
                              "auto operation = [] (int a, int b, const char* op) -> double {\n"
                              "if (op == \"sum\") {\n"
                                "return a + b;\n"
                              "}\n"
                              "else {\n"
                              "return (a + b) / 2.0;\n"
                              "}\n"
                              "};\n"
                              "operation(4,5,\"sum\");\n"
                              "auto b = [](int x) {\n"
                              "return x;\n"
                              "}(4);\n"
                              "return 0;}";

  std::vector<int> ExpWarningsLines = {4,8,11,11,11,14,15}; 

  tooling::runToolOnCode(std::make_unique<FindMagicLitsAction>(ExpWarningsLines), main_file_contents);
}

TEST(AutosarTest, functionCall) {
  char main_file_contents[] = "void g(int*){}\n"
                              "void f(int a, float b, double c, const char* d, int* e){}\n"
                              "void f1(int a){}\n"
                              "void foo(){\n"
                              "int a = 10;\n"
                              "float b = 55.5;\n"
                              "double c = 77;\n"
                              "const char* d = \"test\";\n"
                              "int * pointer = nullptr;\n"
                              "f(5,b,c,d,pointer);\n"
                              "f(a,42.5f,c,d,pointer);\n"
                              "f(a,b,98.5L,d,pointer);\n"
                              "f(a,b,c,\"test-text\",pointer);\n"
                              "f(a,b,c,d,nullptr);\n"
                              "f(a,b,c,d,pointer);\n"
                              "f1((int) 55);\n"
                              "g(nullptr);\n"
                              "g((int*) pointer); \n"
                              "g((int *) nullptr);\n"
                              "}";

  std::vector<int> ExpWarningsLines = {10,11,12,13,14,16,17,19}; 

  tooling::runToolOnCode(std::make_unique<FindMagicLitsAction>(ExpWarningsLines), main_file_contents);
}



