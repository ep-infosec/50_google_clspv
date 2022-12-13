// RUN: clspv %target %s -w -constant-args-ubo -verify -inline-entry-points

struct dt {
  int x;
  int y[4]; //expected-note{{here}}
} __attribute((aligned(32)));

__kernel void foo(__constant struct dt* c) { } //expected-error{{in an UBO, arrays must be aligned to their element alignment, rounded up to a multiple of 16}}

