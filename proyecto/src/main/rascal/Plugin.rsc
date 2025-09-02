module Plugin
import IO;
import ParseTree;
import util::Reflective;
import util::IDEServices;
import util::LanguageServer; // proporciona Language y LanguageService
import Relation;
import Syntax;

 PathConfig pcfg = getProjectPathConfig(|project://proyecto|);
Language tdslLang = language(pcfg, "TDSL", "tdsl", "Plugin", "contribs");
set[LanguageService] contribs() = {
// Alineado con tu gramática: Start es el símbolo inicial
parser(start[Start] (str program, loc src) {
return parse(#Start, program, src);
})
};
public void main() {
  registerLanguage(tdslLang);
}
