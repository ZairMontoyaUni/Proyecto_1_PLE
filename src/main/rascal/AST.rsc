module AST

// Programa y módulos
data Program = program(list[Module] modules);

data Module
  = funMod(FunctionDecl f)
  | dataMod(DataDecl d)
  ;

// Declaraciones
data FunctionDecl = function(
  str name,                  // Identifier
  list[str] params,          // Parameters?
  list[Statement] body       // Statements
);

data DataDecl = dataDecl(
  str name,                  // Identifier
  list[str] fields           // IdentifierList
);

// Sentencias
data Statement
  = assign(list[str] lhs, Expression rhs)                                   // VariableList "=" Expression
  | ifStmt(
      Condition cond,                                                       // if <cond>
      list[Statement] thenBody,                                             // then
      list[tuple[Condition, list[Statement]]] elifs,                        // (elseif cond then body)*
      list[Statement] elseBody                                              // else
    )
  | condStmt(
      str selector,                                                         // "cond" Identifier ...
      list[tuple[Condition, list[Statement]]] branches                      // (Condition -> Statements)+
    )
  | forStmt(
      str var,                                                              // for Identifier
      Range range,                                                          // from Range
      list[Statement] body                                                  // do Statements end
    )
  | exprStmt(Expression e)                                                  // expresión como sentencia
  ;

// Rango y condición
data Range      = range(Expression lo, Expression hi);                      // Expression "to" Expression

data Operator   = lt() | gt() | le() | ge() | ne() | eq() | and() | or();

data Condition  = condition(Expression left, Operator op, Expression right); // Expression OP Expression

// Expresiones
data Expression
  = add (Expression left, Expression right)
  | sub (Expression left, Expression right)
  | mul (Expression left, Expression right)
  | div (Expression left, Expression right)
  | call(str callee, list[Expression] args)                                  // Identifier $ ( Arguments )
  | var (str name)                                                           // Identifier como Primary
  | number(str lexeme)                                                       // Number (guarda como string; puedes parsear luego)
  | boolean  (bool b)                                                           // Boolean
  | char  (str c)                                                            // Char
  | string(str s)                                                            // String
  ;
