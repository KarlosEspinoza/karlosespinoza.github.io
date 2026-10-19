---
layout: default
title: Inteligencia Artificial
---
[Inicio](/curso/ia)

# Semana 17 - Revisión final

Cierre de la Unidad 4 (Evaluación y Despliegue) y entrega final del sistema completo.

## Antes de la clase (entrega previa)

Haz push a GitHub de la entrega final (evidencias y `BITACORA.md`) antes del día de la revisión. Si no hay push a tiempo, la revisión cuenta como no entregada.

Tu sistema debe:

- Clasificar las piezas con un modelo validado por validación cruzada y con hiperparámetros justificados.
- Detectar piezas anómalas y reaccionar ante ellas dentro del bucle.
- Correr el bucle completo sobre la maqueta: sensores -> Python -> modelo -> PLC -> banda y pistón.
- `BITACORA.md` con una sección por cada unidad del curso, explicando cómo se aplica ese concepto en tu sistema.

Equipos: integran los módulos de cada integrante en el controlador central y presentan el clasificador multi-dominio completo sobre la maqueta. Cada integrante hace push de su autoevaluación final (`<codigo>.csv`).

## Durante la clase (revisión)

La sesión se dedica a la demostración del bucle de control sobre la maqueta y a las preguntas (orales o escritas). Cerramos con un panorama de frontera: Physical AI, modelos fundacionales y aprendizaje por refuerzo en robótica.

## Lo que se evalúa

- Prácticas: evidencias 50%, BITACORA.md 30%, preguntas 20%.
- Proyecto integrador: evidencias 45%, BITACORA.md 25%, preguntas 20%, autoevaluación entre pares 10%.

---

## Preguntas de revisión {#preguntas-de-revision}

Banco de preguntas de la revisión final (semana 17). Son las mismas que están al final de cada una de las semanas 15 a 16, juntas aquí para que estudies de corrido. En la revisión te puedo hacer cualquiera de ellas, variarlas, o preguntar directo sobre tu propio código. El instrumento completo está en [Prácticas](/curso/ia/evaluacion/individual).

### Semana 15: Evaluación del modelo {#preguntas-s15}

**Fáciles**

1. ¿Qué son la exactitud, la precisión, la exhaustividad (recall) y el F1?
2. ¿Qué es un verdadero positivo, un falso positivo, un falso negativo y un verdadero negativo?
3. ¿Qué es la validación cruzada de k pliegues?

**De aplicación a tu proyecto**

4. Para tu sistema, dame un ejemplo de falso positivo y uno de falso negativo. ¿Cuál te duele más y por qué?
5. Con esa respuesta, ¿subirías o bajarías el umbral de tu detector de anomalías?
6. ¿Cuál es tu exactitud con su desviación estándar? ¿Subió o bajó respecto a la que reportabas en la semana 7?
7. Enséñame tu `classification_report`. ¿Cuál es la clase más débil de tu sistema?
8. Calcula a mano la precisión y la exhaustividad de una de tus clases con tu matriz de confusión.
9. ¿Qué exactitud dio tu modelo sobre `datos_banda.csv` comparada con tus datos de escritorio?

**Difíciles**

10. ¿Por qué la exactitud engaña con clases desbalanceadas?
    *Respuesta: si el 95% de las piezas son buenas, un modelo que responde "buena" siempre tiene 95% de exactitud y no detecta ni un solo defecto, que era lo único que se le pedía.*
11. ¿Por qué el F1 usa promedio armónico y no aritmético?
    *Respuesta: porque castiga los desequilibrios. Con precisión 1.0 y exhaustividad 0.0, el promedio normal daría 0.5 y el F1 da 0, que es lo correcto porque ese modelo no sirve.*
12. Dos modelos tienen 0.87 de exactitud promedio, uno con desviación 0.04 y otro con 0.19. ¿Cuál prefieres?
    *Respuesta: el primero. El segundo es un volado, va del 68% al 100% según los datos que le toquen. Nunca se reporta una exactitud sin su desviación.*
13. ¿Por qué tu 0.89 de la semana 7 no es "la exactitud de tu modelo"?
    *Respuesta: salió de una sola partición con `random_state=42`. Con 18 ejemplos de prueba, un ejemplo más o menos cambia la exactitud 5 puntos. Con otra partición habría salido otro número.*
