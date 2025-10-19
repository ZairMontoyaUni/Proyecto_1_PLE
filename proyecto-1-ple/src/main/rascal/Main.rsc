module Main

import IO;
import AST;
import Implode;
import Checker;
import Generator1;

public void main(list[str] args=[]) {
  str path =
    (args == [])
      ? "C:/Users/LENOVO/Documents/GitHub/Proyecto_1_PLE/proyecto-1-ple/instance/prueba.alu"
      : args[0];

  if (args == [])
    println(" No se proporcionó ruta. Usando por defecto: <path>");

  str src = readFile(|file://<path>|);
  Program p = toAST(src, |file://<path>|);
  check(p);
  runProgram(p);
}

