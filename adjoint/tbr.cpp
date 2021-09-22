#include <pybind11/pybind11.h>
#include <pybind11/stl.h>
#include <vector>
#include <stack>

static std::stack<float> tbr_s;

void push_s(float x) {
  tbr_s.push(x);
}

float pop_s() {
  float r=tbr_s.top(); tbr_s.pop(); return r;
}

static std::stack<std::vector<float>> tbr_v;

void push_v(std::vector<float> x) {
  tbr_v.push(x);
}

std::vector<float> pop_v() {
  std::vector<float> r=tbr_v.top(); tbr_v.pop(); return r;
}

static std::stack<int> tbr_i;

void push_i(int x) {
  tbr_i.push(x);
}

int pop_i() {
  int r=tbr_i.top(); tbr_i.pop(); return r;
}

PYBIND11_MODULE(tbr, m) {
  m.doc() = "support for recording in adjoint Python scripts"; 
  m.def("push_s", &push_s, "push required float value");
  m.def("pop_s", &pop_s, "pop required float value");
  m.def("push_v", &push_v, "push checkpoint");
  m.def("pop_v", &pop_v, "pop checkpoint");
  m.def("push_i", &push_i, "push loop iteration counter");
  m.def("pop_i", &pop_i, "pop loop iteration counter");
}
