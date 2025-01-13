run:
	google-chrome-stable --new-window http://127.0.0.1:4000/
	bundle exec jekyll serve
local:
	#google-chrome-stable --new-window http://127.0.0.1:4000/
	bundle exec jekyll serve --host 0.0.0.0 --livereload

