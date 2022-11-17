set(LLVM_LINK_COMPONENTS support)

add_clang_executable(magic-lits-mch
  MagicLitsMch.cpp
  )
target_link_libraries(magic-lits-mch
  PRIVATE
  clangAST
  clangASTMatchers
  clangBasic
  clangFrontend
  clangSerialization
  clangTooling
  )