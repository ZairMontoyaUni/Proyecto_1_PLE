module AST

data ElseIf     = elseif(Expr cond, list[Expr] body);
data CondBranch = condBranch(Expr guard, list[Expr] body);

data Value
  = intLit(int v)
  | realLit(real v)
  | boolTrue()
  | boolFalse()
  | charLit(str c)
  | strLit(str s)
  ;

data Expr
  = assign(list[str] ids, Expr e)
  | ife(Expr cond, list[Expr] thenBody, list[ElseIf] elseifs, list[Expr] elseBody)
  | cone(str tags, list[CondBranch] branches)
  | forRange(str v, Expr lo, Expr hi, list[Expr] body)
  | call1(str fname, list[Expr] args)
  | call2(str owner, str fname, list[Expr] args)
  | lit(Value v)
  | var(str id)
  ;

data FunctionModule = function(str fName, list[str] params, list[Expr] body);

data DataBody   = dataBody();
data DataModule = dataDecl(str name, DataBody body);

data Module
  = funMod(FunctionModule f)
  | dataMod(DataModule d)
  ;

data Program = program(list[Module] modules);
