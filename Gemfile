# frozen_string_literal: true

source "https://rubygems.org"

# gem "jekyll", "~> 4.2.2"             # 4.2.x es compatible con converter 2.x
# gem "csv", "~> 3.3"
# gem "jekyll-sass-converter", "~> 2.2" # usa sassc (evita sass-embedded)
# gem "webrick", "~> 1.8"               # útil para servir local, no afecta Actions

gem "jekyll", "~> 4.4"                # subir jekyll a 4.4.x
gem "jekyll-sass-converter", "~> 3.0" # usa sass-embedded en lugar de sassc
gem "sass-embedded", "~> 1.93"        # motor Sass moderno
gem "csv", "~> 3.3"                   # para el warning de Ruby 3.4
gem "webrick", "~> 1.9"               # necesario en Ruby 3.x

gemspec
# commenting below to remove dependency with "github-pages" 
# gem "github-pages", group: :jekyll_plugins

gem "jekyll-seo-tag"
gem "jekyll-sitemap"

# https://github.com/jekyll/jekyll/issues/8523#issuecomment-751409319
# When running locally, we run into the following error —
# `require': cannot load such file -- webrick (LoadError)
# adding this avoids it
#gem "webrick"

# adding the following gems to support removal of "github-pages" dependency
gem "jemoji"
gem "kramdown-parser-gfm"
