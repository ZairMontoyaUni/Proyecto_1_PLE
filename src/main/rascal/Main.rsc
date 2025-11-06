module Main

import IO;
import AST;
import Implode;
import Generator1;

public void main(list[str] args=[]) {
  str path =
    (args == [])
    //Por favor no olvidar cambiar la ruta para probar los diferentes archivos.
      //? "C:/Users/User/Documents/UNI/LYM/proyecto-1-ple/proyecto-1-ple/instance/prueba.alu"
      //? "C:/Users/nelso/Documents/proyecto-1-ple/instance/prueba.alu"
      ? "C:/Users/LENOVO/Documents/GitHub/proyecto-1-ple/instance/prueba3.alu"
      : args[0];

  if (args == [])
    println(" No se proporcionó ruta. Usando por defecto: <path>");

  str src = readFile(|file://<path>|);
  println(src); 
  Program p = toAST(src, |file://<path>|);
  runProgram(p);
}

