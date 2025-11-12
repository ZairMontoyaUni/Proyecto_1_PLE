module TypeChecker

import Syntax;
import ParseTree;
import Collect;
import analysis::typepal::TypePal;
import IO;

TypePalConfig cfg() = tconfig(
  verbose = false
);

public void typeCheckFile(loc file) {
  try {
    str  src = readFile(file);
    Tree pt  = parse(#Program, src, file);     // devuelve start[Program]

    TModel tm = collectAndSolve(pt, config = cfg());

    if (size(tm.messages) == 0) {
      println(" No type errors.");
    } else {
      println(" Type errors:");
      for (msg <- tm.messages) {
        println("  <msg>");
      }
    }
  }
  catch e: {
    println("Error: <e>");
  }
}
