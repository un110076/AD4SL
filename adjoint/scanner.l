%{ 
#include "ast.h"
#include "parser.tab.h"

%}

whitespace      [ \t\n]+
lcletter	[a-z]
ucletter	[A-Z]
letter		{lcletter}|{ucletter}
digit		[0-9]
integer		{digit}{digit}*
float		{digit}+[.]{digit}*
aname		{lcletter}(_|{letter}|{digit})*
pname		{ucletter}(_|{letter}|{digit})*

%%

{whitespace} 	{ }
"#pragma"	{ return PRAGMA; } 
"notbr"	 	{ return NOTBR; } 
"noprimal"	{ return NOPRIMAL; } 
"from"		{ return FROM; } 
"import"	{ return IMPORT; } 
"def"		{ return DEF; } 
"return"	{ return RETURN; } 
"if"		{ return IF; } 
"else"		{ return ELSE; } 
"while"		{ return WHILE; } 
"for"		{ return FOR; } 
"in"		{ return IN; } 
"range"		{ return RANGE; } 
"exp"	 	{ return EXP; } 
"gt0"		{ return GT0; } 
{aname}		{ yylval.p=yytext; yylval.v=true; return NAME; }
{pname}		{ yylval.p=yytext; yylval.v=false; return NAME; }
{integer} 	{ yylval.p=yytext; return INTEGER; }
{float} 	{ yylval.p=yytext; return FLOAT; }
. 		{ return yytext[0]; }

%%

void lexinit(FILE *source) { yyin=source; }
