; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-linux-gnu -mattr=+sve < %s | FileCheck %s

define <vscale x 16 x i8> @test_lane0_16xi8(<vscale x 16 x i8> %a) {
; CHECK-LABEL: test_lane0_16xi8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #30
; CHECK-NEXT:    ptrue p0.b, vl1
; CHECK-NEXT:    mov z0.b, p0/m, w8
; CHECK-NEXT:    ret
  %b = insertelement <vscale x 16 x i8> %a, i8 30, i32 0
  ret <vscale x 16 x i8> %b
}

define <vscale x 8 x i16> @test_lane0_8xi16(<vscale x 8 x i16> %a) {
; CHECK-LABEL: test_lane0_8xi16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #30
; CHECK-NEXT:    ptrue p0.h, vl1
; CHECK-NEXT:    mov z0.h, p0/m, w8
; CHECK-NEXT:    ret
  %b = insertelement <vscale x 8 x i16> %a, i16 30, i32 0
  ret <vscale x 8 x i16> %b
}

define <vscale x 4 x i32> @test_lane0_4xi32(<vscale x 4 x i32> %a) {
; CHECK-LABEL: test_lane0_4xi32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #30
; CHECK-NEXT:    ptrue p0.s, vl1
; CHECK-NEXT:    mov z0.s, p0/m, w8
; CHECK-NEXT:    ret
  %b = insertelement <vscale x 4 x i32> %a, i32 30, i32 0
  ret <vscale x 4 x i32> %b
}

define <vscale x 2 x i64> @test_lane0_2xi64(<vscale x 2 x i64> %a) {
; CHECK-LABEL: test_lane0_2xi64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #30
; CHECK-NEXT:    ptrue p0.d, vl1
; CHECK-NEXT:    mov z0.d, p0/m, x8
; CHECK-NEXT:    ret
  %b = insertelement <vscale x 2 x i64> %a, i64 30, i32 0
  ret <vscale x 2 x i64> %b
}

define <vscale x 2 x double> @test_lane0_2xf64(<vscale x 2 x double> %a) {
; CHECK-LABEL: test_lane0_2xf64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    fmov d1, #1.00000000
; CHECK-NEXT:    ptrue p0.d, vl1
; CHECK-NEXT:    mov z0.d, p0/m, z1.d
; CHECK-NEXT:    ret
  %b = insertelement <vscale x 2 x double> %a, double 1.0, i32 0
  ret <vscale x 2 x double> %b
}

define <vscale x 4 x float> @test_lane0_4xf32(<vscale x 4 x float> %a) {
; CHECK-LABEL: test_lane0_4xf32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    fmov s1, #1.00000000
; CHECK-NEXT:    ptrue p0.s, vl1
; CHECK-NEXT:    mov z0.s, p0/m, z1.s
; CHECK-NEXT:    ret
  %b = insertelement <vscale x 4 x float> %a, float 1.0, i32 0
  ret <vscale x 4 x float> %b
}

define <vscale x 8 x half> @test_lane0_8xf16(<vscale x 8 x half> %a) {
; CHECK-LABEL: test_lane0_8xf16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    fmov h1, #1.00000000
; CHECK-NEXT:    ptrue p0.h, vl1
; CHECK-NEXT:    mov z0.h, p0/m, z1.h
; CHECK-NEXT:    ret
  %b = insertelement <vscale x 8 x half> %a, half 1.0, i32 0
  ret <vscale x 8 x half> %b
}

; Undefined lane insert
define <vscale x 2 x i64> @test_lane4_2xi64(<vscale x 2 x i64> %a) {
; CHECK-LABEL: test_lane4_2xi64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #4
; CHECK-NEXT:    mov w9, #30
; CHECK-NEXT:    index z2.d, #0, #1
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    mov z1.d, x8
; CHECK-NEXT:    cmpeq p0.d, p0/z, z2.d, z1.d
; CHECK-NEXT:    mov z0.d, p0/m, x9
; CHECK-NEXT:    ret
  %b = insertelement <vscale x 2 x i64> %a, i64 30, i32 4
  ret <vscale x 2 x i64> %b
}

