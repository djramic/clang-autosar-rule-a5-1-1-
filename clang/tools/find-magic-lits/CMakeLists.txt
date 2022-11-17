set(LLVM_LINK_COMPONENTS
  Support
  )

add_clang_executable(find-magic-lits FindMagicLits.cpp)

target_link_libraries(find-magic-lits
  PRIVATE
  clangAST
  clangBasic
  clangFrontend
  clangSerialization
  clangTooling
  )