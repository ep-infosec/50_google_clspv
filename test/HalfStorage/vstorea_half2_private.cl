// RUN: clspv %target %s -o %t.spv -arch=spir
// RUN: spirv-dis -o %t2.spvasm %t.spv
// RUN: FileCheck %s < %t2.spvasm --check-prefixes=CHECK,CHECK-32
// RUN: spirv-val --target-env vulkan1.0 %t.spv

// RUN: clspv %target %s -o %t.spv -arch=spir64
// RUN: spirv-dis -o %t2.spvasm %t.spv
// RUN: FileCheck %s < %t2.spvasm --check-prefixes=CHECK,CHECK-64
// RUN: spirv-val --target-env vulkan1.0 %t.spv

kernel void foo(global uint* A, float2 val, uint n) {
  uint arr[5];
  half* cast = (private half*) arr;
  vstorea_half2(val, n, cast);
  vstorea_half2_rte(val, n+1, cast);
  vstorea_half2_rtz(val, n+2, cast);
  *A = *(uint*) arr;
}
// CHECK-DAG: [[_uint:%[0-9a-zA-Z_]+]] = OpTypeInt 32 0
// CHECK-64-DAG: [[_ulong:%[0-9a-zA-Z_]+]] = OpTypeInt 64 0
// CHECK-DAG: [[_float:%[0-9a-zA-Z_]+]] = OpTypeFloat 32
// CHECK-DAG: [[_v2float:%[0-9a-zA-Z_]+]] = OpTypeVector [[_float]] 2
// CHECK-DAG: [[_uint_0:%[0-9a-zA-Z_]+]] = OpConstant [[_uint]] 0
// CHECK-DAG: [[_uint_1:%[0-9a-zA-Z_]+]] = OpConstant [[_uint]] 1
// CHECK-DAG: [[_uint_2:%[0-9a-zA-Z_]+]] = OpConstant [[_uint]] 2
// CHECK-64-DAG: [[_ulong_0:%[0-9a-zA-Z_]+]] = OpConstant [[_ulong]] 0
// CHECK: [[_39:%[0-9a-zA-Z_]+]] = OpCompositeExtract [[_v2float]]
// CHECK: [[_41:%[0-9a-zA-Z_]+]] = OpCompositeExtract [[_uint]]
// CHECK-64: [[_42:%[0-9a-zA-Z_]+]] = OpAccessChain {{.*}} [[arr:%[0-9a-zA-Z_]+]] [[_ulong_0]]
// CHECK-32: [[_42:%[0-9a-zA-Z_]+]] = OpAccessChain {{.*}} [[arr:%[0-9a-zA-Z_]+]] [[_uint_0]]
// CHECK-64: [[_41_long:%[0-9a-zA-Z_]+]] = OpUConvert [[_ulong]] [[_41]]
// CHECK: [[_43:%[0-9a-zA-Z_]+]] = OpExtInst [[_uint]] {{.*}} PackHalf2x16 [[_39]]
// CHECK-64: [[_44:%[0-9a-zA-Z_]+]] = OpAccessChain {{.*}} [[arr]] [[_41_long]]
// CHECK-32: [[_44:%[0-9a-zA-Z_]+]] = OpAccessChain {{.*}} [[arr]] [[_41]]
// CHECK: OpStore [[_44]] [[_43]]
// CHECK: [[_45:%[0-9a-zA-Z_]+]] = OpIAdd [[_uint]] [[_41]] [[_uint_1]]
// CHECK-64: [[_45_long:%[0-9a-zA-Z_]+]] = OpUConvert [[_ulong]] [[_45]]
// CHECK: [[_46:%[0-9a-zA-Z_]+]] = OpExtInst [[_uint]] {{.*}} PackHalf2x16 [[_39]]
// CHECK-64: [[_47:%[0-9a-zA-Z_]+]] = OpAccessChain {{.*}} [[arr]] [[_45_long]]
// CHECK-32: [[_47:%[0-9a-zA-Z_]+]] = OpAccessChain {{.*}} [[arr]] [[_45]]
// CHECK: OpStore [[_47]] [[_46]]
// CHECK: [[_48:%[0-9a-zA-Z_]+]] = OpIAdd [[_uint]] [[_41]] [[_uint_2]]
// CHECK-64: [[_48_long:%[0-9a-zA-Z_]+]] = OpUConvert [[_ulong]] [[_48]]
// CHECK: [[_49:%[0-9a-zA-Z_]+]] = OpExtInst [[_uint]] {{.*}} PackHalf2x16 [[_39]]
// CHECK-64: [[_50:%[0-9a-zA-Z_]+]] = OpAccessChain {{.*}} [[arr]] [[_48_long]]
// CHECK-32: [[_50:%[0-9a-zA-Z_]+]] = OpAccessChain {{.*}} [[arr]] [[_48]]
// CHECK: OpStore [[_50]] [[_49]]
// CHECK: [[_51:%[0-9a-zA-Z_]+]] = OpLoad [[_uint]] [[_42]]