; Undefined lane insert
define <vscale x 8 x half> @test_lane9_8xf16(<vscale x 8 x half> %a) {
; CHECK-LABEL: test_lane9_8xf16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #9
; CHECK-NEXT:    fmov h1, #1.00000000
; CHECK-NEXT:    index z3.h, #0, #1
; CHECK-NEXT:    ptrue p0.h
; CHECK-NEXT:    mov z2.h, w8
; CHECK-NEXT:    cmpeq p0.h, p0/z, z3.h, z2.h
; CHECK-NEXT:    mov z0.h, p0/m, h1
; CHECK-NEXT:    ret
  %b = insertelement <vscale x 8 x half> %a, half 1.0, i32 9
  ret <vscale x 8 x half> %b
}

define <vscale x 16 x i8> @test_lane1_16xi8(<vscale x 16 x i8> %a) {
; CHECK-LABEL: test_lane1_16xi8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #1
; CHECK-NEXT:    mov w9, #30
; CHECK-NEXT:    index z2.b, #0, #1
; CHECK-NEXT:    ptrue p0.b
; CHECK-NEXT:    mov z1.b, w8
; CHECK-NEXT:    cmpeq p0.b, p0/z, z2.b, z1.b
; CHECK-NEXT:    mov z0.b, p0/m, w9
; CHECK-NEXT:    ret
  %b = insertelement <vscale x 16 x i8> %a, i8 30, i32 1
  ret <vscale x 16 x i8> %b
}

define <vscale x 16 x i8> @test_lanex_16xi8(<vscale x 16 x i8> %a, i32 %x) {
; CHECK-LABEL: test_lanex_16xi8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, w0
; CHECK-NEXT:    mov w9, #30
; CHECK-NEXT:    index z2.b, #0, #1
; CHECK-NEXT:    ptrue p0.b
; CHECK-NEXT:    mov z1.b, w8
; CHECK-NEXT:    cmpeq p0.b, p0/z, z2.b, z1.b
; CHECK-NEXT:    mov z0.b, p0/m, w9
; CHECK-NEXT:    ret
  %b = insertelement <vscale x 16 x i8> %a, i8 30, i32 %x
  ret <vscale x 16 x i8> %b
}


; Redundant lane insert
define <vscale x 4 x i32> @extract_insert_4xi32(<vscale x 4 x i32> %a) {
; CHECK-LABEL: extract_insert_4xi32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %b = extractelement <vscale x 4 x i32> %a, i32 2
  %c = insertelement <vscale x 4 x i32> %a, i32 %b, i32 2
  ret <vscale x 4 x i32> %c
}

define <vscale x 8 x i16> @test_lane6_undef_8xi16(i16 %a) {
; CHECK-LABEL: test_lane6_undef_8xi16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #6
; CHECK-NEXT:    index z1.h, #0, #1
; CHECK-NEXT:    ptrue p0.h
; CHECK-NEXT:    mov z0.h, w8
; CHECK-NEXT:    cmpeq p0.h, p0/z, z1.h, z0.h
; CHECK-NEXT:    mov z0.h, p0/m, w0
; CHECK-NEXT:    ret
  %b = insertelement <vscale x 8 x i16> undef, i16 %a, i32 6
  ret <vscale x 8 x i16> %b
}

define <vscale x 16 x i8> @test_lane0_undef_16xi8(i8 %a) {
; CHECK-LABEL: test_lane0_undef_16xi8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    fmov s0, w0
; CHECK-NEXT:    ret
  %b = insertelement <vscale x 16 x i8> undef, i8 %a, i32 0
  ret <vscale x 16 x i8> %b
}

define <vscale x 16 x i8> @test_insert0_of_extract0_16xi8(<vscale x 16 x i8> %a, <vscale x 16 x i8> %b) {
; CHECK-LABEL: test_insert0_of_extract0_16xi8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    fmov w8, s1
; CHECK-NEXT:    ptrue p0.b, vl1
; CHECK-NEXT:    mov z0.b, p0/m, w8
; CHECK-NEXT:    ret
  %c = extractelement <vscale x 16 x i8> %b, i32 0
  %d = insertelement <vscale x 16 x i8> %a, i8 %c, i32 0
  ret <vscale x 16 x i8> %d
}

