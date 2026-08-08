---
layout: default
title: Configuracion del entorno - Sistemas Operativos
---
[Inicio](/curso/so)


---

- [Video](#video)
- [Lo que necesitas](#lo-que-necesitas)
- [Pasos](#pasos)
    - [Paso 1 - Instalar WSL2](#paso-1)
    - [Paso 2 - Instalar Java JDK 21](#paso-2)
    - [Paso 3 - Instalar Git y GitHub CLI](#paso-3)
    - [Paso 4 - Configurar tu nombre y correo en Git](#paso-4)
    - [Paso 5 - Crear cuenta en GitHub](#paso-5)
    - [Paso 6 - Autenticar GitHub desde la terminal](#paso-6)
    - [Paso 7 - Elegir tu dominio y registrarlo](#paso-7)
    - [Paso 8 - Crear tu repositorio desde la plantilla](#paso-8)
    - [Paso 9 - Clonar tu repositorio en WSL2](#paso-9)
    - [Paso 10 - Verificar que el proyecto compila](#paso-10)
    - [Paso 11 - Editar README.md y BITACORA.md](#paso-11)
    - [Paso 12 - Primer commit y push](#paso-12)
    - [Paso 13 - Entregar en Google Classroom](#paso-13)
- [Verificacion final](#verificacion-final)
- [Preguntas frecuentes](#preguntas-frecuentes)

---

# Configuracion del entorno

Esta actividad se hace **antes de la sesion 2**, de forma asincrona.
No se realiza en clase.

El video te guia paso a paso. Las instrucciones escritas estan debajo como referencia.
Al terminar tendras tu entorno de desarrollo listo y tu repositorio del proyecto creado.

---

## Video {#video}

*(Video pendiente de publicacion -- se anunciara por Google Classroom)*

---

## Lo que necesitas {#lo-que-necesitas}

| Requisito | Para que sirve |
|---|---|
| Laptop con Windows 10 u 11 | tu equipo de trabajo |
| WSL2 (Linux dentro de Windows) | el SO sobre el que corre todo el curso |
| Java JDK 21 o superior | lenguaje del proyecto |
| Git y GitHub CLI (`gh`) | control de versiones y entrega de evidencias |
| Cuenta en GitHub | aloja tu repositorio del proyecto |
| Visual Studio Code | editor de codigo |

Todo se instala en los pasos de abajo. No necesitas tener nada listo de antemano.

---

## Pasos {#pasos}

### Paso 1 - Instalar WSL2 {#paso-1}

Abre **PowerShell como administrador** y ejecuta:

```powershell
wsl --install
```

Reinicia la computadora si te lo pide. La primera vez, Ubuntu te pedira
crear un usuario y contrasena de Linux (apuntala, la usaras para `sudo`).

Para verificar, abre la terminal de **Ubuntu** y escribe:

```bash
uname -a
```

Debe aparecer algo como `Linux ... microsoft ...`.

> A partir de aqui, **todos los comandos se escriben dentro de la terminal de Ubuntu (WSL2)**,
> salvo que se indique lo contrario.

---

### Paso 2 - Instalar Java JDK 21 {#paso-2}

```bash
sudo apt update
sudo apt install openjdk-21-jdk -y
java -version
```

El ultimo comando debe mostrar `openjdk version "21..."`.

---

### Paso 3 - Instalar Git y GitHub CLI {#paso-3}

```bash
sudo apt install git -y
sudo apt install gh -y
git --version
gh --version
```

Si `gh` no se instala con el comando anterior (en algunas versiones de Ubuntu),
ejecuta este bloque una sola vez y vuelve a intentar `sudo apt install gh -y`:

```bash
sudo mkdir -p -m 755 /etc/apt/keyrings
wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null
sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
```

---

### Paso 4 - Configurar tu nombre y correo en Git {#paso-4}

Esto identifica tus commits. Usa tu nombre real y tu correo:

```bash
git config --global user.name "Tu Nombre Completo"
git config --global user.email "tu.correo@alumnos.udg.mx"
git config --list
```

---

### Paso 5 - Crear cuenta en GitHub {#paso-5}

Si ya tienes cuenta, salta este paso.

1. Ve a [github.com](https://github.com) en tu navegador de Windows.
2. Haz clic en **Sign up**.
3. Usa tu correo y elige un nombre de usuario profesional (por ejemplo: `karlos-espinoza`).

---

### Paso 6 - Autenticar GitHub desde la terminal {#paso-6}

Este paso conecta tu terminal con tu cuenta de GitHub usando el navegador
(donde ya iniciaste sesion). **No uses contrasena**, GitHub ya no la acepta para git.

```bash
gh auth login
```

Responde:
- **Where do you use GitHub?** -> `GitHub.com`
- **Preferred protocol?** -> `HTTPS`
- **Authenticate Git with your GitHub credentials?** -> `Yes`
- **How would you like to authenticate?** -> `Login with a web browser`

Copia el codigo de 8 caracteres que aparece, presiona Enter, autoriza en el
navegador y pega el codigo. Al terminar, asegura que git use estas credenciales:

```bash
gh auth setup-git
```

Con esto, los `git push` siguientes ya no te pediran usuario ni contrasena.

---

### Paso 7 - Elegir tu dominio y registrarlo {#paso-7}

Tu proyecto es un **Servidor de Pedidos** para un dominio de negocio que tu eliges
(restaurante, farmacia, libreria, taller, renta de equipo, estacionamiento, veterinaria, etc.).

**Dos alumnos no pueden tener el mismo dominio.** Registra el tuyo con el asesor
durante la primera semana (se confirma por orden de registro).

Los detalles estan en [Prácticas](/curso/so/evaluacion/practicas).

---

### Paso 8 - Crear tu repositorio desde la plantilla {#paso-8}

1. Abre la plantilla: [github.com/KarlosEspinoza/so-proyecto-template](https://github.com/KarlosEspinoza/so-proyecto-template)
2. Haz clic en **Use this template** -> **Create a new repository**.
3. Nombre del repositorio: `so-proyecto`
4. Visibilidad: **Public**.
5. Haz clic en **Create repository**.

---

### Paso 9 - Clonar tu repositorio en WSL2 {#paso-9}

Copia la URL de tu repositorio desde GitHub (boton verde **Code** -> HTTPS).

```bash
cd ~
git clone https://github.com/tu-usuario/so-proyecto.git
cd so-proyecto
```

---

### Paso 10 - Verificar que el proyecto compila {#paso-10}

La plantilla ya trae un servidor minimo. Compruebalo:

```bash
cd src
javac ServidorPedidos.java
java ServidorPedidos
cd ..
```

Debe imprimir `Servidor listo.`. Si lo ves, tu entorno de Java funciona.

---

### Paso 11 - Editar README.md y BITACORA.md {#paso-11}

Abre VS Code desde la carpeta del proyecto:

```bash
code .
```

> La primera vez, VS Code instalara su componente para WSL automaticamente.
> Si no abre, instala **Visual Studio Code** en Windows y la extension **WSL**
> desde el marketplace de VS Code.

En `README.md` rellena tu nombre y tu dominio elegido.

En `BITACORA.md` completa la entrada de la **Semana 1**: que instalaste,
que dominio elegiste y por que.

---

### Paso 12 - Primer commit y push {#paso-12}

```bash
git add .
git commit -m "inicio: configuracion del entorno y primer push"
git push
```

Gracias al Paso 6, el push no te pedira credenciales.

---

### Paso 13 - Entregar en Google Classroom {#paso-13}

1. Abre Google Classroom.
2. Busca la tarea **Tarea 0 - URL del repositorio**.
3. Pega la URL de tu repositorio (por ejemplo: `https://github.com/tu-usuario/so-proyecto`).
4. Entrega.

**Solo entregas la URL una vez.** Todas las revisiones del semestre se hacen sobre el mismo repositorio actualizado.

---

## Verificacion final {#verificacion-final}

Antes de entregar, revisa que tu repositorio en GitHub muestre:

- `README.md` con tu nombre y tu dominio elegido
- `BITACORA.md` con la entrada de la Semana 1
- `src/ServidorPedidos.java` (lo compilaste y corrio: `Servidor listo.`)
- `catalogo.txt` presente
- Al menos un commit con un mensaje descriptivo

---

## Preguntas frecuentes {#preguntas-frecuentes}

**No tengo internet estable en casa, que hago?**  
`git commit` funciona sin conexion; solo `git push` necesita internet.
Puedes ir guardando commits y subirlos todos juntos cuando tengas conexion.

**Mi computadora no soporta WSL2, que hago?**  
Avisame antes de la sesion 2. Hay opciones alternativas (maquina virtual o una computadora del laboratorio).

**Al hacer `git push` me pide usuario y contrasena.**  
No completaste el Paso 6. Ejecuta `gh auth login` (responde **Yes** a "Authenticate Git with your GitHub credentials")
y luego `gh auth setup-git`. Despues el push funciona sin pedir nada.

**`javac` o `java` no se reconocen.**  
No quedo instalado el JDK (Paso 2) o lo instalaste en Windows en vez de WSL2.
Todos los comandos del curso van dentro de la terminal de Ubuntu. Repite el Paso 2.

**`code .` no abre VS Code.**  
Instala VS Code en Windows (no en WSL2) y agrega la extension **WSL** desde el marketplace de VS Code.
