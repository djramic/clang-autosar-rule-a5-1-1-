; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: sed 's/iXLen2/i64/g' %s | llc -mtriple=riscv32 -mattr=+m | \
; RUN:   FileCheck %s --check-prefix=RV32
; RUN: sed 's/iXLen2/i128/g' %s | llc -mtriple=riscv64 -mattr=+m | \
; RUN:   FileCheck %s --check-prefix=RV64

define iXLen2 @test_udiv_3(iXLen2 %x) nounwind {
; RV32-LABEL: test_udiv_3:
; RV32:       # %bb.0:
; RV32-NEXT:    add a2, a0, a1
; RV32-NEXT:    sltu a3, a2, a0
; RV32-NEXT:    add a2, a2, a3
; RV32-NEXT:    lui a3, 699051
; RV32-NEXT:    addi a4, a3, -1365
; RV32-NEXT:    mulhu a5, a2, a4
; RV32-NEXT:    srli a6, a5, 1
; RV32-NEXT:    andi a5, a5, -2
; RV32-NEXT:    add a5, a5, a6
; RV32-NEXT:    sub a2, a2, a5
; RV32-NEXT:    sub a5, a0, a2
; RV32-NEXT:    addi a3, a3, -1366
; RV32-NEXT:    mul a3, a5, a3
; RV32-NEXT:    mulhu a6, a5, a4
; RV32-NEXT:    add a3, a6, a3
; RV32-NEXT:    sltu a0, a0, a2
; RV32-NEXT:    sub a0, a1, a0
; RV32-NEXT:    mul a0, a0, a4
; RV32-NEXT:    add a1, a3, a0
; RV32-NEXT:    mul a0, a5, a4
; RV32-NEXT:    ret
;
; RV64-LABEL: test_udiv_3:
; RV64:       # %bb.0:
; RV64-NEXT:    lui a2, %hi(.LCPI0_0)
; RV64-NEXT:    ld a2, %lo(.LCPI0_0)(a2)
; RV64-NEXT:    add a3, a0, a1
; RV64-NEXT:    sltu a4, a3, a0
; RV64-NEXT:    add a3, a3, a4
; RV64-NEXT:    mulhu a4, a3, a2
; RV64-NEXT:    srli a5, a4, 1
; RV64-NEXT:    andi a4, a4, -2
; RV64-NEXT:    lui a6, %hi(.LCPI0_1)
; RV64-NEXT:    ld a6, %lo(.LCPI0_1)(a6)
; RV64-NEXT:    add a4, a4, a5
; RV64-NEXT:    sub a3, a3, a4
; RV64-NEXT:    sub a4, a0, a3
; RV64-NEXT:    mul a5, a4, a6
; RV64-NEXT:    mulhu a6, a4, a2
; RV64-NEXT:    add a5, a6, a5
; RV64-NEXT:    sltu a0, a0, a3
; RV64-NEXT:    sub a0, a1, a0
; RV64-NEXT:    mul a0, a0, a2
; RV64-NEXT:    add a1, a5, a0
; RV64-NEXT:    mul a0, a4, a2
; RV64-NEXT:    ret
  %a = udiv iXLen2 %x, 3
  ret iXLen2 %a
}

