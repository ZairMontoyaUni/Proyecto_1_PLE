module Syntax

// ---------- Layout ----------
lexical WS = [\ \t\r];
layout Layout = WS* !>> [\n];
lexical NL = "\n";


// ---------- Átomos ----------
lexical Identifier = [a-z][a-z0-9\-]*;
keyword KW = "function" | "do" | "end" | "if" | "then" | "elseif" | "else"
           | "for" | "from" | "to" | "cond" | "in" | "with" | "data" | "yielding"
           | "true" | "false";

lexical INT    = [0-9]+;
lexical REAL   = [0-9]+ "." [0-9]+;
lexical CHAR = "\"" [a-z] "\"";
lexical STRING = "\"" [CHAR]* "\"";

// ---------- Raíz ----------
start syntax Program = program: Module+;

// ---------- Módulos ----------
syntax Module
  = funMod: FunctionModule
  | dataMod: DataModule
  ;

syntax DataModule
  = dataDecl: "data" Identifier "with" NL* DataBody "end"
  ;

syntax DataBody
  = /* completar en incremento 2 (struct/tuple/sequence/iterators) */
  ;

// ---------- Funciones ----------
syntax FunctionModule
  = function: "function"
              fName: Identifier
              "(" params: {Identifier ","}* ")"
              "do" NL* body: Expressions "end"
  ;


syntax Params = params: Identifier (COMMA Identifier)* ;

// ---------- Bloques/Expresiones ----------
syntax Expressions
  = expressions: Expression (NL+ Expression)* NL*
  ;

syntax Expression
  = assign   : Assignment
  | ife      : IfExpr
  | cone     : CondExpr
  | forRange : ForExpr
  | call     : Call
  | lit      : Value
  | var      : Identifier
  ;

syntax Assignment
  = ids:Identifier (COMMA Identifier)* ASSIGN e:Expression
  ;

syntax IfExpr
  = "if" cond:Expression "then" NL* tBody:Expressions
    ( "elseif" eCond:Expression "then" NL* eBody:Expressions )*
    "else" NL* fBody:Expressions
    "end"
  ;

syntax CondExpr
  = "cond" tag:Identifier "do" NL*
    branches:(CondBranch NL+)+
    "end"
  ;

syntax CondBranch
  = guard:Expression ARROW NL* body:Expressions
  ;

syntax ForExpr
  = "for" v:Identifier "from" lo:Expression "to" hi:Expression
    "do" NL* body:Expressions "end"
  ;

syntax Call
  = call1: fname:Identifier LPAREN Args? RPAREN
  | call2: owner:Identifier DOLLAR fname:Identifier LPAREN Args? RPAREN
  ;

syntax Args = args: Expression (COMMA Expression)* ;

// ---------- Literales ----------
syntax Value
  = intLit    : INT
  | realLit   : REAL
  | boolTrue  : "true"
  | boolFalse : "false"
  | charLit   : CHAR
  | strLit    : STRING
  ;
