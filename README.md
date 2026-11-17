# rsdocs

A Quarto documentation website packaged as an RStudio / RStudio Server addin.

## Layout

- `docs-src/` - Quarto website source (not shipped)
- `build-docs.sh` - renders `docs-src/` and copies `_site/` to `inst/docs/`
- `inst/docs/` - rendered site, shipped with the package
- `R/rsdocs.R` - serves `inst/docs/` with httpuv and opens it

## Update the docs

```bash
./build-docs.sh
cd .. && R CMD build rsdocs && R CMD INSTALL rsdocs_0.1.0.tar.gz
```

Restart R in RStudio, then **Addins -> Docs**, or call
`rsdocs::rsdocs()` (opens the viewer pane) / `rsdocs::rsdocs_stop()`.

## Make targets

```bash
make docs    # roxygen Rd files + render website into inst/docs/
make preview # live-reloading preview of docs-src/ (Ctrl+C to stop)
make preview PORT=8002   # fixed port instead of a random free one
make clean   # delete docs-src/_site, docs-src/.quarto, inst/docs, man
```

On RStudio Server the preview's `http://localhost:<port>/` is not reachable
from your browser directly. Open it through the session proxy from the R
console in the viewer pane, e.g. `rstudioapi::viewer("http://localhost:8002/")`.
