BIND ?= 127.0.0.1
PORT ?= 1313
HUGO_BASE_URL ?= http://$(BIND):$(PORT)/
HUGO_CACHE_DIR ?= $(CURDIR)/.cache/hugo

.PHONY: runserver build clean

runserver:
	hugo server -D --bind $(BIND) --port $(PORT) --baseURL $(HUGO_BASE_URL) --cacheDir $(HUGO_CACHE_DIR)

build:
	hugo --minify --cleanDestinationDir --cacheDir $(HUGO_CACHE_DIR)

clean:
	rm -rf public resources .hugo_build.lock
