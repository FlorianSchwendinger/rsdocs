.PHONY: docs preview clean

docs:
	Rscript -e 'roxygen2::roxygenise(".")'
	./build-docs.sh

preview:
	quarto preview docs-src --no-browser $(if $(PORT),--port $(PORT))

clean:
	rm -rf docs-src/_site docs-src/.quarto inst/docs man
