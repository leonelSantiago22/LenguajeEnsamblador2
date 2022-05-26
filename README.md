# LenguajeEnsamblador2
Segundo RepositorioLenguajeEnsamblador
TASM
Después de haber probado el ensamblado de programas con el Debug, ahora corresponde utilizar un
medio más poderoso, que es el TurboAssembler, también conocido como TASM. Desafortunadamente,
éste tampoco es compatible con Windows de 64 bits (Win64), por lo que podría ser necesario utilizar
DOSBox.
Es importante tomar en cuenta que para este curso la base es el ensamblador que accede a
interrupciones de DOS y el BIOS, porque es muy parecido a la programación de bajo nivel en los
microcontroladores. Por supuesto, existen otras opciones mucho más modernas, tales como nasm, pero
que ya no acceden a interrupciones, sino a llamadas a funciones, alejándose de la programación de
microcontroladores.
El uso del TASM permite el uso de etiquetas para representar direcciones, ya sean de datos o de código.
Cuando se usaba el Debug, se generaba código ejecutable directamente y no se utilizaron etiquetas ni
archivos anexos. Por lo tanto, no era necesario integrar bloques de código e integrar etiquetas.
Sin embargo, al utilizar bloques de código provenientes de diferentes archivos, se requiere realizar por
separado el ensamblado y el ligado. El ligado es un proceso realizado por el linker que integra varios
bloques de código utilizando etiquetas para hacer referencia a sus puntos de acceso a código y a datos.
De hecho, prácticamente todos los compiladores modernos utilizan ligadores para realizar esa función.
