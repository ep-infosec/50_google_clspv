; RUN: clspv-opt --passes=specialize-image-types %s -o %t
; RUN: FileCheck %s < %t

; CHECK: %[[IMAGE:opencl.image3d_ro_t.float.sampled]] = type opaque
; CHECK: declare spir_func i32 @_Z15get_image_depth33[[IMAGE]](%[[IMAGE]] addrspace(1)*) [[ATTRS:#[0-9]+]]
; CHECK: declare spir_func <4 x float> @_Z11read_imagef33[[IMAGE]]11ocl_samplerDv4_f(%[[IMAGE]] addrspace(1)*, %opencl.sampler_t addrspace(2)*, <4 x float>) [[ATTRS:#[0-9]+]]
; CHECK: define spir_kernel void @read_float
; CHECK: call spir_func <4 x float> @_Z11read_imagef33[[IMAGE]]11ocl_samplerDv4_f(%[[IMAGE]] addrspace(1)* %image
; CHECK: call spir_func i32 @_Z15get_image_depth33[[IMAGE]](%[[IMAGE]] addrspace(1)* %image)
; CHECK: attributes [[ATTRS]] = { convergent nounwind }

target datalayout = "e-p:32:32-i64:64-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024"
target triple = "spir-unknown-unknown"

%opencl.image3d_ro_t = type opaque
%opencl.sampler_t = type opaque

define spir_kernel void @read_float(%opencl.image3d_ro_t addrspace(1)* %image, <4 x float> %coord, <4 x float> addrspace(1)* nocapture %data) local_unnamed_addr #0 {
entry:
  %0 = tail call %opencl.sampler_t addrspace(2)* @__translate_sampler_initializer(i32 23) #2
  %call = tail call spir_func <4 x float> @_Z11read_imagef14ocl_image3d_ro11ocl_samplerDv4_f(%opencl.image3d_ro_t addrspace(1)* %image, %opencl.sampler_t addrspace(2)* %0, <4 x float> %coord) #3
  %h = tail call spir_func i32 @_Z15get_image_depth14ocl_image3d_ro(%opencl.image3d_ro_t addrspace(1)* %image)
  store <4 x float> %call, <4 x float> addrspace(1)* %data, align 16
  ret void
}

declare spir_func <4 x float> @_Z11read_imagef14ocl_image3d_ro11ocl_samplerDv4_f(%opencl.image3d_ro_t addrspace(1)*, %opencl.sampler_t addrspace(2)*, <4 x float>) local_unnamed_addr #1

declare %opencl.sampler_t addrspace(2)* @__translate_sampler_initializer(i32) local_unnamed_addr

declare spir_func i32 @_Z15get_image_depth14ocl_image3d_ro(%opencl.image3d_ro_t addrspace(1)*) #1

attributes #0 = { convergent }
attributes #1 = { convergent nounwind }
attributes #2 = { nounwind }
attributes #3 = { convergent nobuiltin nounwind readonly }

