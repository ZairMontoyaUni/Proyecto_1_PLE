module Parser

import ParseTree;
import Syntax;

public Tree parse(str input, loc src = |unknown:///|) {
  return parse(#Program, input, src);
}