define iXLen2 @test_udiv_5(iXLen2 %x) nounwind {
; RV32-LABEL: test_udiv_5:
; RV32:       # %bb.0:
; RV32-NEXT:    add a2, a0, a1
; RV32-NEXT:    sltu a3, a2, a0
; RV32-NEXT:    add a2, a2, a3
; RV32-NEXT:    lui a3, 838861
; RV32-NEXT:    addi a4, a3, -819
; RV32-NEXT:    mulhu a5, a2, a4
; RV32-NEXT:    srli a6, a5, 2
; RV32-NEXT:    andi a5, a5, -4
; RV32-NEXT:    add a5, a5, a6
; RV32-NEXT:    sub a2, a2, a5
; RV32-NEXT:    sub a5, a0, a2
; RV32-NEXT:    addi a3, a3, -820
; RV32-NEXT:    mul a3, a5, a3
; RV32-NEXT:    mulhu a6, a5, a4
; RV32-NEXT:    add a3, a6, a3
; RV32-NEXT:    sltu a0, a0, a2
; RV32-NEXT:    sub a0, a1, a0
; RV32-NEXT:    mul a0, a0, a4
; RV32-NEXT:    add a1, a3, a0
; RV32-NEXT:    mul a0, a5, a4
; RV32-NEXT:    ret
;
; RV64-LABEL: test_udiv_5:
; RV64:       # %bb.0:
; RV64-NEXT:    lui a2, %hi(.LCPI1_0)
; RV64-NEXT:    ld a2, %lo(.LCPI1_0)(a2)
; RV64-NEXT:    add a3, a0, a1
; RV64-NEXT:    sltu a4, a3, a0
; RV64-NEXT:    add a3, a3, a4
; RV64-NEXT:    mulhu a4, a3, a2
; RV64-NEXT:    srli a5, a4, 2
; RV64-NEXT:    andi a4, a4, -4
; RV64-NEXT:    lui a6, %hi(.LCPI1_1)
; RV64-NEXT:    ld a6, %lo(.LCPI1_1)(a6)
; RV64-NEXT:    add a4, a4, a5
; RV64-NEXT:    sub a3, a3, a4
; RV64-NEXT:    sub a4, a0, a3
; RV64-NEXT:    mul a5, a4, a6
; RV64-NEXT:    mulhu a6, a4, a2
; RV64-NEXT:    add a5, a6, a5
; RV64-NEXT:    sltu a0, a0, a3
; RV64-NEXT:    sub a0, a1, a0
; RV64-NEXT:    mul a0, a0, a2
; RV64-NEXT:    add a1, a5, a0
; RV64-NEXT:    mul a0, a4, a2
; RV64-NEXT:    ret
  %a = udiv iXLen2 %x, 5
  ret iXLen2 %a
}

define iXLen2 @test_udiv_7(iXLen2 %x) nounwind {
; RV32-LABEL: test_udiv_7:
; RV32:       # %bb.0:
; RV32-NEXT:    addi sp, sp, -16
; RV32-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32-NEXT:    li a2, 7
; RV32-NEXT:    li a3, 0
; RV32-NEXT:    call __udivdi3@plt
; RV32-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32-NEXT:    addi sp, sp, 16
; RV32-NEXT:    ret
;
; RV64-LABEL: test_udiv_7:
; RV64:       # %bb.0:
; RV64-NEXT:    addi sp, sp, -16
; RV64-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64-NEXT:    li a2, 7
; RV64-NEXT:    li a3, 0
; RV64-NEXT:    call __udivti3@plt
; RV64-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64-NEXT:    addi sp, sp, 16
; RV64-NEXT:    ret
  %a = udiv iXLen2 %x, 7
  ret iXLen2 %a
}

define iXLen2 @test_udiv_9(iXLen2 %x) nounwind {
; RV32-LABEL: test_udiv_9:
; RV32:       # %bb.0:
; RV32-NEXT:    addi sp, sp, -16
; RV32-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32-NEXT:    li a2, 9
; RV32-NEXT:    li a3, 0
; RV32-NEXT:    call __udivdi3@plt
; RV32-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32-NEXT:    addi sp, sp, 16
; RV32-NEXT:    ret
;
; RV64-LABEL: test_udiv_9:
; RV64:       # %bb.0:
; RV64-NEXT:    addi sp, sp, -16
; RV64-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64-NEXT:    li a2, 9
; RV64-NEXT:    li a3, 0
; RV64-NEXT:    call __udivti3@plt
; RV64-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64-NEXT:    addi sp, sp, 16
; RV64-NEXT:    ret
  %a = udiv iXLen2 %x, 9
  ret iXLen2 %a
}

