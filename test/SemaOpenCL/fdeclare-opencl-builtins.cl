// RUN: %clang_cc1 %s -triple spir -verify -pedantic -fsyntax-only -cl-std=CL2.0 -fdeclare-opencl-builtins
// expected-no-diagnostics

// Test the -fdeclare-opencl-builtins option.

typedef char char2 __attribute__((ext_vector_type(2)));
typedef char char4 __attribute__((ext_vector_type(4)));
typedef float float4 __attribute__((ext_vector_type(4)));
typedef half half4 __attribute__((ext_vector_type(4)));
typedef int int2 __attribute__((ext_vector_type(2)));
typedef int int4 __attribute__((ext_vector_type(4)));
typedef long long2 __attribute__((ext_vector_type(2)));
typedef unsigned int uint;
typedef __SIZE_TYPE__ size_t;

kernel void test_pointers(volatile global void *global_p, global const int4 *a) {
  int i;
  unsigned int ui;

  prefetch(a, 2);

  atom_add((volatile __global int *)global_p, i);
  atom_cmpxchg((volatile __global unsigned int *)global_p, ui, ui);
}

kernel void basic_conversion() {
  double d;
  float f;
  char2 c2;
  long2 l2;
  float4 f4;
  int4 i4;

  f = convert_float(d);
  d = convert_double_sat_rtp(f);
  l2 = convert_long2_rtz(c2);
  i4 = convert_int4_sat(f4);
}

char4 test_int(char c, char4 c4) {
  char m = max(c, c);
  char4 m4 = max(c4, c4);
  return max(c4, c);
}

kernel void basic_image_readonly(read_only image2d_t image_read_only_image2d) {
  int2 i2;
  sampler_t sampler;
  half4 res;
  float4 resf;

  resf = read_imagef(image_read_only_image2d, i2);
  res = read_imageh(image_read_only_image2d, i2);
  res = read_imageh(image_read_only_image2d, sampler, i2);

  int imgWidth = get_image_width(image_read_only_image2d);
}

kernel void basic_image_readwrite(read_write image3d_t image_read_write_image3d) {
  half4 h4;
  int4 i4;

  write_imageh(image_read_write_image3d, i4, h4);

  int imgDepth = get_image_depth(image_read_write_image3d);
}

kernel void basic_image_writeonly(write_only image1d_buffer_t image_write_only_image1d_buffer) {
  half4 h4;
  float4 f4;
  int i;

  write_imagef(image_write_only_image1d_buffer, i, f4);
  write_imageh(image_write_only_image1d_buffer, i, h4);
}

kernel void basic_subgroup(global uint *out) {
  out[0] = get_sub_group_size();
}
