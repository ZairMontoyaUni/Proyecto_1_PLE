module TypeChecker

import AST;
import Collect;
import Implode;
import IO;

public void checkFile(loc file) {
  println("Iniciando análisis…");
  str src = readFile(file);

  Program p = program([]);

  try {
    p = toAST(src, file);           // Usa tu Parser/Implode ya existentes
  }
  catch e: {
    println("Error parseando archivo: <e>");
    return;
  }

  println("AST generado.");
  collectProgram(p);                // <- usamos nuestro recolector básico
  println("Análisis completado.");
}
