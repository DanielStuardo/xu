# xu
XU (read "chú" or "shu") Programming Language & VM made in Harbour/Ansi C.

"XU" no significa nada. Es solo "XU".

XU es una máquina virtual escrita para realizar procesos en modo consola de comandos. Está escrita en su core con Harbour 3.0, y para procesos masivos (de archivos de texto y matrices, tanto de string como numéricas y booleanas), el core es ANSI C. Harbour es una excelente y maravillosa máquina virtual que trabaja codo a codo con el lenguaje C, por lo que añadir procesos al core y ejecutar código nativo C no es ningún problema, e incrementa la velocidad de ejecución de cualquier proceso Harbour de manera exponencial. Bueno, exagero un poco, pero es más rápido.

Hay, y pueden haber tantas versiones multiplataformas de XU como los haya de Harbour.

XU Tiene su propio editor de textos, llamado LAICA, y está escrito casi enteramente en Harbour 3.0. Este edita tanto archivos XU y DEF (los archivos de definiciones de XU), como de cualquier lenguaje. Posee capacidad de highlight de palabras reservadas, y es capaz de compilar y ejecutar los programas editados desde el mismo editor. Si vas a editar otros programas (c, python, perl, java, PDFLatex, etc, etc, etc), puedes configurar los detalles del highlight y las líneas de compilación y/o ejecución en el archivo LAICA.COMPILER. Al respecto, el mismo archivo tiene ejemplos documentados.

ED4XU, además, puede hacer edición de archivos binarios, activando automaticamente el módulo de edición hexadecimal cuando detecta un archivo de esa clase (si el archivo tiene caracteres ASCII con denominación menor a 32, es binario para ED4XU).
Para más detalles, consulte la ayuda incorporada.

Siguiendo con LAICA, este posee un potente lenguaje de programación de macros incorporado, que extiende las capacidades de edición de texto del editor. Para acceder a dicho lenguaje, presionar CTRL-OL o ALT-L.
Este lenguaje posee todas las funcionalidades de las funciones de procesamiento de texto de XU, más otras añadidas especialmente para el modo de edición de texto. El editor de expresiones de macros tiene la capacidad de guardar y cargar listas de expresiones, y está hecho enteramente en Harbour 3.0. Es rápido, pero en una versión posterior será reemplazado por una versión en ANSI C incrustado en #pragma de Harbour, que lo convertirá en un lenguaje aún más rápido.
Su funcionamiento es semejante a AWK, dado que procesa individualmente cada línea del texto almacenado en un BUFFER de copia, o del texto marcado con CTRL-K4, reemplazando las fuentes de datos a voluntad.

Para trabajar con ambos programas, debes crear una variable de entorno llamada PATH_XU, con el path o ruta donde copiaste el sistema. Dicha variable puede ser seteada en .profile, por ejemplo, para que quede disponible cada vez que se inicie el sistema operativo. También puedes copiar los binarios en /usr/bin, por ejemplo, para que queden disponibles desde cualquier parte. La variable PATH_XU hace que los programas fuentes y binarios, además de los archivos de definiciones, puedan ser accedidos con una línea como esta:

      laica prueba.xu                ---> para editar un archivo XU
      xuc prueba.xu -x -m -v -p      ---> para compilar un archivo XU
      xu prueba                      ---> para ejecutar un archivo xu-code (binario) XU

La ayuda del editor y del lenguaje se accede desde el editor mismo, con ^OO y ^OX.

XU is available for Linux based on Debian (32-64 bit), Windows 32 bits (64 bits non-native), Mac OSX Mountain Lion 64 bits.

Lo anterior no es tan cierto: de flojo aún no he habilitado la versión para Windows 32-64 bits. De todas maneras, esto da pie para indicar lo siguiente: Una vez copiado el entorno en el disco, debes elegir los binarios de acuerdo al sistema. Si es Linux basado en Debian, copia en el raíz del directorio XU los archivos ubicados dentro de "xu-bin-debian"; si es Mac OSx 10.8 o superior, copia los binarios desde "xu-bin-osx".

Asegúrate de que las carpetas seteadas en el archivo XU.CONFIG sean las mismas que ves en el directorio. Si quieres cambiar las carpetas de trabajo, deberás indicarlo en este archivo. Tanto el compilador, el ejecutor y el editor de XU se basarán en esta información para trabajar con los archivos nativos XU sin tener que indicar las rutas.

OBSERVACIONES.
No todos los archivos fuentes del lenguaje (y que sirven de ejemplos) están actualizados. Irán actualizándose en la medida que tenga tiempo para hacerlo. El problema es que XU, como pasatiempo, lleva desarrollándose muchos años, y durante ese tiempo ha variado su sintaxis. Ahora tiene la sintaxis oficial: ya no existirán más variaciones, y es la razón por la cual me decidí a subirlo a este repositorio.

Además, añadí algunos ejemplos de juegos "vintage", como una versión en modo texto del Pacman clásico que estoy seguro que te va a gustar. Con él podrás ver algo de la forma de programar de XU. Y como esto fuera poco, añadí un juego inspirado en el Phoenix, un juego arcade más penca que la xuxa, pero que supe adaptar bien. Tiene una mezcla de sonidos del Space Invaders y el Bosconian. Ambos son ejemplos de programación, y pueden ser compilados tanto en OSX como en Linux. En el futuro haré más juegos, porque me gustaron los resultados. Quizás, una versión del "Hero" de Atari, o el mismo Space Invaders. Tengo una versión del Pong clásico, pero aún no lo he convertido a la nueva sintaxis.

**IMPORTANTE**

Puedes revisar la WIKI, ahí encontrarás documentación para usar el editor LAICA y para programar cosillas con XU. Sin embargo, no está actualizada. La ayuda incorporada en el programa (CTRL-OO y CTRL-OX), sí está actualizada.

TODO: programar funciones de sockets. Hasta ahora, he dejado eso como algo externo, ya sabes, si quiero usar sockets, hago una rutina en C y cosas así, y desde esa misma rutina puedo llamar a XU. No lo he probado en una aplicación de alta exigencia, por lo que no sé cómo se podría comportar. 

Espero que te sirva. A mi me sirve cuando el AWK se me hace engorroso. De hecho, hice este lenguaje porque nunca pude entender bien el AWK.

Saludos, Mr. Dalien!
