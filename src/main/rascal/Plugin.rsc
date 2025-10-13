module Plugin

import util::LanguageServer;
import ParseTree;
import Syntax;

PathConfig pcfg = getProjectPathConfig(|project://proyecto|);

Language aluLang = language(pcfg, "ALU", "alu", "Plugin", "contribs");

set[LanguageService] contribs() = {
  parser(start[Program] (str program, loc src) {
    return parse(#Program, program, src);
  })
};

public void main() { registerLanguage(aluLang); }
