module Collect

import Syntax;
import ParseTree;

import analysis::typepal::TypePal;   // Collector, TModel, tconfig, collectAndSolve
import analysis::typepal::AType;     // tyInt(), tyBool(), tyChar(), tyString(), tyVoid()

// Roles
data IdRole = variableId() | functionId() | dataTypeId();

// helper: nombre (string) para define()
private str t2s(Tree t) = "<t>";

/* =========================
 * ROOT BRIDGE
 * ========================= */
void collect(current: start[Program] `<Program p>`, Collector c) = collect(p, c);

/* =========================
 * PROGRAM & MODULES
 * ========================= */
void collect(current: (Program) `program: <Module ms>`, Collector c) {
  c.enterScope(current);
  for (Module m <- ms) collect(m, c);
  c.leaveScope(current);
}

void collect(current: (Module) `funMod: <FunctionModule f>`, Collector c) = collect(f, c);
void collect(current: (Module) `dataMod: <DataModule d>`,   Collector c) = collect(d, c);

/* =========================
 * DATA DECLARATIONS
 * ========================= */
void collect(current: (DataModule)
  `dataDecl: "data" <Identifier id> "with" NL* <TypedIdentifierList til> NL* "end"`, Collector c) {
  c.define(t2s(id), dataTypeId(), id, defType(tyVoid()));
  visit(til) {
    case (TypedIdentifier) `<Identifier fid>`:
      c.define(t2s(fid), variableId(), fid, defType(tyVoid()));
  }
}

void collect(current: (DataModule)
  `dataDecl: "data" <Identifier id> "with" NL* <IdentifierList il> NL* "end"`, Collector c) {
  c.define(t2s(id), dataTypeId(), id, defType(tyVoid()));
  visit(il) {
    case (Identifier) i:
      c.define(t2s(i), variableId(), i, defType(tyVoid()));
  }
}

/* =========================
 * FUNCTIONS
 * ========================= */
void collect(current: (FunctionModule)
  `function: "function" <Identifier id> "(" ")" NL* "do" NL* <Statements ss> NL* "end" NL*`, Collector c) {
  c.define(t2s(id), functionId(), id, defType(tyVoid()));
  c.enterScope(current);
  collect(ss, c);
  c.leaveScope(current);
}

void collect(current: (FunctionModule)
  `function: "function" <Identifier id> "(" <Parameters ps> ")" NL* "do" NL* <Statements ss> NL* "end" NL*`, Collector c) {
  c.define(t2s(id), functionId(), id, defType(tyVoid()));
  c.enterScope(current);
  switch (ps) {
    case (Parameters) `<Identifier ids>`:
      for (Identifier p <- ids) {
        c.define(t2s(p), variableId(), p, defType(tyVoid()));
      }
  }
  collect(ss, c);
  c.leaveScope(current);
}

/* =========================
 * STATEMENTS / BLOCKS
 * ========================= */
void collect(current: (Statements) `<Statement ss>`, Collector c) {
  for (Statement s <- ss) collect(s, c);
}

void collect(current: (Statement) `<VariableList vs> "=" <Expression e>`, Collector c) {
  collect(e, c);
  switch (vs) {
    case (VariableList) `<Identifier ids>`:
      for (Identifier v <- ids) {
        c.define(t2s(v), variableId(), v, defType(tyVoid()));
      }
  }
}

// if / elseif* / else — robusto (evita patrones frágiles)
void collect(current: (IfExpression) _, Collector c) {
  visit (current) {
    case (Condition)  cond: collect(cond, c);
    case (Statements) body: collect(body, c);
  }
}

// for v from lo to hi do ... end
void collect(current: (ForExpression)
  `for <Identifier v> "from" <Range r> "do" NL* <Statements b> NL* "end"`, Collector c) {
  c.enterScope(current);
  c.define(t2s(v), variableId(), v, defType(tyVoid()));
  collect(r, c);
  collect(b, c);
  c.leaveScope(current);
}

// cond sel do (g -> s)+ end
void collect(current: (CondExpression) _, Collector c) {
  visit(current) {
    case (Identifier) sel: c.use(sel, {variableId(), functionId()}); // pasa Tree, no str
    case (Condition)  g  : collect(g, c);
    case (Statements) s  : collect(s, c);
  }
}

/* =========================
 * RANGE / CONDITION
 * ========================= */
void collect(current: (Range) `<Expression lo> "to" <Expression hi> NL*`, Collector c) {
  collect(lo, c);
  collect(hi, c);
  c.fact(lo,  tyInt());
  c.fact(hi,  tyInt());
}

void collect(current: (Condition) `<Expression a> <Operator _> <Expression b>`, Collector c) {
  collect(a, c);
  collect(b, c);
  c.fact(current, tyBool());
}

/* =========================
 * EXPRESSIONS
 * ========================= */
void collect(current: (Expression) `<Expression l> PLUS  <Expression r>`, Collector c) {
  collect(l, c); collect(r, c);
  c.fact(current, tyInt()); c.fact(l, tyInt()); c.fact(r, tyInt());
}
void collect(current: (Expression) `<Expression l> MINUS <Expression r>`, Collector c) {
  collect(l, c); collect(r, c);
  c.fact(current, tyInt()); c.fact(l, tyInt()); c.fact(r, tyInt());
}
void collect(current: (Expression) `<Expression l> STAR  <Expression r>`, Collector c) {
  collect(l, c); collect(r, c);
  c.fact(current, tyInt()); c.fact(l, tyInt()); c.fact(r, tyInt());
}
void collect(current: (Expression) `<Expression l> SLASH <Expression r>`, Collector c) {
  collect(l, c); collect(r, c);
  c.fact(current, tyInt()); c.fact(l, tyInt()); c.fact(r, tyInt());
}

// llamadas f$(...)
void collect(current: (Expression) `<FunctionCall fc>`, Collector c) = collect(fc, c);

void collect(current: (FunctionCall) `<Identifier f> DOLLAR "(" <Arguments as> ")"`, Collector c) {
  c.use(f, {functionId()});
  switch (as) {
    case (Arguments) `<Expression es>`:
      for (Expression e <- es) collect(e, c);
  }
}

// id y literales
void collect(current: (Expression) `<Identifier x>`, Collector c) = c.use(x, {variableId(), functionId()});
void collect(current: (Expression) `<Number  _>`, Collector c)   = c.fact(current, tyInt());
void collect(current: (Expression) `<Boolean _>`, Collector c)   = c.fact(current, tyBool());
void collect(current: (Expression) `<Char    _>`, Collector c)   = c.fact(current, tyChar());
void collect(current: (Expression) `<String  _>`, Collector c)   = c.fact(current, tyString());
