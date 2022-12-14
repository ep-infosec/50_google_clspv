// RUN: clspv %target -int8 -cluster-pod-kernel-args %s -o %t.spv
// RUN: clspv-reflection %t.spv -o %t.map
// RUN: FileCheck %s < %t.map -check-prefix=MAP
// RUN: spirv-val --target-env vulkan1.0 %t.spv

// MAP: kernel,test,arg,buf,argOrdinal,0,descriptorSet,0,binding,0,offset,0,argKind,buffer
// MAP: kernel,test,arg,val,argOrdinal,1,offset,0,argKind,pod_pushconstant,argSize,1

kernel void test(global char *buf, char val)
{
    int tid = get_global_id(0);
    buf[tid] += val;
}

