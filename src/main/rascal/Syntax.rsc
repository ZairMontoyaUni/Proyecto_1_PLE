module Syntax

// ---------- Layout ----------
lexical WS = [\ \t\r];
layout Layout = WS* !>> [\ \t\r];
lexical NL = "\n";

// ---------- Átomos ----------
lexical Identifier = ([a-z][a-z0-9\-]*) \ KW;
keyword KW = "function" | "do" | "end" | "if" | "then" | "elseif" | "else"
           | "for" | "from" | "to" | "cond" | "in" | "with" | "data" | "yielding"
           | "true" | "false";

lexical INT    = [0-9]+;
lexical REAL   = [0-9]+ "." [0-9]+;
lexical CHAR   = "\"" [a-z] "\"";
lexical STRING = "\"" ![\"]* "\"";

// ---------- Tokens ----------
lexical COMMA  = ",";
lexical ASSIGN = "=";
lexical ARROW  = "-\>";
lexical LPAREN = "(";
lexical RPAREN = ")";
lexical DOLLAR = "$";

// ---------- Raíz ----------
start syntax Program = program: Module+ modules;

// ---------- Módulos ----------
syntax Module
  = funMod: FunctionModule
  | dataMod: DataModule
  ;

syntax DataModule
  = dataDecl: "data" Identifier name "with" NL* DataBody body "end"
  ;

syntax DataBody
  = empty: ()
  ;

// ---------- Funciones ----------
syntax FunctionModule
  = function: "function"
              Identifier fName
              LPAREN {Identifier COMMA}* params RPAREN
              "do" NL* Expressions body "end"
  ;

// ---------- Bloques/Expresiones ----------
syntax Expressions
  = expressions: {Expression NL+}+ exprs NL*
  ;

syntax Expression
  = assign   : Assignment
  | ife      : IfExpr
  | cone     : CondExpr
  | forRange : ForExpr
  | call     : Call
  > lit      : Value
  | var      : Identifier
  ;

syntax Assignment
  = assign: {Identifier COMMA}+ ids ASSIGN Expression e
  ;

syntax IfExpr
  = ifExpr: "if" Expression cond "then" NL* Expressions tBody
    ElseIfBranch* elseifs
    "else" NL* Expressions fBody
    "end"
  ;

syntax ElseIfBranch
  = elseif: "elseif" Expression eCond "then" NL* Expressions eBody
  ;

syntax CondExpr
  = condExpr: "cond" Identifier tag "do" NL*
    CondBranch+ branches
    "end"
  ;

syntax CondBranch
  = branch: Expression guard ARROW NL* Expressions body NL+
  ;

syntax ForExpr
  = forExpr: "for" Identifier v "from" Expression lo "to" Expression hi
    "do" NL* Expressions body "end"
  ;

syntax Call
  = call1: Identifier fname LPAREN Args? args RPAREN
  | call2: Identifier owner DOLLAR Identifier fname LPAREN Args? args RPAREN
  ;

syntax Args = args: {Expression COMMA}+ exprs;

// ---------- Literales ----------
syntax Value
  = intLit    : INT
  | realLit   : REAL
  | boolTrue  : "true"
  | boolFalse : "false"
  | charLit   : CHAR
  | strLit    : STRING
  ;