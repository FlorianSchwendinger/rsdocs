.docs <- new.env(parent = emptyenv())

#' Open the bundled documentation site
#'
#' Serves the pre-rendered Quarto website shipped in `inst/docs/` from a
#' local background web server and opens it in the RStudio viewer pane
#' (RStudio Server proxies the local URL). Outside RStudio it falls back to
#' the default browser. The server keeps running in the background; call
#' [rsdocs_stop()] to stop it.
#'
#' @return Invisibly, the local URL of the docs server.
#' @export
rsdocs <- function() {
  site <- system.file("docs", package = "rsdocs")
  if (!nzchar(site) || !file.exists(file.path(site, "index.html"))) {
    stop("No rendered docs found. Run build-docs.sh and reinstall the package.",
         call. = FALSE)
  }

  if (is.null(.docs$server) || !.docs$server$isRunning()) {
    port <- httpuv::randomPort()
    .docs$server <- httpuv::startServer("127.0.0.1", port, list(
      call = function(req) {
        list(status = 404L, headers = list("Content-Type" = "text/plain"),
             body = "Not found")
      },
      staticPaths = list("/" = httpuv::staticPath(site, indexhtml = TRUE))
    ))
    .docs$url <- sprintf("http://127.0.0.1:%d/", port)
  }

  if (rstudioapi::isAvailable()) {
    rstudioapi::viewer(.docs$url)
  } else {
    utils::browseURL(.docs$url)
  }
  invisible(.docs$url)
}

#' Stop the documentation server
#'
#' @return Invisibly, `TRUE` if a server was stopped.
#' @export
rsdocs_stop <- function() {
  running <- !is.null(.docs$server) && .docs$server$isRunning()
  if (running) .docs$server$stop()
  .docs$server <- NULL
  .docs$url <- NULL
  invisible(running)
}
