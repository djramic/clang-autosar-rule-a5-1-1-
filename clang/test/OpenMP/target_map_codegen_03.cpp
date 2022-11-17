// NOTE: Assertions have been autogenerated by utils/update_cc_test_checks.py UTC_ARGS: --function-signature --include-generated-funcs --replace-value-regex "__omp_offloading_[0-9a-z]+_[0-9a-z]+" "reduction_size[.].+[.]" "pl_cond[.].+[.|,]" --prefix-filecheck-ir-name _
// expected-no-diagnostics
#ifndef HEADER
#define HEADER

///==========================================================================///
// RUN: %clang_cc1 -DCK4 -verify -fopenmp -fopenmp-targets=powerpc64le-ibm-linux-gnu -x c++ -triple powerpc64le-unknown-unknown -emit-llvm %s -o - | FileCheck -allow-deprecated-dag-overlap  %s --check-prefix=CHECK1
// RUN: %clang_cc1 -DCK4 -fopenmp -fopenmp-targets=powerpc64le-ibm-linux-gnu -x c++ -std=c++11 -triple powerpc64le-unknown-unknown -emit-pch -o %t %s
// RUN: %clang_cc1 -fopenmp -fopenmp-targets=powerpc64le-ibm-linux-gnu -x c++ -triple powerpc64le-unknown-unknown -std=c++11 -include-pch %t -verify %s -emit-llvm -o - | FileCheck -allow-deprecated-dag-overlap  %s  --check-prefix=CHECK1
// RUN: %clang_cc1 -DCK4 -verify -fopenmp -fopenmp-targets=i386-pc-linux-gnu -x c++ -triple i386-unknown-unknown -emit-llvm %s -o - | FileCheck -allow-deprecated-dag-overlap  %s  --check-prefix=CHECK3
// RUN: %clang_cc1 -DCK4 -fopenmp -fopenmp-targets=i386-pc-linux-gnu -x c++ -std=c++11 -triple i386-unknown-unknown -emit-pch -o %t %s
// RUN: %clang_cc1 -fopenmp -fopenmp-targets=i386-pc-linux-gnu -x c++ -triple i386-unknown-unknown -std=c++11 -include-pch %t -verify %s -emit-llvm -o - | FileCheck -allow-deprecated-dag-overlap  %s  --check-prefix=CHECK3

// RUN: %clang_cc1 -DCK4 -verify -fopenmp -fopenmp-version=45 -fopenmp-targets=powerpc64le-ibm-linux-gnu -x c++ -triple powerpc64le-unknown-unknown -emit-llvm %s -o - | FileCheck -allow-deprecated-dag-overlap  %s --check-prefix=CHECK1
// RUN: %clang_cc1 -DCK4 -fopenmp -fopenmp-version=45 -fopenmp-targets=powerpc64le-ibm-linux-gnu -x c++ -std=c++11 -triple powerpc64le-unknown-unknown -emit-pch -o %t %s
// RUN: %clang_cc1 -fopenmp -fopenmp-version=45 -fopenmp-targets=powerpc64le-ibm-linux-gnu -x c++ -triple powerpc64le-unknown-unknown -std=c++11 -include-pch %t -verify %s -emit-llvm -o - | FileCheck -allow-deprecated-dag-overlap  %s  --check-prefix=CHECK1
// RUN: %clang_cc1 -DCK4 -verify -fopenmp -fopenmp-version=45 -fopenmp-targets=i386-pc-linux-gnu -x c++ -triple i386-unknown-unknown -emit-llvm %s -o - | FileCheck -allow-deprecated-dag-overlap  %s  --check-prefix=CHECK3
// RUN: %clang_cc1 -DCK4 -fopenmp -fopenmp-version=45 -fopenmp-targets=i386-pc-linux-gnu -x c++ -std=c++11 -triple i386-unknown-unknown -emit-pch -o %t %s
// RUN: %clang_cc1 -fopenmp -fopenmp-version=45 -fopenmp-targets=i386-pc-linux-gnu -x c++ -triple i386-unknown-unknown -std=c++11 -include-pch %t -verify %s -emit-llvm -o - | FileCheck -allow-deprecated-dag-overlap  %s  --check-prefix=CHECK3