define <vscale x 16 x i8> @test_insert64_of_extract64_16xi8(<vscale x 16 x i8> %a, <vscale x 16 x i8> %b) {
; CHECK-LABEL: test_insert64_of_extract64_16xi8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #64
; CHECK-NEXT:    index z3.b, #0, #1
; CHECK-NEXT:    ptrue p1.b
; CHECK-NEXT:    whilels p0.b, xzr, x8
; CHECK-NEXT:    mov z2.b, w8
; CHECK-NEXT:    lastb w8, p0, z1.b
; CHECK-NEXT:    cmpeq p0.b, p1/z, z3.b, z2.b
; CHECK-NEXT:    mov z0.b, p0/m, w8
; CHECK-NEXT:    ret
  %c = extractelement <vscale x 16 x i8> %b, i32 64
  %d = insertelement <vscale x 16 x i8> %a, i8 %c, i32 64
  ret <vscale x 16 x i8> %d
}

define <vscale x 16 x i8> @test_insert3_of_extract1_16xi8(<vscale x 16 x i8> %a, <vscale x 16 x i8> %b) {
; CHECK-LABEL: test_insert3_of_extract1_16xi8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #3
; CHECK-NEXT:    umov w9, v1.b[1]
; CHECK-NEXT:    index z2.b, #0, #1
; CHECK-NEXT:    ptrue p0.b
; CHECK-NEXT:    mov z1.b, w8
; CHECK-NEXT:    cmpeq p0.b, p0/z, z2.b, z1.b
; CHECK-NEXT:    mov z0.b, p0/m, w9
; CHECK-NEXT:    ret
  %c = extractelement <vscale x 16 x i8> %b, i32 1
  %d = insertelement <vscale x 16 x i8> %a, i8 %c, i32 3
  ret <vscale x 16 x i8> %d
}

define <vscale x 8 x half> @test_insert_into_undef_nxv8f16(half %a) {
; CHECK-LABEL: test_insert_into_undef_nxv8f16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $h0 killed $h0 def $z0
; CHECK-NEXT:    ret
  %b = insertelement <vscale x 8 x half> undef, half %a, i32 0
  ret <vscale x 8 x half> %b
}

define <vscale x 4 x half> @test_insert_into_undef_nxv4f16(half %a) {
; CHECK-LABEL: test_insert_into_undef_nxv4f16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $h0 killed $h0 def $z0
; CHECK-NEXT:    ret
  %b = insertelement <vscale x 4 x half> undef, half %a, i32 0
  ret <vscale x 4 x half> %b
}

define <vscale x 2 x half> @test_insert_into_undef_nxv2f16(half %a) {
; CHECK-LABEL: test_insert_into_undef_nxv2f16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $h0 killed $h0 def $z0
; CHECK-NEXT:    ret
  %b = insertelement <vscale x 2 x half> undef, half %a, i32 0
  ret <vscale x 2 x half> %b
}

define <vscale x 4 x float> @test_insert_into_undef_nxv4f32(float %a) {
; CHECK-LABEL: test_insert_into_undef_nxv4f32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $s0 killed $s0 def $z0
; CHECK-NEXT:    ret
  %b = insertelement <vscale x 4 x float> undef, float %a, i32 0
  ret <vscale x 4 x float> %b
}

define <vscale x 2 x float> @test_insert_into_undef_nxv2f32(float %a) {
; CHECK-LABEL: test_insert_into_undef_nxv2f32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $s0 killed $s0 def $z0
; CHECK-NEXT:    ret
  %b = insertelement <vscale x 2 x float> undef, float %a, i32 0
  ret <vscale x 2 x float> %b
}

define <vscale x 2 x double> @test_insert_into_undef_nxv2f64(double %a) {
; CHECK-LABEL: test_insert_into_undef_nxv2f64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $z0
; CHECK-NEXT:    ret
  %b = insertelement <vscale x 2 x double> undef, double %a, i32 0
  ret <vscale x 2 x double> %b
}

; Insert scalar at index
define <vscale x 2 x half> @test_insert_with_index_nxv2f16(half %h, i64 %idx) {
; CHECK-LABEL: test_insert_with_index_nxv2f16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    index z1.d, #0, #1
; CHECK-NEXT:    mov z2.d, x0
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    cmpeq p0.d, p0/z, z1.d, z2.d
; CHECK-NEXT:    mov z0.h, p0/m, h0
; CHECK-NEXT:    ret
  %res = insertelement <vscale x 2 x half> undef, half %h, i64 %idx
  ret <vscale x 2 x half> %res
}

