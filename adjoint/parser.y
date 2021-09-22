%{
#include "ast.h"
#include <iostream>
#include <cassert>
using namespace std;

extern int lexinit(FILE*);
extern int yylex();
int yyerror(char*);

unsigned int i;
unsigned int ld;
unsigned int j, j_max;
const string sac_var="v";
const string adj="a_";
bool notbr=false, noprimal=false;

string I(unsigned int i) { 
  string tabs="\n";
  for (int j=0;j<i;j++) tabs+='\t';
  return tabs;
}

string V(unsigned int i) { 
  string o=sac_var+"["+to_string(i)+']';
  return o;
}

string A(unsigned int i) { 
  string o=adj+sac_var+"["+to_string(i)+']';
  return o;
}

%}

%token FROM IMPORT DEF RETURN IF ELSE WHILE FOR IN RANGE NAME INTEGER FLOAT EXP GT0 PRAGMA NOTBR NOPRIMAL

%left '+' '-'
%left '*' '/'

%%

script : imports subprograms 
  {
    cout << $1.p  << "from tbr import *" << "\n\n"
         << $2.p << '\n' << $2.a << endl;
  }
  ;

imports : import
  | import imports
  { 
    $$.p=$1.p+$2.p;
  }
  ;

import : FROM NAME IMPORT '*'
  {
    $$.p="from "+$2.p+" import *\n";
  }
  ;

subprograms : subprogram
  | subprogram subprograms
  {
    $$.p=$1.p+'\n'+$2.p;
    $$.a=$1.a+'\n'+$2.a;
  }
  ;

subprogram : DEF NAME '(' arguments ')' '{' { i=1; j_max=0; ld=0; } declarations_or_statements RETURN argument '}' 
  {
    $$.p="def "+$2.p+'('+$4.p+") : "
        +$8.p+I(i)+"return "+$10.p+'\n';
    $$.a="def "+adj+$2.p+'('+$4.a+") : "
        +I(1)+sac_var+"=[0.0]*"+to_string(j_max)
        +I(1)+adj+sac_var+"=[0.0]*"+to_string(j_max)
        +$8.f+$8.a+I(1)+"return "+$4.s+'\n';
  }
  ;

arguments : argument ',' argument
  {
    $$.p=$1.p+','+$3.p;
    $$.s=adj+$1.p;
    $$.a=$1.p+','+adj+$1.p+','+$3.p+','+adj+$3.p;
  }
  | argument ',' argument ',' argument
  {
    $$.p=$1.p+','+$3.p+','+$5.p;
    $$.s=adj+$1.p;
    $$.a=$1.p+','+adj+$1.p+','+$3.p+','+adj+$3.p+','+$5.p;
  }
  | argument ',' argument ',' argument ',' argument
  {
    $$.p=$1.p+','+$3.p+','+$5.p+','+$7.p;
    $$.s=adj+$1.p;
    $$.a=$1.p+','+adj+$1.p+','+$3.p+','+adj+$3.p+','+$5.p+','+$7.p;
  }
  ;

argument : NAME ;

declarations_or_statements : declaration_or_statement 
  | declaration_or_statement declarations_or_statements
  {
    $$.p=$1.p+$2.p;
    $$.f=$1.f+$2.f;
    $$.a=$2.a+$1.a;
  }
  ;

statements : statement 
  | statement statements
  {
    $$.p=$1.p+$2.p;
    $$.f=$1.f+$2.f;
    $$.a=$2.a+$1.a;
  }
  ;

statement : pragma | assignment | if | while | for | call ;

declaration_or_statement : declaration | statement ;

pragma : PRAGMA NOTBR 
  {
    $$.p=""; $$.f=""; $$.a=""; notbr=true;
  }
  | PRAGMA NOPRIMAL
  {
    $$.p=""; $$.f=""; $$.a=""; noprimal=true;
  }
  ;

declaration : NAME '=' '[' FLOAT ']' '*' INTEGER
  {
    $$.p=I(i)+$1.p+"=["+$4.p+"]*"+$7.p;
    $$.f=$$.p+I(i)+adj+$1.p+"=["+$4.p+"]*"+$7.p;
  }
  | NAME '=' '[' FLOAT ']' '*' NAME
  {
    $$.p=I(i)+$1.p+"=["+$4.p+"]*"+$7.p;
    $$.f=$$.p+I(i)+adj+$1.p+"=["+$4.p+"]*"+$7.p;
  }
  ;

