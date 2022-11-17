// NOTE: Assertions have been autogenerated by utils/update_cc_test_checks.py
// RUN: %clang_cc1 -triple thumbv8.1m.main-none-none-eabi -target-feature +mve.fp -mfloat-abi hard -O0 -disable-O0-optnone -S -emit-llvm -o - %s | opt -S -passes=mem2reg | FileCheck %s
// RUN: %clang_cc1 -triple thumbv8.1m.main-none-none-eabi -target-feature +mve.fp -mfloat-abi hard -O0 -disable-O0-optnone -DPOLYMORPHIC -S -emit-llvm -o - %s | opt -S -passes=mem2reg | FileCheck %s

// REQUIRES: aarch64-registered-target || arm-registered-target

#include <arm_mve.h>

// CHECK-LABEL: @test_vqdmulltq_s16(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = call <4 x i32> @llvm.arm.mve.vqdmull.v4i32.v8i16(<8 x i16> [[A:%.*]], <8 x i16> [[B:%.*]], i32 1)
// CHECK-NEXT:    ret <4 x i32> [[TMP0]]
//
int32x4_t test_vqdmulltq_s16(int16x8_t a, int16x8_t b) {
#ifdef POLYMORPHIC
  return vqdmulltq(a, b);
#else  /* POLYMORPHIC */
  return vqdmulltq_s16(a, b);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vqdmulltq_s32(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = call <2 x i64> @llvm.arm.mve.vqdmull.v2i64.v4i32(<4 x i32> [[A:%.*]], <4 x i32> [[B:%.*]], i32 1)
// CHECK-NEXT:    ret <2 x i64> [[TMP0]]
//
int64x2_t test_vqdmulltq_s32(int32x4_t a, int32x4_t b) {
#ifdef POLYMORPHIC
  return vqdmulltq(a, b);
#else  /* POLYMORPHIC */
  return vqdmulltq_s32(a, b);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vqdmulltq_m_s16(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// CHECK-NEXT:    [[TMP1:%.*]] = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 [[TMP0]])
// CHECK-NEXT:    [[TMP2:%.*]] = call <4 x i32> @llvm.arm.mve.vqdmull.predicated.v4i32.v8i16.v4i1(<8 x i16> [[A:%.*]], <8 x i16> [[B:%.*]], i32 1, <4 x i1> [[TMP1]], <4 x i32> [[INACTIVE:%.*]])
// CHECK-NEXT:    ret <4 x i32> [[TMP2]]
//
int32x4_t test_vqdmulltq_m_s16(int32x4_t inactive, int16x8_t a, int16x8_t b, mve_pred16_t p) {
#ifdef POLYMORPHIC
  return vqdmulltq_m(inactive, a, b, p);
#else  /* POLYMORPHIC */
  return vqdmulltq_m_s16(inactive, a, b, p);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vqdmulltq_m_s32(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// CHECK-NEXT:    [[TMP1:%.*]] = call <2 x i1> @llvm.arm.mve.pred.i2v.v2i1(i32 [[TMP0]])
// CHECK-NEXT:    [[TMP2:%.*]] = call <2 x i64> @llvm.arm.mve.vqdmull.predicated.v2i64.v4i32.v2i1(<4 x i32> [[A:%.*]], <4 x i32> [[B:%.*]], i32 1, <2 x i1> [[TMP1]], <2 x i64> [[INACTIVE:%.*]])
// CHECK-NEXT:    ret <2 x i64> [[TMP2]]
//
int64x2_t test_vqdmulltq_m_s32(int64x2_t inactive, int32x4_t a, int32x4_t b, mve_pred16_t p) {
#ifdef POLYMORPHIC
  return vqdmulltq_m(inactive, a, b, p);
#else  /* POLYMORPHIC */
  return vqdmulltq_m_s32(inactive, a, b, p);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vqdmulltq_n_s16(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[DOTSPLATINSERT:%.*]] = insertelement <8 x i16> poison, i16 [[B:%.*]], i32 0
// CHECK-NEXT:    [[DOTSPLAT:%.*]] = shufflevector <8 x i16> [[DOTSPLATINSERT]], <8 x i16> poison, <8 x i32> zeroinitializer
// CHECK-NEXT:    [[TMP0:%.*]] = call <4 x i32> @llvm.arm.mve.vqdmull.v4i32.v8i16(<8 x i16> [[A:%.*]], <8 x i16> [[DOTSPLAT]], i32 1)
// CHECK-NEXT:    ret <4 x i32> [[TMP0]]
//
int32x4_t test_vqdmulltq_n_s16(int16x8_t a, int16_t b) {
#ifdef POLYMORPHIC
  return vqdmulltq(a, b);
#else  /* POLYMORPHIC */
  return vqdmulltq_n_s16(a, b);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vqdmulltq_n_s32(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[DOTSPLATINSERT:%.*]] = insertelement <4 x i32> poison, i32 [[B:%.*]], i32 0
// CHECK-NEXT:    [[DOTSPLAT:%.*]] = shufflevector <4 x i32> [[DOTSPLATINSERT]], <4 x i32> poison, <4 x i32> zeroinitializer
// CHECK-NEXT:    [[TMP0:%.*]] = call <2 x i64> @llvm.arm.mve.vqdmull.v2i64.v4i32(<4 x i32> [[A:%.*]], <4 x i32> [[DOTSPLAT]], i32 1)
// CHECK-NEXT:    ret <2 x i64> [[TMP0]]
//
int64x2_t test_vqdmulltq_n_s32(int32x4_t a, int32_t b) {
#ifdef POLYMORPHIC
  return vqdmulltq(a, b);
#else  /* POLYMORPHIC */
  return vqdmulltq_n_s32(a, b);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vqdmulltq_m_n_s16(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[DOTSPLATINSERT:%.*]] = insertelement <8 x i16> poison, i16 [[B:%.*]], i32 0
// CHECK-NEXT:    [[DOTSPLAT:%.*]] = shufflevector <8 x i16> [[DOTSPLATINSERT]], <8 x i16> poison, <8 x i32> zeroinitializer
// CHECK-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// CHECK-NEXT:    [[TMP1:%.*]] = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 [[TMP0]])
// CHECK-NEXT:    [[TMP2:%.*]] = call <4 x i32> @llvm.arm.mve.vqdmull.predicated.v4i32.v8i16.v4i1(<8 x i16> [[A:%.*]], <8 x i16> [[DOTSPLAT]], i32 1, <4 x i1> [[TMP1]], <4 x i32> [[INACTIVE:%.*]])
// CHECK-NEXT:    ret <4 x i32> [[TMP2]]
//
int32x4_t test_vqdmulltq_m_n_s16(int32x4_t inactive, int16x8_t a, int16_t b, mve_pred16_t p) {
#ifdef POLYMORPHIC
  return vqdmulltq_m(inactive, a, b, p);
#else  /* POLYMORPHIC */
  return vqdmulltq_m_n_s16(inactive, a, b, p);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vqdmulltq_m_n_s32(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[DOTSPLATINSERT:%.*]] = insertelement <4 x i32> poison, i32 [[B:%.*]], i32 0
// CHECK-NEXT:    [[DOTSPLAT:%.*]] = shufflevector <4 x i32> [[DOTSPLATINSERT]], <4 x i32> poison, <4 x i32> zeroinitializer
// CHECK-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// CHECK-NEXT:    [[TMP1:%.*]] = call <2 x i1> @llvm.arm.mve.pred.i2v.v2i1(i32 [[TMP0]])
// CHECK-NEXT:    [[TMP2:%.*]] = call <2 x i64> @llvm.arm.mve.vqdmull.predicated.v2i64.v4i32.v2i1(<4 x i32> [[A:%.*]], <4 x i32> [[DOTSPLAT]], i32 1, <2 x i1> [[TMP1]], <2 x i64> [[INACTIVE:%.*]])
// CHECK-NEXT:    ret <2 x i64> [[TMP2]]
//
int64x2_t test_vqdmulltq_m_n_s32(int64x2_t inactive, int32x4_t a, int32_t b, mve_pred16_t p) {
#ifdef POLYMORPHIC
  return vqdmulltq_m(inactive, a, b, p);
#else  /* POLYMORPHIC */
  return vqdmulltq_m_n_s32(inactive, a, b, p);
#endif /* POLYMORPHIC */
}