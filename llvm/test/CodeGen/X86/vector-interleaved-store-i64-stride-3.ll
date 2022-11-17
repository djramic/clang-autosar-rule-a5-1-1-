; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-- -mattr=+sse2 | FileCheck %s --check-prefixes=SSE
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx  | FileCheck %s --check-prefixes=AVX1
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx2 | FileCheck %s --check-prefixes=AVX2
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx2,+fast-variable-crosslane-shuffle,+fast-variable-perlane-shuffle | FileCheck %s --check-prefixes=AVX2
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx2,+fast-variable-perlane-shuffle | FileCheck %s --check-prefixes=AVX2
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx512bw,+avx512vl | FileCheck %s --check-prefixes=AVX512

; These patterns are produced by LoopVectorizer for interleaved stores.

define void @store_i64_stride3_vf2(ptr %in.vecptr0, ptr %in.vecptr1, ptr %in.vecptr2, ptr %out.vec) nounwind {
; SSE-LABEL: store_i64_stride3_vf2:
; SSE:       # %bb.0:
; SSE-NEXT:    movapd (%rdi), %xmm0
; SSE-NEXT:    movapd (%rsi), %xmm1
; SSE-NEXT:    movapd (%rdx), %xmm2
; SSE-NEXT:    movapd %xmm0, %xmm3
; SSE-NEXT:    unpcklpd {{.*#+}} xmm3 = xmm3[0],xmm1[0]
; SSE-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm2[1]
; SSE-NEXT:    movsd {{.*#+}} xmm0 = xmm2[0],xmm0[1]
; SSE-NEXT:    movapd %xmm0, 16(%rcx)
; SSE-NEXT:    movapd %xmm1, 32(%rcx)
; SSE-NEXT:    movapd %xmm3, (%rcx)
; SSE-NEXT:    retq
;
; AVX1-LABEL: store_i64_stride3_vf2:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vmovaps (%rdi), %xmm0
; AVX1-NEXT:    vmovaps (%rsi), %xmm1
; AVX1-NEXT:    vmovaps (%rdx), %xmm2
; AVX1-NEXT:    vinsertf128 $1, %xmm0, %ymm1, %ymm3
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; AVX1-NEXT:    vshufpd {{.*#+}} ymm0 = ymm0[0],ymm3[0],ymm0[2],ymm3[3]
; AVX1-NEXT:    vunpckhpd {{.*#+}} xmm1 = xmm1[1],xmm2[1]
; AVX1-NEXT:    vmovaps %xmm1, 32(%rcx)
; AVX1-NEXT:    vmovapd %ymm0, (%rcx)
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: store_i64_stride3_vf2:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovaps (%rdi), %xmm0
; AVX2-NEXT:    vmovaps (%rsi), %xmm1
; AVX2-NEXT:    vmovaps (%rdx), %xmm2
; AVX2-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX2-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm3
; AVX2-NEXT:    vpermpd {{.*#+}} ymm0 = ymm0[0,2,2,1]
; AVX2-NEXT:    vblendps {{.*#+}} ymm0 = ymm0[0,1,2,3],ymm3[4,5],ymm0[6,7]
; AVX2-NEXT:    vunpckhpd {{.*#+}} xmm1 = xmm1[1],xmm2[1]
; AVX2-NEXT:    vmovaps %xmm1, 32(%rcx)
; AVX2-NEXT:    vmovaps %ymm0, (%rcx)
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512-LABEL: store_i64_stride3_vf2:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovaps (%rdi), %xmm0
; AVX512-NEXT:    vmovaps (%rdx), %xmm1
; AVX512-NEXT:    vinsertf128 $1, (%rsi), %ymm0, %ymm0
; AVX512-NEXT:    vinsertf64x4 $1, %ymm1, %zmm0, %zmm0
; AVX512-NEXT:    vmovaps {{.*#+}} zmm1 = <0,2,4,1,3,5,u,u>
; AVX512-NEXT:    vpermpd %zmm0, %zmm1, %zmm0
; AVX512-NEXT:    vextractf32x4 $2, %zmm0, 32(%rcx)
; AVX512-NEXT:    vmovaps %ymm0, (%rcx)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %in.vec0 = load <2 x i64>, ptr %in.vecptr0, align 32
  %in.vec1 = load <2 x i64>, ptr %in.vecptr1, align 32
  %in.vec2 = load <2 x i64>, ptr %in.vecptr2, align 32

  %concat01 = shufflevector <2 x i64> %in.vec0, <2 x i64> %in.vec1, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %concat2u = shufflevector <2 x i64> %in.vec2, <2 x i64> poison, <4 x i32> <i32 0, i32 1, i32 undef, i32 undef>
  %concat012 = shufflevector <4 x i64> %concat01, <4 x i64> %concat2u, <6 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5>
  %interleaved.vec = shufflevector <6 x i64> %concat012, <6 x i64> poison, <6 x i32> <i32 0, i32 2, i32 4, i32 1, i32 3, i32 5>

  store <6 x i64> %interleaved.vec, ptr %out.vec, align 32

  ret void
}

define void @store_i64_stride3_vf4(ptr %in.vecptr0, ptr %in.vecptr1, ptr %in.vecptr2, ptr %out.vec) nounwind {
; SSE-LABEL: store_i64_stride3_vf4:
; SSE:       # %bb.0:
; SSE-NEXT:    movaps (%rdi), %xmm0
; SSE-NEXT:    movaps 16(%rdi), %xmm1
; SSE-NEXT:    movaps (%rsi), %xmm2
; SSE-NEXT:    movaps 16(%rsi), %xmm3
; SSE-NEXT:    movaps (%rdx), %xmm4
; SSE-NEXT:    movaps 16(%rdx), %xmm5
; SSE-NEXT:    movaps %xmm3, %xmm6
; SSE-NEXT:    unpckhpd {{.*#+}} xmm6 = xmm6[1],xmm5[1]
; SSE-NEXT:    shufps {{.*#+}} xmm5 = xmm5[0,1],xmm1[2,3]
; SSE-NEXT:    movlhps {{.*#+}} xmm1 = xmm1[0],xmm3[0]
; SSE-NEXT:    movaps %xmm2, %xmm3
; SSE-NEXT:    unpckhpd {{.*#+}} xmm3 = xmm3[1],xmm4[1]
; SSE-NEXT:    shufps {{.*#+}} xmm4 = xmm4[0,1],xmm0[2,3]
; SSE-NEXT:    movlhps {{.*#+}} xmm0 = xmm0[0],xmm2[0]
; SSE-NEXT:    movaps %xmm0, (%rcx)
; SSE-NEXT:    movaps %xmm4, 16(%rcx)
; SSE-NEXT:    movaps %xmm3, 32(%rcx)
; SSE-NEXT:    movaps %xmm1, 48(%rcx)
; SSE-NEXT:    movaps %xmm5, 64(%rcx)
; SSE-NEXT:    movaps %xmm6, 80(%rcx)
; SSE-NEXT:    retq
;
; AVX1-LABEL: store_i64_stride3_vf4:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vmovapd (%rdi), %ymm0
; AVX1-NEXT:    vmovapd (%rsi), %ymm1
; AVX1-NEXT:    vmovapd (%rdx), %ymm2
; AVX1-NEXT:    vmovapd 16(%rdi), %xmm3
; AVX1-NEXT:    vblendpd {{.*#+}} ymm3 = ymm3[0,1],ymm2[2,3]
; AVX1-NEXT:    vpermilpd {{.*#+}} ymm4 = ymm1[0,0,3,2]
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm4 = ymm2[2,3],ymm4[2,3]
; AVX1-NEXT:    vblendpd {{.*#+}} ymm3 = ymm4[0],ymm3[1],ymm4[2],ymm3[3]
; AVX1-NEXT:    vinsertf128 $1, (%rdx), %ymm0, %ymm4
; AVX1-NEXT:    vpermilps {{.*#+}} xmm5 = mem[0,1,0,1]
; AVX1-NEXT:    vinsertf128 $1, (%rdi), %ymm5, %ymm5
; AVX1-NEXT:    vblendps {{.*#+}} ymm4 = ymm4[0,1],ymm5[2,3],ymm4[4,5],ymm5[6,7]
; AVX1-NEXT:    vpermilpd {{.*#+}} ymm1 = ymm1[1,0,2,2]
; AVX1-NEXT:    vblendpd {{.*#+}} ymm0 = ymm1[0,1],ymm0[2],ymm1[3]
; AVX1-NEXT:    vblendpd {{.*#+}} ymm0 = ymm0[0],ymm2[1],ymm0[2,3]
; AVX1-NEXT:    vmovaps %ymm4, (%rcx)
; AVX1-NEXT:    vmovapd %ymm3, 64(%rcx)
; AVX1-NEXT:    vmovapd %ymm0, 32(%rcx)
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: store_i64_stride3_vf4:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovaps (%rdi), %ymm0
; AVX2-NEXT:    vmovaps (%rsi), %ymm1
; AVX2-NEXT:    vmovaps (%rdx), %ymm2
; AVX2-NEXT:    vpermilps {{.*#+}} ymm3 = ymm1[2,3,0,1,6,7,4,5]
; AVX2-NEXT:    vblendps {{.*#+}} ymm3 = ymm3[0,1,2,3],ymm0[4,5],ymm3[6,7]
; AVX2-NEXT:    vblendps {{.*#+}} ymm3 = ymm3[0,1],ymm2[2,3],ymm3[4,5,6,7]
; AVX2-NEXT:    vunpckhpd {{.*#+}} ymm1 = ymm0[1],ymm1[1],ymm0[3],ymm1[3]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm1 = ymm1[0,2,3,3]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm2 = ymm2[2,1,2,3]
; AVX2-NEXT:    vblendps {{.*#+}} ymm1 = ymm2[0,1],ymm1[2,3,4,5],ymm2[6,7]
; AVX2-NEXT:    vmovddup {{.*#+}} xmm2 = mem[0,0]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm0 = ymm0[0,1,2,1]
; AVX2-NEXT:    vblendps {{.*#+}} ymm0 = ymm0[0,1],ymm2[2,3],ymm0[4,5,6,7]
; AVX2-NEXT:    vbroadcastsd (%rdx), %ymm2
; AVX2-NEXT:    vblendps {{.*#+}} ymm0 = ymm0[0,1,2,3],ymm2[4,5],ymm0[6,7]
; AVX2-NEXT:    vmovaps %ymm0, (%rcx)
; AVX2-NEXT:    vmovaps %ymm1, 64(%rcx)
; AVX2-NEXT:    vmovaps %ymm3, 32(%rcx)
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512-LABEL: store_i64_stride3_vf4:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512-NEXT:    vmovdqa (%rdx), %ymm1
; AVX512-NEXT:    vinserti64x4 $1, (%rsi), %zmm0, %zmm0
; AVX512-NEXT:    vmovdqa {{.*#+}} ymm2 = [10,3,7,11]
; AVX512-NEXT:    vpermi2q %zmm1, %zmm0, %zmm2
; AVX512-NEXT:    vmovdqa64 {{.*#+}} zmm3 = [0,4,8,1,5,9,2,6]
; AVX512-NEXT:    vpermi2q %zmm1, %zmm0, %zmm3
; AVX512-NEXT:    vmovdqu64 %zmm3, (%rcx)
; AVX512-NEXT:    vmovdqa %ymm2, 64(%rcx)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %in.vec0 = load <4 x i64>, ptr %in.vecptr0, align 32
  %in.vec1 = load <4 x i64>, ptr %in.vecptr1, align 32
  %in.vec2 = load <4 x i64>, ptr %in.vecptr2, align 32

  %concat01 = shufflevector <4 x i64> %in.vec0, <4 x i64> %in.vec1, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %concat2u = shufflevector <4 x i64> %in.vec2, <4 x i64> poison, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef>
  %concat012 = shufflevector <8 x i64> %concat01, <8 x i64> %concat2u, <12 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11>
  %interleaved.vec = shufflevector <12 x i64> %concat012, <12 x i64> poison, <12 x i32> <i32 0, i32 4, i32 8, i32 1, i32 5, i32 9, i32 2, i32 6, i32 10, i32 3, i32 7, i32 11>

  store <12 x i64> %interleaved.vec, ptr %out.vec, align 32

  ret void
}

define void @store_i64_stride3_vf8(ptr %in.vecptr0, ptr %in.vecptr1, ptr %in.vecptr2, ptr %out.vec) nounwind {
; SSE-LABEL: store_i64_stride3_vf8:
; SSE:       # %bb.0:
; SSE-NEXT:    movaps (%rdi), %xmm3
; SSE-NEXT:    movaps 16(%rdi), %xmm2
; SSE-NEXT:    movaps 32(%rdi), %xmm1
; SSE-NEXT:    movaps 48(%rdi), %xmm0
; SSE-NEXT:    movaps (%rsi), %xmm7
; SSE-NEXT:    movaps 16(%rsi), %xmm8
; SSE-NEXT:    movaps 32(%rsi), %xmm9
; SSE-NEXT:    movaps 48(%rsi), %xmm10
; SSE-NEXT:    movaps (%rdx), %xmm11
; SSE-NEXT:    movaps 16(%rdx), %xmm12
; SSE-NEXT:    movaps 32(%rdx), %xmm6
; SSE-NEXT:    movaps 48(%rdx), %xmm5
; SSE-NEXT:    movaps %xmm10, %xmm4
; SSE-NEXT:    unpckhpd {{.*#+}} xmm4 = xmm4[1],xmm5[1]
; SSE-NEXT:    shufps {{.*#+}} xmm5 = xmm5[0,1],xmm0[2,3]
; SSE-NEXT:    movlhps {{.*#+}} xmm0 = xmm0[0],xmm10[0]
; SSE-NEXT:    movaps %xmm9, %xmm10
; SSE-NEXT:    unpckhpd {{.*#+}} xmm10 = xmm10[1],xmm6[1]
; SSE-NEXT:    shufps {{.*#+}} xmm6 = xmm6[0,1],xmm1[2,3]
; SSE-NEXT:    movlhps {{.*#+}} xmm1 = xmm1[0],xmm9[0]
; SSE-NEXT:    movaps %xmm8, %xmm9
; SSE-NEXT:    unpckhpd {{.*#+}} xmm9 = xmm9[1],xmm12[1]
; SSE-NEXT:    shufps {{.*#+}} xmm12 = xmm12[0,1],xmm2[2,3]
; SSE-NEXT:    movlhps {{.*#+}} xmm2 = xmm2[0],xmm8[0]
; SSE-NEXT:    movaps %xmm7, %xmm8
; SSE-NEXT:    unpckhpd {{.*#+}} xmm8 = xmm8[1],xmm11[1]
; SSE-NEXT:    shufps {{.*#+}} xmm11 = xmm11[0,1],xmm3[2,3]
; SSE-NEXT:    movlhps {{.*#+}} xmm3 = xmm3[0],xmm7[0]
; SSE-NEXT:    movaps %xmm3, (%rcx)
; SSE-NEXT:    movaps %xmm11, 16(%rcx)
; SSE-NEXT:    movaps %xmm8, 32(%rcx)
; SSE-NEXT:    movaps %xmm2, 48(%rcx)
; SSE-NEXT:    movaps %xmm12, 64(%rcx)
; SSE-NEXT:    movaps %xmm9, 80(%rcx)
; SSE-NEXT:    movaps %xmm1, 96(%rcx)
; SSE-NEXT:    movaps %xmm6, 112(%rcx)
; SSE-NEXT:    movaps %xmm10, 128(%rcx)
; SSE-NEXT:    movaps %xmm0, 144(%rcx)
; SSE-NEXT:    movaps %xmm5, 160(%rcx)
; SSE-NEXT:    movaps %xmm4, 176(%rcx)
; SSE-NEXT:    retq
;
; AVX1-LABEL: store_i64_stride3_vf8:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vmovapd 32(%rdi), %ymm0
; AVX1-NEXT:    vmovapd (%rdi), %ymm1
; AVX1-NEXT:    vmovapd (%rsi), %ymm2
; AVX1-NEXT:    vmovapd 32(%rsi), %ymm3
; AVX1-NEXT:    vmovapd (%rdx), %ymm4
; AVX1-NEXT:    vmovapd 32(%rdx), %ymm5
; AVX1-NEXT:    vinsertf128 $1, (%rdx), %ymm1, %ymm6
; AVX1-NEXT:    vpermilps {{.*#+}} xmm7 = mem[0,1,0,1]
; AVX1-NEXT:    vinsertf128 $1, (%rdi), %ymm7, %ymm7
; AVX1-NEXT:    vblendps {{.*#+}} ymm6 = ymm6[0,1],ymm7[2,3],ymm6[4,5],ymm7[6,7]
; AVX1-NEXT:    vmovapd 48(%rdi), %xmm7
; AVX1-NEXT:    vblendpd {{.*#+}} ymm7 = ymm7[0,1],ymm5[2,3]
; AVX1-NEXT:    vpermilpd {{.*#+}} ymm8 = ymm3[0,0,3,2]
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm8 = ymm5[2,3],ymm8[2,3]
; AVX1-NEXT:    vblendpd {{.*#+}} ymm7 = ymm8[0],ymm7[1],ymm8[2],ymm7[3]
; AVX1-NEXT:    vinsertf128 $1, 32(%rdx), %ymm0, %ymm8
; AVX1-NEXT:    vpermilps {{.*#+}} xmm9 = mem[0,1,0,1]
; AVX1-NEXT:    vinsertf128 $1, 32(%rdi), %ymm9, %ymm9
; AVX1-NEXT:    vblendps {{.*#+}} ymm8 = ymm8[0,1],ymm9[2,3],ymm8[4,5],ymm9[6,7]
; AVX1-NEXT:    vmovapd 16(%rdi), %xmm9
; AVX1-NEXT:    vblendpd {{.*#+}} ymm9 = ymm9[0,1],ymm4[2,3]
; AVX1-NEXT:    vpermilpd {{.*#+}} ymm10 = ymm2[0,0,3,2]
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm10 = ymm4[2,3],ymm10[2,3]
; AVX1-NEXT:    vblendpd {{.*#+}} ymm9 = ymm10[0],ymm9[1],ymm10[2],ymm9[3]
; AVX1-NEXT:    vpermilpd {{.*#+}} ymm3 = ymm3[1,0,2,2]
; AVX1-NEXT:    vblendpd {{.*#+}} ymm0 = ymm3[0,1],ymm0[2],ymm3[3]
; AVX1-NEXT:    vblendpd {{.*#+}} ymm0 = ymm0[0],ymm5[1],ymm0[2,3]
; AVX1-NEXT:    vpermilpd {{.*#+}} ymm2 = ymm2[1,0,2,2]
; AVX1-NEXT:    vblendpd {{.*#+}} ymm1 = ymm2[0,1],ymm1[2],ymm2[3]
; AVX1-NEXT:    vblendpd {{.*#+}} ymm1 = ymm1[0],ymm4[1],ymm1[2,3]
; AVX1-NEXT:    vmovapd %ymm1, 32(%rcx)
; AVX1-NEXT:    vmovapd %ymm9, 64(%rcx)
; AVX1-NEXT:    vmovaps %ymm8, 96(%rcx)
; AVX1-NEXT:    vmovapd %ymm7, 160(%rcx)
; AVX1-NEXT:    vmovapd %ymm0, 128(%rcx)
; AVX1-NEXT:    vmovaps %ymm6, (%rcx)
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: store_i64_stride3_vf8:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovaps (%rdi), %ymm0
; AVX2-NEXT:    vmovaps 32(%rdi), %ymm1
; AVX2-NEXT:    vmovaps (%rsi), %ymm2
; AVX2-NEXT:    vmovaps 32(%rsi), %ymm3
; AVX2-NEXT:    vmovaps (%rdx), %ymm4
; AVX2-NEXT:    vmovaps 32(%rdx), %ymm5
; AVX2-NEXT:    vmovddup {{.*#+}} xmm6 = mem[0,0]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm7 = ymm0[0,1,2,1]
; AVX2-NEXT:    vblendps {{.*#+}} ymm6 = ymm7[0,1],ymm6[2,3],ymm7[4,5,6,7]
; AVX2-NEXT:    vbroadcastsd (%rdx), %ymm7
; AVX2-NEXT:    vblendps {{.*#+}} ymm6 = ymm6[0,1,2,3],ymm7[4,5],ymm6[6,7]
; AVX2-NEXT:    vpermilps {{.*#+}} ymm7 = ymm3[2,3,0,1,6,7,4,5]
; AVX2-NEXT:    vblendps {{.*#+}} ymm7 = ymm7[0,1,2,3],ymm1[4,5],ymm7[6,7]
; AVX2-NEXT:    vblendps {{.*#+}} ymm7 = ymm7[0,1],ymm5[2,3],ymm7[4,5,6,7]
; AVX2-NEXT:    vunpckhpd {{.*#+}} ymm3 = ymm1[1],ymm3[1],ymm1[3],ymm3[3]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm3 = ymm3[0,2,3,3]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm5 = ymm5[2,1,2,3]
; AVX2-NEXT:    vblendps {{.*#+}} ymm3 = ymm5[0,1],ymm3[2,3,4,5],ymm5[6,7]
; AVX2-NEXT:    vmovddup {{.*#+}} xmm5 = mem[0,0]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm1 = ymm1[0,1,2,1]
; AVX2-NEXT:    vblendps {{.*#+}} ymm1 = ymm1[0,1],ymm5[2,3],ymm1[4,5,6,7]
; AVX2-NEXT:    vbroadcastsd 32(%rdx), %ymm5
; AVX2-NEXT:    vblendps {{.*#+}} ymm1 = ymm1[0,1,2,3],ymm5[4,5],ymm1[6,7]
; AVX2-NEXT:    vunpckhpd {{.*#+}} ymm5 = ymm0[1],ymm2[1],ymm0[3],ymm2[3]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm5 = ymm5[0,2,3,3]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm8 = ymm4[2,1,2,3]
; AVX2-NEXT:    vblendps {{.*#+}} ymm5 = ymm8[0,1],ymm5[2,3,4,5],ymm8[6,7]
; AVX2-NEXT:    vpermilps {{.*#+}} ymm2 = ymm2[2,3,0,1,6,7,4,5]
; AVX2-NEXT:    vblendps {{.*#+}} ymm0 = ymm2[0,1,2,3],ymm0[4,5],ymm2[6,7]
; AVX2-NEXT:    vblendps {{.*#+}} ymm0 = ymm0[0,1],ymm4[2,3],ymm0[4,5,6,7]
; AVX2-NEXT:    vmovaps %ymm0, 32(%rcx)
; AVX2-NEXT:    vmovaps %ymm5, 64(%rcx)
; AVX2-NEXT:    vmovaps %ymm1, 96(%rcx)
; AVX2-NEXT:    vmovaps %ymm3, 160(%rcx)
; AVX2-NEXT:    vmovaps %ymm7, 128(%rcx)
; AVX2-NEXT:    vmovaps %ymm6, (%rcx)
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512-LABEL: store_i64_stride3_vf8:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovdqu64 (%rdi), %zmm0
; AVX512-NEXT:    vmovdqu64 (%rsi), %zmm1
; AVX512-NEXT:    vmovdqu64 (%rdx), %zmm2
; AVX512-NEXT:    vmovdqa64 {{.*#+}} zmm3 = <0,8,u,1,9,u,2,10>
; AVX512-NEXT:    vpermi2q %zmm1, %zmm0, %zmm3
; AVX512-NEXT:    vmovdqa64 {{.*#+}} zmm4 = [0,1,8,3,4,9,6,7]
; AVX512-NEXT:    vpermi2q %zmm2, %zmm3, %zmm4
; AVX512-NEXT:    vmovdqa64 {{.*#+}} zmm3 = <u,3,11,u,4,12,u,5>
; AVX512-NEXT:    vpermi2q %zmm1, %zmm0, %zmm3
; AVX512-NEXT:    vmovdqa64 {{.*#+}} zmm5 = [10,1,2,11,4,5,12,7]
; AVX512-NEXT:    vpermi2q %zmm2, %zmm3, %zmm5
; AVX512-NEXT:    vmovdqa64 {{.*#+}} zmm3 = <5,u,14,6,u,15,7,u>
; AVX512-NEXT:    vpermi2q %zmm0, %zmm1, %zmm3
; AVX512-NEXT:    vmovdqa64 {{.*#+}} zmm0 = [0,13,2,3,14,5,6,15]
; AVX512-NEXT:    vpermi2q %zmm2, %zmm3, %zmm0
; AVX512-NEXT:    vmovdqu64 %zmm0, 128(%rcx)
; AVX512-NEXT:    vmovdqu64 %zmm5, 64(%rcx)
; AVX512-NEXT:    vmovdqu64 %zmm4, (%rcx)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %in.vec0 = load <8 x i64>, ptr %in.vecptr0, align 32
  %in.vec1 = load <8 x i64>, ptr %in.vecptr1, align 32
  %in.vec2 = load <8 x i64>, ptr %in.vecptr2, align 32

  %concat01 = shufflevector <8 x i64> %in.vec0, <8 x i64> %in.vec1, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %concat2u = shufflevector <8 x i64> %in.vec2, <8 x i64> poison, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %concat012 = shufflevector <16 x i64> %concat01, <16 x i64> %concat2u, <24 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23>
  %interleaved.vec = shufflevector <24 x i64> %concat012, <24 x i64> poison, <24 x i32> <i32 0, i32 8, i32 16, i32 1, i32 9, i32 17, i32 2, i32 10, i32 18, i32 3, i32 11, i32 19, i32 4, i32 12, i32 20, i32 5, i32 13, i32 21, i32 6, i32 14, i32 22, i32 7, i32 15, i32 23>

  store <24 x i64> %interleaved.vec, ptr %out.vec, align 32

  ret void
}

define void @store_i64_stride3_vf16(ptr %in.vecptr0, ptr %in.vecptr1, ptr %in.vecptr2, ptr %out.vec) nounwind {
; SSE-LABEL: store_i64_stride3_vf16:
; SSE:       # %bb.0:
; SSE-NEXT:    subq $24, %rsp
; SSE-NEXT:    movapd 64(%rdi), %xmm4
; SSE-NEXT:    movapd (%rdi), %xmm0
; SSE-NEXT:    movapd 16(%rdi), %xmm1
; SSE-NEXT:    movapd 32(%rdi), %xmm2
; SSE-NEXT:    movapd 48(%rdi), %xmm5
; SSE-NEXT:    movapd 64(%rsi), %xmm9
; SSE-NEXT:    movapd (%rsi), %xmm3
; SSE-NEXT:    movapd 16(%rsi), %xmm6
; SSE-NEXT:    movapd 32(%rsi), %xmm7
; SSE-NEXT:    movapd 48(%rsi), %xmm10
; SSE-NEXT:    movapd 64(%rdx), %xmm15
; SSE-NEXT:    movapd (%rdx), %xmm11
; SSE-NEXT:    movapd 16(%rdx), %xmm12
; SSE-NEXT:    movapd 32(%rdx), %xmm13
; SSE-NEXT:    movapd 48(%rdx), %xmm14
; SSE-NEXT:    movapd %xmm0, %xmm8
; SSE-NEXT:    unpcklpd {{.*#+}} xmm8 = xmm8[0],xmm3[0]
; SSE-NEXT:    movapd %xmm8, (%rsp) # 16-byte Spill
; SSE-NEXT:    movsd {{.*#+}} xmm0 = xmm11[0],xmm0[1]
; SSE-NEXT:    movapd %xmm0, {{[-0-9]+}}(%r{{[sb]}}p) # 16-byte Spill
; SSE-NEXT:    unpckhpd {{.*#+}} xmm3 = xmm3[1],xmm11[1]
; SSE-NEXT:    movapd %xmm3, {{[-0-9]+}}(%r{{[sb]}}p) # 16-byte Spill
; SSE-NEXT:    movapd %xmm1, %xmm0
; SSE-NEXT:    movapd %xmm1, %xmm11
; SSE-NEXT:    unpcklpd {{.*#+}} xmm11 = xmm11[0],xmm6[0]
; SSE-NEXT:    movsd {{.*#+}} xmm0 = xmm12[0],xmm0[1]
; SSE-NEXT:    movapd %xmm0, {{[-0-9]+}}(%r{{[sb]}}p) # 16-byte Spill
; SSE-NEXT:    unpckhpd {{.*#+}} xmm6 = xmm6[1],xmm12[1]
; SSE-NEXT:    movapd %xmm6, {{[-0-9]+}}(%r{{[sb]}}p) # 16-byte Spill
; SSE-NEXT:    movapd %xmm2, %xmm12
; SSE-NEXT:    unpcklpd {{.*#+}} xmm12 = xmm12[0],xmm7[0]
; SSE-NEXT:    movsd {{.*#+}} xmm2 = xmm13[0],xmm2[1]
; SSE-NEXT:    movapd %xmm2, {{[-0-9]+}}(%r{{[sb]}}p) # 16-byte Spill
; SSE-NEXT:    unpckhpd {{.*#+}} xmm7 = xmm7[1],xmm13[1]
; SSE-NEXT:    movapd %xmm7, {{[-0-9]+}}(%r{{[sb]}}p) # 16-byte Spill
; SSE-NEXT:    movapd %xmm5, %xmm13
; SSE-NEXT:    unpcklpd {{.*#+}} xmm13 = xmm13[0],xmm10[0]
; SSE-NEXT:    movsd {{.*#+}} xmm5 = xmm14[0],xmm5[1]
; SSE-NEXT:    movapd %xmm5, {{[-0-9]+}}(%r{{[sb]}}p) # 16-byte Spill
; SSE-NEXT:    unpckhpd {{.*#+}} xmm10 = xmm10[1],xmm14[1]
; SSE-NEXT:    movapd %xmm4, %xmm14
; SSE-NEXT:    unpcklpd {{.*#+}} xmm14 = xmm14[0],xmm9[0]
; SSE-NEXT:    movsd {{.*#+}} xmm4 = xmm15[0],xmm4[1]
; SSE-NEXT:    movapd %xmm4, {{[-0-9]+}}(%r{{[sb]}}p) # 16-byte Spill
; SSE-NEXT:    unpckhpd {{.*#+}} xmm9 = xmm9[1],xmm15[1]
; SSE-NEXT:    movapd 80(%rdi), %xmm15
; SSE-NEXT:    movapd 80(%rsi), %xmm6
; SSE-NEXT:    movapd %xmm15, %xmm8
; SSE-NEXT:    unpcklpd {{.*#+}} xmm8 = xmm8[0],xmm6[0]
; SSE-NEXT:    movapd 80(%rdx), %xmm0
; SSE-NEXT:    movsd {{.*#+}} xmm15 = xmm0[0],xmm15[1]
; SSE-NEXT:    unpckhpd {{.*#+}} xmm6 = xmm6[1],xmm0[1]
; SSE-NEXT:    movapd 96(%rdi), %xmm4
; SSE-NEXT:    movapd 96(%rsi), %xmm1
; SSE-NEXT:    movapd %xmm4, %xmm7
; SSE-NEXT:    unpcklpd {{.*#+}} xmm7 = xmm7[0],xmm1[0]
; SSE-NEXT:    movapd 96(%rdx), %xmm2
; SSE-NEXT:    movsd {{.*#+}} xmm4 = xmm2[0],xmm4[1]
; SSE-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm2[1]
; SSE-NEXT:    movapd 112(%rdi), %xmm2
; SSE-NEXT:    movapd 112(%rsi), %xmm0
; SSE-NEXT:    movapd %xmm2, %xmm3
; SSE-NEXT:    unpcklpd {{.*#+}} xmm3 = xmm3[0],xmm0[0]
; SSE-NEXT:    movapd 112(%rdx), %xmm5
; SSE-NEXT:    movsd {{.*#+}} xmm2 = xmm5[0],xmm2[1]
; SSE-NEXT:    unpckhpd {{.*#+}} xmm0 = xmm0[1],xmm5[1]
; SSE-NEXT:    movapd %xmm0, 368(%rcx)
; SSE-NEXT:    movapd %xmm2, 352(%rcx)
; SSE-NEXT:    movapd %xmm3, 336(%rcx)
; SSE-NEXT:    movapd %xmm1, 320(%rcx)
; SSE-NEXT:    movapd %xmm4, 304(%rcx)
; SSE-NEXT:    movapd %xmm7, 288(%rcx)
; SSE-NEXT:    movapd %xmm6, 272(%rcx)
; SSE-NEXT:    movapd %xmm15, 256(%rcx)
; SSE-NEXT:    movapd %xmm8, 240(%rcx)
; SSE-NEXT:    movapd %xmm9, 224(%rcx)
; SSE-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 # 16-byte Reload
; SSE-NEXT:    movaps %xmm0, 208(%rcx)
; SSE-NEXT:    movapd %xmm14, 192(%rcx)
; SSE-NEXT:    movapd %xmm10, 176(%rcx)
; SSE-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 # 16-byte Reload
; SSE-NEXT:    movaps %xmm0, 160(%rcx)
; SSE-NEXT:    movapd %xmm13, 144(%rcx)
; SSE-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 # 16-byte Reload
; SSE-NEXT:    movaps %xmm0, 128(%rcx)
; SSE-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 # 16-byte Reload
; SSE-NEXT:    movaps %xmm0, 112(%rcx)
; SSE-NEXT:    movapd %xmm12, 96(%rcx)
; SSE-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 # 16-byte Reload
; SSE-NEXT:    movaps %xmm0, 80(%rcx)
; SSE-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 # 16-byte Reload
; SSE-NEXT:    movaps %xmm0, 64(%rcx)
; SSE-NEXT:    movapd %xmm11, 48(%rcx)
; SSE-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 # 16-byte Reload
; SSE-NEXT:    movaps %xmm0, 32(%rcx)
; SSE-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 # 16-byte Reload
; SSE-NEXT:    movaps %xmm0, 16(%rcx)
; SSE-NEXT:    movaps (%rsp), %xmm0 # 16-byte Reload
; SSE-NEXT:    movaps %xmm0, (%rcx)
; SSE-NEXT:    addq $24, %rsp
; SSE-NEXT:    retq
;
; AVX1-LABEL: store_i64_stride3_vf16:
; AVX1:       # %bb.0:
; AVX1-NEXT:    subq $40, %rsp
; AVX1-NEXT:    vmovapd 32(%rdi), %ymm2
; AVX1-NEXT:    vmovapd 64(%rdi), %ymm4
; AVX1-NEXT:    vmovaps (%rdi), %ymm0
; AVX1-NEXT:    vmovups %ymm0, {{[-0-9]+}}(%r{{[sb]}}p) # 32-byte Spill
; AVX1-NEXT:    vmovapd 32(%rsi), %ymm6
; AVX1-NEXT:    vmovapd 64(%rsi), %ymm9
; AVX1-NEXT:    vmovapd 96(%rsi), %ymm5
; AVX1-NEXT:    vmovapd 32(%rdx), %ymm8
; AVX1-NEXT:    vmovapd 64(%rdx), %ymm11
; AVX1-NEXT:    vmovapd 96(%rdx), %ymm7
; AVX1-NEXT:    vinsertf128 $1, (%rdx), %ymm0, %ymm1
; AVX1-NEXT:    vpermilps {{.*#+}} xmm3 = mem[0,1,0,1]
; AVX1-NEXT:    vinsertf128 $1, (%rdi), %ymm3, %ymm3
; AVX1-NEXT:    vblendps {{.*#+}} ymm0 = ymm1[0,1],ymm3[2,3],ymm1[4,5],ymm3[6,7]
; AVX1-NEXT:    vmovups %ymm0, (%rsp) # 32-byte Spill
; AVX1-NEXT:    vmovapd 80(%rdi), %xmm3
; AVX1-NEXT:    vblendpd {{.*#+}} ymm3 = ymm3[0,1],ymm11[2,3]
; AVX1-NEXT:    vpermilpd {{.*#+}} ymm10 = ymm9[0,0,3,2]
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm10 = ymm11[2,3],ymm10[2,3]
; AVX1-NEXT:    vblendpd {{.*#+}} ymm0 = ymm10[0],ymm3[1],ymm10[2],ymm3[3]
; AVX1-NEXT:    vmovupd %ymm0, {{[-0-9]+}}(%r{{[sb]}}p) # 32-byte Spill
; AVX1-NEXT:    vinsertf128 $1, 64(%rdx), %ymm4, %ymm10
; AVX1-NEXT:    vpermilps {{.*#+}} xmm12 = mem[0,1,0,1]
; AVX1-NEXT:    vinsertf128 $1, 64(%rdi), %ymm12, %ymm12
; AVX1-NEXT:    vblendps {{.*#+}} ymm0 = ymm10[0,1],ymm12[2,3],ymm10[4,5],ymm12[6,7]
; AVX1-NEXT:    vmovups %ymm0, {{[-0-9]+}}(%r{{[sb]}}p) # 32-byte Spill
; AVX1-NEXT:    vmovapd 48(%rdi), %xmm12
; AVX1-NEXT:    vblendpd {{.*#+}} ymm12 = ymm12[0,1],ymm8[2,3]
; AVX1-NEXT:    vpermilpd {{.*#+}} ymm13 = ymm6[0,0,3,2]
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm13 = ymm8[2,3],ymm13[2,3]
; AVX1-NEXT:    vblendpd {{.*#+}} ymm0 = ymm13[0],ymm12[1],ymm13[2],ymm12[3]
; AVX1-NEXT:    vmovupd %ymm0, {{[-0-9]+}}(%r{{[sb]}}p) # 32-byte Spill
; AVX1-NEXT:    vinsertf128 $1, 32(%rdx), %ymm2, %ymm13
; AVX1-NEXT:    vmovapd %ymm2, %ymm12
; AVX1-NEXT:    vpermilps {{.*#+}} xmm14 = mem[0,1,0,1]
; AVX1-NEXT:    vinsertf128 $1, 32(%rdi), %ymm14, %ymm14
; AVX1-NEXT:    vblendps {{.*#+}} ymm13 = ymm13[0,1],ymm14[2,3],ymm13[4,5],ymm14[6,7]
; AVX1-NEXT:    vmovapd 112(%rdi), %xmm14
; AVX1-NEXT:    vblendpd {{.*#+}} ymm14 = ymm14[0,1],ymm7[2,3]
; AVX1-NEXT:    vpermilpd {{.*#+}} ymm15 = ymm5[0,0,3,2]
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm15 = ymm7[2,3],ymm15[2,3]
; AVX1-NEXT:    vblendpd {{.*#+}} ymm14 = ymm15[0],ymm14[1],ymm15[2],ymm14[3]
; AVX1-NEXT:    vpermilps {{.*#+}} xmm15 = mem[0,1,0,1]
; AVX1-NEXT:    vinsertf128 $1, 96(%rdi), %ymm15, %ymm15
; AVX1-NEXT:    vmovapd 96(%rdi), %ymm2
; AVX1-NEXT:    vinsertf128 $1, 96(%rdx), %ymm2, %ymm1
; AVX1-NEXT:    vblendps {{.*#+}} ymm1 = ymm1[0,1],ymm15[2,3],ymm1[4,5],ymm15[6,7]
; AVX1-NEXT:    vmovapd (%rdx), %ymm15
; AVX1-NEXT:    vmovapd 16(%rdi), %xmm3
; AVX1-NEXT:    vblendpd {{.*#+}} ymm3 = ymm3[0,1],ymm15[2,3]
; AVX1-NEXT:    vmovapd (%rsi), %ymm0
; AVX1-NEXT:    vpermilpd {{.*#+}} ymm10 = ymm0[0,0,3,2]
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm10 = ymm15[2,3],ymm10[2,3]
; AVX1-NEXT:    vblendpd {{.*#+}} ymm3 = ymm10[0],ymm3[1],ymm10[2],ymm3[3]
; AVX1-NEXT:    vpermilpd {{.*#+}} ymm9 = ymm9[1,0,2,2]
; AVX1-NEXT:    vblendpd {{.*#+}} ymm4 = ymm9[0,1],ymm4[2],ymm9[3]
; AVX1-NEXT:    vblendpd {{.*#+}} ymm4 = ymm4[0],ymm11[1],ymm4[2,3]
; AVX1-NEXT:    vpermilpd {{.*#+}} ymm6 = ymm6[1,0,2,2]
; AVX1-NEXT:    vblendpd {{.*#+}} ymm6 = ymm6[0,1],ymm12[2],ymm6[3]
; AVX1-NEXT:    vblendpd {{.*#+}} ymm6 = ymm6[0],ymm8[1],ymm6[2,3]
; AVX1-NEXT:    vpermilpd {{.*#+}} ymm5 = ymm5[1,0,2,2]
; AVX1-NEXT:    vblendpd {{.*#+}} ymm2 = ymm5[0,1],ymm2[2],ymm5[3]
; AVX1-NEXT:    vblendpd {{.*#+}} ymm2 = ymm2[0],ymm7[1],ymm2[2,3]
; AVX1-NEXT:    vpermilpd {{.*#+}} ymm0 = ymm0[1,0,2,2]
; AVX1-NEXT:    vblendpd $4, {{[-0-9]+}}(%r{{[sb]}}p), %ymm0, %ymm0 # 32-byte Folded Reload
; AVX1-NEXT:    # ymm0 = ymm0[0,1],mem[2],ymm0[3]
; AVX1-NEXT:    vblendpd {{.*#+}} ymm0 = ymm0[0],ymm15[1],ymm0[2,3]
; AVX1-NEXT:    vmovapd %ymm0, 32(%rcx)
; AVX1-NEXT:    vmovapd %ymm3, 64(%rcx)
; AVX1-NEXT:    vmovaps %ymm1, 288(%rcx)
; AVX1-NEXT:    vmovapd %ymm14, 352(%rcx)
; AVX1-NEXT:    vmovapd %ymm2, 320(%rcx)
; AVX1-NEXT:    vmovaps %ymm13, 96(%rcx)
; AVX1-NEXT:    vmovups {{[-0-9]+}}(%r{{[sb]}}p), %ymm0 # 32-byte Reload
; AVX1-NEXT:    vmovaps %ymm0, 160(%rcx)
; AVX1-NEXT:    vmovapd %ymm6, 128(%rcx)
; AVX1-NEXT:    vmovapd %ymm4, 224(%rcx)
; AVX1-NEXT:    vmovups {{[-0-9]+}}(%r{{[sb]}}p), %ymm0 # 32-byte Reload
; AVX1-NEXT:    vmovaps %ymm0, 192(%rcx)
; AVX1-NEXT:    vmovups {{[-0-9]+}}(%r{{[sb]}}p), %ymm0 # 32-byte Reload
; AVX1-NEXT:    vmovaps %ymm0, 256(%rcx)
; AVX1-NEXT:    vmovups (%rsp), %ymm0 # 32-byte Reload
; AVX1-NEXT:    vmovaps %ymm0, (%rcx)
; AVX1-NEXT:    addq $40, %rsp
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: store_i64_stride3_vf16:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovaps (%rdi), %ymm0
; AVX2-NEXT:    vmovaps 32(%rdi), %ymm9
; AVX2-NEXT:    vmovaps 64(%rdi), %ymm7
; AVX2-NEXT:    vmovaps 96(%rdi), %ymm5
; AVX2-NEXT:    vmovaps (%rsi), %ymm2
; AVX2-NEXT:    vmovaps 32(%rsi), %ymm12
; AVX2-NEXT:    vmovaps 64(%rsi), %ymm11
; AVX2-NEXT:    vmovaps 96(%rsi), %ymm8
; AVX2-NEXT:    vmovaps (%rdx), %ymm3
; AVX2-NEXT:    vmovaps 32(%rdx), %ymm13
; AVX2-NEXT:    vmovaps 64(%rdx), %ymm14
; AVX2-NEXT:    vmovaps 96(%rdx), %ymm10
; AVX2-NEXT:    vmovddup {{.*#+}} xmm1 = mem[0,0]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm4 = ymm0[0,1,2,1]
; AVX2-NEXT:    vblendps {{.*#+}} ymm1 = ymm4[0,1],ymm1[2,3],ymm4[4,5,6,7]
; AVX2-NEXT:    vbroadcastsd (%rdx), %ymm4
; AVX2-NEXT:    vblendps {{.*#+}} ymm1 = ymm1[0,1,2,3],ymm4[4,5],ymm1[6,7]
; AVX2-NEXT:    vunpckhpd {{.*#+}} ymm4 = ymm7[1],ymm11[1],ymm7[3],ymm11[3]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm4 = ymm4[0,2,3,3]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm6 = ymm14[2,1,2,3]
; AVX2-NEXT:    vblendps {{.*#+}} ymm4 = ymm6[0,1],ymm4[2,3,4,5],ymm6[6,7]
; AVX2-NEXT:    vmovddup {{.*#+}} xmm6 = mem[0,0]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm15 = ymm7[0,1,2,1]
; AVX2-NEXT:    vblendps {{.*#+}} ymm6 = ymm15[0,1],ymm6[2,3],ymm15[4,5,6,7]
; AVX2-NEXT:    vbroadcastsd 64(%rdx), %ymm15
; AVX2-NEXT:    vblendps {{.*#+}} ymm6 = ymm6[0,1,2,3],ymm15[4,5],ymm6[6,7]
; AVX2-NEXT:    vpermilps {{.*#+}} ymm11 = ymm11[2,3,0,1,6,7,4,5]
; AVX2-NEXT:    vblendps {{.*#+}} ymm7 = ymm11[0,1,2,3],ymm7[4,5],ymm11[6,7]
; AVX2-NEXT:    vblendps {{.*#+}} ymm7 = ymm7[0,1],ymm14[2,3],ymm7[4,5,6,7]
; AVX2-NEXT:    vpermilps {{.*#+}} ymm11 = ymm12[2,3,0,1,6,7,4,5]
; AVX2-NEXT:    vblendps {{.*#+}} ymm11 = ymm11[0,1,2,3],ymm9[4,5],ymm11[6,7]
; AVX2-NEXT:    vblendps {{.*#+}} ymm11 = ymm11[0,1],ymm13[2,3],ymm11[4,5,6,7]
; AVX2-NEXT:    vunpckhpd {{.*#+}} ymm12 = ymm9[1],ymm12[1],ymm9[3],ymm12[3]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm12 = ymm12[0,2,3,3]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm13 = ymm13[2,1,2,3]
; AVX2-NEXT:    vblendps {{.*#+}} ymm12 = ymm13[0,1],ymm12[2,3,4,5],ymm13[6,7]
; AVX2-NEXT:    vmovddup {{.*#+}} xmm13 = mem[0,0]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm9 = ymm9[0,1,2,1]
; AVX2-NEXT:    vblendps {{.*#+}} ymm9 = ymm9[0,1],ymm13[2,3],ymm9[4,5,6,7]
; AVX2-NEXT:    vbroadcastsd 32(%rdx), %ymm13
; AVX2-NEXT:    vblendps {{.*#+}} ymm9 = ymm9[0,1,2,3],ymm13[4,5],ymm9[6,7]
; AVX2-NEXT:    vpermilps {{.*#+}} ymm13 = ymm8[2,3,0,1,6,7,4,5]
; AVX2-NEXT:    vblendps {{.*#+}} ymm13 = ymm13[0,1,2,3],ymm5[4,5],ymm13[6,7]
; AVX2-NEXT:    vblendps {{.*#+}} ymm13 = ymm13[0,1],ymm10[2,3],ymm13[4,5,6,7]
; AVX2-NEXT:    vunpckhpd {{.*#+}} ymm8 = ymm5[1],ymm8[1],ymm5[3],ymm8[3]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm8 = ymm8[0,2,3,3]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm10 = ymm10[2,1,2,3]
; AVX2-NEXT:    vblendps {{.*#+}} ymm8 = ymm10[0,1],ymm8[2,3,4,5],ymm10[6,7]
; AVX2-NEXT:    vmovddup {{.*#+}} xmm10 = mem[0,0]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm5 = ymm5[0,1,2,1]
; AVX2-NEXT:    vblendps {{.*#+}} ymm5 = ymm5[0,1],ymm10[2,3],ymm5[4,5,6,7]
; AVX2-NEXT:    vbroadcastsd 96(%rdx), %ymm10
; AVX2-NEXT:    vblendps {{.*#+}} ymm5 = ymm5[0,1,2,3],ymm10[4,5],ymm5[6,7]
; AVX2-NEXT:    vunpckhpd {{.*#+}} ymm10 = ymm0[1],ymm2[1],ymm0[3],ymm2[3]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm10 = ymm10[0,2,3,3]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm14 = ymm3[2,1,2,3]
; AVX2-NEXT:    vblendps {{.*#+}} ymm10 = ymm14[0,1],ymm10[2,3,4,5],ymm14[6,7]
; AVX2-NEXT:    vpermilps {{.*#+}} ymm2 = ymm2[2,3,0,1,6,7,4,5]
; AVX2-NEXT:    vblendps {{.*#+}} ymm0 = ymm2[0,1,2,3],ymm0[4,5],ymm2[6,7]
; AVX2-NEXT:    vblendps {{.*#+}} ymm0 = ymm0[0,1],ymm3[2,3],ymm0[4,5,6,7]
; AVX2-NEXT:    vmovaps %ymm0, 32(%rcx)
; AVX2-NEXT:    vmovaps %ymm10, 64(%rcx)
; AVX2-NEXT:    vmovaps %ymm5, 288(%rcx)
; AVX2-NEXT:    vmovaps %ymm8, 352(%rcx)
; AVX2-NEXT:    vmovaps %ymm13, 320(%rcx)
; AVX2-NEXT:    vmovaps %ymm9, 96(%rcx)
; AVX2-NEXT:    vmovaps %ymm12, 160(%rcx)
; AVX2-NEXT:    vmovaps %ymm11, 128(%rcx)
; AVX2-NEXT:    vmovaps %ymm7, 224(%rcx)
; AVX2-NEXT:    vmovaps %ymm6, 192(%rcx)
; AVX2-NEXT:    vmovaps %ymm4, 256(%rcx)
; AVX2-NEXT:    vmovaps %ymm1, (%rcx)
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512-LABEL: store_i64_stride3_vf16:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovdqu64 (%rdi), %zmm0
; AVX512-NEXT:    vmovdqu64 64(%rdi), %zmm1
; AVX512-NEXT:    vmovdqu64 (%rsi), %zmm2
; AVX512-NEXT:    vmovdqu64 64(%rsi), %zmm3
; AVX512-NEXT:    vmovdqu64 (%rdx), %zmm4
; AVX512-NEXT:    vmovdqu64 64(%rdx), %zmm5
; AVX512-NEXT:    vmovdqa64 {{.*#+}} zmm6 = <0,8,u,1,9,u,2,10>
; AVX512-NEXT:    vmovdqa64 %zmm0, %zmm7
; AVX512-NEXT:    vpermt2q %zmm2, %zmm6, %zmm7
; AVX512-NEXT:    vmovdqa64 {{.*#+}} zmm8 = [0,1,8,3,4,9,6,7]
; AVX512-NEXT:    vpermt2q %zmm4, %zmm8, %zmm7
; AVX512-NEXT:    vmovdqa64 {{.*#+}} zmm9 = <5,u,14,6,u,15,7,u>
; AVX512-NEXT:    vmovdqa64 %zmm3, %zmm10
; AVX512-NEXT:    vpermt2q %zmm1, %zmm9, %zmm10
; AVX512-NEXT:    vmovdqa64 {{.*#+}} zmm11 = [0,13,2,3,14,5,6,15]
; AVX512-NEXT:    vpermt2q %zmm5, %zmm11, %zmm10
; AVX512-NEXT:    vmovdqa64 {{.*#+}} zmm12 = <u,3,11,u,4,12,u,5>
; AVX512-NEXT:    vmovdqa64 %zmm1, %zmm13
; AVX512-NEXT:    vpermt2q %zmm3, %zmm12, %zmm13
; AVX512-NEXT:    vmovdqa64 {{.*#+}} zmm14 = [10,1,2,11,4,5,12,7]
; AVX512-NEXT:    vpermt2q %zmm5, %zmm14, %zmm13
; AVX512-NEXT:    vpermt2q %zmm3, %zmm6, %zmm1
; AVX512-NEXT:    vpermt2q %zmm5, %zmm8, %zmm1
; AVX512-NEXT:    vpermi2q %zmm0, %zmm2, %zmm9
; AVX512-NEXT:    vpermt2q %zmm4, %zmm11, %zmm9
; AVX512-NEXT:    vpermt2q %zmm2, %zmm12, %zmm0
; AVX512-NEXT:    vpermt2q %zmm4, %zmm14, %zmm0
; AVX512-NEXT:    vmovdqu64 %zmm0, 64(%rcx)
; AVX512-NEXT:    vmovdqu64 %zmm9, 128(%rcx)
; AVX512-NEXT:    vmovdqu64 %zmm1, 192(%rcx)
; AVX512-NEXT:    vmovdqu64 %zmm13, 256(%rcx)
; AVX512-NEXT:    vmovdqu64 %zmm10, 320(%rcx)
; AVX512-NEXT:    vmovdqu64 %zmm7, (%rcx)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %in.vec0 = load <16 x i64>, ptr %in.vecptr0, align 32
  %in.vec1 = load <16 x i64>, ptr %in.vecptr1, align 32
  %in.vec2 = load <16 x i64>, ptr %in.vecptr2, align 32

  %concat01 = shufflevector <16 x i64> %in.vec0, <16 x i64> %in.vec1, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  %concat2u = shufflevector <16 x i64> %in.vec2, <16 x i64> poison, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %concat012 = shufflevector <32 x i64> %concat01, <32 x i64> %concat2u, <48 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31, i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47>
  %interleaved.vec = shufflevector <48 x i64> %concat012, <48 x i64> poison, <48 x i32> <i32 0, i32 16, i32 32, i32 1, i32 17, i32 33, i32 2, i32 18, i32 34, i32 3, i32 19, i32 35, i32 4, i32 20, i32 36, i32 5, i32 21, i32 37, i32 6, i32 22, i32 38, i32 7, i32 23, i32 39, i32 8, i32 24, i32 40, i32 9, i32 25, i32 41, i32 10, i32 26, i32 42, i32 11, i32 27, i32 43, i32 12, i32 28, i32 44, i32 13, i32 29, i32 45, i32 14, i32 30, i32 46, i32 15, i32 31, i32 47>

  store <48 x i64> %interleaved.vec, ptr %out.vec, align 32

  ret void
}