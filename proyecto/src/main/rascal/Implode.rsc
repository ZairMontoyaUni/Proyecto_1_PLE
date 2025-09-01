module Implode
import AST;
import Parser;
import ParseTree;

public AST::Start toAST(str input) = implode(#Start, parse(input));
