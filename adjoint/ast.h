#include <string>

typedef struct {
  unsigned int j;
  bool v; // varied
  std::string p; // primal
  std::string f; // augmented primal
  std::string s; // assignment-level sac
  std::string a; // adjoint 
} astNode_t;

#define YYSTYPE astNode_t
