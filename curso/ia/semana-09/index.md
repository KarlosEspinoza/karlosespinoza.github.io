---
layout: default
title: Inteligencia Artificial
---
[Inicio](/curso/ia)

# Semana 9 - Revisión de avances 1

Cierre de las Unidades 1 y 2 (Introducción y Aprendizaje Supervisado).

## Antes de la clase (entrega previa)

Haz push a GitHub de tus evidencias y tu `BITACORA.md` antes del día de la revisión. Si no hay push a tiempo, la revisión cuenta como no entregada.

Tu sistema debe:

- Leer la señal de tu sensor desde Python y graficarla.
- Tener `datos.csv` con al menos 30 repeticiones etiquetadas de cada tipo de pieza.
- Extraer características de tiempo y de frecuencia hacia `features.csv`.
- Tener un clasificador entrenado y guardado en `modelo.pkl`, con su matriz de confusión.
- Cerrar el bucle: el modelo decide y el actuador responde.

Equipos: cada integrante actualiza y hace push de su autoevaluación privada (`<codigo>.csv`) antes de la revisión.

## Durante la clase (revisión)

La sesión se dedica a las preguntas (orales o escritas): una sobre tu trabajo y otra sobre los temas vistos. Se revisan las prácticas y el proyecto integrador.

## Lo que se evalúa

- Prácticas: evidencias 50%, BITACORA.md 30%, preguntas 20%.
- Proyecto integrador: evidencias 45%, BITACORA.md 25%, preguntas 20%, autoevaluación entre pares 10%.

---

## Preguntas de revisión {#preguntas-de-revision}

Banco de preguntas de la revisión de avances 1 (semana 9). Son las mismas que están al final de cada una de las semanas 1 a 8, juntas aquí para que estudies de corrido. En la revisión te puedo hacer cualquiera de ellas, variarlas, o preguntar directo sobre tu propio código. El instrumento completo está en [Prácticas](/curso/ia/evaluacion/individual).

### Semana 1: Encuadre y configuración del entorno {#preguntas-s01}

**Fáciles**

1. ¿Qué es el aprendizaje de máquina y en qué se distingue de programar una regla a mano?
2. ¿Qué es un commit y para qué sirve el historial de commits en este curso?
3. ¿Cuáles son las tres piezas del bucle de control inteligente y qué hace cada una?

**De aplicación a tu proyecto**

4. Dime tu dominio y tus tres tipos de pieza, y qué mide tu sensor en tu sistema.
5. Descríbeme el bucle de **tu** sistema: qué mide el sensor, qué tiene que decidir el modelo y qué hace el actuador con cada uno de tus tres tipos.
6. ¿Por qué elegiste ese sensor? ¿Qué par de tus piezas crees que se te van a confundir más?
7. Enséñame la estructura de tu repositorio y dime qué va en cada carpeta.

**Difíciles**

8. En la programación tradicional entran datos y reglas, y salen resultados. ¿Qué entra y qué sale en el aprendizaje de máquina?
    *Respuesta: entran datos y resultados (las etiquetas), y salen las reglas, o sea el modelo.*
9. ¿Por qué un solo `if` con un umbral no alcanza para distinguir madera de plástico, y qué hace distinto el modelo?
    *Respuesta: la diferencia está en una combinación de varias señales, no en un solo valor. El modelo encuentra la frontera a partir de ejemplos etiquetados.*
10. ¿Por qué el curso se trabaja primero con Arduino en protoboard y no directo en la maqueta, y qué es lo que se conserva al pasar a producción?
    *Respuesta: el prototipo es barato para equivocarse y recolectar datos. El modelo es el mismo; lo que cambia es a quién le manda la orden (el PLC en vez del Arduino).*
11. ¿Por qué tus datos (el CSV) van al repositorio igual que el código?
    *Respuesta: sin los datos no se puede volver a entrenar el modelo. Los datos son parte del proyecto.*

### Semana 2: La primera señal del sensor {#preguntas-s02}

**Fáciles**

1. ¿Qué papel tiene el Arduino y qué papel tiene Python en tu sistema?
2. Por el puerto serial, ¿viajan números o caracteres?
3. ¿Qué es una ventana?