define iXLen2 @test_udiv_15(iXLen2 %x) nounwind {
; RV32-LABEL: test_udiv_15:
; RV32:       # %bb.0:
; RV32-NEXT:    add a2, a0, a1
; RV32-NEXT:    sltu a3, a2, a0
; RV32-NEXT:    add a2, a2, a3
; RV32-NEXT:    lui a3, 559241
; RV32-NEXT:    addi a3, a3, -1911
; RV32-NEXT:    mulhu a3, a2, a3
; RV32-NEXT:    srli a3, a3, 3
; RV32-NEXT:    slli a4, a3, 4
; RV32-NEXT:    sub a3, a3, a4
; RV32-NEXT:    add a2, a2, a3
; RV32-NEXT:    sub a3, a0, a2
; RV32-NEXT:    lui a4, 978671
; RV32-NEXT:    addi a5, a4, -274
; RV32-NEXT:    mul a5, a3, a5
; RV32-NEXT:    addi a4, a4, -273
; RV32-NEXT:    mulhu a6, a3, a4
; RV32-NEXT:    add a5, a6, a5
; RV32-NEXT:    sltu a0, a0, a2
; RV32-NEXT:    sub a0, a1, a0
; RV32-NEXT:    mul a0, a0, a4
; RV32-NEXT:    add a1, a5, a0
; RV32-NEXT:    mul a0, a3, a4
; RV32-NEXT:    ret
;
; RV64-LABEL: test_udiv_15:
; RV64:       # %bb.0:
; RV64-NEXT:    lui a2, %hi(.LCPI4_0)
; RV64-NEXT:    ld a2, %lo(.LCPI4_0)(a2)
; RV64-NEXT:    add a3, a0, a1
; RV64-NEXT:    sltu a4, a3, a0
; RV64-NEXT:    add a3, a3, a4
; RV64-NEXT:    mulhu a2, a3, a2
; RV64-NEXT:    srli a2, a2, 3
; RV64-NEXT:    slli a4, a2, 4
; RV64-NEXT:    sub a2, a2, a4
; RV64-NEXT:    lui a4, %hi(.LCPI4_1)
; RV64-NEXT:    ld a4, %lo(.LCPI4_1)(a4)
; RV64-NEXT:    lui a5, %hi(.LCPI4_2)
; RV64-NEXT:    ld a5, %lo(.LCPI4_2)(a5)
; RV64-NEXT:    add a2, a3, a2
; RV64-NEXT:    sub a3, a0, a2
; RV64-NEXT:    mul a4, a3, a4
; RV64-NEXT:    mulhu a6, a3, a5
; RV64-NEXT:    add a4, a6, a4
; RV64-NEXT:    sltu a0, a0, a2
; RV64-NEXT:    sub a0, a1, a0
; RV64-NEXT:    mul a0, a0, a5
; RV64-NEXT:    add a1, a4, a0
; RV64-NEXT:    mul a0, a3, a5
; RV64-NEXT:    ret
  %a = udiv iXLen2 %x, 15
  ret iXLen2 %a
}

define iXLen2 @test_udiv_17(iXLen2 %x) nounwind {
; RV32-LABEL: test_udiv_17:
; RV32:       # %bb.0:
; RV32-NEXT:    add a2, a0, a1
; RV32-NEXT:    sltu a3, a2, a0
; RV32-NEXT:    add a2, a2, a3
; RV32-NEXT:    lui a3, 986895
; RV32-NEXT:    addi a4, a3, 241
; RV32-NEXT:    mulhu a5, a2, a4
; RV32-NEXT:    srli a6, a5, 4
; RV32-NEXT:    andi a5, a5, -16
; RV32-NEXT:    add a5, a5, a6
; RV32-NEXT:    sub a2, a2, a5
; RV32-NEXT:    sub a5, a0, a2
; RV32-NEXT:    addi a3, a3, 240
; RV32-NEXT:    mul a3, a5, a3
; RV32-NEXT:    mulhu a6, a5, a4
; RV32-NEXT:    add a3, a6, a3
; RV32-NEXT:    sltu a0, a0, a2
; RV32-NEXT:    sub a0, a1, a0
; RV32-NEXT:    mul a0, a0, a4
; RV32-NEXT:    add a1, a3, a0
; RV32-NEXT:    mul a0, a5, a4
; RV32-NEXT:    ret
;
; RV64-LABEL: test_udiv_17:
; RV64:       # %bb.0:
; RV64-NEXT:    lui a2, %hi(.LCPI5_0)
; RV64-NEXT:    ld a2, %lo(.LCPI5_0)(a2)
; RV64-NEXT:    add a3, a0, a1
; RV64-NEXT:    sltu a4, a3, a0
; RV64-NEXT:    add a3, a3, a4
; RV64-NEXT:    mulhu a4, a3, a2
; RV64-NEXT:    srli a5, a4, 4
; RV64-NEXT:    andi a4, a4, -16
; RV64-NEXT:    lui a6, %hi(.LCPI5_1)
; RV64-NEXT:    ld a6, %lo(.LCPI5_1)(a6)
; RV64-NEXT:    add a4, a4, a5
; RV64-NEXT:    sub a3, a3, a4
; RV64-NEXT:    sub a4, a0, a3
; RV64-NEXT:    mul a5, a4, a6
; RV64-NEXT:    mulhu a6, a4, a2
; RV64-NEXT:    add a5, a6, a5
; RV64-NEXT:    sltu a0, a0, a3
; RV64-NEXT:    sub a0, a1, a0
; RV64-NEXT:    mul a0, a0, a2
; RV64-NEXT:    add a1, a5, a0
; RV64-NEXT:    mul a0, a4, a2
; RV64-NEXT:    ret
  %a = udiv iXLen2 %x, 17
  ret iXLen2 %a
}

