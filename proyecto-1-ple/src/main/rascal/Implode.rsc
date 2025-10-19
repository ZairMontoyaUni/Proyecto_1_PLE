module Implode

import ParseTree;
import AST;
import Parser;

public AST::Program toAST(str input, loc src) {
  Tree t = parse(input, src);
  return implode(#Program, t);
}