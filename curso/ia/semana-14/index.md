---
layout: default
title: Inteligencia Artificial
---
[Inicio](/curso/ia)

# Semana 14 - Revisión de avances 2

Cierre de la Unidad 3 (Aprendizaje No Supervisado).

## Antes de la clase (entrega previa)

Haz push a GitHub de tus evidencias y tu `BITACORA.md` antes del día de la revisión. Si no hay push a tiempo, la revisión cuenta como no entregada.

Tu sistema debe:

- Proyectar tus características con PCA y reportar la varianza explicada.
- Agrupar las piezas con K-Means y DBSCAN, comparando los grupos contra las etiquetas reales.
- Detectar piezas anómalas con un autoencoder y un umbral justificado con tus datos.
- Reaccionar a la anomalía dentro del bucle de control.

Equipos: cada integrante actualiza y hace push de su autoevaluación privada (`<codigo>.csv`) antes de la revisión.

## Durante la clase (revisión)

La sesión se dedica a las preguntas (orales o escritas): una sobre tu trabajo y otra sobre los temas vistos. Se revisan las prácticas y el proyecto integrador.

## Lo que se evalúa

- Prácticas: evidencias 50%, BITACORA.md 30%, preguntas 20%.
- Proyecto integrador: evidencias 45%, BITACORA.md 25%, preguntas 20%, autoevaluación entre pares 10%.

---

## Preguntas de revisión {#preguntas-de-revision}

Banco de preguntas de la revisión de avances 2 (semana 14). Son las mismas que están al final de cada una de las semanas 10 a 13, juntas aquí para que estudies de corrido. En la revisión te puedo hacer cualquiera de ellas, variarlas, o preguntar directo sobre tu propio código. El instrumento completo está en [Prácticas](/curso/ia/evaluacion/individual).

### Semana 10: Aprendizaje no supervisado y PCA {#preguntas-s10}

**Fáciles**

1. ¿Cuál es la diferencia entre aprendizaje supervisado y no supervisado?
2. ¿Qué busca PCA?
3. ¿Qué te dice la varianza explicada de una componente?

**De aplicación a tu proyecto**

4. ¿Cuántas características tiene tu `features.csv` y qué porcentaje de varianza explican tus dos primeras componentes?
5. Enséñame tu gráfica de PCA. ¿Tus clases se separan solas? ¿Qué significa que sí o que no?
6. ¿Qué piezas raras capturaste y qué respondió tu clasificador ante ellas?
7. ¿Dónde caen tus piezas raras en el plano de PCA, fuera de tus tres grupos o camufladas dentro de alguno?
8. ¿Viste algún punto atípico? ¿Cuál ventana era y qué encontraste al graficar su señal?

**Difíciles**

9. ¿Por qué estandarizar es obligatorio antes de PCA?
    *Respuesta: PCA busca varianza y la varianza depende de la escala. Una característica con números de millones se llevaría la primera componente solo por tener números grandes, no por tener más información.*
10. ¿Se usan las etiquetas para calcular PCA? Entonces, ¿para qué las usas en la gráfica?
    *Respuesta: no se usan. PCA es no supervisado. Las etiquetas solo sirven para pintar los puntos después y juzgar el resultado.*
11. En el plano de PCA tus clases se mezclan. ¿Significa que tu clasificador va a ser malo?
    *Respuesta: no necesariamente. PCA busca la dirección de mayor varianza, no la de mayor separación entre clases. Lo que más varía puede ser algo que no distingue piezas, como el ruido de fondo.*
12. ¿Qué es la maldición de la dimensionalidad?
    *Respuesta: al crecer las dimensiones, tus ejemplos quedan lejos de todos y la idea de "vecino cercano" pierde sentido. Con más dimensiones que ejemplos, cualquier modelo separa perfecto el entrenamiento y falla con lo demás.*
13. ¿Por qué PCA gana en visualización y pierde en interpretación?
    *Respuesta: cada componente es una mezcla de todas las características, no una característica en sí. Es un intercambio consciente.*
14. ¿Qué responde tu clasificador de la semana 7 ante un objeto que no es de ninguna de tus clases, y por qué eso es un problema?
    *Respuesta: responde con seguridad una de las tres, porque es lo único que sabe decir. Una pieza defectuosa podría pasar como buena.*