assignment : variable '=' { j=0; } expression 
  {
    assert($1.v||!$4.v);
    $$.p=I(i)+$1.p+'='+$4.p;
    if (!notbr&&!noprimal) {
      $$.f=I(i)+"push_s("+$1.p+')';
      $$.a=I(i)+$1.p+"=pop_s()"; 
    } else { $$.f=""; $$.a=""; notbr=false; }
    if (!noprimal) $$.f+=I(i)+$1.p+'='+$4.p; else noprimal=false; 
    if ($$.v)
      $$.a+=$4.s
          +I(i)+A($4.j)+'='+A($4.j)+'+'+adj+$1.p
          +I(i)+adj+$1.p+"=0.0"
          +$4.a;
  }
  ;

expression : variable
  {
    $$.j=j++; j_max=max(j_max,j);
    $$.v=$1.v;
    $$.p=$1.p; 
    $$.s=I(i)+V($$.j)+'='+$1.p;
    $$.a="";
    if ($1.v) $$.a+=I(i)+adj+$1.p+'='+adj+$1.p+'+'+A($$.j);
    $$.a+=I(i)+A($$.j)+"=0.0";
  }
  | passive_value
  {
    $$.j=j++; j_max=max(j_max,j);
    $$.v=false;
    $$.p=$1.p; 
    $$.s=I(i)+V($$.j)+'='+$1.p;
    $$.a=I(i)+A($$.j)+"=0.0";
  }
  | expression '+' expression
  {
    $$.j=j++; j_max=max(j_max,j);
    $$.v=$1.v||$3.v;
    $$.p=$1.p+'+'+$3.p;
    $$.s=$1.s+$3.s+I(i)+V($$.j)+'='+V($1.j)+'+'+V($3.j);
    $$.a="";
    if ($1.v) $$.a+=I(i)+A($1.j)+'='+A($1.j)+'+'+A($$.j);
    if ($3.v) $$.a+=I(i)+A($3.j)+'='+A($3.j)+'+'+A($$.j);
    $$.a+=I(i)+A($$.j)+"=0.0";
    if ($$.v) $$.a+=$3.a+$1.a;
  }
  | expression '-' expression
  {
    $$.j=j++; j_max=max(j_max,j);
    $$.v=$1.v||$3.v;
    $$.p=$1.p+'-'+$3.p;
    $$.s=$1.s+$3.s+I(i)+V($$.j)+'='+V($1.j)+'-'+V($3.j);
    $$.a="";
    if ($1.v) $$.a+=I(i)+A($1.j)+'='+A($1.j)+'+'+A($$.j);
    if ($3.v) $$.a+=I(i)+A($3.j)+'='+A($3.j)+'-'+A($$.j);
    $$.a+=I(i)+A($$.j)+"=0.0";
    if ($$.v) $$.a+=$3.a+$1.a;
  }
  | expression '*' expression
  {
    $$.j=j++; j_max=max(j_max,j);
    $$.v=$1.v||$3.v;
    $$.p=$1.p+'*'+$3.p;
    $$.s=$1.s+$3.s+I(i)+V($$.j)+'='+V($1.j)+'*'+V($3.j);
    $$.a="";
    if ($1.v) $$.a+=I(i)+A($1.j)+'='+A($1.j)+'+'+V($3.j)+'*'+A($$.j);
    if ($3.v) $$.a+=I(i)+A($3.j)+'='+A($3.j)+'+'+V($1.j)+'*'+A($$.j);
    $$.a+=I(i)+A($$.j)+"=0.0";
    if ($$.v) $$.a+=$3.a+$1.a;
  }
  | expression '/' expression
  {
    $$.j=j++; j_max=max(j_max,j);
    $$.v=$1.v||$3.v;
    $$.p=$1.p+'/'+$3.p;
    $$.s=$1.s+$3.s+I(i)+V($$.j)+'='+V($1.j)+'/'+V($3.j);
    $$.a="";
    if ($1.v) $$.a+=I(i)+A($1.j)+'='+A($1.j)+'+'+A($$.j)+'/'+V($3.j);
    if ($3.v) $$.a+=I(i)+A($3.j)+'='+A($3.j)+'-'+V($1.j)+'*'+A($$.j)+"/("+V($3.j)+'*'+V($3.j)+')';
    $$.a+=I(i)+A($$.j)+"=0.0";
    if ($$.v) $$.a+=$3.a+$1.a;
  }
  | EXP '(' expression ')'
  {
    $$.j=j++; j_max=max(j_max,j);
    $$.v=$3.v;
    $$.p="exp("+$3.p+')';
    $$.s=$3.s+I(i)+V($$.j)+"=exp("+V($3.j)+')';
    $$.a="";
    if ($3.v) $$.a+=I(i)+A($3.j)+'='+A($3.j)+'+'+V($$.j)+'*'+A($$.j);
    $$.a+=I(i)+A($$.j)+"=0.0";
    if ($$.v) $$.a+=$3.a;
  }
  | GT0 '(' expression ')'
  {
    $$.j=j++; j_max=max(j_max,j);
    $$.v=$3.v;
    $$.p="gt0("+$3.p+')';
    $$.s=$3.s+I(i)+V($$.j)+"=gt0("+V($3.j)+')';
    $$.a="";
    if ($3.v) $$.a+=I(i)+A($3.j)+'='+A($3.j)+"+d_gt0("+V($3.j)+")*"+A($$.j);
    $$.a+=I(i)+A($$.j)+"=0.0";
    if ($$.v) $$.a+=$3.a;
  }
  | '-' expression
  {
    $$.j=j++; j_max=max(j_max,j);
    $$.v=$2.v;
    $$.p='-'+$2.p;
    $$.s=$2.s+I(i)+V($$.j)+"=-"+V($2.j);
    $$.a="";
    if ($2.v) $$.a+=I(i)+A($2.j)+'='+A($2.j)+'-'+A($$.j);
    $$.a+=I(i)+A($$.j)+"=0.0";
    if ($$.v) $$.a+=$2.a;
  }
  | '(' expression ')'
  {
    $$.j=j++; j_max=max(j_max,j);
    $$.v=$2.v;
    $$.p='('+$2.p+')';
    $$.s=$2.s+I(i)+V($$.j)+"="+V($2.j);
    $$.a="";
    if ($2.v) $$.a+=I(i)+A($2.j)+'='+A($2.j)+'+'+A($$.j);
    $$.a+=I(i)+A($$.j)+"=0.0";
    if ($$.v) $$.a+=$2.a;
  }
  ;

