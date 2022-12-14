; RUN: clspv-opt --passes=specialize-image-types %s -o %t
; RUN: FileCheck %s < %t

; CHECK: %[[IMAGE:opencl.image2d_ro_t.float.sampled]] = type opaque
; CHECK: declare spir_func <4 x float> @_Z11read_imagef33[[IMAGE]]11ocl_samplerDv2_f(%[[IMAGE]] addrspace(1)*, %opencl.sampler_t addrspace(2)*, <2 x float>)
; CHECK: define spir_kernel void @read_float
; CHECK: call spir_func <4 x float> @bar(%[[IMAGE]] addrspace(1)* %image, <2 x float> %coord
; CHECK: define spir_func <4 x float> @bar(%[[IMAGE]] addrspace(1)* %image, <2 x float> %coord
; CHECK: call spir_func <4 x float> @_Z11read_imagef33[[IMAGE]]11ocl_samplerDv2_f(%[[IMAGE]] addrspace(1)* %image

target datalayout = "e-p:32:32-i64:64-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024"
target triple = "spir-unknown-unknown"

%opencl.image2d_ro_t = type opaque
%opencl.sampler_t = type opaque

define spir_kernel void @read_float(%opencl.image2d_ro_t addrspace(1)* %image, <2 x float> %coord, <4 x float> addrspace(1)* nocapture %data) local_unnamed_addr {
entry:
  %call = tail call spir_func <4 x float> @bar(%opencl.image2d_ro_t addrspace(1)* %image, <2 x float> %coord)
  store <4 x float> %call, <4 x float> addrspace(1)* %data, align 16
  ret void
}

define spir_func <4 x float> @bar(%opencl.image2d_ro_t addrspace(1)* %image, <2 x float> %coord) {
  %sampler = tail call %opencl.sampler_t addrspace(2)* @__translate_sampler_initializer(i32 23)
  %call = tail call spir_func <4 x float> @_Z11read_imagef14ocl_image2d_ro11ocl_samplerDv2_f(%opencl.image2d_ro_t addrspace(1)* %image, %opencl.sampler_t addrspace(2)* %sampler, <2 x float> %coord)
  ret <4 x float> %call
}

declare spir_func <4 x float> @_Z11read_imagef14ocl_image2d_ro11ocl_samplerDv2_f(%opencl.image2d_ro_t addrspace(1)*, %opencl.sampler_t addrspace(2)*, <2 x float>) local_unnamed_addr

declare %opencl.sampler_t addrspace(2)* @__translate_sampler_initializer(i32) local_unnamed_addr