### Semana 11: Agrupamiento: K-Means y DBSCAN {#preguntas-s11}

**Fáciles**

1. ¿Qué es agrupar (clustering)?
2. ¿Cuáles son los pasos de K-Means?
3. ¿Qué dos parámetros tiene DBSCAN y qué controla cada uno?

**De aplicación a tu proyecto**

4. Enséñame tu tabla cruzada. ¿K-Means encontró tus clases por su cuenta?
5. ¿Qué `eps` elegiste y cómo lo elegiste? ¿Cuántos grupos y cuántos puntos de ruido salieron?
6. De tus piezas raras, ¿cuántas marcó DBSCAN como ruido?
7. ¿Qué te enseñó el agrupamiento sobre tu problema que tus etiquetas no te habían dicho?

**Difíciles**

8. Dame tres limitaciones de K-Means.
    *Respuesta: hay que decirle cuántos grupos buscar; todo punto acaba en algún grupo, no existe "ninguno"; prefiere grupos redondos y del mismo tamaño.*
9. ¿Por qué DBSCAN puede detectar anomalías y K-Means no?
    *Respuesta: en DBSCAN un grupo es una zona densa, así que un punto en una zona vacía no pertenece a ninguno y queda como ruido (`-1`). K-Means obliga a asignar cada punto a un grupo.*
10. ¿Qué tipos de punto distingue DBSCAN?
    *Respuesta: núcleo (tiene al menos `min_samples` vecinos dentro de `eps`), frontera (pocos vecinos pero dentro del radio de un núcleo) y ruido (ninguna de las dos).*
11. ¿Qué pasa si `eps` es muy chico? ¿Y si es muy grande?
    *Respuesta: muy chico, casi todo es ruido. Muy grande, todo es un solo grupo gigante y no hay ruido.*
12. K-Means te dice que un punto es del grupo 0. ¿Eso quiere decir que es madera?
    *Respuesta: no. Los números de los grupos no significan nada. Se compara la estructura de la tabla cruzada, no los números.*
13. En tu tabla cruzada, el plástico cae completo en un grupo y la madera y el metal se reparten parejo entre otros dos. ¿Qué te dice?
    *Respuesta: el plástico es genuinamente distinto, pero la madera y el metal no se distinguen con tus características. La división que encontró K-Means puede ser otra cosa, por ejemplo el inicio contra el final de la sesión.*
14. DBSCAN no marcó tus piezas raras como ruido. ¿Qué significa?
    *Respuesta: se parecen demasiado a las normales en el espacio de tus características. Es justo el problema que ataca el autoencoder.*

### Semana 12: Autoencoders para detección de anomalías {#preguntas-s12}

**Fáciles**

1. ¿Qué es un autoencoder?
2. ¿Qué es el error de reconstrucción?
3. ¿Qué es el cuello de botella de un autoencoder?

**De aplicación a tu proyecto**

4. ¿Qué umbral elegiste y por qué ese percentil, en función de tu proceso?
5. Enséñame tus dos histogramas. ¿Qué tan separadas quedaron las piezas normales y las anómalas?
6. ¿Cuántas piezas raras detectó tu autoencoder comparado con DBSCAN? ¿Y cuántas falsas alarmas dio?
7. ¿Qué tipo de anomalía detecta bien tu sistema y cuál se le escapa?

**Difíciles**

8. ¿Por qué obligar a la red a pasar por un cuello de botella es lo que hace que el truco funcione?
    *Respuesta: sin cuello de botella la red solo copiaría. Obligada a comprimir, tiene que descubrir las direcciones que resumen tus datos. Lo que no se parece a lo aprendido se reconstruye mal.*
9. ¿Por qué el autoencoder se entrena solo con piezas normales? ¿Qué pasaría si le metieras también las anómalas?
    *Respuesta: tiene que aprender cómo es lo normal. Si ve anómalas, aprende a reconstruirlas también y dejan de dar un error alto.*
10. ¿Por qué no entrenas un clasificador con una cuarta clase llamada "anomalía"?
    *Respuesta: no sabes cómo van a ser las anomalías. Va a aparecer algo que no imaginaste y el clasificador lo metería en la clase que más se le parezca. El autoencoder aprende lo normal y marca todo lo que se sale de eso.*
