// RUN: clspv %target --long-vector %s -o %t.spv
// RUN: spirv-dis %t.spv -o - | FileCheck %s
// RUN: spirv-val --target-env vulkan1.0 %t.spv

// Check that fmin for float8 is supported.

// CHECK: [[GLSL:%[0-9a-zA-Z_]+]] = OpExtInstImport "GLSL.std.450"
//
// CHECK: [[FLOAT:%[0-9a-zA-Z_]+]] = OpTypeFloat 32
//
// CHECK: OpExtInst [[FLOAT]] [[GLSL]] NMin
// CHECK: OpExtInst [[FLOAT]] [[GLSL]] NMin
// CHECK: OpExtInst [[FLOAT]] [[GLSL]] NMin
// CHECK: OpExtInst [[FLOAT]] [[GLSL]] NMin
// CHECK: OpExtInst [[FLOAT]] [[GLSL]] NMin
// CHECK: OpExtInst [[FLOAT]] [[GLSL]] NMin
// CHECK: OpExtInst [[FLOAT]] [[GLSL]] NMin
// CHECK: OpExtInst [[FLOAT]] [[GLSL]] NMin

void kernel test(global float8 *in, global float8 *out) {
  *out = fmin(in[0], in[1]);
}
