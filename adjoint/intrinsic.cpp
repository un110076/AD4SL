#include <pybind11/pybind11.h>
#include <pybind11/stl.h>
#include <cmath>

float gt0(float x) { return fmax(x,0.0); }

float d_gt0_cfd(float x) {
  const float h=1e-3;
  if (x<-h) 
    return 0;
  else if (x>h)
    return 1;
  else
    return (gt0(x+h)-gt0(x-h))/(2*h);
}

float d_gt0_sig(float x) {
  const float h=1e-3;
  if (x<-h) 
    return 0;
  else if (x>h)
    return 1;
  else
    return 1./(1.+exp(-(x)/h));
}

float d_gt0(float x) {
  return d_gt0_sig(x);
  // return d_gt0_cfd(x);
}
  
PYBIND11_MODULE(intrinsic, M) {
  M.doc() = "smooth intrinsics";
  M.def("gt0", &gt0, "primal");
  M.def("d_gt0", &d_gt0, "derivative");
}




