module Checker

import AST;

public void check(Program p) {
  set[str] fnames = {};
  for (funMod(function(fname, _, _)) <- p.modules) {
    if (fname in fnames) {
      throw "Function redefined: <fname>";
    }
    fnames += {fname};
  }
  for (funMod(function(_, _, body)) <- p.modules) {
    _ = checkExprs(body, fnames);
  }
}

bool checkExprs(list[Expr] es, set[str] fns) {
  for (e <- es) {
    switch (e) {
      case call1(fname, _):
        if (!(fname in fns) && fname != "print") { 
          throw "Unknown function: <fname>"; 
        }
      case call2(_, fname, _):
        if (!(fname in fns)) { 
          throw "Unknown method: <fname>"; 
        }
      case ife(c, t, elifs, f): {
        _ = checkExprs([c], fns);
        _ = checkExprs(t, fns);
        for (elseif(cond, body) <- elifs) {
          _ = checkExprs([cond], fns);
          _ = checkExprs(body, fns);
        }
        _ = checkExprs(f, fns);
      }
      case cone(_, branches): {
        for (condBranch(g, b) <- branches) {
          _ = checkExprs([g], fns);
          _ = checkExprs(b, fns);
        }
      }
      case forRange(_, lo, hi, b): {
        _ = checkExprs([lo, hi], fns);
        _ = checkExprs(b, fns);
      }
      case assign(_, e2):
        _ = checkExprs([e2], fns);
      default:
        ;
    }
  }
  return true;
}