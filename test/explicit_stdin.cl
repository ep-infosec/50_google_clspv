// RUN: clspv %target - -o %t.spv < %s
// RUN: spirv-dis -o %t2.spvasm %t.spv
// RUN: FileCheck %s < %t2.spvasm
// RUN: spirv-val --target-env vulkan1.0 %t.spv

// CHECK: OpCapability Shader
// CHECK: OpMemoryModel Logical GLSL450
// CHECK: OpEntryPoint GLCompute %[[FOO_ID:[a-zA-Z0-9_]*]] "foo"
// CHECK: OpExecutionMode %[[FOO_ID]] LocalSize 1 1 1
// CHECK-DAG: %[[VOID_TYPE_ID:[a-zA-Z0-9_]*]] = OpTypeVoid
// CHECK-DAG: %[[FOO_TYPE_ID:[a-zA-Z0-9_]*]] = OpTypeFunction %[[VOID_TYPE_ID]]

// CHECK: %[[FOO_ID]] = OpFunction %[[VOID_TYPE_ID]] Pure|Const %[[FOO_TYPE_ID]]
void kernel __attribute__((reqd_work_group_size(1, 1, 1))) foo()
// CHECK: %[[LABEL_ID:[a-zA-Z0-9_]*]] = OpLabel
{
// CHECK: OpReturn
}
// CHECK: OpFunctionEnd
