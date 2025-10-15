module Main

import IO;
import AST;
import Implode;
import Checker;
import Generator1;

public void main(list[str] args=[]) {
  if (args == []) {
    println("Uso: main(\"path/to/file.alu\")");
    return;
  }
  str path = args[0];
  str src = readFile(|file://<path>|);
  Program p = toAST(src, |file://<path>|);
  check(p);
  runProgram(p);
}