define <vscale x 4 x half> @test_insert_with_index_nxv4f16(half %h, i64 %idx) {
; CHECK-LABEL: test_insert_with_index_nxv4f16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    index z1.s, #0, #1
; CHECK-NEXT:    mov z2.s, w0
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    cmpeq p0.s, p0/z, z1.s, z2.s
; CHECK-NEXT:    mov z0.h, p0/m, h0
; CHECK-NEXT:    ret
  %res = insertelement <vscale x 4 x half> undef, half %h, i64 %idx
  ret <vscale x 4 x half> %res
}

define <vscale x 8 x half> @test_insert_with_index_nxv8f16(half %h, i64 %idx) {
; CHECK-LABEL: test_insert_with_index_nxv8f16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    index z1.h, #0, #1
; CHECK-NEXT:    mov z2.h, w0
; CHECK-NEXT:    ptrue p0.h
; CHECK-NEXT:    cmpeq p0.h, p0/z, z1.h, z2.h
; CHECK-NEXT:    mov z0.h, p0/m, h0
; CHECK-NEXT:    ret
  %res = insertelement <vscale x 8 x half> undef, half %h, i64 %idx
  ret <vscale x 8 x half> %res
}

define <vscale x 2 x float> @test_insert_with_index_nxv2f32(float %f, i64 %idx) {
; CHECK-LABEL: test_insert_with_index_nxv2f32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    index z1.d, #0, #1
; CHECK-NEXT:    mov z2.d, x0
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    cmpeq p0.d, p0/z, z1.d, z2.d
; CHECK-NEXT:    mov z0.s, p0/m, s0
; CHECK-NEXT:    ret
  %res = insertelement <vscale x 2 x float> undef, float %f, i64 %idx
  ret <vscale x 2 x float> %res
}

define <vscale x 4 x float> @test_insert_with_index_nxv4f32(float %f, i64 %idx) {
; CHECK-LABEL: test_insert_with_index_nxv4f32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    index z1.s, #0, #1
; CHECK-NEXT:    mov z2.s, w0
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    cmpeq p0.s, p0/z, z1.s, z2.s
; CHECK-NEXT:    mov z0.s, p0/m, s0
; CHECK-NEXT:    ret
  %res = insertelement <vscale x 4 x float> undef, float %f, i64 %idx
  ret <vscale x 4 x float> %res
}

define <vscale x 2 x double> @test_insert_with_index_nxv2f64(double %d, i64 %idx) {
; CHECK-LABEL: test_insert_with_index_nxv2f64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    index z1.d, #0, #1
; CHECK-NEXT:    mov z2.d, x0
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    cmpeq p0.d, p0/z, z1.d, z2.d
; CHECK-NEXT:    mov z0.d, p0/m, d0
; CHECK-NEXT:    ret
  %res = insertelement <vscale x 2 x double> undef, double %d, i64 %idx
  ret <vscale x 2 x double> %res
}

;Predicate insert
define <vscale x 2 x i1> @test_predicate_insert_2xi1_immediate (<vscale x 2 x i1> %val, i1 %elt) {
; CHECK-LABEL: test_predicate_insert_2xi1_immediate:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p1.d, vl1
; CHECK-NEXT:    mov z0.d, p0/z, #1 // =0x1
; CHECK-NEXT:    // kill: def $w0 killed $w0 def $x0
; CHECK-NEXT:    mov z0.d, p1/m, x0
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    and z0.d, z0.d, #0x1
; CHECK-NEXT:    cmpne p0.d, p0/z, z0.d, #0
; CHECK-NEXT:    ret
  %res = insertelement <vscale x 2 x i1> %val, i1 %elt, i32 0
  ret <vscale x 2 x i1> %res
}

define <vscale x 4 x i1> @test_predicate_insert_4xi1_immediate (<vscale x 4 x i1> %val, i1 %elt) {
; CHECK-LABEL: test_predicate_insert_4xi1_immediate:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #2
; CHECK-NEXT:    index z1.s, #0, #1
; CHECK-NEXT:    ptrue p1.s
; CHECK-NEXT:    mov z0.s, w8
; CHECK-NEXT:    cmpeq p2.s, p1/z, z1.s, z0.s
; CHECK-NEXT:    mov z0.s, p0/z, #1 // =0x1
; CHECK-NEXT:    mov z0.s, p2/m, w0
; CHECK-NEXT:    and z0.s, z0.s, #0x1
; CHECK-NEXT:    cmpne p0.s, p1/z, z0.s, #0
; CHECK-NEXT:    ret
  %res = insertelement <vscale x 4 x i1> %val, i1 %elt, i32 2
  ret <vscale x 4 x i1> %res
}