define iXLen2 @test_udiv_255(iXLen2 %x) nounwind {
; RV32-LABEL: test_udiv_255:
; RV32:       # %bb.0:
; RV32-NEXT:    add a2, a0, a1
; RV32-NEXT:    sltu a3, a2, a0
; RV32-NEXT:    add a2, a2, a3
; RV32-NEXT:    lui a3, 526344
; RV32-NEXT:    addi a3, a3, 129
; RV32-NEXT:    mulhu a3, a2, a3
; RV32-NEXT:    srli a3, a3, 7
; RV32-NEXT:    slli a4, a3, 8
; RV32-NEXT:    sub a3, a3, a4
; RV32-NEXT:    add a2, a2, a3
; RV32-NEXT:    sub a3, a0, a2
; RV32-NEXT:    lui a4, 1044464
; RV32-NEXT:    addi a5, a4, -258
; RV32-NEXT:    mul a5, a3, a5
; RV32-NEXT:    addi a4, a4, -257
; RV32-NEXT:    mulhu a6, a3, a4
; RV32-NEXT:    add a5, a6, a5
; RV32-NEXT:    sltu a0, a0, a2
; RV32-NEXT:    sub a0, a1, a0
; RV32-NEXT:    mul a0, a0, a4
; RV32-NEXT:    add a1, a5, a0
; RV32-NEXT:    mul a0, a3, a4
; RV32-NEXT:    ret
;
; RV64-LABEL: test_udiv_255:
; RV64:       # %bb.0:
; RV64-NEXT:    lui a2, %hi(.LCPI6_0)
; RV64-NEXT:    ld a2, %lo(.LCPI6_0)(a2)
; RV64-NEXT:    add a3, a0, a1
; RV64-NEXT:    sltu a4, a3, a0
; RV64-NEXT:    add a3, a3, a4
; RV64-NEXT:    mulhu a2, a3, a2
; RV64-NEXT:    srli a2, a2, 7
; RV64-NEXT:    slli a4, a2, 8
; RV64-NEXT:    sub a2, a2, a4
; RV64-NEXT:    lui a4, %hi(.LCPI6_1)
; RV64-NEXT:    ld a4, %lo(.LCPI6_1)(a4)
; RV64-NEXT:    lui a5, %hi(.LCPI6_2)
; RV64-NEXT:    ld a5, %lo(.LCPI6_2)(a5)
; RV64-NEXT:    add a2, a3, a2
; RV64-NEXT:    sub a3, a0, a2
; RV64-NEXT:    mul a4, a3, a4
; RV64-NEXT:    mulhu a6, a3, a5
; RV64-NEXT:    add a4, a6, a4
; RV64-NEXT:    sltu a0, a0, a2
; RV64-NEXT:    sub a0, a1, a0
; RV64-NEXT:    mul a0, a0, a5
; RV64-NEXT:    add a1, a4, a0
; RV64-NEXT:    mul a0, a3, a5
; RV64-NEXT:    ret
  %a = udiv iXLen2 %x, 255
  ret iXLen2 %a
}