**De aplicación a tu proyecto**

4. Enséñame tu `sensor.ino` y dime qué formato tiene cada línea que manda.
5. ¿Qué `delay()` elegiste, a cuántas muestras por segundo equivale y cuántas muestras tienes de tu pieza mientras pasa?
6. Ese `delay()`, ¿lo tuviste que cambiar al probarlo con el hardware? ¿Por qué?
7. Enséñame la figura con tus tres señales juntas. ¿Se distinguen tus tres tipos a simple vista?

**Difíciles**

8. ¿Por qué el Arduino no puede mandar `Serial.println("Leyendo...")`?
    *Respuesta: ese texto viaja por el mismo canal que los datos. Python intenta convertirlo a número y truena.*
9. Te sale `PermissionError: Acceso denegado` al abrir `COM3`. ¿Es un problema de permisos?
    *Respuesta: casi nunca. Es que alguien más tiene el puerto abierto: el Monitor Serie, otra terminal, o tu script anterior que no llegó al `ser.close()`.*
10. ¿Por qué hay un `time.sleep(2)` justo después de abrir el puerto?
    *Respuesta: abrir el puerto reinicia el Arduino. Si lees antes, las primeras líneas llegan cortadas o vacías.*
11. ¿Qué le pasa a tu dataset si muestreas demasiado lento? ¿Y si muestreas demasiado rápido?
    *Respuesta: muy lento, la pieza pasa entre dos lecturas y no queda rastro del evento. Muy rápido, generas montañas de datos casi iguales que hacen todo más lento. Además cada sensor tiene un techo por su tiempo de respuesta.*
12. ¿Por qué un valor suelto del sensor no identifica una pieza?
    *Respuesta: lo que la identifica es la forma de la señal a lo largo del tiempo: cuánto baja, qué tan rápido, cuánto dura.*

### Semana 3: Recolección de datos etiquetados {#preguntas-s03}

**Fáciles**

1. ¿Qué es una muestra, qué es una ventana y qué es una etiqueta?
2. ¿Qué columnas tiene tu `datos.csv` y qué guarda cada una?
3. Si tu dataset tiene 90 ventanas de 200 muestras cada una, ¿cuántos ejemplos ve el modelo?
    *Respuesta: 90. La unidad es la ventana, no la muestra.*

**De aplicación a tu proyecto**

4. ¿Cuántas ventanas capturaste por clase? ¿Está balanceado tu dataset?
5. Cuéntame tu protocolo: en qué orden pasaste las piezas, a qué distancia del sensor y qué hiciste para mantener pareja la velocidad de tu mano.
6. ¿Qué te sorprendió al ver tus datos juntos? ¿Algo salió mal en la captura y cómo lo resolviste?
7. ¿Qué tan bien crees que te salió controlar la velocidad de tu mano? ¿Qué evidencia tienes?

**Difíciles**

8. ¿Por qué no se capturan las 30 ventanas de una clase seguidas y luego las de la siguiente?
    *Respuesta: el mundo cambia durante la sesión (luz, temperatura del sensor, cansancio). Si una clase se captura toda junta, esos cambios quedan pegados a su etiqueta y el modelo puede aprender el momento y no la pieza. Alternando, el cambio se reparte parejo.*
9. ¿Qué es fuga de información y cómo se puede colar por la velocidad de tu mano?
    *Respuesta: es una pista en los datos que separa las clases pero no tiene que ver con lo que quieres medir. Si pasas un tipo de pieza más rápido que otro, la duración las separa por tu mano y no por la pieza.*
10. Tu modelo llega al 98% de exactitud sin un solo error en el código. ¿Por qué puede estar mal?
    *Respuesta: puede haber aprendido una pista falsa. Ese error no se ve en los resultados, solo se ve si lo piensas antes.*
11. ¿Por qué se guarda en formato largo (una fila por muestra) y no una fila por ventana?
    *Respuesta: porque las ventanas no tienen que medir todas lo mismo. Una de 180 muestras y otra de 220 caben sin problema.*