define <vscale x 8 x i1> @test_predicate_insert_8xi1_immediate (<vscale x 8 x i1> %val, i32 %idx) {
; CHECK-LABEL: test_predicate_insert_8xi1_immediate:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, w0
; CHECK-NEXT:    mov w9, #1
; CHECK-NEXT:    index z1.h, #0, #1
; CHECK-NEXT:    ptrue p1.h
; CHECK-NEXT:    mov z0.h, w8
; CHECK-NEXT:    cmpeq p2.h, p1/z, z1.h, z0.h
; CHECK-NEXT:    mov z0.h, p0/z, #1 // =0x1
; CHECK-NEXT:    mov z0.h, p2/m, w9
; CHECK-NEXT:    and z0.h, z0.h, #0x1
; CHECK-NEXT:    cmpne p0.h, p1/z, z0.h, #0
; CHECK-NEXT:    ret
  %res = insertelement <vscale x 8 x i1> %val, i1 1, i32 %idx
  ret <vscale x 8 x i1> %res
}

define <vscale x 16 x i1> @test_predicate_insert_16xi1_immediate (<vscale x 16 x i1> %val) {
; CHECK-LABEL: test_predicate_insert_16xi1_immediate:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w9, #4
; CHECK-NEXT:    mov w8, wzr
; CHECK-NEXT:    index z1.b, #0, #1
; CHECK-NEXT:    ptrue p1.b
; CHECK-NEXT:    mov z0.b, w9
; CHECK-NEXT:    cmpeq p2.b, p1/z, z1.b, z0.b
; CHECK-NEXT:    mov z0.b, p0/z, #1 // =0x1
; CHECK-NEXT:    mov z0.b, p2/m, w8
; CHECK-NEXT:    and z0.b, z0.b, #0x1
; CHECK-NEXT:    cmpne p0.b, p1/z, z0.b, #0
; CHECK-NEXT:    ret
  %res = insertelement <vscale x 16 x i1> %val, i1 0, i32 4
  ret <vscale x 16 x i1> %res
}


define <vscale x 2 x i1> @test_predicate_insert_2xi1(<vscale x 2 x i1> %val, i1 %elt, i32 %idx) {
; CHECK-LABEL: test_predicate_insert_2xi1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, w1
; CHECK-NEXT:    index z1.d, #0, #1
; CHECK-NEXT:    ptrue p1.d
; CHECK-NEXT:    // kill: def $w0 killed $w0 def $x0
; CHECK-NEXT:    mov z0.d, x8
; CHECK-NEXT:    cmpeq p2.d, p1/z, z1.d, z0.d
; CHECK-NEXT:    mov z0.d, p0/z, #1 // =0x1
; CHECK-NEXT:    mov z0.d, p2/m, x0
; CHECK-NEXT:    and z0.d, z0.d, #0x1
; CHECK-NEXT:    cmpne p0.d, p1/z, z0.d, #0
; CHECK-NEXT:    ret
  %res = insertelement <vscale x 2 x i1> %val, i1 %elt, i32 %idx
  ret <vscale x 2 x i1> %res
}

define <vscale x 4 x i1> @test_predicate_insert_4xi1(<vscale x 4 x i1> %val, i1 %elt, i32 %idx) {
; CHECK-LABEL: test_predicate_insert_4xi1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, w1
; CHECK-NEXT:    index z1.s, #0, #1
; CHECK-NEXT:    ptrue p1.s
; CHECK-NEXT:    mov z0.s, w8
; CHECK-NEXT:    cmpeq p2.s, p1/z, z1.s, z0.s
; CHECK-NEXT:    mov z0.s, p0/z, #1 // =0x1
; CHECK-NEXT:    mov z0.s, p2/m, w0
; CHECK-NEXT:    and z0.s, z0.s, #0x1
; CHECK-NEXT:    cmpne p0.s, p1/z, z0.s, #0
; CHECK-NEXT:    ret
  %res = insertelement <vscale x 4 x i1> %val, i1 %elt, i32 %idx
  ret <vscale x 4 x i1> %res
}
define <vscale x 8 x i1> @test_predicate_insert_8xi1(<vscale x 8 x i1> %val, i1 %elt, i32 %idx) {
; CHECK-LABEL: test_predicate_insert_8xi1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, w1
; CHECK-NEXT:    index z1.h, #0, #1
; CHECK-NEXT:    ptrue p1.h
; CHECK-NEXT:    mov z0.h, w8
; CHECK-NEXT:    cmpeq p2.h, p1/z, z1.h, z0.h
; CHECK-NEXT:    mov z0.h, p0/z, #1 // =0x1
; CHECK-NEXT:    mov z0.h, p2/m, w0
; CHECK-NEXT:    and z0.h, z0.h, #0x1
; CHECK-NEXT:    cmpne p0.h, p1/z, z0.h, #0
; CHECK-NEXT:    ret
  %res = insertelement <vscale x 8 x i1> %val, i1 %elt, i32 %idx
  ret <vscale x 8 x i1> %res
}

