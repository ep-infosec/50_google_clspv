
; RUN: clspv-opt --passes=replace-opencl-builtin %s -o %t
; RUN: FileCheck %s < %t

target datalayout = "e-p:32:32-i64:64-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024"
target triple = "spir-unknown-unknown"

define void @foo(i16 addrspace(2)* %in, i32 %offset) {
entry:
  %0 = call spir_func <4 x i16> @_Z6vload4Dv4_jPU3AS2t(i32 %offset, i16 addrspace(2)* %in)
  ret void
}

declare <4 x i16> @_Z6vload4Dv4_jPU3AS2t(i32, i16 addrspace(2)*)

; CHECK: [[mul:%[a-zA-Z0-9_.]+]] = mul i32 %offset, 4
; CHECK: [[add:%[a-zA-Z0-9_.]+]] = add i32 [[mul]], 0
; CHECK: [[gep:%[a-zA-Z0-9_.]+]] = getelementptr i16, i16 addrspace(2)* %in, i32 [[add]]
; CHECK: [[ld:%[a-zA-Z0-9_.]+]] = load i16, i16 addrspace(2)* [[gep]]
; CHECK: [[in0:%[a-zA-Z0-9_.]+]] = insertelement <4 x i16> undef, i16 [[ld]], i64 0
; CHECK: [[add:%[a-zA-Z0-9_.]+]] = add i32 [[mul]], 1
; CHECK: [[gep:%[a-zA-Z0-9_.]+]] = getelementptr i16, i16 addrspace(2)* %in, i32 [[add]]
; CHECK: [[ld:%[a-zA-Z0-9_.]+]] = load i16, i16 addrspace(2)* [[gep]]
; CHECK: [[in1:%[a-zA-Z0-9_.]+]] = insertelement <4 x i16> [[in0]], i16 [[ld]], i64 1
; CHECK: [[add:%[a-zA-Z0-9_.]+]] = add i32 [[mul]], 2
; CHECK: [[gep:%[a-zA-Z0-9_.]+]] = getelementptr i16, i16 addrspace(2)* %in, i32 [[add]]
; CHECK: [[ld:%[a-zA-Z0-9_.]+]] = load i16, i16 addrspace(2)* [[gep]]
; CHECK: [[in2:%[a-zA-Z0-9_.]+]] = insertelement <4 x i16> [[in1]], i16 [[ld]], i64 2
; CHECK: [[add:%[a-zA-Z0-9_.]+]] = add i32 [[mul]], 3
; CHECK: [[gep:%[a-zA-Z0-9_.]+]] = getelementptr i16, i16 addrspace(2)* %in, i32 [[add]]
; CHECK: [[ld:%[a-zA-Z0-9_.]+]] = load i16, i16 addrspace(2)* [[gep]]
; CHECK: [[in3:%[a-zA-Z0-9_.]+]] = insertelement <4 x i16> [[in2]], i16 [[ld]], i64 3
