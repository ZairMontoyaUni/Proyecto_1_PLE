module Collect

import AST;
import IO;

// ==============================
// Recolector básico sobre el AST
// ==============================

public void collectProgram(Program p) {
  println("Recolectando programa…");
  for (m <- p.modules) {
    collectModule(m);
  }
}

// ---------- Módulos ----------
void collectModule(Module m) {
  switch (m) {
    case funMod(f): collectFunction(f);
    case dataMod(d): collectData(d);
  }
}

void collectData(DataDecl d) {
  println("→ data <d.name> con campos <d.fields>");
}

// ---------- Funciones ----------
void collectFunction(FunctionDecl f) {
  //println("→ function <f.name> con <size(f.params)> parámetro(s)");
  for (s <- f.body) {
    collectStatement(s);
  }
}

// ---------- Sentencias ----------
void collectStatement(Statement s) {
  switch (s) {
    case assign(lhs, rhs): {
      println("  asignación a <lhs>");
      collectExpression(rhs);
    }
    case ifStmt(cond, thenBody, elifs, elseBody): {
      println("  if …");
      collectCondition(cond);
      for (t <- thenBody) collectStatement(t);
      for (<c, bs> <- elifs) {
        println("  elseif …");
        collectCondition(c);
        for (t <- bs) collectStatement(t);
      }
      println("  else …");
      for (t <- elseBody) collectStatement(t);
    }
    case condStmt(selector, branches): {
      println("  cond <selector>");
      for (<c, bs> <- branches) {
        collectCondition(c);
        for (t <- bs) collectStatement(t);
      }
    }
    case forStmt(v, r, body): {
      println("  for <v> from …");
      collectRange(r);
      for (t <- body) collectStatement(t);
    }
    case exprStmt(e): {
      collectExpression(e);
    }
  }
}

// ---------- Rangos y condiciones ----------
void collectRange(Range r) {
  switch (r) {
    case range(lo, hi): {
      collectExpression(lo);
      collectExpression(hi);
    }
  }
}

void collectCondition(Condition c) {
  switch (c) {
    case condition(left, _, right): {
      collectExpression(left);
      collectExpression(right);
    }
  }
}

// ---------- Expresiones ----------
void collectExpression(Expression e) {
  switch (e) {
    case add(l, r): { collectExpression(l); collectExpression(r); }
    case sub(l, r): { collectExpression(l); collectExpression(r); }
    case mul(l, r): { collectExpression(l); collectExpression(r); }
    case div(l, r): { collectExpression(l); collectExpression(r); }
    case call(fn, args): {
      println("  call <fn>(…)");
      for (a <- args) collectExpression(a);
    }
    case var(x):     { println("  var <x>"); }
    case number(n):  { println("  number <n>"); }
    case boolean(b): { println("  boolean <b>"); }
    case char(c):    { println("  char <c>"); }
    case string(s):  { println("  string <s>"); }
  }
}
