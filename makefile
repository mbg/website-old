all:
	cabal build
	cp dist/build/website/website .
	./website build

install:
	cp -R _site/* ~/public_html/
