# Proyecto_1_PLE
## Nombres Equipo
Zair Montoya Bello - 202321067 - z.montoya@uniandes.edu.co

N Felipe Celis D -202320636 - nf.celis@uniandes.edu.co

## Rascal

1. primero descargar la extension de rascal Rascal Metaprogramming Language -- UseTheSource
2. luego descargar JDK 11 hasta 17 (osea alguna de las versiones entre 11 y 17)
3. luego installar maven de https://maven.apache.org/download.cgi y (busca la versión binaria ZIP)
4. La ruta en el PATH debe apuntar al directorio bin de Maven
5. Variable JAVA_HOME:
    -  Busca "Variables de entorno" en el menú Inicio.
    -    Haz clic en "Variables de entorno...".
    -    En "Variables del sistema", crea una nueva variable llamada JAVA_HOME con la ruta de tu JDK.
6. Ejecuta en la terminal: mvn --version para verificar la version

## Para crear este proyecto lo que se hizo fue 

1. 
cd C:\Users\User\Documents\UNI\LYM\Proyecto_1_PLE
mkdir ProyectoRascal
cd ProyectoRascal

2. 
mvn archetype:generate `
    "-DarchetypeGroupId=org.rascalmpl" `
    "-DarchetypeArtifactId=rascal-archetype-project" `
    "-DarchetypeVersion=0.1.0" `
    "-DarchetypeRepository=https://repo.usethesource.io/maven"
3. 



