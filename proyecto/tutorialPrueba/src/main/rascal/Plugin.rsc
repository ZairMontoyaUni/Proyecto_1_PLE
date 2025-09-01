module Plugin
import IO;
import ParseTree;
import util::Reflective;
import util::IDEServices;
import util::LanguageServer;
import Relation;
import Syntax;
PathConfig pcfg = getProjectPathConfig(|project://rascaldsl|);
Language tdslLang = language(pcfg, "TDSL", "tdsl", "Plugin", "contribs");
set[LanguageService] contribs() = {
parser(start[Planning] (str program, loc src) {
return parse(#start[Planning], program, src);
})
};
void main() {
registerLanguage(tdslLang);
}