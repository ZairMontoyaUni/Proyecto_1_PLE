module Parser

import ParseTree;
import Syntax;

public Tree parse(str input, loc src) {
  return parse(#Program, input, src);
}
