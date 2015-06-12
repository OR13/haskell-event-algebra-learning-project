.PHONY: css

build: css cull

css:
	grunt sass

# This doesn't work correctly
optimize:
	grunt closureCompiler

cull:
	node node_modules/requirejs/bin/r.js -o build.js && rm -f src/components/*.js