12. ¿Para qué sirve `ser.reset_input_buffer()` antes de capturar cada ventana?
    *Respuesta: tira lo que llegó mientras esperabas el Enter. Sin eso la ventana empieza con muestras viejas y el evento sale corrido.*
13. ¿Por qué se abre el archivo en modo `'a'` y qué problema crea eso?
    *Respuesta: para no borrar lo capturado antes. El problema es que hay que averiguar en qué número de ventana te quedaste para no repetir números.*

### Semana 4: Limpieza y normalización de señales {#preguntas-s04}

**Fáciles**

1. ¿Qué es el ruido, qué es un valor atípico y qué es la deriva?
2. ¿Qué hace el filtro de media móvil?
3. ¿Para qué se corrige la línea base?

**De aplicación a tu proyecto**

4. ¿Qué tamaño de filtro elegiste y por qué, en relación con la duración de tu evento?
5. ¿Qué rango físico tiene tu sensor y qué valores descartaste por imposibles?
6. ¿Cuánto se movió tu línea base entre la primera y la última ventana de la sesión?
7. ¿Qué normalización elegiste, min-max o z-score, y por qué?
8. ¿Descartaste alguna ventana? ¿Cuál, cuántas y por qué lo dejaste anotado?

**Difíciles**

9. ¿Por qué el filtro se aplica ventana por ventana y no a toda la columna de un jalón?
    *Respuesta: si no, el final de una ventana se promedia con el inicio de la siguiente, que es otra pasada y a lo mejor otra clase.*
10. ¿Por qué los atípicos se quitan antes de filtrar?
    *Respuesta: el promedio móvil no borra un valor absurdo, lo reparte entre sus vecinos. Un pico feo se vuelve cinco muestras contaminadas.*
11. ¿Qué pasa si usas un filtro de tamaño 30 con un evento que dura 40 muestras?
    *Respuesta: aplana y deforma el evento, y puedes borrar justo la característica que distinguía tus clases.*
12. ¿Por qué se guardan el mínimo, el máximo, la media y la desviación que usaste para normalizar?
    *Respuesta: en producción hay que aplicar exactamente los mismos valores. Si se recalculan con otros datos, el modelo recibe un mundo distinto al que aprendió.*
13. Una ventana de madera de fin de sesión se parece más a una de metal del principio que a las de su propia clase. ¿Qué la causó y cómo se arregla?
    *Respuesta: la deriva de la línea base. Se arregla restándole a cada ventana su propio valor de reposo.*
14. ¿En qué orden se limpia la señal y por qué ese orden?
    *Respuesta: atípicos, filtro, línea base, normalización. Los atípicos antes del filtro porque el filtro los reparte; la línea base antes de normalizar para que todas arranquen desde cero.*

### Semana 5: Características en el dominio del tiempo {#preguntas-s05}

**Fáciles**

1. ¿Qué es una característica (feature)?
2. Nombra al menos cuatro características del dominio del tiempo.
3. ¿Cuántas filas tiene tu `features.csv` y qué representa cada una?

**De aplicación a tu proyecto**

4. ¿Qué características elegiste y por qué cada una debería distinguir tus clases, en tu dominio?
5. Enséñame tu diagrama de dispersión. ¿Qué par de características separa mejor tus clases?
6. ¿Cuál predijiste que sería la mejor y cuál la más inútil? ¿Acertaste?
7. Si dos de tus clases se encimaron, ¿qué decidiste hacer?

**Difíciles**

8. Dame tres problemas de darle al modelo la ventana completa en vez de características.
    *Respuesta: las ventanas no miden todas lo mismo y el clasificador pide filas del mismo largo; son demasiados números para tan pocos ejemplos (maldición de la dimensionalidad); la información está repetida entre muestras vecinas.*
9. ¿Por qué no conviene calcular todas las características posibles "por si acaso"?
    *Respuesta: cada característica es una dimensión más y las dimensiones cuestan. Hay que preguntarse si esa debería ser distinta entre mis clases.*
10. Tu clasificador acierta casi todo apoyándose en la duración y tu dominio no es de tamaño. ¿De qué sospechas?
    *Respuesta: de la velocidad de tu mano. Es la fuga de información de la semana 3.*
