; RUN: clspv-opt %s -o %t --passes=replace-pointer-bitcast
; RUN: FileCheck %s < %t

target datalayout = "e-p:32:32-i64:64-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024"
target triple = "spir-unknown-unknown"

; CHECK:  [[shl:%[^ ]+]] = shl i32 %i, 3
; CHECK:  [[shr:%[^ ]+]] = lshr i32 [[shl]], 1
; CHECK:  [[gep:%[^ ]+]] = getelementptr <2 x i8>, <2 x i8> addrspace(1)* %a, i32 [[shr]]
; CHECK:  [[ld0:%[^ ]+]] = load <2 x i8>, <2 x i8> addrspace(1)* [[gep]], align 2
; CHECK:  [[add:%[^ ]+]] = add i32 [[shr]], 1
; CHECK:  [[gep:%[^ ]+]] = getelementptr <2 x i8>, <2 x i8> addrspace(1)* %a, i32 [[add]]
; CHECK:  [[ld1:%[^ ]+]] = load <2 x i8>, <2 x i8> addrspace(1)* [[gep]], align 2
; CHECK:  [[add2:%[^ ]+]] = add i32 [[add]], 1
; CHECK:  [[gep:%[^ ]+]] = getelementptr <2 x i8>, <2 x i8> addrspace(1)* %a, i32 [[add2]]
; CHECK:  [[ld2:%[^ ]+]] = load <2 x i8>, <2 x i8> addrspace(1)* [[gep]], align 2
; CHECK:  [[add3:%[^ ]+]] = add i32 [[add2]], 1
; CHECK:  [[gep:%[^ ]+]] = getelementptr <2 x i8>, <2 x i8> addrspace(1)* %a, i32 [[add3]]
; CHECK:  [[ld3:%[^ ]+]] = load <2 x i8>, <2 x i8> addrspace(1)* [[gep]], align 2

; CHECK:  [[shuffle0:%[^ ]+]] = shufflevector <2 x i8> [[ld0]], <2 x i8> [[ld1]], <4 x i32> <i32 0, i32 1, i32 2, i32 3>
; CHECK:  [[shuffle1:%[^ ]+]] = shufflevector <2 x i8> [[ld2]], <2 x i8> [[ld3]], <4 x i32> <i32 0, i32 1, i32 2, i32 3>

; CHECK:  [[bitcast0:%[^ ]+]] = bitcast <4 x i8> [[shuffle0]] to <2 x i16>
; CHECK:  [[bitcast1:%[^ ]+]] = bitcast <4 x i8> [[shuffle1]] to <2 x i16>

; CHECK:  [[shuffle:%[^ ]+]] = shufflevector <2 x i16> [[bitcast0]], <2 x i16> [[bitcast1]], <4 x i32> <i32 0, i32 1, i32 2, i32 3>
; CHECK:  bitcast <4 x i16> [[shuffle]] to i64

define spir_kernel void @foo(<2 x i8> addrspace(1)* %a, i64 addrspace(1)* %b, i32 %i) {
entry:
  %0 = bitcast <2 x i8> addrspace(1)* %a to i64 addrspace(1)*
  %arrayidx = getelementptr inbounds i64, i64 addrspace(1)* %0, i32 %i
  %1 = load i64, i64 addrspace(1)* %arrayidx, align 8
  store i64 %1, i64 addrspace(1)* %b, align 8
  ret void
}

