module Plugin

import lang::rascal::syntax::Syntax;
import util::Reflective;

public void main() {
  contribs();
}

public void contribs() {
  registerLanguage("tdsl", "Text DSL Example");
}