11. ¿Por qué el umbral se calcula con datos de validación y no con los de entrenamiento?
    *Respuesta: en entrenamiento la red reconstruye demasiado bien, el umbral saldría muy bajo y todo dispararía alarma.*
12. Subes el umbral. ¿Qué cambia?
    *Respuesta: hay menos falsas alarmas, pero se escapan más anomalías. Bajarlo hace lo contrario. Cuál conviene depende de qué le cuesta más a tu proceso.*
13. ¿Qué pasa con un cuello de botella muy chico y con uno muy grande?
    *Respuesta: muy chico, la red reconstruye mal hasta lo normal y las dos poblaciones se juntan. Muy grande, aprende a copiar y reconstruye bien cualquier cosa, incluidas las anomalías. El criterio para elegir es la mayor separación entre poblaciones, no el menor error.*
14. ¿Por qué DBSCAN no sirve como detector en producción?
    *Respuesta: necesita ver todo el conjunto de datos junto para decidir, y en la banda las piezas llegan de una en una. El autoencoder juzga una pieza sola, en un milisegundo.*

### Semana 13: La anomalía como señal de control {#preguntas-s13}

**Fáciles**

1. ¿Qué es el umbral de rechazo con `predict_proba`?
2. ¿Cuáles son los dos mecanismos para que tu sistema reconozca que no sabe, y qué detecta cada uno?
3. ¿Qué hace tu sistema cuando detecta una anomalía?

**De aplicación a tu proyecto**

4. Dibújame el diagrama de decisión de tu sistema completo, con tus clases y tus acciones.
5. ¿Por qué esa acción de rechazo y no otra, en tu dominio? ¿Cómo se distingue de las tres acciones normales?
6. Enséñame tu tabla de medición en vivo: clasificación, detección de anomalías y falsas alarmas.
7. ¿Qué anomalía se le escapó a tu sistema y por qué crees que fue?
8. ¿Tuviste falsas alarmas seguidas en vivo? ¿Qué las causaba?

**Difíciles**

9. ¿Por qué primero se pregunta si la pieza es anómala y solo después se clasifica?
    *Respuesta: clasificar algo que no pertenece a ninguna de tus clases es trabajo desperdiciado y da un resultado basura que podrías usar por error. Es lo que hace un operador competente: primero mira si el objeto le resulta familiar.*
10. ¿Por qué la confianza del clasificador no basta para detectar piezas desconocidas?
    *Respuesta: un modelo puede estar muy seguro y muy equivocado. La confianza mide qué tan lejos está el punto de la frontera entre clases, no qué tan lejos está de todo lo que ha visto.*
11. Dame un ejemplo, de tu dominio, de una pieza que pasaría el detector de anomalías pero debería rechazarse por baja confianza.
    *Respuesta: una pieza normal pero que cae justo entre dos de tus clases, cerca de la frontera. Se parece a lo conocido, pero el clasificador no sabe de cuál es.*
12. ¿Por qué el detector es más sensible que el clasificador a un procesamiento distinto entre entrenamiento y control?
    *Respuesta: su trabajo es notar lo que se sale de lo aprendido. Una diferencia pequeña en el procesamiento se le presenta como algo desconocido y dispara falsas alarmas.*
13. ¿Por qué el clasificador y el detector tienen cada uno su propio escalador y su propia lista de columnas?
    *Respuesta: son dos paquetes independientes. Usar el escalador del clasificador en el detector daría resultados sin sentido.*
14. ¿Qué es la deriva del modelo y por qué se reentrenan los modelos en la industria?
    *Respuesta: es que el error de reconstrucción de las piezas normales sube con el tiempo, no porque la pieza cambie, sino porque el sistema se desajusta (sensor sucio, luz, desgaste). Por eso se reentrenan periódicamente.*
15. ¿En qué se parece y en qué se diferencia lo que hace tu detector de lo que hace tu clasificador?
    *Respuesta: los dos son modelos que deciden sobre la misma ventana. El clasificador aprende a separar las clases que conoce y siempre responde algo; el detector aprende cómo es lo normal y puede decir que no reconoce nada.*
