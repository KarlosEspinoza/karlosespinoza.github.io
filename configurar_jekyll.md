# Jekyll

## 1. Editar el `Gemfile` del proyecto

Abre `~/gh/karlosespinoza.github.io/Gemfile` y ajusta las líneas de Jekyll y Sass.

### 1.1. Asegura estas líneas (al inicio, después de `source`)

Deja algo así:

```ruby
source "https://rubygems.org"

gem "jekyll", "~> 4.4"                # subir jekyll a 4.4.x
gem "jekyll-sass-converter", "~> 3.0" # usa sass-embedded en lugar de sassc
gem "sass-embedded", "~> 1.93"        # motor Sass moderno
gem "csv", "~> 3.3"                   # para el warning de Ruby 3.4
gem "webrick", "~> 1.9"               # necesario en Ruby 3.x

# resto de gems que ya tengas:
# gem "html-proofer", ...
# gem "rubocop", ...
# gem "jekyll-seo-tag", ...
# gem "jekyll-sitemap", ...
# gem "jemoji", ...
```

Puntos importantes:

* **Si tu Gemfile ya tiene `gem "jekyll"`**, cambia su versión a `"~> 4.4"` como arriba.

* **Si tu Gemfile no tiene `jekyll-sass-converter`**, agrega la línea:

  ```ruby
  gem "jekyll-sass-converter", "~> 3.0"
  ```

* **No debe haber ninguna línea que diga:**

  ```ruby
  gem "sassc"
  ```

  Si existe, elimínala.

> Si por algún motivo tu Gemfile tuviera `gem "github-pages"`, esa es otra historia (porque `github-pages` fija su propia versión de Jekyll y plugins). Por lo que se ve en los logs, no parece el caso, así que sigo con la receta “sin github-pages”.

---

## 2. Borrar el bundle viejo para este proyecto

Así nos aseguramos de que no quede rastro de `sassc` dentro de `vendor/bundle`.

```bash
cd ~/gh/karlosespinoza.github.io
rm -rf vendor/bundle
```

---

## 3. Aislar dependencias del repo (ya lo hiciste, pero lo reafirmamos)

```bash
bundle config set --local path 'vendor/bundle'
```

Esto hace que **todo** lo que instale Bundler para este sitio viva en `./vendor/bundle`, independiente del resto del sistema.

---

## 4. Instalar de nuevo las dependencias con las versiones nuevas

Ahora sí:

```bash
bundle install
```

Aquí es donde queremos ver que *ya no* aparezca:

* `Installing jekyll-sass-converter 2.2.0`
* `Installing sassc 2.4.0`

Sino que idealmente veas algo como:

* `Installing jekyll 4.4.x`
* `Installing jekyll-sass-converter 3.x`
* `Installing sass-embedded 1.93.x`

Si por restricciones de alguna otra gem Bundler no pudiera subir a `jekyll-sass-converter 3.x`, te marcaría un conflicto de versiones en este paso (y ese mensaje sería el siguiente que habría que revisar). Pero con lo que has enseñado, no parece haber nada que lo bloquee.

---

## 5. Verificar la versión de Jekyll y el conversor

Opcional pero útil:

```bash
bundle exec jekyll -v
```

Debería mostrar algo tipo:

```text
jekyll 4.4.0
```

Y si quieres ver qué versión de `jekyll-sass-converter` quedó:

```bash
bundle info jekyll-sass-converter
```

---

## 6. Levantar de nuevo el servidor local

Ahora prueba:

```bash
make local
# o directamente:
bundle exec jekyll serve --host 0.0.0.0 --livereload
```

En este punto:

* Jekyll debería arrancar sin intentar cargar `sassc` ni `libsass.so`.
* Tus `.scss` deberían compilar usando `sass-embedded`.


