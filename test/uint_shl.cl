// RUN: clspv %target %s -o %t.spv
// RUN: spirv-dis -o %t2.spvasm %t.spv
// RUN: FileCheck %s < %t2.spvasm
// RUN: spirv-val --target-env vulkan1.0 %t.spv

// CHECK-DAG: %[[UINT_TYPE_ID:[a-zA-Z0-9_]*]] = OpTypeInt 32 0
// CHECK-DAG: %[[CONSTANT_31_ID:[a-zA-Z0-9_]*]] = OpConstant %[[UINT_TYPE_ID]] 31
void kernel __attribute__((reqd_work_group_size(1, 1, 1))) foo(global uint* a, global uint* b)
{
// CHECK: %[[LOADB_ID:[a-zA-Z0-9_]*]] = OpLoad %[[UINT_TYPE_ID]]
// CHECK: %[[LOADA_ID:[a-zA-Z0-9_]*]] = OpLoad %[[UINT_TYPE_ID]]
// CHECK: %[[OP_AND_ID:[a-zA-Z0-9_]*]] = OpBitwiseAnd %[[UINT_TYPE_ID]] %[[LOADB_ID]] %[[CONSTANT_31_ID]]
// CHECK: %[[OP_ID:[a-zA-Z0-9_]*]] = OpShiftLeftLogical %[[UINT_TYPE_ID]] %[[LOADA_ID]] %[[OP_AND_ID]]
// CHECK: OpStore {{.*}} %[[OP_ID]]
  *a <<= *b;
}