14. ¿Por qué el pipeline es obligatorio en la validación cruzada?
    *Respuesta: si estandarizas antes de partir en pliegues, el escalador usa todos los datos, incluidos los de prueba de cada ronda, y esa información se filtra al entrenamiento. Con el pipeline se ajusta solo con los datos de entrenamiento de cada ronda.*
15. Precisión y exhaustividad se mueven en direcciones opuestas. ¿Cómo lo ves en el umbral de tu detector?
    *Respuesta: bajar el umbral detecta más anomalías (sube la exhaustividad) pero dispara más falsas alarmas (baja la precisión). Subirlo hace lo contrario. No hay ajuste que mejore las dos; se elige según el proceso.*
16. En la curva de aprendizaje, la curva de validación sigue subiendo al llegar al final. ¿Qué te dice?
    *Respuesta: te faltan datos. Capturar más ventanas es la inversión más rentable.*

### Semana 16: Sobreajuste y preparación para producción {#preguntas-s16}

**Fáciles**

1. ¿Qué es el sobreajuste y cómo se diagnostica con dos números?
2. ¿Qué contiene el paquete `modelo_produccion.pkl`?
3. ¿Con qué PLC y con qué biblioteca se comunica tu Python en la maqueta?

**De aplicación a tu proyecto**

4. Dame tus tres exactitudes juntas: entrenamiento, validación cruzada y banda.
5. Enséñame `figuras/desajuste.png`. ¿Qué características cambiaron más entre tu escritorio y la banda?
6. ¿Cuál es tu diagnóstico: sobreajuste, desajuste de distribución, o los dos? ¿Hay evidencia de que tu modelo aprendía la velocidad de tu mano?
7. ¿Quitaste alguna característica al reentrenar con datos de la banda? ¿Cuál y por qué?
8. ¿Alcanza tu sistema el tiempo de ciclo de la banda? Respóndeme con números.
9. ¿Cómo conectaste tu PC al PLC? ¿Qué IP tiene tu PC y cuál el PLC?

**Difíciles**

10. Tu modelo tiene 0.91 en entrenamiento y 0.87 en validación cruzada, y 0.50 en la banda. ¿Es sobreajuste?
    *Respuesta: no, el modelo está sano. Es desajuste de distribución: los datos de la banda vienen de otro proceso (el motor en vez de tu mano, velocidad constante, vibración, otra distancia, otra luz).*
11. ¿Por qué la duración dejó de servir en la banda?
    *Respuesta: en la banda la velocidad es constante, así que todas las piezas duran lo mismo. La característica dejó de discriminar y al modelo le quitaron el suelo.*
12. Dame las tres salidas ante un desajuste de distribución.
    *Respuesta: reentrenar con datos de la banda (la correcta); quitar las características frágiles; recapturar más datos si 10 ventanas por clase no alcanzan.*
13. ¿Por qué el paquete de producción guarda el orden exacto de las columnas?
    *Respuesta: pandas puede armar el vector en otro orden y el modelo leería la energía donde esperaba la duración, sin marcar ningún error. Solo respondería mal.*
14. ¿Por qué "el modelo se entrena con datos del mismo mundo donde va a operar"? ¿Cómo se conecta eso con lo que hiciste en la semana 3?
    *Respuesta: un modelo solo conoce el proceso que generó sus datos. Si moviste cada tipo de pieza a distinta velocidad con la mano, aprendió tu mano, y en la banda tu mano no existe.*
15. ¿Por qué no se escribe una dirección del PLC sin confirmarla antes?
    *Respuesta: leer es inofensivo, escribir mueve motores y pistones de verdad. Un bit equivocado puede arrancar la banda con alguien con la mano dentro.*
16. Haces `ping 192.168.0.1` y falla siempre, y tu PC tiene una IP `169.254.x.x`. ¿Qué pasó?
    *Respuesta: la IP quedó en automático y el PLC no reparte direcciones. Hay que ponerla fija a mano, por ejemplo `192.168.0.20` con máscara `255.255.255.0`.*
17. La latencia de tu bucle es 3.4 s y la banda trae una pieza cada 2.5 s. ¿Qué haces?
    *Respuesta: acortar la ventana (casi siempre es el cuello de botella), procesar mientras capturas, y solo al final simplificar el modelo, que es lo que menos ayuda. Se mide antes de optimizar.*
