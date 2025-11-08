module Implode

import Syntax;
import ParseTree;
import AST;
import Parser;
// ====================
// API principal
// ====================

public AST::Program toAST(str input, loc src) {
  Tree pt = parse(#Program, input, src);
  return implodeProgram(pt);
}

// ====================
// Program y módulos
// ====================

public AST::Program implodeProgram(Tree t) {
  list[Module] mods = [];
  visit(t) {
    case (Module) m:
      mods += [ implodeModule(m) ];
  }
  return program(mods);
}

public AST::Module implodeModule(Tree t) {
  switch (t) {
    case (Module) `funMod: <FunctionModule f>`:
      return funMod(implodeFunction(f));
    case (Module) `dataMod: <DataModule d>`:
      return dataMod(implodeData(d));
  }
  throw "Unexpected Module tree in implodeModule";
}

// ====================
// DataModule
// ====================

public AST::DataDecl implodeData(Tree t) {
  switch (t) {
    case (DataModule)
         `dataDecl: "data" <Identifier id> "with" NL* <IdentifierList il> NL* "end"`:
      return dataDecl(yield(id), implodeIdentifierList(il));
  }
  throw "Unexpected DataModule tree in implodeData";
}

public list[str] implodeIdentifierList(Tree t) {
  switch (t) {
    case (IdentifierList) `<Identifier ids>`:
      return [ yield(i) | Identifier i <- ids ];
  }
  return [];
}

// ====================
// FunctionModule
// ====================

public AST::FunctionDecl implodeFunction(Tree t) {
  switch (t) {
    // sin parámetros
    case (FunctionModule)
         `function: "function" <Identifier id> "(" ")" NL* "do" NL* <Statements ss> NL* "end" NL*`:
      return function(yield(id), [], implodeStatements(ss));

    // con parámetros
    case (FunctionModule)
         `function: "function" <Identifier id> "(" <Parameters ps> ")" NL* "do" NL* <Statements ss> NL* "end" NL*`:
      return function(yield(id), implodeParameters(ps), implodeStatements(ss));
  }
  throw "Unexpected FunctionModule tree in implodeFunction";
}

public list[str] implodeParameters(Tree t) {
  switch (t) {
    case (Parameters) `<Identifier ids>`:
      return [ yield(i) | Identifier i <- ids ];
  }
  return [];
}

// ====================
// Statements y Statement
// ====================

public list[AST::Statement] implodeStatements(Tree t) {
  list[Statement] out = [];
  visit(t) {
    case (Statement) s:
      out += [ implodeStatement(s) ];
  }
  return out;
}

public AST::Statement implodeStatement(Tree t) {
  switch (t) {
    // sentencia: control (if / for / cond)
    case (Statement) `<ControlStatement c>`:
      return implodeControl(c);

    // sentencia: asignación
    case (Statement) `<VariableList vs> = <Expression e>`:
      return assign(implodeVariableList(vs), implodeExpr(e));

    // sentencia: expresión normal
    case (Statement) `<Expression e>`:
      return exprStmt(implodeExpr(e));
  }
  throw "Unexpected Statement tree in implodeStatement";
}


public list[str] implodeVariableList(Tree t) {
  switch (t) {
    case (VariableList) `<Identifier ids>`:
      return [ yield(i) | Identifier i <- ids ];
  }
  return [];
}

// ====================
// Control statements
// ====================

public AST::Statement implodeControl(Tree t) {
  switch (t) {
    case (IfExpression) `if <Condition c0> "then" NL* <Statements t0> NL* ( "elseif" <Condition ci> "then" NL* <Statements ti> )* "else" NL* <Statements e0> NL* "end"`:
      return AST::ifStmt(
        implodeCondition(c0),
        implodeStatements(t0),
        [ <implodeCondition(ci), implodeStatements(ti)> | ci <- ci, ti <- ti ],
        implodeStatements(e0)
      );

    case (ForExpression)
         `for <Identifier v> "from" <Range r> "do" NL* <Statements b> NL* "end"`:
      return AST::forStmt(
        yield(v),
        implodeRange(r),
        implodeStatements(b)
      );
  }

  throw "Unexpected ControlStatement tree in implodeControl";
}


// ====================
// Range, Condition, Operator
// ====================

public AST::Range implodeRange(Tree t) {
  switch (t) {
    case (Range) `<Expression lo> "to" <Expression hi> NL*`:
      return range(implodeExpr(lo), implodeExpr(hi));
  }
  throw "Unexpected Range tree in implodeRange";
}

public AST::Condition implodeCondition(Tree t) {
  switch (t) {
    case (Condition) `<Expression a> <Operator op> <Expression b>`:
      return AST::condition(
        implodeExpr(a),
        implodeOperator(op),
        implodeExpr(b)
      );
  }
  throw "Unexpected Condition tree in implodeCondition";
}


public AST::Operator implodeOperator(Tree t) {
  switch (t) {
    case (Operator) `LT`:  return lt();
    case (Operator) `GT`:  return gt();
    case (Operator) `LE`:  return le();
    case (Operator) `GE`:  return ge();
    case (Operator) `NE`:  return ne();
    case (Operator) `EQ`:  return eq();
    case (Operator) `"and"`: return and();
    case (Operator) `"or"`:  return or();
  }
  throw "Unexpected Operator tree in implodeOperator";
}

// ====================
// Expresiones
// ====================

public AST::Expression implodeExpr(Tree t) {
  switch (t) {
    // suma / resta
    case (Expression) `<Expression a> PLUS <Expression b>`:
      return add(implodeExpr(a), implodeExpr(b));

    case (Expression) `<Expression a> MINUS <Expression b>`:
      return sub(implodeExpr(a), implodeExpr(b));

    // multiplicación / división
    case (Expression) `<Expression a> STAR <Expression b>`:
      return mul(implodeExpr(a), implodeExpr(b));

    case (Expression) `<Expression a> SLASH <Expression b>`:
      return div(implodeExpr(a), implodeExpr(b));

    // llamada a función: id $ (args)
    case (Expression) `<FunctionCall fc>`:
      return implodeCall(fc);

    // identificador solo
    case (Expression) `<Identifier x>`:
      return var(yield(x));

    // literales
    case (Expression) `<Number n>`:
      return number(yield(n));

    case (Expression) `<Boolean b>`: {
      str v = yield(b);
      return boolean(v == "true");
    }

    case (Expression) `<Char c>`:
      return char(yield(c));

    case (Expression) `<String s>`:
      return string(yield(s));
  }

  throw "Unexpected Expression tree in implodeExpr";
}

// llamada a función y argumentos
public AST::Expression implodeCall(Tree t) {
  switch (t) {
    case (FunctionCall) `<Identifier f> DOLLAR "(" <Arguments as> ")"`:
      return call(yield(f), implodeArgs(as));
  }
  throw "Unexpected FunctionCall tree in implodeCall";
}

public list[AST::Expression] implodeArgs(Tree t) {
  switch (t) {
    case (Arguments) `<Expression es>`:
      return [ implodeExpr(e) | Expression e <- es ];
  }
  return [];
}
