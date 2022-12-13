
; RUN: clspv-opt --passes=replace-opencl-builtin %s -o %t.ll
; RUN: FileCheck %s < %t.ll

; AUTO-GENERATED TEST FILE
; This test was generated by add_sat_test_gen.cpp.
; Please modify the that file and regenerate the tests to make changes.

target datalayout = "e-p:32:32-i64:64-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024"
target triple = "spir-unknown-unknown"

define i64 @rhadd_long(i64 %a, i64 %b) {
entry:
 %call = call i64 @_Z5rhaddll(i64 %a, i64 %b)
 ret i64 %call
}

declare i64 @_Z5rhaddll(i64, i64)

; CHECK: [[a_shr:%[a-zA_Z0-9_.]+]] = ashr i64 %a, 1
; CHECK: [[b_shr:%[a-zA-Z0-9_.]+]] = ashr i64 %b, 1
; CHECK: [[add:%[a-zA-Z0-9_.]+]] = add i64 [[a_shr]], [[b_shr]]
; CHECK: [[join:%[a-zA-Z0-9_.]+]] = or i64 %a, %b
; CHECK: [[and:%[a-zA-Z0-9_.]+]] = and i64 [[join]], 1
; CHECK: [[hadd:%[a-zA-Z0-9_.]+]] = add i64 [[add]], [[and]]
; CHECK: ret i64 [[hadd]]
