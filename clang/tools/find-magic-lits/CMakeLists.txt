set(LLVM_LINK_COMPONENTS support)

add_clang_executable(find-magic-lits
  FindMagicLits.cpp
  )
target_link_libraries(find-magic-lits
  PRIVATE
  clangAST
  clangASTMatchers
  clangBasic
  clangFrontend
  clangSerialization
  clangTooling
  )