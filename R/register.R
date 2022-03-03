.pkgusage <<- list()
#.calls = list()

#' Register that this package was used
#'
#' @description
#' This saves the usage to a global variable ".pkgusage"
#'
#' @aliases register_pkg
#' @keywords internal
#' @param pkg Package name (character)
#' @return NULL
register_pkg = function(pkg) {
  ignore_packages = c("base", "stats")

  if (pkg %in% ignore_packages == FALSE & is.null(.pkgusage[[pkg]])) {
    call_time = Sys.time()
    message("pkgusage: checking reverse dependencies...")
    qnames = getExportedValue("tools", "package_dependencies")(pkg, which = "strong", recursive = TRUE)[[pkg]]  # Avoids infinite loop if called from `::`
    .pkgusage[[pkg]] = call_time
    for (qname in qnames)
      if (is.null(.pkgusage[[qname]]))
        .pkgusage[[qname]] = call_time
  }
  .pkgusage <<- .pkgusage
}



#' #' @keywords internal
#' #' @param pkg Package name (character)
#' #' @param name Function name (character)
#' register_call = function(pkg, name) {
#'   ignore_packages = c("base", "stats")
#'
#'   if (pkg %in% ignore_packages == FALSE) {
#'     if (is.null(.calls[[pkg]]))
#'       .calls[[pkg]] = list()
#'
#'     if (is.null(.calls[[pkg]][[name]]))
#'       .calls[[pkg]][[name]] = 0
#'
#'     .calls[[pkg]][[name]] = .calls[[pkg]][[name]] + 1
#'     .calls <<- .calls
#'   }
#' }