// RUN: %clang_cc1 -DCK4 -verify -fopenmp -fopenmp-version=50 -fopenmp-targets=powerpc64le-ibm-linux-gnu -x c++ -triple powerpc64le-unknown-unknown -emit-llvm %s -o - | FileCheck -allow-deprecated-dag-overlap  %s --check-prefix=CHECK1
// RUN: %clang_cc1 -DCK4 -fopenmp -fopenmp-version=50 -fopenmp-targets=powerpc64le-ibm-linux-gnu -x c++ -std=c++11 -triple powerpc64le-unknown-unknown -emit-pch -o %t %s
// RUN: %clang_cc1 -fopenmp -fopenmp-version=50 -fopenmp-targets=powerpc64le-ibm-linux-gnu -x c++ -triple powerpc64le-unknown-unknown -std=c++11 -include-pch %t -verify %s -emit-llvm -o - | FileCheck -allow-deprecated-dag-overlap  %s  --check-prefix=CHECK1
// RUN: %clang_cc1 -DCK4 -verify -fopenmp -fopenmp-version=50 -fopenmp-targets=i386-pc-linux-gnu -x c++ -triple i386-unknown-unknown -emit-llvm %s -o - | FileCheck -allow-deprecated-dag-overlap  %s  --check-prefix=CHECK3
// RUN: %clang_cc1 -DCK4 -fopenmp -fopenmp-version=50 -fopenmp-targets=i386-pc-linux-gnu -x c++ -std=c++11 -triple i386-unknown-unknown -emit-pch -o %t %s
// RUN: %clang_cc1 -fopenmp -fopenmp-version=50 -fopenmp-targets=i386-pc-linux-gnu -x c++ -triple i386-unknown-unknown -std=c++11 -include-pch %t -verify %s -emit-llvm -o - | FileCheck -allow-deprecated-dag-overlap  %s  --check-prefix=CHECK3

// RUN: %clang_cc1 -DCK4 -verify -fopenmp-simd -fopenmp-targets=powerpc64le-ibm-linux-gnu -x c++ -triple powerpc64le-unknown-unknown -emit-llvm %s -o - | FileCheck %s --implicit-check-not="{{__kmpc|__tgt}}"
// RUN: %clang_cc1 -DCK4 -fopenmp-simd -fopenmp-targets=powerpc64le-ibm-linux-gnu -x c++ -std=c++11 -triple powerpc64le-unknown-unknown -emit-pch -o %t %s
// RUN: %clang_cc1 -fopenmp-simd -fopenmp-targets=powerpc64le-ibm-linux-gnu -x c++ -triple powerpc64le-unknown-unknown -std=c++11 -include-pch %t -verify %s -emit-llvm -o - | FileCheck %s --implicit-check-not="{{__kmpc|__tgt}}"
// RUN: %clang_cc1 -DCK4 -verify -fopenmp-simd -fopenmp-targets=i386-pc-linux-gnu -x c++ -triple i386-unknown-unknown -emit-llvm %s -o - | FileCheck %s --implicit-check-not="{{__kmpc|__tgt}}"
// RUN: %clang_cc1 -DCK4 -fopenmp-simd -fopenmp-targets=i386-pc-linux-gnu -x c++ -std=c++11 -triple i386-unknown-unknown -emit-pch -o %t %s
// RUN: %clang_cc1 -fopenmp-simd -fopenmp-targets=i386-pc-linux-gnu -x c++ -triple i386-unknown-unknown -std=c++11 -include-pch %t -verify %s -emit-llvm -o - | FileCheck %s --implicit-check-not="{{__kmpc|__tgt}}"
#ifdef CK4


// Map types: OMP_MAP_PRIVATE_VAL | OMP_MAP_TARGET_PARAM | OMP_MAP_IMPLICIT = 800

void implicit_maps_nested_integer (int a){
  int i = a;

  // The captures in parallel are by reference. Only the capture in target is by
  // copy.

  #pragma omp parallel
  {

    #pragma omp target
    {
      #pragma omp parallel
      {
        ++i;
      }
    }
  }
}

