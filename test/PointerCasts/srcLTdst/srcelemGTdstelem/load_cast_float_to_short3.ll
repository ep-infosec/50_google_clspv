; RUN: clspv-opt %s -o %t --passes=replace-pointer-bitcast
; RUN: FileCheck %s < %t

target datalayout = "e-p:32:32-i64:64-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024"
target triple = "spir-unknown-unknown"

; CHECK: [[shl:%[^ ]+]] = shl i32 %i, 1
; CHECK: [[gep:%[a-zA-Z0-9_.]+]] = getelementptr float, float addrspace(1)* %a, i32 [[shl]]
; CHECK: [[ld0:%[a-zA-Z0-9_.]+]] = load float, float addrspace(1)* [[gep]]
; CHECK: [[add:%[a-zA-Z0-9_.]+]] = add i32 [[shl]], 1
; CHECK: [[gep:%[a-zA-Z0-9_.]+]] = getelementptr float, float addrspace(1)* %a, i32 [[add]]
; CHECK: [[ld1:%[a-zA-Z0-9_.]+]] = load float, float addrspace(1)* [[gep]]
; CHECK: [[in0:%[a-zA-Z0-9_.]+]] = insertelement <2 x float> undef, float [[ld0]], i32 0
; CHECK: [[in1:%[a-zA-Z0-9_.]+]] = insertelement <2 x float> [[in0]], float [[ld1]], i32 1
; CHECK: [[bitcast:%[^ ]+]] = bitcast <2 x float> [[in1]] to <4 x i16>
; CHECK: shufflevector <4 x i16> [[bitcast]], <4 x i16> poison, <3 x i32> <i32 0, i32 1, i32 2>

define spir_kernel void @foo(float addrspace(1)* %a, <3 x i16> addrspace(1)* %b, i32 %i) {
entry:
  %0 = bitcast float addrspace(1)* %a to <3 x i16> addrspace(1)*
  %arrayidx = getelementptr inbounds <3 x i16>, <3 x i16> addrspace(1)* %0, i32 %i
  %1 = load <3 x i16>, <3 x i16> addrspace(1)* %arrayidx, align 8
  store <3 x i16> %1, <3 x i16> addrspace(1)* %b, align 8
  ret void
}

