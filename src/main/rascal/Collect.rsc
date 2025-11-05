module Collect

import Syntax;  // <- tu gramática
import ParseTree;

import analysis::typepal::AType;
import analysis::typepal::Collector;

// Literales
void collect(current: (Number)  _, Collector c) = c.fact(current, intType());   // o decide int/real con yield()
void collect(current: (Boolean) _, Collector c) = c.fact(current, boolType());  // <- esta es la que te fallaba
void collect(current: (String)  _, Collector c) = c.fact(current, strType());

// Declaración (ajusta a tu producción real)
void collect(current: (VarDecl) `let <Identifier x> = <Expression e> ;`, Collector c){
  c.define(yield(x), variableId(), x);
  collect(e, c);
}

// Uso (ajusta el patrón al tuyo)
void collect(current: (Expression) `<Identifier x>`, Collector c){
  c.use(x, {variableId()});
}