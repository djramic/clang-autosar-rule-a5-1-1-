; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --check-attributes --check-globals
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=2 -S < %s | FileCheck %s --check-prefixes=CHECK,TUNIT
; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,CGSCC
; PR2498

; This test tries to convince CHECK about promoting the load from %A + 2,
; because there is a load of %A in the entry block
define internal i32 @callee(i1 %C, i32* %A) {
;
; CHECK: Function Attrs: nofree norecurse nosync nounwind willreturn memory(argmem: read)
; CHECK-LABEL: define {{[^@]+}}@callee
; CHECK-SAME: (i32* nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[A:%.*]]) #[[ATTR0:[0-9]+]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A_0:%.*]] = load i32, i32* [[A]], align 4
; CHECK-NEXT:    br label [[F:%.*]]
; CHECK:       T:
; CHECK-NEXT:    unreachable
; CHECK:       F:
; CHECK-NEXT:    [[A_2:%.*]] = getelementptr i32, i32* [[A]], i32 2
; CHECK-NEXT:    [[R:%.*]] = load i32, i32* [[A_2]], align 4
; CHECK-NEXT:    ret i32 [[R]]
;
entry:
  ; Unconditonally load the element at %A
  %A.0 = load i32, i32* %A
  br i1 %C, label %T, label %F

T:
  ret i32 %A.0

F:
  ; Load the element at offset two from %A. This should not be promoted!
  %A.2 = getelementptr i32, i32* %A, i32 2
  %R = load i32, i32* %A.2
  ret i32 %R
}

define i32 @foo(i32* %A) {
; TUNIT: Function Attrs: nofree norecurse nosync nounwind willreturn memory(argmem: read)
; TUNIT-LABEL: define {{[^@]+}}@foo
; TUNIT-SAME: (i32* nocapture nofree readonly [[A:%.*]]) #[[ATTR0]] {
; TUNIT-NEXT:    [[X:%.*]] = call i32 @callee(i32* nocapture nofree readonly align 4 [[A]]) #[[ATTR1:[0-9]+]]
; TUNIT-NEXT:    ret i32 [[X]]
;
; CGSCC: Function Attrs: nofree nosync nounwind willreturn memory(argmem: read)
; CGSCC-LABEL: define {{[^@]+}}@foo
; CGSCC-SAME: (i32* nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[A:%.*]]) #[[ATTR1:[0-9]+]] {
; CGSCC-NEXT:    [[X:%.*]] = call i32 @callee(i32* nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[A]]) #[[ATTR2:[0-9]+]]
; CGSCC-NEXT:    ret i32 [[X]]
;
  %X = call i32 @callee(i1 false, i32* %A)             ; <i32> [#uses=1]
  ret i32 %X
}

;.
; TUNIT: attributes #[[ATTR0]] = { nofree norecurse nosync nounwind willreturn memory(argmem: read) }
; TUNIT: attributes #[[ATTR1]] = { nofree nosync nounwind willreturn }
;.
; CGSCC: attributes #[[ATTR0]] = { nofree norecurse nosync nounwind willreturn memory(argmem: read) }
; CGSCC: attributes #[[ATTR1]] = { nofree nosync nounwind willreturn memory(argmem: read) }
; CGSCC: attributes #[[ATTR2]] = { willreturn }
;.