11. En la matriz de dispersión, dos características forman una diagonal perfecta. ¿Qué significa?
    *Respuesta: miden lo mismo. Una de las dos sobra.*
12. ¿Por qué conservas la columna `ventana` en `features.csv` si el modelo no la va a usar?
    *Respuesta: para poder rastrear un ejemplo raro de vuelta a la señal que lo produjo.*
13. ¿Por qué el rango es de las características más útiles?
    *Respuesta: es el máximo menos el mínimo, así que no le afecta la línea base.*

### Semana 6: Características en el dominio de la frecuencia {#preguntas-s06}

**Fáciles**

1. ¿Qué es la FFT y qué te devuelve?
2. Nombra las features espectrales que viste.
3. Si muestreas a 200 Hz, ¿hasta qué frecuencia llega tu espectro?
    *Respuesta: hasta 100 Hz, la mitad de la frecuencia de muestreo (Nyquist).*

**De aplicación a tu proyecto**

4. ¿Cuál es tu frecuencia de muestreo, cuál es tu frecuencia de Nyquist y qué significa eso para tu señal?
5. Calcula tu resolución en frecuencia con el largo de ventana que usas.
6. ¿Qué frecuencia dominante tiene tu señal y tiene sentido físico?
7. Enséñame la gráfica: ¿tus features de frecuencia separan tus clases? ¿Te las quedaste o las quitaste, y por qué?

**Difíciles**

8. ¿Qué es el aliasing y cómo lo sospecharías en tu espectro?
    *Respuesta: una frecuencia mayor a Nyquist no desaparece, aparece disfrazada de una frecuencia baja que no existe. Se sospecha de un pico sin explicación física.*
9. ¿Por qué se tira la primera barra del espectro, la de 0 Hz?
    *Respuesta: es el promedio de la señal, no una oscilación, y suele ser tan grande que aplasta todo lo demás.*
10. ¿Cómo consigues más detalle en frecuencia?
    *Respuesta: con ventanas más largas. La resolución es la frecuencia de muestreo entre el número de muestras.*
11. Tu espectro no separa nada. ¿Es un fracaso? ¿Qué haces?
    *Respuesta: no, es un resultado bien hecho. Enseñas la gráfica, escribes la razón física (tu evento es lento, tu sensor es lento) y quitas las features, porque características que no aportan sí estorban.*
12. Si tus ventanas miden distinto, ¿por qué no puedes meter las barras del espectro como características sueltas?
    *Respuesta: no corresponderían a las mismas frecuencias entre ventanas. La frecuencia dominante, el centroide y las bandas definidas en Hz sí son comparables.*
13. ¿Qué te dice un centroide espectral alto y uno bajo?
    *Respuesta: alto, mucho contenido rápido en la señal. Bajo, una señal lenta y suave.*

### Semana 7: Entrenamiento del clasificador {#preguntas-s07}

**Fáciles**

1. ¿Qué son `X` y `y`?
2. ¿Qué significa entrenar un modelo?
3. ¿Qué te muestra una matriz de confusión que no te muestra la exactitud?

**De aplicación a tu proyecto**

4. ¿Con cuántos ejemplos entrenaste y con cuántos probaste?
5. ¿Qué algoritmo usaste y por qué, en función de tu caso?
6. Enséñame tu matriz de confusión. ¿Qué par de clases se confunde más y por qué crees que pasa?
7. ¿El resultado coincidió con lo que predijiste al ver la separación de tus clases en la semana 6?
8. Si usaste un árbol, léeme las reglas que aprendió. ¿Tienen sentido físico?

**Difíciles**

9. ¿Por qué un modelo que acierta 100% en los datos de entrenamiento puede ser inútil?
    *Respuesta: puede haber memorizado. Lo que importa es que acierte en piezas que nunca vio, o sea, que generalice. Un k-NN con k=1 acierta 100% en sus propios datos siempre.*
10. ¿Por qué la partición entrenamiento/prueba es estratificada?
    *Respuesta: para que la proporción de clases sea la misma en las dos partes. Si no, el azar puede dejar todo el metal en prueba y el modelo nunca lo vio.*
