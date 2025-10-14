module Generator1

import AST;
import IO;

data Val = I(int v) | R(real v) | B(bool v) | C(str v) | S(str v) | U(); // U = undefined/null

alias Env = map[str, Val];
alias Fns = map[str, FunctionModule];

public void runProgram(Program p) {
  Fns fns = indexFns(p);
  if ("main" in fns) {
    Val v = runFunction(fns["main"], fns, []);
    println("main =\> <v>");
  } else {
    println("No main() found");
  }
}

Fns indexFns(Program p) {
  Fns m = ();
  for (funMod(f) <- p.modules) {
    m[f.fName] = f;
  }
  return m;
}

Val runFunction(FunctionModule f, Fns fns, list[Val] args) {
  Env env = ();
  Val last = U();
  for (e <- f.body) {
    last = eval(e, env, fns);
  }
  return last;
}

Val eval(Expr e, Env env, Fns fns) {
  switch (e) {
    case lit(intLit(v)): 
      return I(v);
    case lit(realLit(v)): 
      return R(v);
    case lit(boolTrue()): 
      return B(true);
    case lit(boolFalse()): 
      return B(false);
    case lit(charLit(c)): 
      return C(c);
    case lit(strLit(s)): 
      return S(s);
    case var(x): 
      return (x in env) ? env[x] : U();
    case assign(ids, ex): {
      Val v = eval(ex, env, fns);
      for (id <- ids) {
        env[id] = v;
      }
      return v;
    }
    case call1("print", argList): {
      Val v = (argList != []) ? eval(argList[0], env, fns) : U();
      println(v);
      return v;
    }
    case call1(fname, _): {
      if (!(fname in fns)) return U();
      return runFunction(fns[fname], fns, []);
    }
    case call2(_, _, _): {
      // Por ahora no implementado
      return U();
    }
    case ife(c, t, elifs, f): {
      if (asBool(eval(c, env, fns))) 
        return evalBlock(t, env, fns);
      for (elseif(c2, b2) <- elifs) {
        if (asBool(eval(c2, env, fns))) 
          return evalBlock(b2, env, fns);
      }
      return evalBlock(f, env, fns);
    }
    case forRange(v, lo, hi, b): {
      int a = asInt(eval(lo, env, fns));
      int z = asInt(eval(hi, env, fns));
      Val last = U();
      for (i <- [a..z]) {
        env[v] = I(i);
        last = evalBlock(b, env, fns);
      }
      return last;
    }
    case cone(_, branches): {
      for (condBranch(g, b) <- branches) {
        if (asBool(eval(g, env, fns))) 
          return evalBlock(b, env, fns);
      }
      return U();
    }
    default: 
      return U();
  }
}

Val evalBlock(list[Expr] es, Env env, Fns fns) {
  Val last = U();
  for (e <- es) {
    last = eval(e, env, fns);
  }
  return last;
}

bool asBool(Val v) {
  switch(v) {
    case B(b): return b;
    default: return false;
  }
}

int asInt(Val v) {
  switch(v) {
    case I(i): return i;
    default: return 0;
  }
}