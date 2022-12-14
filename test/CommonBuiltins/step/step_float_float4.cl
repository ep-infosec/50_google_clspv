// RUN: clspv %target  %s -o %t.spv
// RUN: spirv-dis -o %t2.spvasm %t.spv
// RUN: FileCheck %s < %t2.spvasm
// RUN: spirv-val --target-env vulkan1.0 %t.spv

// CHECK:     %[[__original_id_1:[0-9]+]] = OpExtInstImport "GLSL.std.450"
// CHECK-DAG: %[[float:[0-9a-zA-Z_]+]] = OpTypeFloat 32
// CHECK-DAG: %[[v4float:[0-9a-zA-Z_]+]] = OpTypeVector %[[float]] 4
// CHECK:     %[[__original_id_16:[0-9]+]] = OpUndef %[[v4float]]
// CHECK:     %[[__original_id_23:[0-9]+]] = OpLoad %[[float]]
// CHECK:     %[[__original_id_24:[0-9]+]] = OpLoad %[[v4float]]
// CHECK:     %[[__original_id_25:[0-9]+]] = OpCompositeInsert %[[v4float]] %[[__original_id_23]] %[[__original_id_16]] 0
// CHECK:     %[[__original_id_26:[0-9]+]] = OpVectorShuffle %[[v4float]] %[[__original_id_25]] %[[__original_id_16]] 0 0 0 0
// CHECK:     %[[__original_id_27:[0-9]+]] = OpExtInst %[[v4float]] %[[__original_id_1]] Step %[[__original_id_26]] %[[__original_id_24]]
// CHECK:     OpStore {{.*}} %[[__original_id_27]]

kernel void __attribute__((reqd_work_group_size(1, 1, 1))) foo(global float* a, global float4* b)
{
    *b = step(*a, *b);
}