define <vscale x 16 x i1> @test_predicate_insert_16xi1(<vscale x 16 x i1> %val, i1 %elt, i32 %idx) {
; CHECK-LABEL: test_predicate_insert_16xi1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, w1
; CHECK-NEXT:    index z1.b, #0, #1
; CHECK-NEXT:    ptrue p1.b
; CHECK-NEXT:    mov z0.b, w8
; CHECK-NEXT:    cmpeq p2.b, p1/z, z1.b, z0.b
; CHECK-NEXT:    mov z0.b, p0/z, #1 // =0x1
; CHECK-NEXT:    mov z0.b, p2/m, w0
; CHECK-NEXT:    and z0.b, z0.b, #0x1
; CHECK-NEXT:    cmpne p0.b, p1/z, z0.b, #0
; CHECK-NEXT:    ret
  %res = insertelement <vscale x 16 x i1> %val, i1 %elt, i32 %idx
  ret <vscale x 16 x i1> %res
}

define <vscale x 32 x i1> @test_predicate_insert_32xi1(<vscale x 32 x i1> %val, i1 %elt, i32 %idx) uwtable {
; CHECK-LABEL: test_predicate_insert_32xi1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    str x29, [sp, #-16]! // 8-byte Folded Spill
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    .cfi_offset w29, -16
; CHECK-NEXT:    addvl sp, sp, #-2
; CHECK-NEXT:    .cfi_escape 0x0f, 0x0c, 0x8f, 0x00, 0x11, 0x10, 0x22, 0x11, 0x10, 0x92, 0x2e, 0x00, 0x1e, 0x22 // sp + 16 + 16 * VG
; CHECK-NEXT:    mov x8, #-1
; CHECK-NEXT:    mov w9, w1
; CHECK-NEXT:    mov z0.b, p1/z, #1 // =0x1
; CHECK-NEXT:    ptrue p1.b
; CHECK-NEXT:    st1b { z0.b }, p1, [sp, #1, mul vl]
; CHECK-NEXT:    mov z0.b, p0/z, #1 // =0x1
; CHECK-NEXT:    addvl x8, x8, #2
; CHECK-NEXT:    st1b { z0.b }, p1, [sp]
; CHECK-NEXT:    cmp x9, x8
; CHECK-NEXT:    csel x8, x9, x8, lo
; CHECK-NEXT:    mov x9, sp
; CHECK-NEXT:    strb w0, [x9, x8]
; CHECK-NEXT:    ld1b { z0.b }, p1/z, [sp]
; CHECK-NEXT:    ld1b { z1.b }, p1/z, [sp, #1, mul vl]
; CHECK-NEXT:    and z0.b, z0.b, #0x1
; CHECK-NEXT:    and z1.b, z1.b, #0x1
; CHECK-NEXT:    cmpne p0.b, p1/z, z0.b, #0
; CHECK-NEXT:    cmpne p1.b, p1/z, z1.b, #0
; CHECK-NEXT:    addvl sp, sp, #2
; CHECK-NEXT:    .cfi_def_cfa wsp, 16
; CHECK-NEXT:    ldr x29, [sp], #16 // 8-byte Folded Reload
; CHECK-NEXT:    .cfi_def_cfa_offset 0
; CHECK-NEXT:    .cfi_restore w29
; CHECK-NEXT:    ret
  %res = insertelement <vscale x 32 x i1> %val, i1 %elt, i32 %idx
  ret <vscale x 32 x i1> %res
}