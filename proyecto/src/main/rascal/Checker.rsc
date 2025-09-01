module Checker

import AST;

public void check(Start ast) {
  if(ast.name == "error") {
    println("Nombre inválido");
  }
}