define iXLen2 @test_udiv_257(iXLen2 %x) nounwind {
; RV32-LABEL: test_udiv_257:
; RV32:       # %bb.0:
; RV32-NEXT:    add a2, a0, a1
; RV32-NEXT:    sltu a3, a2, a0
; RV32-NEXT:    add a2, a2, a3
; RV32-NEXT:    lui a3, 1044496
; RV32-NEXT:    addi a4, a3, -255
; RV32-NEXT:    mulhu a5, a2, a4
; RV32-NEXT:    srli a6, a5, 8
; RV32-NEXT:    andi a5, a5, -256
; RV32-NEXT:    add a5, a5, a6
; RV32-NEXT:    sub a2, a2, a5
; RV32-NEXT:    sub a5, a0, a2
; RV32-NEXT:    addi a3, a3, -256
; RV32-NEXT:    mul a3, a5, a3
; RV32-NEXT:    mulhu a6, a5, a4
; RV32-NEXT:    add a3, a6, a3
; RV32-NEXT:    sltu a0, a0, a2
; RV32-NEXT:    sub a0, a1, a0
; RV32-NEXT:    mul a0, a0, a4
; RV32-NEXT:    add a1, a3, a0
; RV32-NEXT:    mul a0, a5, a4
; RV32-NEXT:    ret
;
; RV64-LABEL: test_udiv_257:
; RV64:       # %bb.0:
; RV64-NEXT:    lui a2, %hi(.LCPI7_0)
; RV64-NEXT:    ld a2, %lo(.LCPI7_0)(a2)
; RV64-NEXT:    add a3, a0, a1
; RV64-NEXT:    sltu a4, a3, a0
; RV64-NEXT:    add a3, a3, a4
; RV64-NEXT:    mulhu a4, a3, a2
; RV64-NEXT:    srli a5, a4, 8
; RV64-NEXT:    andi a4, a4, -256
; RV64-NEXT:    lui a6, %hi(.LCPI7_1)
; RV64-NEXT:    ld a6, %lo(.LCPI7_1)(a6)
; RV64-NEXT:    add a4, a4, a5
; RV64-NEXT:    sub a3, a3, a4
; RV64-NEXT:    sub a4, a0, a3
; RV64-NEXT:    mul a5, a4, a6
; RV64-NEXT:    mulhu a6, a4, a2
; RV64-NEXT:    add a5, a6, a5
; RV64-NEXT:    sltu a0, a0, a3
; RV64-NEXT:    sub a0, a1, a0
; RV64-NEXT:    mul a0, a0, a2
; RV64-NEXT:    add a1, a5, a0
; RV64-NEXT:    mul a0, a4, a2
; RV64-NEXT:    ret
  %a = udiv iXLen2 %x, 257
  ret iXLen2 %a
}

