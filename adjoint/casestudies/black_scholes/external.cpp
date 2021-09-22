#include <pybind11/pybind11.h>
#include <pybind11/stl.h>
#include <iostream>
#include <vector>
#include <random>
#include <cmath>
using namespace std;

vector<float> mc(vector<float> x, vector<float> y, int m) {
  const float &s0=x[0], &r=x[1], &sigma=x[2];
  default_random_engine g;
  normal_distribution<float> d(0.0,1.0);
  float c=r-0.5*sigma*sigma;
  for (int i=0;i<m;i++) 
    y[i]=s0*exp(c+sigma*d(g));
  return y;
}

vector<float> t_mc(vector<float> x, vector<float> t_x, vector<float> y, vector<float> t_y, int m) {
  const float &s0=x[0], &r=x[1], &sigma=x[2];
  const float &t_s0=t_x[0], &t_r=t_x[1], &t_sigma=t_x[2];
  default_random_engine g;
  normal_distribution<float> d(0.0,1.0);
  float t_c=t_r-sigma*t_sigma;
  float c=r-0.5*sigma*sigma;
  for (int i=0;i<m;i++) {
    float z=d(g);
    t_y[i]=t_s0*exp(c+sigma*z)+s0*exp(c+sigma*z)*t_c
          +s0*exp(c+sigma*z)*z*t_sigma;
    y[i]=s0*exp(c+sigma*z);
  }
  return t_y;
}

vector<float> a_mc(
    vector<float> x,
    vector<float> a_x,
    vector<float> y,
    vector<float> a_y,
    int m
  ) {
  const float &s0=x[0], &r=x[1], &sigma=x[2];
  default_random_engine g;
  normal_distribution<float> d(0.0,1.0);
  vector<float> Z(m);
  float c=r-0.5*sigma*sigma;
  for (int i=0;i<m;i++) {
    Z[i]=d(g);
    y[i]=s0*exp(c+sigma*Z[i]);
  }
  float &a_s0=a_x[0], &a_r=a_x[1], &a_sigma=a_x[2];
  float a_c=0;
  for (int i=0;i<m;i++) {
    float ex=exp(c+sigma*Z[i]);
    a_s0+=ex*a_y[i]; 
    a_c+=s0*ex*a_y[i]; 
    a_sigma+=s0*ex*Z[i]*a_y[i];
    a_y[i]=0;
  }
  a_r+=a_c; a_sigma-=sigma*a_c; a_c=0;
  return a_x;
}

PYBIND11_MODULE(external, M) {
  M.doc() = "Basic Black Scholes by Monte Carlo";
  M.def("mc", &mc, "primal");
  M.def("t_mc", &t_mc, "tangent");
  M.def("a_mc", &a_mc, "adjoint");
}




