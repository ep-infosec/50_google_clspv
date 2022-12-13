
; RUN: clspv-opt --passes=replace-opencl-builtin %s -o %t.ll
; RUN: FileCheck %s < %t.ll

; AUTO-GENERATED TEST FILE
; This test was generated by mad_sat_test_gen.cpp.
; Please modify the that file and regenerate the tests to make changes.

target datalayout = "e-p:32:32-i64:64-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024"
target triple = "spir-unknown-unknown"

define <2 x i32> @mad_sat_int2(<2 x i32> %a, <2 x i32> %b, <2 x i32> %c) {
entry:
 %call = call <2 x i32> @_Z7mad_satDv2_iS_S_(<2 x i32> %a, <2 x i32> %b, <2 x i32> %c)
 ret <2 x i32> %call
}

declare <2 x i32> @_Z7mad_satDv2_iS_S_(<2 x i32>, <2 x i32>, <2 x i32>)

; CHECK: [[mul_ext:%[a-zA-Z0-9_.]+]] = call { <2 x i32>, <2 x i32> } @_Z8spirv.op.152.{{.*}}(i32 152, <2 x i32> %a, <2 x i32> %b)
; CHECK: [[mul_lo:%[a-zA-Z0-9_.]+]] = extractvalue { <2 x i32>, <2 x i32> } [[mul_ext]], 0
; CHECK: [[mul_hi:%[a-zA-Z0-9_.]+]] = extractvalue { <2 x i32>, <2 x i32> } [[mul_ext]], 1
; CHECK: [[add:%[a-zA-Z0-9_.]+]] = add <2 x i32> [[mul_lo]], %c
; CHECK: [[xor:%[a-zA-Z0-9_.]+]] = xor <2 x i32> %a, %b
; CHECK: [[same_sign:%[a-zA-Z0-9_.]+]] = icmp sgt <2 x i32> [[xor]], <i32 -1, i32 -1>
; CHECK: [[diff_sign:%[a-zA-Z0-9_.]+]] = xor <2 x i1> [[same_sign]], <i1 true, i1 true>
; CHECK: [[hi_eq_0:%[a-zA-Z0-9_.]+]] = icmp eq <2 x i32> [[mul_hi]], zeroinitializer
; CHECK: [[hi_ne_0:%[a-zA-Z0-9_.]+]] = xor <2 x i1> [[hi_eq_0]], <i1 true, i1 true>
; CHECK: [[lo_ge_max:%[a-zA-Z0-9_.]+]] = icmp uge <2 x i32> [[mul_lo]], <i32 2147483647, i32 2147483647>
; CHECK: [[c_gt_0:%[a-zA-Z0-9_.]+]] = icmp sgt <2 x i32> %c, zeroinitializer
; CHECK: [[c_lt_0:%[a-zA-Z0-9_.]+]] = icmp slt <2 x i32> %c, zeroinitializer
; CHECK: [[add_gt_max:%[a-zA-Z0-9_.]+]] = icmp ugt <2 x i32> [[add]], <i32 2147483647, i32 2147483647>
; CHECK: [[hi_eq_m1:%[a-zA-Z0-9_.]+]] = icmp eq <2 x i32> [[mul_hi]], <i32 -1, i32 -1>
; CHECK: [[hi_ne_m1:%[a-zA-Z0-9_.]+]] = xor <2 x i1> [[hi_eq_m1]], <i1 true, i1 true>
; CHECK: [[lo_le_max_plus_1:%[a-zA-Z0-9_.]+]] = icmp ule <2 x i32> [[mul_lo]], <i32 -2147483648, i32 -2147483648>
; CHECK: [[max_sub_lo:%[a-zA-Z0-9_.]+]] = sub <2 x i32> <i32 2147483647, i32 2147483647>, [[mul_lo]]
; CHECK: [[c_lt_max_sub_lo:%[a-zA-Z0-9_.]+]] = icmp ult <2 x i32> %c, [[max_sub_lo]]
; CHECK: [[max_clamp1:%[a-zA-Z0-9_.]+]] = and <2 x i1> [[same_sign]], [[hi_ne_0]]
; CHECK: [[tmp:%[a-zA-Z0-9_.]+]] = or <2 x i1> [[c_gt_0]], [[add_gt_max]]
; CHECK: [[tmp2:%[a-zA-Z0-9_.]+]] = and <2 x i1> [[hi_eq_0]], [[lo_ge_max]]
; CHECK: [[max_clamp2:%[a-zA-Z0-9_.]+]] = and <2 x i1> [[tmp2]], [[tmp]]
; CHECK: [[max_clamp:%[a-zA-Z0-9_.]+]] = or <2 x i1> [[max_clamp1]], [[max_clamp2]]
; CHECK: [[min_clamp1:%[a-zA-Z0-9_.]+]] = and <2 x i1> [[diff_sign]], [[hi_ne_m1]]
; CHECK: [[tmp:%[a-zA-Z0-9_.]+]] = or <2 x i1> [[c_lt_0]], [[c_lt_max_sub_lo]]
; CHECK: [[tmp2:%[a-zA-Z0-9_.]+]] = and <2 x i1> [[hi_eq_m1]], [[lo_le_max_plus_1]]
; CHECK: [[min_clamp2:%[a-zA-Z0-9_.]+]] = and <2 x i1> [[tmp2]], [[tmp]]
; CHECK: [[min_clamp:%[a-zA-Z0-9_.]+]] = or <2 x i1> [[min_clamp1]], [[min_clamp2]]
; CHECK: [[sel1:%[a-zA-Z0-9_.]+]] = select <2 x i1> [[min_clamp]], <2 x i32> <i32 -2147483648, i32 -2147483648>, <2 x i32> [[add]]
; CHECK: [[sel2:%[a-zA-Z0-9_.]+]] = select <2 x i1> [[max_clamp]], <2 x i32> <i32 2147483647, i32 2147483647>, <2 x i32> [[sel1]]
; CHECK: ret <2 x i32> [[sel2]]