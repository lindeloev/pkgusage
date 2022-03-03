#' Start listening for package usage
#'
#' @description
#' This is a quite violent solution, so use with care. It overwrites
#' `library()`, `require()`, `::`, and `:::` from the base package in the
#' current session. Consider adding `pkgusage::start_listening()` to your
#' `.Rprofile` to start it every session.
#'
#' It enhances these functions by saving which packages are used.
#' @export
#' @aliases start_listening
#' @return NULL
listen = function() {
  `::` <<- function(pkg, name) {
    pkg = as.character(substitute(pkg))
    name = as.character(substitute(name))

    #register_call(pkg, name)
    register_pkg(pkg)

    getExportedValue(pkg, name)
  }

  `:::` <<- function (pkg, name) {
    pkg = as.character(substitute(pkg))
    name = as.character(substitute(name))

    #register_call(pkg, name)
    register_pkg(pkg)

    get(name, envir = asNamespace(pkg), inherits = FALSE)
  }

  library <<- function(package, ...) {
    pkg = as.character(substitute(package))
    register_pkg(pkg)
    base::library(pkg, character.only = TRUE, ...)
  }

  require <<- function(package, ...) {
    pkg = as.character(substitute(package))
    register_pkg(pkg)
    base::require(pkg, character.only = TRUE, ...)
  }

}
