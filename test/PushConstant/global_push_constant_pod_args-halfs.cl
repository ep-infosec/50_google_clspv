// RUN: clspv %target %s -o %t.spv -inline-entry-points -cl-std=CL2.0 -no-16bit-storage=pushconstant
// RUN: spirv-dis %t.spv -o %t.spvasm
// RUN: FileCheck %s < %t.spvasm
// RUN: clspv-reflection %t.spv -o %t.map
// RUN: FileCheck --check-prefix=MAP %s < %t.map
// RUN: spirv-val --target-env vulkan1.0 %t.spv

#pragma OPENCL EXTENSION cl_khr_fp16 : enable

kernel void foo(global half *out, half s, half2 v2, half3 v3, half4 v4) {
  *out = s + v2[0] + v3[1] + v4[2];
}

// MAP: kernel,foo,arg,out,argOrdinal,0
// MAP: kernel,foo,arg,s,argOrdinal,1,offset,0,argKind,pod_pushconstant,argSize,2
// MAP: kernel,foo,arg,v2,argOrdinal,2,offset,4,argKind,pod_pushconstant,argSize,4
// MAP: kernel,foo,arg,v3,argOrdinal,3,offset,8,argKind,pod_pushconstant,argSize,6
// MAP: kernel,foo,arg,v4,argOrdinal,4,offset,16,argKind,pod_pushconstant,argSize,8

// CHECK-DAG: OpMemberDecorate [[inner:%[a-zA-Z0-9_]+]] 5 Offset 20
// CHECK-DAG: OpMemberDecorate [[inner]] 4 Offset 16
// CHECK-DAG: OpMemberDecorate [[inner]] 3 Offset 12
// CHECK-DAG: OpMemberDecorate [[inner]] 2 Offset 8
// CHECK-DAG: OpMemberDecorate [[inner]] 1 Offset 4
// CHECK-DAG: OpMemberDecorate [[inner]] 0 Offset 0
// CHECK-DAG: [[int:%[a-zA-Z0-9_]+]] = OpTypeInt 32 0
// CHECK-DAG: [[short:%[a-zA-Z0-9_]+]] = OpTypeInt 16 0
// CHECK-DAG: [[int_0:%[a-zA-Z0-9_]+]] = OpConstant [[int]] 0
// CHECK-DAG: [[int_16:%[a-zA-Z0-9_]+]] = OpConstant [[int]] 16
// CHECK-DAG: [[int_1:%[a-zA-Z0-9_]+]] = OpConstant [[int]] 1
// CHECK-DAG: [[int_2:%[a-zA-Z0-9_]+]] = OpConstant [[int]] 2
// CHECK-DAG: [[int_5:%[a-zA-Z0-9_]+]] = OpConstant [[int]] 5
// CHECK-DAG: [[half:%[a-zA-Z0-9_]+]] = OpTypeFloat 16
// CHECK-DAG: [[inner]] = OpTypeStruct [[int]] [[int]] [[int]] [[int]] [[int]] [[int]]
// CHECK-DAG: [[outer:%[a-zA-Z0-9_]+]] = OpTypeStruct [[inner]]
// CHECK-DAG: [[outer_ptr:%[a-zA-Z0-9_]+]] = OpTypePointer PushConstant [[outer]]
// CHECK-DAG: [[int_ptr:%[a-zA-Z0-9_]+]] = OpTypePointer PushConstant [[int]]
// CHECK-DAG: [[var:%[a-zA-Z0-9_]+]] = OpVariable [[outer_ptr]] PushConstant

// CHECK: OpLabel
// CHECK-DAG: [[gep0:%[a-zA-Z0-9_]+]] = OpAccessChain [[int_ptr]] [[var]] [[int_0]] [[int_0]]
// CHECK-DAG: [[gep1:%[a-zA-Z0-9_]+]] = OpAccessChain [[int_ptr]] [[var]] [[int_0]] [[int_1]]
// CHECK-DAG: [[gep2:%[a-zA-Z0-9_]+]] = OpAccessChain [[int_ptr]] [[var]] [[int_0]] [[int_2]]
// CHECK-DAG: [[gep5:%[a-zA-Z0-9_]+]] = OpAccessChain [[int_ptr]] [[var]] [[int_0]] [[int_5]]
//
// CHECK-DAG: [[ld0:%[a-zA-Z0-9_]+]] = OpLoad [[int]] [[gep0]]
// CHECK-DAG: [[cast0:%[a-zA-Z0-9_]+]] = OpUConvert [[short]] [[ld0]]
// CHECK-DAG: OpBitcast [[half]] [[cast0]]

// CHECK-DAG: [[ld1:%[a-zA-Z0-9_]+]] = OpLoad [[int]] [[gep1]]
// CHECK-DAG: [[cast1:%[a-zA-Z0-9_]+]] = OpUConvert [[short]] [[ld1]]
// CHECK-DAG: OpBitcast [[half]] [[cast1]]

// CHECK-DAG: [[ld2:%[a-zA-Z0-9_]+]] = OpLoad [[int]] [[gep2]]
// CHECK-DAG: [[shr2:%[a-zA-Z0-9_]+]] = OpShiftRightLogical [[int]] [[ld2]] [[int_16]]
// CHECK-DAG: [[cast_v3:%[a-zA-Z0-9_]+]] = OpUConvert [[short]] [[shr2]]
// CHECK-DAG: OpBitcast [[half]] [[cast_v3]]

// CHECK-DAG: [[ld5:%[a-zA-Z0-9_]+]] = OpLoad [[int]] [[gep5]]
// CHECK-DAG: [[cast_v4:%[a-zA-Z0-9_]+]] = OpUConvert [[short]] [[ld5]]
// CHECK-DAG: OpBitcast [[half]] [[cast_v4]]

// Uses of the casts aren't checked because LLVM optimizes them to vector additions.