define iXLen2 @test_udiv_65535(iXLen2 %x) nounwind {
; RV32-LABEL: test_udiv_65535:
; RV32:       # %bb.0:
; RV32-NEXT:    add a2, a0, a1
; RV32-NEXT:    sltu a3, a2, a0
; RV32-NEXT:    add a2, a2, a3
; RV32-NEXT:    lui a3, 524296
; RV32-NEXT:    addi a3, a3, 1
; RV32-NEXT:    mulhu a3, a2, a3
; RV32-NEXT:    srli a3, a3, 15
; RV32-NEXT:    slli a4, a3, 16
; RV32-NEXT:    sub a3, a3, a4
; RV32-NEXT:    add a2, a2, a3
; RV32-NEXT:    sub a3, a0, a2
; RV32-NEXT:    lui a4, 1048560
; RV32-NEXT:    addi a5, a4, -2
; RV32-NEXT:    mul a5, a3, a5
; RV32-NEXT:    addi a4, a4, -1
; RV32-NEXT:    mulhu a4, a3, a4
; RV32-NEXT:    add a4, a4, a5
; RV32-NEXT:    sltu a0, a0, a2
; RV32-NEXT:    sub a0, a1, a0
; RV32-NEXT:    slli a1, a0, 16
; RV32-NEXT:    add a0, a1, a0
; RV32-NEXT:    sub a1, a4, a0
; RV32-NEXT:    slli a0, a3, 16
; RV32-NEXT:    add a0, a0, a3
; RV32-NEXT:    neg a0, a0
; RV32-NEXT:    ret
;
; RV64-LABEL: test_udiv_65535:
; RV64:       # %bb.0:
; RV64-NEXT:    lui a2, %hi(.LCPI8_0)
; RV64-NEXT:    ld a2, %lo(.LCPI8_0)(a2)
; RV64-NEXT:    add a3, a0, a1
; RV64-NEXT:    sltu a4, a3, a0
; RV64-NEXT:    add a3, a3, a4
; RV64-NEXT:    mulhu a2, a3, a2
; RV64-NEXT:    srli a2, a2, 15
; RV64-NEXT:    slli a4, a2, 16
; RV64-NEXT:    sub a2, a2, a4
; RV64-NEXT:    add a2, a3, a2
; RV64-NEXT:    sub a3, a0, a2
; RV64-NEXT:    lui a4, 983039
; RV64-NEXT:    slli a4, a4, 4
; RV64-NEXT:    addi a4, a4, -1
; RV64-NEXT:    slli a4, a4, 16
; RV64-NEXT:    addi a5, a4, -2
; RV64-NEXT:    mul a5, a3, a5
; RV64-NEXT:    addi a4, a4, -1
; RV64-NEXT:    mulhu a6, a3, a4
; RV64-NEXT:    add a5, a6, a5
; RV64-NEXT:    sltu a0, a0, a2
; RV64-NEXT:    sub a0, a1, a0
; RV64-NEXT:    mul a0, a0, a4
; RV64-NEXT:    add a1, a5, a0
; RV64-NEXT:    mul a0, a3, a4
; RV64-NEXT:    ret
  %a = udiv iXLen2 %x, 65535
  ret iXLen2 %a
}

define iXLen2 @test_udiv_65537(iXLen2 %x) nounwind {
; RV32-LABEL: test_udiv_65537:
; RV32:       # %bb.0:
; RV32-NEXT:    add a2, a0, a1
; RV32-NEXT:    sltu a3, a2, a0
; RV32-NEXT:    add a2, a2, a3
; RV32-NEXT:    lui a3, 1048560
; RV32-NEXT:    addi a4, a3, 1
; RV32-NEXT:    mulhu a5, a2, a4
; RV32-NEXT:    and a3, a5, a3
; RV32-NEXT:    srli a5, a5, 16
; RV32-NEXT:    or a3, a3, a5
; RV32-NEXT:    sub a2, a2, a3
; RV32-NEXT:    sub a3, a0, a2
; RV32-NEXT:    mulhu a4, a3, a4
; RV32-NEXT:    slli a5, a3, 16
; RV32-NEXT:    sub a4, a4, a5
; RV32-NEXT:    sltu a0, a0, a2
; RV32-NEXT:    sub a0, a1, a0
; RV32-NEXT:    slli a1, a0, 16
; RV32-NEXT:    sub a0, a0, a1
; RV32-NEXT:    add a1, a4, a0
; RV32-NEXT:    sub a0, a3, a5
; RV32-NEXT:    ret
;
; RV64-LABEL: test_udiv_65537:
; RV64:       # %bb.0:
; RV64-NEXT:    add a2, a0, a1
; RV64-NEXT:    sltu a3, a2, a0
; RV64-NEXT:    add a2, a2, a3
; RV64-NEXT:    lui a3, 983041
; RV64-NEXT:    slli a3, a3, 4
; RV64-NEXT:    addi a3, a3, -1
; RV64-NEXT:    slli a3, a3, 16
; RV64-NEXT:    addi a4, a3, 1
; RV64-NEXT:    mulhu a5, a2, a4
; RV64-NEXT:    lui a6, 1048560
; RV64-NEXT:    and a6, a5, a6
; RV64-NEXT:    srli a5, a5, 16
; RV64-NEXT:    add a5, a6, a5
; RV64-NEXT:    sub a2, a2, a5
; RV64-NEXT:    sub a5, a0, a2
; RV64-NEXT:    mul a3, a5, a3
; RV64-NEXT:    mulhu a6, a5, a4
; RV64-NEXT:    add a3, a6, a3
; RV64-NEXT:    sltu a0, a0, a2
; RV64-NEXT:    sub a0, a1, a0
; RV64-NEXT:    mul a0, a0, a4
; RV64-NEXT:    add a1, a3, a0
; RV64-NEXT:    mul a0, a5, a4
; RV64-NEXT:    ret
  %a = udiv iXLen2 %x, 65537
  ret iXLen2 %a
}

