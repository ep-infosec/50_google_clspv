
; RUN: clspv-opt --passes=replace-opencl-builtin %s -o %t.ll
; RUN: FileCheck %s < %t.ll

; AUTO-GENERATED TEST FILE
; This test was generated by mad_sat_test_gen.cpp.
; Please modify the that file and regenerate the tests to make changes.

target datalayout = "e-p:32:32-i64:64-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024"
target triple = "spir-unknown-unknown"

define i16 @mad_sat_ushort(i16 %a, i16 %b, i16 %c) {
entry:
 %call = call i16 @_Z7mad_satttt(i16 %a, i16 %b, i16 %c)
 ret i16 %call
}

declare i16 @_Z7mad_satttt(i16, i16, i16)

; CHECK: [[mul_ext:%[a-zA-Z0-9_.]+]] = call { i16, i16 } @_Z8spirv.op.151.{{.*}}(i32 151, i16 %a, i16 %b)
; CHECK: [[mul_lo:%[a-zA-Z0-9_.]+]] = extractvalue { i16, i16 } [[mul_ext]], 0
; CHECK: [[mul_hi:%[a-zA-Z0-9_.]+]] = extractvalue { i16, i16 } [[mul_ext]], 1
; CHECK: [[add:%[a-zA-Z0-9_.]+]] = call { i16, i16 } @_Z8spirv.op.149.{{.*}}(i32 149, i16 [[mul_lo]], i16 %c)
; CHECK: [[ex0:%[a-zA-Z0-9_.]+]] = extractvalue { i16, i16 } [[add]], 0
; CHECK: [[ex1:%[a-zA-Z0-9_.]+]] = extractvalue { i16, i16 } [[add]], 1
; CHECK: [[or:%[a-zA-Z0-9_.]+]] = or i16 [[mul_hi]], [[ex1]]
; CHECK: [[cmp:%[a-zA-Z0-9_.]+]] = icmp eq i16 [[or]], 0
; CHECK: [[sel:%[a-zA-Z0-9_.]+]] = select i1 [[cmp]], i16 [[ex0]], i16 -1
; CHECK: ret i16 [[sel]]