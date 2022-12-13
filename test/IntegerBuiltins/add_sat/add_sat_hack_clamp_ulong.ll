
; RUN: clspv-opt --passes=replace-opencl-builtin,replace-llvm-intrinsics -hack-clamp-width %s -o %t.ll
; RUN: FileCheck %s < %t.ll

; AUTO-GENERATED TEST FILE
; This test was generated by add_sat_hack_clamp_test_gen.cpp.
; Please modify the that file and regenerate the tests to make changes.

target datalayout = "e-p:32:32-i64:64-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024"
target triple = "spir-unknown-unknown"

define i64 @add_sat_ulong(i64 %a, i64 %b) {
entry:
 %call = call i64 @_Z7add_satmm(i64 %a, i64 %b)
 ret i64 %call
}

declare i64 @_Z7add_satmm(i64, i64)

; CHECK: [[call:%[a-zA-Z0-9_.]+]] = call { i64, i64 } @_Z8spirv.op.149.mm(i32 149, i64 %a, i64 %b)
; CHECK: [[ex0:%[a-zA-Z0-9_.]+]] = extractvalue { i64, i64 } [[call]], 0
; CHECK: [[ex1:%[a-zA-Z0-9_.]+]] = extractvalue { i64, i64 } [[call]], 1
; CHECK: [[cmp:%[a-zA-Z0-9_.]+]] = icmp eq i64 [[ex1]], 0
; CHECK: [[sel:%[a-zA-Z0-9_.]+]] = select i1 [[cmp]], i64 [[ex0]], i64 -1
; CHECK: ret i64 [[sel]]
