module Syntax

// ---------- Layout ----------
layout LAYOUT = [\ \t]*;
lexical NL = [\r]?[\n]+;

// ---------- identificadores y literales ----------
lexical Identifier = [a-z] [a-zA-Z0-9\-]* ;
keyword KW =
  "cond" | "do" | "data" | "elseif" | "end" | "for" | "from" | "then"
| "function" | "else" | "if" | "in" | "iterator" | "sequence" | "struct"
| "to" | "tuple" | "type" | "with" | "yielding"
| "and" | "or"                           
;
lexical Number  = [0-9]+ ("." [0-9]+)?;
syntax Boolean = "true" | "false";
lexical Char   = "\'" [a-z] "\'";
lexical String = "\"" ![\"]* "\"";

// ---------- Símbolos ----------
lexical STAR    = "*";
lexical SLASH   = "/";
lexical MINUS   = "-";
lexical PLUS    = "+";
lexical POW     = "**";
lexical MOD     = "%";

lexical LT      = '\<';
lexical GT      = '\>';
lexical LE      = '\<=';
lexical GE      = '\>=';
lexical NE      = '\<\>';
lexical EQ      = "==";

lexical ARROW   = '-\>';
lexical COLON   = ":";
lexical DOLLAR  = "$";
lexical LP      = "(";
lexical RP      = ")";
lexical LB      = "[";
lexical RB      = "]";
lexical COMMA   = ",";

// ---------- Raíz ----------
start syntax Program = program:Module+;

// ---------- Módulos ----------
syntax Module
  = funMod: FunctionModule
  | dataMod: DataModule
  ;

syntax DataModule = dataDecl: "data" Identifier "with" NL* IdentifierList "end" ;

// ---------- Funciones ----------
syntax FunctionModule
  = function: "function" Identifier LP Parameters? RP   // <--- quita los corchetes [ ] y usa ? normal
    NL* "do" NL* Statements NL* "end" NL*
  ;

// ---------- Bloques / Expresiones ----------
syntax Parameters = Identifier (COMMA Identifier)* ;
syntax Statements = Statement (NL Statement)* ;

syntax Primary
  = Identifier
  | FunctionCall
  | Value
  ;

syntax Mul
  = left Mul STAR  right Mul
  > left Mul SLASH right Mul
  > Primary
  ;

syntax Add
  = left Add PLUS  right Add
  > left Add MINUS right Add
  > Mul
  ;

syntax Expression
   = left VariableList "=" right Expression
   > Add;         

syntax Statement
  = ControlStatement
  | Expression
  ;

// --- Control ---
syntax ControlStatement = IfExpression | CondExpression | ForExpression ;

syntax IfExpression
  = "if" Condition "then" NL* Statements
    ( "elseif" Condition "then" NL* Statements )*
    "else" NL* Statements
    "end"
  ;

syntax CondExpression
  = "cond" Identifier "do" NL* (Condition ARROW Statements)+ NL* "end" ;

syntax ForExpression
  = "for" Identifier "from" Range "do" NL* Statements "end" ;

syntax Range = Expression "to" Expression ;     

// --- Assignment y listas ---
syntax VariableList  = Identifier (COMMA Identifier)* ;
syntax IdentifierList = Identifier (COMMA Identifier)* ;

// --- DataDefinition  ---
syntax DataDefinition
  = "struct"   LP FieldList RP
  | "sequence" LP Elements RP
  | "tuple"    LP Expression COMMA Expression RP   
  ;

syntax FieldList = Identifier (COMMA Identifier)* ;
syntax Elements  = Expression (COMMA Expression)* ; 

// --- Literales / valores primarios ---
syntax Value
  = Number
  | Boolean
  | Char
  | String
  ;

// --- Llamadas ---
syntax FunctionCall = Identifier DOLLAR LP Arguments RP ;
syntax Arguments    = Expression (COMMA Expression)* ; 

// --- Condiciones ---
syntax Condition = Expression Operator Expression ;     
syntax Operator  = LT | GT | LE | GE | NE | EQ | "and" | "or";