define iXLen2 @test_udiv_12(iXLen2 %x) nounwind {
; RV32-LABEL: test_udiv_12:
; RV32:       # %bb.0:
; RV32-NEXT:    slli a2, a1, 30
; RV32-NEXT:    srli a0, a0, 2
; RV32-NEXT:    or a0, a0, a2
; RV32-NEXT:    srli a1, a1, 2
; RV32-NEXT:    add a2, a0, a1
; RV32-NEXT:    sltu a3, a2, a0
; RV32-NEXT:    add a2, a2, a3
; RV32-NEXT:    lui a3, 699051
; RV32-NEXT:    addi a4, a3, -1365
; RV32-NEXT:    mulhu a5, a2, a4
; RV32-NEXT:    srli a6, a5, 1
; RV32-NEXT:    andi a5, a5, -2
; RV32-NEXT:    add a5, a5, a6
; RV32-NEXT:    sub a2, a2, a5
; RV32-NEXT:    sub a5, a0, a2
; RV32-NEXT:    addi a3, a3, -1366
; RV32-NEXT:    mul a3, a5, a3
; RV32-NEXT:    mulhu a6, a5, a4
; RV32-NEXT:    add a3, a6, a3
; RV32-NEXT:    sltu a0, a0, a2
; RV32-NEXT:    sub a0, a1, a0
; RV32-NEXT:    mul a0, a0, a4
; RV32-NEXT:    add a1, a3, a0
; RV32-NEXT:    mul a0, a5, a4
; RV32-NEXT:    ret
;
; RV64-LABEL: test_udiv_12:
; RV64:       # %bb.0:
; RV64-NEXT:    slli a2, a1, 62
; RV64-NEXT:    srli a0, a0, 2
; RV64-NEXT:    or a0, a0, a2
; RV64-NEXT:    srli a1, a1, 2
; RV64-NEXT:    lui a2, %hi(.LCPI10_0)
; RV64-NEXT:    ld a2, %lo(.LCPI10_0)(a2)
; RV64-NEXT:    add a3, a0, a1
; RV64-NEXT:    sltu a4, a3, a0
; RV64-NEXT:    add a3, a3, a4
; RV64-NEXT:    mulhu a4, a3, a2
; RV64-NEXT:    srli a5, a4, 1
; RV64-NEXT:    andi a4, a4, -2
; RV64-NEXT:    lui a6, %hi(.LCPI10_1)
; RV64-NEXT:    ld a6, %lo(.LCPI10_1)(a6)
; RV64-NEXT:    add a4, a4, a5
; RV64-NEXT:    sub a3, a3, a4
; RV64-NEXT:    sub a4, a0, a3
; RV64-NEXT:    mul a5, a4, a6
; RV64-NEXT:    mulhu a6, a4, a2
; RV64-NEXT:    add a5, a6, a5
; RV64-NEXT:    sltu a0, a0, a3
; RV64-NEXT:    sub a0, a1, a0
; RV64-NEXT:    mul a0, a0, a2
; RV64-NEXT:    add a1, a5, a0
; RV64-NEXT:    mul a0, a4, a2
; RV64-NEXT:    ret
  %a = udiv iXLen2 %x, 12
  ret iXLen2 %a
}