passive_value : index | FLOAT ;

index : NAME | INTEGER ;

variable : NAME '[' index ']'
  {
    $$.v=$1.v;
    $$.p=$1.p+'['+$3.p+']';
    $$.a=adj+$1.p+'['+$3.p+']';
  }
  ;

if : IF condition '{' { i++; } statements '}' ELSE '{' statements '}' 
  {
    assert(!$2.v);
    i--;
    $$.p=I(i)+"if "+$2.p+" :"+$5.p+I(i)+"else :"+$9.p;
    $$.f=I(i)+"if "+$2.p+" :"+$5.f+I(i+1)+"push_i(1)"+I(i)+"else :"+$9.f+I(i+1)+"push_i(0)";
    $$.a=I(i)+"if pop_i() :"+$5.a+I(i)+"else :"+$9.a;
  }
  ;

condition : variable '<' variable
  {
    $$.v=$1.v||$3.v;
    $$.p=$1.p+"<"+$3.p;
  }
  ;

while : WHILE condition '{' { ld++; i++; } statements '}' 
  {
    assert(!$2.v);
    i--; ld--;
    $$.p=I(i)+"while "+$2.p+" :"+$5.p;
    $$.f=I(i)+"Lc"+to_string(ld)+"=0"+I(i)+"while "+$2.p+" :"+$5.f+I(i+1)+"Lc"+to_string(ld)+"=Lc"+to_string(ld)+"+1"+I(i)+"push_i(Lc"+to_string(ld)+')';
    $$.a=I(i)+"Lc"+to_string(ld)+"=pop_i()"+
I(i)+"for LLc"+to_string(ld)+" in range("+"Lc"+to_string(ld)+") :"+$5.a;
  }
  ;


for : FOR NAME IN range '{' { i++; } statements '}' 
  {
    i--;
    $$.p=I(i)+"for "+$2.p+" in "+$4.p+':'+$7.p;
    $$.f=I(i)+"for "+$2.p+" in "+$4.p+':'+$7.f;
    $$.a=I(i)+"for "+$2.p+" in reversed("+$4.p+") :"+$7.a;
  }
  ;

range : RANGE '(' index ')'
  {
    $$.p="range("+$3.p+") ";
  }
  ;

call : NAME '=' NAME '(' arguments ')' 
  {
    assert($1.v||!$3.v);
    $$.p=I(i)+$1.p+'='+$3.p+'('+$5.p+") ";
    if (!notbr&&!noprimal) {
      $$.f=I(i)+"push_v("+$1.p+')';
      $$.a=I(i)+$1.p+"=pop_v()"; 
    } else { $$.f=""; $$.a=""; notbr=false; }
    if (!noprimal) $$.f+=I(i)+$1.p+'='+$3.p+'('+$5.p+") "; else noprimal=false; 
    $$.a+=I(i)+$5.s+'='+adj+$3.p+'('+$5.a+')';
  }
  ;

%%

int yyerror(char* msg) {
  cerr << "ERROR: " << msg << endl;
  return -1;
}

int main(int argc, char* argv[]) {
  FILE *source_file=fopen(argv[1],"r");
  lexinit(source_file); 
  yyparse();
  fclose(source_file);
  return 0;
}