11. ¿Por qué `fit_transform` en entrenamiento pero solo `transform` en prueba?
    *Respuesta: el escalador debe calcular su media y desviación solo con los datos de entrenamiento. Si lo ajustas con los de prueba, usas información que el modelo no debería tener y la medición sale inflada, sin dar error.*
12. ¿Por qué la columna `ventana` sale de `X`?
    *Respuesta: es un identificador, no una característica. El modelo podría aprender que "las ventanas del 0 al 29 son madera", cierto en tu archivo e inútil en la realidad.*
13. ¿Por qué k-NN necesita estandarizar y un árbol no?
    *Respuesta: k-NN usa distancias, y una característica con números enormes domina. El árbol hace preguntas sobre una característica a la vez y no le importa la escala.*
14. ¿Por qué se guarda el escalador junto con el modelo en `modelo.pkl`?
    *Respuesta: sin él, en producción escalarías con otros números y el modelo respondería cualquier cosa sin marcar error.*
15. Con 18 ejemplos de prueba, ¿hay diferencia real entre 0.83 y 0.89 de exactitud?
    *Respuesta: prácticamente no. Con tan pocos ejemplos, un acierto más o menos cambia mucho el número.*

### Semana 8: Redes neuronales y primer bucle de control {#preguntas-s08}

**Fáciles**

1. ¿Qué hace una neurona artificial?
2. ¿Para qué sirve una función de activación como ReLU?
3. ¿Cómo le manda Python una orden al Arduino y por qué es un solo carácter?

**De aplicación a tu proyecto**

4. Enséñame tu tabla de acciones: carácter, clase, qué hace tu actuador y por qué esa acción tiene sentido en tu dominio.
5. ¿Qué modelo se quedó en tu sistema, el de la semana 7 o la red? Dame tus números de entrenamiento y prueba.
6. Enséñame en `control.py` dónde limpias y dónde calculas características. ¿Hacen exactamente lo mismo que tus scripts de entrenamiento?
7. ¿Tu bucle funcionó al primer intento en vivo? Si no, ¿qué estaba mal y cómo lo encontraste?

**Difíciles**

8. Tu red salió peor que el modelo de la semana 7. ¿Fracasaste?
    *Respuesta: no. Con 90 ejemplos un árbol o un k-NN suelen igualar o ganarle a una red, y además se pueden explicar. "Porque es inteligencia artificial" no es una razón para elegir un modelo.*
9. ¿Por qué hacen falta capas ocultas, y por qué la activación no puede ser lineal?
    *Respuesta: las capas permiten combinar y curvar las fronteras. Con activación lineal, la composición de capas sigue siendo lineal y toda la red colapsa a una sola neurona.*
10. ¿Qué es el *training-serving skew* y cómo se evita?
    *Respuesta: es aplicar en producción un procesamiento distinto al del entrenamiento (por ejemplo filtro de tamaño 9 en vez de 5). El modelo falla sin dar ningún error. Se evita no duplicando código: un módulo que importen tanto el entrenamiento como el control.*
11. En el CSV tu modelo acierta 90% y en vivo se equivoca la mitad. ¿Cuál es el primer sospechoso y cómo lo cazas?
    *Respuesta: `limpiar()` o `calcular_features()` de `control.py` no hacen exactamente lo mismo que los scripts originales. Se imprime el vector de características que produce `control.py` y se compara número por número con la fila de `features.csv` de la misma ventana.*
12. ¿Por qué se prueba la flecha de regreso sola (mandar `A`, `B`, `C` desde el Monitor Serie) antes de meter el modelo?
    *Respuesta: para depurar por partes. Si el servo no se mueve, el problema es de hardware o de protocolo, y hay que resolverlo antes de agregar nada más.*
13. ¿Qué etapa de tu bucle tarda más y qué consecuencia tiene?
    *Respuesta: casi siempre la captura, porque hay que esperar físicamente a que pasen las muestras. Predecir tarda menos de un milisegundo. El cuello de botella no es la inteligencia artificial, es la adquisición.*
