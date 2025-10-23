module Syntax

// ---------- Layout ----------
layout LAYOUT = [\ \t]*;
lexical NL = [\n]+;

// ---------- identificadores y literales ----------
lexical Identifier = [a-z] [a-zA-Z0-9\-]* ;
keyword KW = "cond" | "do" | "data" | "elsif" | "end" | "for" | "from" | "then" | "function" | "else" | "if" | "in" | "iterator" | "sequence" | "struct" | "to" | "tuple" | "type" | "with" | "yielding" ;
lexical Number  = [0-9]+ ("." [0-9]+)?;
syntax Boolean
  = "true"
  | "false"
  ;
lexical Char   = "\'" [a-z] "\'";
lexical String = "\"" ![\"]* "\""; //Este no me convence; revisar

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
start syntax Program = Module+;

// ---------- Módulos ----------
syntax Module = FunctionModule | DataModule ;

syntax DataModule = dataDecl: "data" Identifier "with" NL* IdentifierList "end" ;


// ---------- Funciones ----------
syntax FunctionModule
  = "function"
              Identifier
              LP Parameters* RP NL
              "do" NL* Expressions NL* "end"
  ;

// ---------- Bloques/Expresiones ----------
syntax Parameters = [Identifier (COMMA Identifier)*] ;
syntax Expressions = Expression (NL Expression)* ;
syntax Expression
  = ControlExpression
  | Assignment
  | Value
  | FunctionCall;

syntax ControlExpression = IfExpression | CondExpression |ForExpression ;
syntax IfExpression
  = "if" Condition "then" NL* Expressions ( "elsif" Condition "then" NL* Expressions )* "else" NL* Expressions "end";
syntax CondExpression 
  = "cond" Identifier "do" NL*(Condition ARROW Expressions)+ NL* "end" ;
syntax ForExpression
  = "for" Identifier "from" Range "do" NL* Expressions "end" ;
syntax Range = Value "to" Value ;

syntax Assignment = VariableList "=" Expression ;
syntax VariableList = Identifier (COMMA Identifier)* ;
syntax IdentifierList = Identifier (COMMA Identifier)* ;

syntax DataDefinition 
  = "struct" LP FieldList RP 
  | "sequence" LP Elements RP 
  | "tuple" LP Expression COMMA Expression RP;

syntax FieldList = Identifier (COMMA Identifier)* ;
syntax Elements = Expression (COMMA Expression)* ;

syntax Value
  = Number
  | Boolean
  | Char
  | String
  ;

syntax FunctionCall = Identifier DOLLAR LP Arguments RP ;
syntax Arguments = [Expression (COMMA Expression)*] ;

syntax Condition = Expression Operator Expression ;
syntax Operator = LT | GT | LE | GE | NE | EQ | "and" | "or";