#endif // CK4
#endif
// CHECK1-LABEL: define {{[^@]+}}@_Z28implicit_maps_nested_integeri
// CHECK1-SAME: (i32 noundef signext [[A:%.*]]) #[[ATTR0:[0-9]+]] {
// CHECK1-NEXT:  entry:
// CHECK1-NEXT:    [[A_ADDR:%.*]] = alloca i32, align 4
// CHECK1-NEXT:    [[I:%.*]] = alloca i32, align 4
// CHECK1-NEXT:    store i32 [[A]], ptr [[A_ADDR]], align 4
// CHECK1-NEXT:    [[TMP0:%.*]] = load i32, ptr [[A_ADDR]], align 4
// CHECK1-NEXT:    store i32 [[TMP0]], ptr [[I]], align 4
// CHECK1-NEXT:    call void (ptr, i32, ptr, ...) @__kmpc_fork_call(ptr @[[GLOB1:[0-9]+]], i32 1, ptr @.omp_outlined., ptr [[I]])
// CHECK1-NEXT:    ret void
//
//
// CHECK1-LABEL: define {{[^@]+}}@.omp_outlined.
// CHECK1-SAME: (ptr noalias noundef [[DOTGLOBAL_TID_:%.*]], ptr noalias noundef [[DOTBOUND_TID_:%.*]], ptr noundef nonnull align 4 dereferenceable(4) [[I:%.*]]) #[[ATTR1:[0-9]+]] {
// CHECK1-NEXT:  entry:
// CHECK1-NEXT:    [[DOTGLOBAL_TID__ADDR:%.*]] = alloca ptr, align 8
// CHECK1-NEXT:    [[DOTBOUND_TID__ADDR:%.*]] = alloca ptr, align 8
// CHECK1-NEXT:    [[I_ADDR:%.*]] = alloca ptr, align 8
// CHECK1-NEXT:    [[I_CASTED:%.*]] = alloca i64, align 8
// CHECK1-NEXT:    [[DOTOFFLOAD_BASEPTRS:%.*]] = alloca [1 x ptr], align 8
// CHECK1-NEXT:    [[DOTOFFLOAD_PTRS:%.*]] = alloca [1 x ptr], align 8
// CHECK1-NEXT:    [[DOTOFFLOAD_MAPPERS:%.*]] = alloca [1 x ptr], align 8
// CHECK1-NEXT:    store ptr [[DOTGLOBAL_TID_]], ptr [[DOTGLOBAL_TID__ADDR]], align 8
// CHECK1-NEXT:    store ptr [[DOTBOUND_TID_]], ptr [[DOTBOUND_TID__ADDR]], align 8
// CHECK1-NEXT:    store ptr [[I]], ptr [[I_ADDR]], align 8
// CHECK1-NEXT:    [[TMP0:%.*]] = load ptr, ptr [[I_ADDR]], align 8
// CHECK1-NEXT:    [[TMP1:%.*]] = load i32, ptr [[TMP0]], align 4
// CHECK1-NEXT:    store i32 [[TMP1]], ptr [[I_CASTED]], align 4
// CHECK1-NEXT:    [[TMP2:%.*]] = load i64, ptr [[I_CASTED]], align 8
// CHECK1-NEXT:    [[TMP3:%.*]] = getelementptr inbounds [1 x ptr], ptr [[DOTOFFLOAD_BASEPTRS]], i32 0, i32 0
// CHECK1-NEXT:    store i64 [[TMP2]], ptr [[TMP3]], align 8
// CHECK1-NEXT:    [[TMP5:%.*]] = getelementptr inbounds [1 x ptr], ptr [[DOTOFFLOAD_PTRS]], i32 0, i32 0
// CHECK1-NEXT:    store i64 [[TMP2]], ptr [[TMP5]], align 8
// CHECK1-NEXT:    [[TMP7:%.*]] = getelementptr inbounds [1 x ptr], ptr [[DOTOFFLOAD_MAPPERS]], i64 0, i64 0
// CHECK1-NEXT:    store ptr null, ptr [[TMP7]], align 8
// CHECK1-NEXT:    [[TMP8:%.*]] = getelementptr inbounds [1 x ptr], ptr [[DOTOFFLOAD_BASEPTRS]], i32 0, i32 0
// CHECK1-NEXT:    [[TMP9:%.*]] = getelementptr inbounds [1 x ptr], ptr [[DOTOFFLOAD_PTRS]], i32 0, i32 0
// CHECK1-NEXT:    [[KERNEL_ARGS:%.*]] = alloca [[STRUCT___TGT_KERNEL_ARGUMENTS:%.*]], align 8
// CHECK1-NEXT:    [[TMP10:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], ptr [[KERNEL_ARGS]], i32 0, i32 0
// CHECK1-NEXT:    store i32 1, ptr [[TMP10]], align 4
// CHECK1-NEXT:    [[TMP11:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], ptr [[KERNEL_ARGS]], i32 0, i32 1
// CHECK1-NEXT:    store i32 1, ptr [[TMP11]], align 4
// CHECK1-NEXT:    [[TMP12:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], ptr [[KERNEL_ARGS]], i32 0, i32 2
// CHECK1-NEXT:    store ptr [[TMP8]], ptr [[TMP12]], align 8
// CHECK1-NEXT:    [[TMP13:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], ptr [[KERNEL_ARGS]], i32 0, i32 3
// CHECK1-NEXT:    store ptr [[TMP9]], ptr [[TMP13]], align 8
// CHECK1-NEXT:    [[TMP14:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], ptr [[KERNEL_ARGS]], i32 0, i32 4
// CHECK1-NEXT:    store ptr @.offload_sizes, ptr [[TMP14]], align 8
// CHECK1-NEXT:    [[TMP15:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], ptr [[KERNEL_ARGS]], i32 0, i32 5
// CHECK1-NEXT:    store ptr @.offload_maptypes, ptr [[TMP15]], align 8
// CHECK1-NEXT:    [[TMP16:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], ptr [[KERNEL_ARGS]], i32 0, i32 6
// CHECK1-NEXT:    store ptr null, ptr [[TMP16]], align 8
// CHECK1-NEXT:    [[TMP17:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], ptr [[KERNEL_ARGS]], i32 0, i32 7
// CHECK1-NEXT:    store ptr null, ptr [[TMP17]], align 8
// CHECK1-NEXT:    [[TMP18:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], ptr [[KERNEL_ARGS]], i32 0, i32 8
// CHECK1-NEXT:    store i64 0, ptr [[TMP18]], align 8
// CHECK1-NEXT:    [[TMP19:%.*]] = call i32 @__tgt_target_kernel(ptr @[[GLOB1]], i64 -1, i32 1, i32 0, ptr @.{{__omp_offloading_[0-9a-z]+_[0-9a-z]+}}__Z28implicit_maps_nested_integeri_l48.region_id, ptr [[KERNEL_ARGS]])
// CHECK1-NEXT:    [[TMP20:%.*]] = icmp ne i32 [[TMP19]], 0
// CHECK1-NEXT:    br i1 [[TMP20]], label [[OMP_OFFLOAD_FAILED:%.*]], label [[OMP_OFFLOAD_CONT:%.*]]
// CHECK1:       omp_offload.failed:
// CHECK1-NEXT:    call void @{{__omp_offloading_[0-9a-z]+_[0-9a-z]+}}__Z28implicit_maps_nested_integeri_l48(i64 [[TMP2]]) #[[ATTR3:[0-9]+]]
// CHECK1-NEXT:    br label [[OMP_OFFLOAD_CONT]]
// CHECK1:       omp_offload.cont:
// CHECK1-NEXT:    ret void
//
//
// CHECK1-LABEL: define {{[^@]+}}@{{__omp_offloading_[0-9a-z]+_[0-9a-z]+}}__Z28implicit_maps_nested_integeri_l48
// CHECK1-SAME: (i64 noundef [[I:%.*]]) #[[ATTR2:[0-9]+]] {
// CHECK1-NEXT:  entry:
// CHECK1-NEXT:    [[I_ADDR:%.*]] = alloca i64, align 8
// CHECK1-NEXT:    store i64 [[I]], ptr [[I_ADDR]], align 8
// CHECK1-NEXT:    call void (ptr, i32, ptr, ...) @__kmpc_fork_call(ptr @[[GLOB1]], i32 1, ptr @.omp_outlined..1, ptr [[I_ADDR]])
// CHECK1-NEXT:    ret void
//
//
// CHECK1-LABEL: define {{[^@]+}}@.omp_outlined..1
// CHECK1-SAME: (ptr noalias noundef [[DOTGLOBAL_TID_:%.*]], ptr noalias noundef [[DOTBOUND_TID_:%.*]], ptr noundef nonnull align 4 dereferenceable(4) [[I:%.*]]) #[[ATTR1]] {
// CHECK1-NEXT:  entry:
// CHECK1-NEXT:    [[DOTGLOBAL_TID__ADDR:%.*]] = alloca ptr, align 8
// CHECK1-NEXT:    [[DOTBOUND_TID__ADDR:%.*]] = alloca ptr, align 8
// CHECK1-NEXT:    [[I_ADDR:%.*]] = alloca ptr, align 8
// CHECK1-NEXT:    store ptr [[DOTGLOBAL_TID_]], ptr [[DOTGLOBAL_TID__ADDR]], align 8
// CHECK1-NEXT:    store ptr [[DOTBOUND_TID_]], ptr [[DOTBOUND_TID__ADDR]], align 8
// CHECK1-NEXT:    store ptr [[I]], ptr [[I_ADDR]], align 8
// CHECK1-NEXT:    [[TMP0:%.*]] = load ptr, ptr [[I_ADDR]], align 8
// CHECK1-NEXT:    [[TMP1:%.*]] = load i32, ptr [[TMP0]], align 4
// CHECK1-NEXT:    [[INC:%.*]] = add nsw i32 [[TMP1]], 1
// CHECK1-NEXT:    store i32 [[INC]], ptr [[TMP0]], align 4
// CHECK1-NEXT:    ret void
//
//
// CHECK1-LABEL: define {{[^@]+}}@.omp_offloading.requires_reg
// CHECK1-SAME: () #[[ATTR4:[0-9]+]] {
// CHECK1-NEXT:  entry:
// CHECK1-NEXT:    call void @__tgt_register_requires(i64 1)
// CHECK1-NEXT:    ret void
//
//
// CHECK3-LABEL: define {{[^@]+}}@_Z28implicit_maps_nested_integeri
// CHECK3-SAME: (i32 noundef [[A:%.*]]) #[[ATTR0:[0-9]+]] {
// CHECK3-NEXT:  entry:
// CHECK3-NEXT:    [[A_ADDR:%.*]] = alloca i32, align 4
// CHECK3-NEXT:    [[I:%.*]] = alloca i32, align 4
// CHECK3-NEXT:    store i32 [[A]], ptr [[A_ADDR]], align 4
// CHECK3-NEXT:    [[TMP0:%.*]] = load i32, ptr [[A_ADDR]], align 4
// CHECK3-NEXT:    store i32 [[TMP0]], ptr [[I]], align 4
// CHECK3-NEXT:    call void (ptr, i32, ptr, ...) @__kmpc_fork_call(ptr @[[GLOB1:[0-9]+]], i32 1, ptr @.omp_outlined., ptr [[I]])
// CHECK3-NEXT:    ret void
//
//
// CHECK3-LABEL: define {{[^@]+}}@.omp_outlined.
// CHECK3-SAME: (ptr noalias noundef [[DOTGLOBAL_TID_:%.*]], ptr noalias noundef [[DOTBOUND_TID_:%.*]], ptr noundef nonnull align 4 dereferenceable(4) [[I:%.*]]) #[[ATTR1:[0-9]+]] {
// CHECK3-NEXT:  entry:
// CHECK3-NEXT:    [[DOTGLOBAL_TID__ADDR:%.*]] = alloca ptr, align 4
// CHECK3-NEXT:    [[DOTBOUND_TID__ADDR:%.*]] = alloca ptr, align 4
// CHECK3-NEXT:    [[I_ADDR:%.*]] = alloca ptr, align 4
// CHECK3-NEXT:    [[I_CASTED:%.*]] = alloca i32, align 4
// CHECK3-NEXT:    [[DOTOFFLOAD_BASEPTRS:%.*]] = alloca [1 x ptr], align 4
// CHECK3-NEXT:    [[DOTOFFLOAD_PTRS:%.*]] = alloca [1 x ptr], align 4
// CHECK3-NEXT:    [[DOTOFFLOAD_MAPPERS:%.*]] = alloca [1 x ptr], align 4
// CHECK3-NEXT:    store ptr [[DOTGLOBAL_TID_]], ptr [[DOTGLOBAL_TID__ADDR]], align 4
// CHECK3-NEXT:    store ptr [[DOTBOUND_TID_]], ptr [[DOTBOUND_TID__ADDR]], align 4
// CHECK3-NEXT:    store ptr [[I]], ptr [[I_ADDR]], align 4
// CHECK3-NEXT:    [[TMP0:%.*]] = load ptr, ptr [[I_ADDR]], align 4
// CHECK3-NEXT:    [[TMP1:%.*]] = load i32, ptr [[TMP0]], align 4
// CHECK3-NEXT:    store i32 [[TMP1]], ptr [[I_CASTED]], align 4
// CHECK3-NEXT:    [[TMP2:%.*]] = load i32, ptr [[I_CASTED]], align 4
// CHECK3-NEXT:    [[TMP3:%.*]] = getelementptr inbounds [1 x ptr], ptr [[DOTOFFLOAD_BASEPTRS]], i32 0, i32 0
// CHECK3-NEXT:    store i32 [[TMP2]], ptr [[TMP3]], align 4
// CHECK3-NEXT:    [[TMP5:%.*]] = getelementptr inbounds [1 x ptr], ptr [[DOTOFFLOAD_PTRS]], i32 0, i32 0
// CHECK3-NEXT:    store i32 [[TMP2]], ptr [[TMP5]], align 4
// CHECK3-NEXT:    [[TMP7:%.*]] = getelementptr inbounds [1 x ptr], ptr [[DOTOFFLOAD_MAPPERS]], i32 0, i32 0
// CHECK3-NEXT:    store ptr null, ptr [[TMP7]], align 4
// CHECK3-NEXT:    [[TMP8:%.*]] = getelementptr inbounds [1 x ptr], ptr [[DOTOFFLOAD_BASEPTRS]], i32 0, i32 0
// CHECK3-NEXT:    [[TMP9:%.*]] = getelementptr inbounds [1 x ptr], ptr [[DOTOFFLOAD_PTRS]], i32 0, i32 0
// CHECK3-NEXT:    [[KERNEL_ARGS:%.*]] = alloca [[STRUCT___TGT_KERNEL_ARGUMENTS:%.*]], align 8
// CHECK3-NEXT:    [[TMP10:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], ptr [[KERNEL_ARGS]], i32 0, i32 0
// CHECK3-NEXT:    store i32 1, ptr [[TMP10]], align 4
// CHECK3-NEXT:    [[TMP11:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], ptr [[KERNEL_ARGS]], i32 0, i32 1
// CHECK3-NEXT:    store i32 1, ptr [[TMP11]], align 4
// CHECK3-NEXT:    [[TMP12:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], ptr [[KERNEL_ARGS]], i32 0, i32 2
// CHECK3-NEXT:    store ptr [[TMP8]], ptr [[TMP12]], align 4
// CHECK3-NEXT:    [[TMP13:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], ptr [[KERNEL_ARGS]], i32 0, i32 3
// CHECK3-NEXT:    store ptr [[TMP9]], ptr [[TMP13]], align 4
// CHECK3-NEXT:    [[TMP14:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], ptr [[KERNEL_ARGS]], i32 0, i32 4
// CHECK3-NEXT:    store ptr @.offload_sizes, ptr [[TMP14]], align 4
// CHECK3-NEXT:    [[TMP15:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], ptr [[KERNEL_ARGS]], i32 0, i32 5
// CHECK3-NEXT:    store ptr @.offload_maptypes, ptr [[TMP15]], align 4
// CHECK3-NEXT:    [[TMP16:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], ptr [[KERNEL_ARGS]], i32 0, i32 6
// CHECK3-NEXT:    store ptr null, ptr [[TMP16]], align 4
// CHECK3-NEXT:    [[TMP17:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], ptr [[KERNEL_ARGS]], i32 0, i32 7
// CHECK3-NEXT:    store ptr null, ptr [[TMP17]], align 4
// CHECK3-NEXT:    [[TMP18:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], ptr [[KERNEL_ARGS]], i32 0, i32 8
// CHECK3-NEXT:    store i64 0, ptr [[TMP18]], align 8
// CHECK3-NEXT:    [[TMP19:%.*]] = call i32 @__tgt_target_kernel(ptr @[[GLOB1]], i64 -1, i32 1, i32 0, ptr @.{{__omp_offloading_[0-9a-z]+_[0-9a-z]+}}__Z28implicit_maps_nested_integeri_l48.region_id, ptr [[KERNEL_ARGS]])
// CHECK3-NEXT:    [[TMP20:%.*]] = icmp ne i32 [[TMP19]], 0
// CHECK3-NEXT:    br i1 [[TMP20]], label [[OMP_OFFLOAD_FAILED:%.*]], label [[OMP_OFFLOAD_CONT:%.*]]
// CHECK3:       omp_offload.failed:
// CHECK3-NEXT:    call void @{{__omp_offloading_[0-9a-z]+_[0-9a-z]+}}__Z28implicit_maps_nested_integeri_l48(i32 [[TMP2]]) #[[ATTR3:[0-9]+]]
// CHECK3-NEXT:    br label [[OMP_OFFLOAD_CONT]]
// CHECK3:       omp_offload.cont:
// CHECK3-NEXT:    ret void
//
//
// CHECK3-LABEL: define {{[^@]+}}@{{__omp_offloading_[0-9a-z]+_[0-9a-z]+}}__Z28implicit_maps_nested_integeri_l48
// CHECK3-SAME: (i32 noundef [[I:%.*]]) #[[ATTR2:[0-9]+]] {
// CHECK3-NEXT:  entry:
// CHECK3-NEXT:    [[I_ADDR:%.*]] = alloca i32, align 4
// CHECK3-NEXT:    store i32 [[I]], ptr [[I_ADDR]], align 4
// CHECK3-NEXT:    call void (ptr, i32, ptr, ...) @__kmpc_fork_call(ptr @[[GLOB1]], i32 1, ptr @.omp_outlined..1, ptr [[I_ADDR]])
// CHECK3-NEXT:    ret void
//
//
// CHECK3-LABEL: define {{[^@]+}}@.omp_outlined..1
// CHECK3-SAME: (ptr noalias noundef [[DOTGLOBAL_TID_:%.*]], ptr noalias noundef [[DOTBOUND_TID_:%.*]], ptr noundef nonnull align 4 dereferenceable(4) [[I:%.*]]) #[[ATTR1]] {
// CHECK3-NEXT:  entry:
// CHECK3-NEXT:    [[DOTGLOBAL_TID__ADDR:%.*]] = alloca ptr, align 4
// CHECK3-NEXT:    [[DOTBOUND_TID__ADDR:%.*]] = alloca ptr, align 4
// CHECK3-NEXT:    [[I_ADDR:%.*]] = alloca ptr, align 4
// CHECK3-NEXT:    store ptr [[DOTGLOBAL_TID_]], ptr [[DOTGLOBAL_TID__ADDR]], align 4
// CHECK3-NEXT:    store ptr [[DOTBOUND_TID_]], ptr [[DOTBOUND_TID__ADDR]], align 4
// CHECK3-NEXT:    store ptr [[I]], ptr [[I_ADDR]], align 4
// CHECK3-NEXT:    [[TMP0:%.*]] = load ptr, ptr [[I_ADDR]], align 4
// CHECK3-NEXT:    [[TMP1:%.*]] = load i32, ptr [[TMP0]], align 4
// CHECK3-NEXT:    [[INC:%.*]] = add nsw i32 [[TMP1]], 1
// CHECK3-NEXT:    store i32 [[INC]], ptr [[TMP0]], align 4
// CHECK3-NEXT:    ret void
//
//
// CHECK3-LABEL: define {{[^@]+}}@.omp_offloading.requires_reg
// CHECK3-SAME: () #[[ATTR4:[0-9]+]] {
// CHECK3-NEXT:  entry:
// CHECK3-NEXT:    call void @__tgt_register_requires(i64 1)
// CHECK3-NEXT:    ret void
//