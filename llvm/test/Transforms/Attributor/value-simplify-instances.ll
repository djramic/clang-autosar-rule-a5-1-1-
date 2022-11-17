; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --check-attributes --check-globals
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=17 -S < %s | FileCheck %s --check-prefixes=CHECK,TUNIT
; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,CGSCC

target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"

declare i1* @geti1Ptr()

; Make sure we do *not* return true.
;.
; CHECK: @[[G1:[a-zA-Z0-9_$"\\.-]+]] = private global i1* undef
; CHECK: @[[G2:[a-zA-Z0-9_$"\\.-]+]] = private global i1* undef
; CHECK: @[[G3:[a-zA-Z0-9_$"\\.-]+]] = private global i1 undef
;.
define internal i1 @recursive_inst_comparator(i1* %a, i1* %b) {
; CHECK: Function Attrs: nofree norecurse nosync nounwind willreturn memory(none)
; CHECK-LABEL: define {{[^@]+}}@recursive_inst_comparator
; CHECK-SAME: (i1* noalias nofree readnone [[A:%.*]], i1* noalias nofree readnone [[B:%.*]]) #[[ATTR0:[0-9]+]] {
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i1* [[A]], [[B]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %cmp = icmp eq i1* %a, %b
  ret i1 %cmp
}

define internal i1 @recursive_inst_generator(i1 %c, i1* %p) {
; TUNIT-LABEL: define {{[^@]+}}@recursive_inst_generator
; TUNIT-SAME: (i1 [[C:%.*]], i1* nofree [[P:%.*]]) {
; TUNIT-NEXT:    [[A:%.*]] = call i1* @geti1Ptr()
; TUNIT-NEXT:    br i1 [[C]], label [[T:%.*]], label [[F:%.*]]
; TUNIT:       t:
; TUNIT-NEXT:    [[R1:%.*]] = call i1 @recursive_inst_comparator(i1* noalias nofree readnone [[A]], i1* noalias nofree readnone [[P]]) #[[ATTR6:[0-9]+]]
; TUNIT-NEXT:    ret i1 [[R1]]
; TUNIT:       f:
; TUNIT-NEXT:    [[R2:%.*]] = call i1 @recursive_inst_generator(i1 noundef true, i1* nofree [[A]])
; TUNIT-NEXT:    ret i1 [[R2]]
;
; CGSCC-LABEL: define {{[^@]+}}@recursive_inst_generator
; CGSCC-SAME: (i1 [[C:%.*]], i1* nofree [[P:%.*]]) {
; CGSCC-NEXT:    [[A:%.*]] = call i1* @geti1Ptr()
; CGSCC-NEXT:    br i1 [[C]], label [[T:%.*]], label [[F:%.*]]
; CGSCC:       t:
; CGSCC-NEXT:    [[R1:%.*]] = call i1 @recursive_inst_comparator(i1* noalias nofree readnone [[A]], i1* noalias nofree readnone [[P]])
; CGSCC-NEXT:    ret i1 [[R1]]
; CGSCC:       f:
; CGSCC-NEXT:    [[R2:%.*]] = call i1 @recursive_inst_generator(i1 noundef true, i1* nofree [[A]])
; CGSCC-NEXT:    ret i1 [[R2]]
;
  %a = call i1* @geti1Ptr()
  br i1 %c, label %t, label %f
t:
  %r1 = call i1 @recursive_inst_comparator(i1* %a, i1* %p)
  ret i1 %r1
f:
  %r2 = call i1 @recursive_inst_generator(i1 true, i1* %a)
  ret i1 %r2
}

; FIXME: This should *not* return true.
define i1 @recursive_inst_generator_caller(i1 %c) {
; CHECK-LABEL: define {{[^@]+}}@recursive_inst_generator_caller
; CHECK-SAME: (i1 [[C:%.*]]) {
; CHECK-NEXT:    [[CALL:%.*]] = call i1 @recursive_inst_generator(i1 [[C]], i1* undef)
; CHECK-NEXT:    ret i1 [[CALL]]
;
  %call = call i1 @recursive_inst_generator(i1 %c, i1* undef)
  ret i1 %call
}

; Make sure we do *not* return true.
define internal i1 @recursive_inst_compare(i1 %c, i1* %p) {
; CHECK-LABEL: define {{[^@]+}}@recursive_inst_compare
; CHECK-SAME: (i1 [[C:%.*]], i1* [[P:%.*]]) {
; CHECK-NEXT:    [[A:%.*]] = call i1* @geti1Ptr()
; CHECK-NEXT:    br i1 [[C]], label [[T:%.*]], label [[F:%.*]]
; CHECK:       t:
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i1* [[A]], [[P]]
; CHECK-NEXT:    ret i1 [[CMP]]
; CHECK:       f:
; CHECK-NEXT:    [[CALL:%.*]] = call i1 @recursive_inst_compare(i1 noundef true, i1* [[A]])
; CHECK-NEXT:    ret i1 [[CALL]]
;
  %a = call i1* @geti1Ptr()
  br i1 %c, label %t, label %f
t:
  %cmp = icmp eq i1* %a, %p
  ret i1 %cmp
f:
  %call = call i1 @recursive_inst_compare(i1 true, i1* %a)
  ret i1 %call
}

; FIXME: This should *not* return true.
define i1 @recursive_inst_compare_caller(i1 %c) {
; CHECK-LABEL: define {{[^@]+}}@recursive_inst_compare_caller
; CHECK-SAME: (i1 [[C:%.*]]) {
; CHECK-NEXT:    [[CALL:%.*]] = call i1 @recursive_inst_compare(i1 [[C]], i1* undef)
; CHECK-NEXT:    ret i1 [[CALL]]
;
  %call = call i1 @recursive_inst_compare(i1 %c, i1* undef)
  ret i1 %call
}

; Make sure we do *not* return true.
define internal i1 @recursive_alloca_compare(i1 %c, i1* %p) {
; TUNIT: Function Attrs: nofree nosync nounwind memory(none)
; TUNIT-LABEL: define {{[^@]+}}@recursive_alloca_compare
; TUNIT-SAME: (i1 [[C:%.*]], i1* noalias nofree nonnull readnone [[P:%.*]]) #[[ATTR1:[0-9]+]] {
; TUNIT-NEXT:    [[A:%.*]] = alloca i1, align 1
; TUNIT-NEXT:    br i1 [[C]], label [[T:%.*]], label [[F:%.*]]
; TUNIT:       t:
; TUNIT-NEXT:    [[CMP:%.*]] = icmp eq i1* [[A]], [[P]]
; TUNIT-NEXT:    ret i1 [[CMP]]
; TUNIT:       f:
; TUNIT-NEXT:    [[CALL:%.*]] = call i1 @recursive_alloca_compare(i1 noundef true, i1* noalias nofree noundef nonnull readnone dereferenceable(1) [[A]]) #[[ATTR4:[0-9]+]]
; TUNIT-NEXT:    ret i1 [[CALL]]
;
; CGSCC: Function Attrs: nofree nosync nounwind memory(none)
; CGSCC-LABEL: define {{[^@]+}}@recursive_alloca_compare
; CGSCC-SAME: (i1 [[C:%.*]], i1* noalias nofree nonnull readnone [[P:%.*]]) #[[ATTR1:[0-9]+]] {
; CGSCC-NEXT:    [[A:%.*]] = alloca i1, align 1
; CGSCC-NEXT:    br i1 [[C]], label [[T:%.*]], label [[F:%.*]]
; CGSCC:       t:
; CGSCC-NEXT:    [[CMP:%.*]] = icmp eq i1* [[A]], [[P]]
; CGSCC-NEXT:    ret i1 [[CMP]]
; CGSCC:       f:
; CGSCC-NEXT:    [[CALL:%.*]] = call i1 @recursive_alloca_compare(i1 noundef true, i1* noalias nofree noundef nonnull readnone dereferenceable(1) [[A]]) #[[ATTR3:[0-9]+]]
; CGSCC-NEXT:    ret i1 [[CALL]]
;
  %a = alloca i1
  br i1 %c, label %t, label %f
t:
  %cmp = icmp eq i1* %a, %p
  ret i1 %cmp
f:
  %call = call i1 @recursive_alloca_compare(i1 true, i1* %a)
  ret i1 %call
}

; FIXME: This should *not* return true.
define i1 @recursive_alloca_compare_caller(i1 %c) {
; TUNIT: Function Attrs: nofree norecurse nosync nounwind memory(none)
; TUNIT-LABEL: define {{[^@]+}}@recursive_alloca_compare_caller
; TUNIT-SAME: (i1 [[C:%.*]]) #[[ATTR2:[0-9]+]] {
; TUNIT-NEXT:    [[CALL:%.*]] = call i1 @recursive_alloca_compare(i1 [[C]], i1* undef) #[[ATTR4]]
; TUNIT-NEXT:    ret i1 [[CALL]]
;
; CGSCC: Function Attrs: nofree nosync nounwind memory(none)
; CGSCC-LABEL: define {{[^@]+}}@recursive_alloca_compare_caller
; CGSCC-SAME: (i1 [[C:%.*]]) #[[ATTR1]] {
; CGSCC-NEXT:    [[CALL:%.*]] = call i1 @recursive_alloca_compare(i1 [[C]], i1* undef) #[[ATTR4:[0-9]+]]
; CGSCC-NEXT:    ret i1 [[CALL]]
;
  %call = call i1 @recursive_alloca_compare(i1 %c, i1* undef)
  ret i1 %call
}

; Make sure we do *not* simplify this to return 0 or 1, return 42 is ok though.
define internal i8 @recursive_alloca_load_return(i1 %c, i8* %p, i8 %v) {
; TUNIT: Function Attrs: nofree nosync nounwind memory(argmem: readwrite)
; TUNIT-LABEL: define {{[^@]+}}@recursive_alloca_load_return
; TUNIT-SAME: (i1 [[C:%.*]], i8* nocapture nofree nonnull readonly [[P:%.*]], i8 noundef [[V:%.*]]) #[[ATTR3:[0-9]+]] {
; TUNIT-NEXT:    [[A:%.*]] = alloca i8, align 1
; TUNIT-NEXT:    store i8 [[V]], i8* [[A]], align 1
; TUNIT-NEXT:    br i1 [[C]], label [[T:%.*]], label [[F:%.*]]
; TUNIT:       t:
; TUNIT-NEXT:    store i8 0, i8* [[A]], align 1
; TUNIT-NEXT:    [[L:%.*]] = load i8, i8* [[P]], align 1
; TUNIT-NEXT:    ret i8 [[L]]
; TUNIT:       f:
; TUNIT-NEXT:    [[CALL:%.*]] = call i8 @recursive_alloca_load_return(i1 noundef true, i8* noalias nocapture nofree noundef nonnull readonly dereferenceable(1) [[A]], i8 noundef 1) #[[ATTR4]]
; TUNIT-NEXT:    ret i8 [[CALL]]
;
; CGSCC: Function Attrs: nofree nosync nounwind memory(argmem: readwrite)
; CGSCC-LABEL: define {{[^@]+}}@recursive_alloca_load_return
; CGSCC-SAME: (i1 [[C:%.*]], i8* nocapture nofree nonnull readonly [[P:%.*]], i8 noundef [[V:%.*]]) #[[ATTR2:[0-9]+]] {
; CGSCC-NEXT:    [[A:%.*]] = alloca i8, align 1
; CGSCC-NEXT:    store i8 [[V]], i8* [[A]], align 1
; CGSCC-NEXT:    br i1 [[C]], label [[T:%.*]], label [[F:%.*]]
; CGSCC:       t:
; CGSCC-NEXT:    store i8 0, i8* [[A]], align 1
; CGSCC-NEXT:    [[L:%.*]] = load i8, i8* [[P]], align 1
; CGSCC-NEXT:    ret i8 [[L]]
; CGSCC:       f:
; CGSCC-NEXT:    [[CALL:%.*]] = call i8 @recursive_alloca_load_return(i1 noundef true, i8* noalias nocapture nofree noundef nonnull readonly dereferenceable(1) [[A]], i8 noundef 1) #[[ATTR3]]
; CGSCC-NEXT:    ret i8 [[CALL]]
;
  %a = alloca i8
  store i8 %v, i8* %a
  br i1 %c, label %t, label %f
t:
  store i8 0, i8* %a
  %l = load i8, i8* %p
  ret i8 %l
f:
  %call = call i8 @recursive_alloca_load_return(i1 true, i8* %a, i8 1)
  ret i8 %call
}

define i8 @recursive_alloca_load_return_caller(i1 %c) {
; TUNIT: Function Attrs: nofree norecurse nosync nounwind memory(none)
; TUNIT-LABEL: define {{[^@]+}}@recursive_alloca_load_return_caller
; TUNIT-SAME: (i1 [[C:%.*]]) #[[ATTR2]] {
; TUNIT-NEXT:    [[CALL:%.*]] = call i8 @recursive_alloca_load_return(i1 [[C]], i8* undef, i8 noundef 42) #[[ATTR4]]
; TUNIT-NEXT:    ret i8 [[CALL]]
;
; CGSCC: Function Attrs: nofree nosync nounwind memory(none)
; CGSCC-LABEL: define {{[^@]+}}@recursive_alloca_load_return_caller
; CGSCC-SAME: (i1 [[C:%.*]]) #[[ATTR1]] {
; CGSCC-NEXT:    [[CALL:%.*]] = call i8 @recursive_alloca_load_return(i1 [[C]], i8* undef, i8 noundef 42) #[[ATTR4]]
; CGSCC-NEXT:    ret i8 [[CALL]]
;
  %call = call i8 @recursive_alloca_load_return(i1 %c, i8* undef, i8 42)
  ret i8 %call
}

@G1 = private global i1* undef
@G2 = private global i1* undef
@G3 = private global i1 undef

; Make sure we do *not* return true.
define internal i1 @recursive_alloca_compare_global1(i1 %c) {
; TUNIT: Function Attrs: nofree nosync nounwind
; TUNIT-LABEL: define {{[^@]+}}@recursive_alloca_compare_global1
; TUNIT-SAME: (i1 [[C:%.*]]) #[[ATTR4]] {
; TUNIT-NEXT:    [[A:%.*]] = alloca i1, align 1
; TUNIT-NEXT:    br i1 [[C]], label [[T:%.*]], label [[F:%.*]]
; TUNIT:       t:
; TUNIT-NEXT:    [[P:%.*]] = load i1*, i1** @G1, align 8
; TUNIT-NEXT:    [[CMP:%.*]] = icmp eq i1* [[A]], [[P]]
; TUNIT-NEXT:    ret i1 [[CMP]]
; TUNIT:       f:
; TUNIT-NEXT:    store i1* [[A]], i1** @G1, align 8
; TUNIT-NEXT:    [[CALL:%.*]] = call i1 @recursive_alloca_compare_global1(i1 noundef true) #[[ATTR4]]
; TUNIT-NEXT:    ret i1 [[CALL]]
;
; CGSCC: Function Attrs: nofree nosync nounwind
; CGSCC-LABEL: define {{[^@]+}}@recursive_alloca_compare_global1
; CGSCC-SAME: (i1 [[C:%.*]]) #[[ATTR3]] {
; CGSCC-NEXT:    [[A:%.*]] = alloca i1, align 1
; CGSCC-NEXT:    br i1 [[C]], label [[T:%.*]], label [[F:%.*]]
; CGSCC:       t:
; CGSCC-NEXT:    [[P:%.*]] = load i1*, i1** @G1, align 8
; CGSCC-NEXT:    [[CMP:%.*]] = icmp eq i1* [[A]], [[P]]
; CGSCC-NEXT:    ret i1 [[CMP]]
; CGSCC:       f:
; CGSCC-NEXT:    store i1* [[A]], i1** @G1, align 8
; CGSCC-NEXT:    [[CALL:%.*]] = call i1 @recursive_alloca_compare_global1(i1 noundef true) #[[ATTR3]]
; CGSCC-NEXT:    ret i1 [[CALL]]
;
  %a = alloca i1
  br i1 %c, label %t, label %f
t:
  %p = load i1*, i1** @G1
  %cmp = icmp eq i1* %a, %p
  ret i1 %cmp
f:
  store i1* %a, i1** @G1
  %call = call i1 @recursive_alloca_compare_global1(i1 true)
  ret i1 %call
}

; FIXME: This should *not* return true.
define i1 @recursive_alloca_compare_caller_global1(i1 %c) {
; TUNIT: Function Attrs: nofree norecurse nosync nounwind
; TUNIT-LABEL: define {{[^@]+}}@recursive_alloca_compare_caller_global1
; TUNIT-SAME: (i1 [[C:%.*]]) #[[ATTR5:[0-9]+]] {
; TUNIT-NEXT:    [[CALL:%.*]] = call i1 @recursive_alloca_compare_global1(i1 [[C]]) #[[ATTR4]]
; TUNIT-NEXT:    ret i1 [[CALL]]
;
; CGSCC: Function Attrs: nofree nosync nounwind
; CGSCC-LABEL: define {{[^@]+}}@recursive_alloca_compare_caller_global1
; CGSCC-SAME: (i1 [[C:%.*]]) #[[ATTR3]] {
; CGSCC-NEXT:    [[CALL:%.*]] = call i1 @recursive_alloca_compare_global1(i1 [[C]]) #[[ATTR4]]
; CGSCC-NEXT:    ret i1 [[CALL]]
;
  %call = call i1 @recursive_alloca_compare_global1(i1 %c)
  ret i1 %call
}

define internal i1 @recursive_alloca_compare_global2(i1 %c) {
; TUNIT: Function Attrs: nofree nosync nounwind
; TUNIT-LABEL: define {{[^@]+}}@recursive_alloca_compare_global2
; TUNIT-SAME: (i1 [[C:%.*]]) #[[ATTR4]] {
; TUNIT-NEXT:    [[A:%.*]] = alloca i1, align 1
; TUNIT-NEXT:    [[P:%.*]] = load i1*, i1** @G2, align 8
; TUNIT-NEXT:    store i1* [[A]], i1** @G2, align 8
; TUNIT-NEXT:    br i1 [[C]], label [[T:%.*]], label [[F:%.*]]
; TUNIT:       t:
; TUNIT-NEXT:    [[CMP:%.*]] = icmp eq i1* [[A]], [[P]]
; TUNIT-NEXT:    ret i1 [[CMP]]
; TUNIT:       f:
; TUNIT-NEXT:    [[CALL:%.*]] = call i1 @recursive_alloca_compare_global2(i1 noundef true) #[[ATTR4]]
; TUNIT-NEXT:    ret i1 [[CALL]]
;
; CGSCC: Function Attrs: nofree nosync nounwind
; CGSCC-LABEL: define {{[^@]+}}@recursive_alloca_compare_global2
; CGSCC-SAME: (i1 [[C:%.*]]) #[[ATTR3]] {
; CGSCC-NEXT:    [[A:%.*]] = alloca i1, align 1
; CGSCC-NEXT:    [[P:%.*]] = load i1*, i1** @G2, align 8
; CGSCC-NEXT:    store i1* [[A]], i1** @G2, align 8
; CGSCC-NEXT:    br i1 [[C]], label [[T:%.*]], label [[F:%.*]]
; CGSCC:       t:
; CGSCC-NEXT:    [[CMP:%.*]] = icmp eq i1* [[A]], [[P]]
; CGSCC-NEXT:    ret i1 [[CMP]]
; CGSCC:       f:
; CGSCC-NEXT:    [[CALL:%.*]] = call i1 @recursive_alloca_compare_global2(i1 noundef true) #[[ATTR3]]
; CGSCC-NEXT:    ret i1 [[CALL]]
;
  %a = alloca i1
  %p = load i1*, i1** @G2
  store i1* %a, i1** @G2
  br i1 %c, label %t, label %f
t:
  %cmp = icmp eq i1* %a, %p
  ret i1 %cmp
f:
  %call = call i1 @recursive_alloca_compare_global2(i1 true)
  ret i1 %call
}

; FIXME: This should *not* return true.
define i1 @recursive_alloca_compare_caller_global2(i1 %c) {
; TUNIT: Function Attrs: nofree norecurse nosync nounwind
; TUNIT-LABEL: define {{[^@]+}}@recursive_alloca_compare_caller_global2
; TUNIT-SAME: (i1 [[C:%.*]]) #[[ATTR5]] {
; TUNIT-NEXT:    [[CALL:%.*]] = call i1 @recursive_alloca_compare_global2(i1 [[C]]) #[[ATTR4]]
; TUNIT-NEXT:    ret i1 [[CALL]]
;
; CGSCC: Function Attrs: nofree nosync nounwind
; CGSCC-LABEL: define {{[^@]+}}@recursive_alloca_compare_caller_global2
; CGSCC-SAME: (i1 [[C:%.*]]) #[[ATTR3]] {
; CGSCC-NEXT:    [[CALL:%.*]] = call i1 @recursive_alloca_compare_global2(i1 [[C]]) #[[ATTR4]]
; CGSCC-NEXT:    ret i1 [[CALL]]
;
  %call = call i1 @recursive_alloca_compare_global2(i1 %c)
  ret i1 %call
}
define internal i1 @recursive_inst_compare_global3(i1 %c) {
;
; TUNIT: Function Attrs: nofree nosync nounwind
; TUNIT-LABEL: define {{[^@]+}}@recursive_inst_compare_global3
; TUNIT-SAME: (i1 [[C:%.*]]) #[[ATTR4]] {
; TUNIT-NEXT:    [[P:%.*]] = load i1, i1* @G3, align 1
; TUNIT-NEXT:    store i1 [[C]], i1* @G3, align 1
; TUNIT-NEXT:    br i1 [[C]], label [[T:%.*]], label [[F:%.*]]
; TUNIT:       t:
; TUNIT-NEXT:    [[CMP:%.*]] = icmp eq i1 [[C]], [[P]]
; TUNIT-NEXT:    ret i1 [[CMP]]
; TUNIT:       f:
; TUNIT-NEXT:    [[CALL:%.*]] = call i1 @recursive_inst_compare_global3(i1 noundef true) #[[ATTR4]]
; TUNIT-NEXT:    ret i1 [[CALL]]
;
; CGSCC: Function Attrs: nofree nosync nounwind
; CGSCC-LABEL: define {{[^@]+}}@recursive_inst_compare_global3
; CGSCC-SAME: (i1 [[C:%.*]]) #[[ATTR3]] {
; CGSCC-NEXT:    [[P:%.*]] = load i1, i1* @G3, align 1
; CGSCC-NEXT:    store i1 [[C]], i1* @G3, align 1
; CGSCC-NEXT:    br i1 [[C]], label [[T:%.*]], label [[F:%.*]]
; CGSCC:       t:
; CGSCC-NEXT:    [[CMP:%.*]] = icmp eq i1 [[C]], [[P]]
; CGSCC-NEXT:    ret i1 [[CMP]]
; CGSCC:       f:
; CGSCC-NEXT:    [[CALL:%.*]] = call i1 @recursive_inst_compare_global3(i1 noundef true) #[[ATTR3]]
; CGSCC-NEXT:    ret i1 [[CALL]]
;
  %p = load i1, i1* @G3
  store i1 %c, i1* @G3
  br i1 %c, label %t, label %f
t:
  %cmp = icmp eq i1 %c, %p
  ret i1 %cmp
f:
  %call = call i1 @recursive_inst_compare_global3(i1 true)
  ret i1 %call
}

; FIXME: This should *not* return true.
define i1 @recursive_inst_compare_caller_global3(i1 %c) {
; TUNIT: Function Attrs: nofree norecurse nosync nounwind
; TUNIT-LABEL: define {{[^@]+}}@recursive_inst_compare_caller_global3
; TUNIT-SAME: (i1 [[C:%.*]]) #[[ATTR5]] {
; TUNIT-NEXT:    [[CALL:%.*]] = call i1 @recursive_inst_compare_global3(i1 [[C]]) #[[ATTR4]]
; TUNIT-NEXT:    ret i1 [[CALL]]
;
; CGSCC: Function Attrs: nofree nosync nounwind
; CGSCC-LABEL: define {{[^@]+}}@recursive_inst_compare_caller_global3
; CGSCC-SAME: (i1 [[C:%.*]]) #[[ATTR3]] {
; CGSCC-NEXT:    [[CALL:%.*]] = call i1 @recursive_inst_compare_global3(i1 [[C]]) #[[ATTR4]]
; CGSCC-NEXT:    ret i1 [[CALL]]
;
  %call = call i1 @recursive_inst_compare_global3(i1 %c)
  ret i1 %call
}
;.
; TUNIT: attributes #[[ATTR0]] = { nofree norecurse nosync nounwind willreturn memory(none) }
; TUNIT: attributes #[[ATTR1]] = { nofree nosync nounwind memory(none) }
; TUNIT: attributes #[[ATTR2]] = { nofree norecurse nosync nounwind memory(none) }
; TUNIT: attributes #[[ATTR3]] = { nofree nosync nounwind memory(argmem: readwrite) }
; TUNIT: attributes #[[ATTR4]] = { nofree nosync nounwind }
; TUNIT: attributes #[[ATTR5]] = { nofree norecurse nosync nounwind }
; TUNIT: attributes #[[ATTR6]] = { nounwind }
;.
; CGSCC: attributes #[[ATTR0]] = { nofree norecurse nosync nounwind willreturn memory(none) }
; CGSCC: attributes #[[ATTR1]] = { nofree nosync nounwind memory(none) }
; CGSCC: attributes #[[ATTR2]] = { nofree nosync nounwind memory(argmem: readwrite) }
; CGSCC: attributes #[[ATTR3]] = { nofree nosync nounwind }
; CGSCC: attributes #[[ATTR4]] = { nounwind }
;.