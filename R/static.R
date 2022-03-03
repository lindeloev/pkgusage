# Home-made progress bar
# progress_bar = function(i, total, prefix = "") {
#   txt_postfix = paste0(" (", i, " of ", total, ")")
#   int_padding = nchar(prefix) + nchar(txt_postfix)
#   int_progress = round((getOption("width") - int_padding) * i / total)
#   txt_dash = rep("*", int_progress)
#   txt_space = rep(" ", getOption("width") - int_progress - int_padding)
#   message("\r", prefix, txt_dash, txt_space, txt_postfix, appendLF = FALSE)
# }

# Home-made progress bar
progress_bar = function(i, total, prefix = "") {
  cat("\r", prefix, " ... [", i, "/", total, "]")
}


#' List all used packages in a directory and subdirectories
#'
#' @description
#' Looks for `library(package)`, `package::function()` in .R and.Rmd files.
#' Looks for `Imports` etc. in DESCRIPTION files.
#' Identifies all dependencies too.
#'
#' Does not scan .Rhistory and .md files
#'
#' Technically, this function uses `renv::dependencies()` to scan files.
#' Then `tools::package_dependencies()pkg, recursive = TRUE)` to find
#' dependencies.
#'
#' @export
#' @aliases pkg_scan
#' @param paths The path(s) to scan. Defaults to the current path.
#' @return A list with
#'  - `called`: explicitly referenced packages (see `called$Packages`)
#'  - `dependencies`: dependencies to `called`.
pkg_scan = function(paths = getwd()) {
  called_all = data.frame()
  for (path in paths) {
    cat("Searching for R files in '", path, "' ...\n")
    called_all = rbind(called_all, renv::dependencies(path))
  }

  called = called_all$Package |> unique() |> sort()

  dependencies = c()
  prefix = "Searching dependency trees:"
  for (i in seq_along(called)) {
    progress_bar(i, length(called), prefix)
    pkg = called[i]
    if (pkg %in% dependencies == FALSE & pkg %in% getOption("defaultPackages") == FALSE)
      dependencies = c(dependencies, tools::package_dependencies(pkg, recursive = TRUE)[[pkg]])
  }
  cat(" Done!")
  dependencies = dependencies |> unique() |> setdiff(called)

  list(
    dependencies = dependencies,
    called = called_all[!duplicated(called_all), c("Package", "Source")]
  )
}


#' Installed packages that are not used
#'
#' @description
#' Does not return packages in `getOption("defaultPackages")` nor the "compiler"
#' package.
#'
#' @export
#' @aliases pkg_unused
#' @param scan Output from `pkg_scan()`.
#' @param include_rstudio Whether to also return packages used by RStudio (in `rstudioapi::getRStudioPackageDependencies()`).
#' @return Character vector of package names.
pkg_unused = function(scan, include_rstudio = TRUE) {
  installed = utils::installed.packages()[, 1]
  used = c(scan$called$Package, scan$dependencies, getOption("defaultPackages"))
  used = c(used, "compiler")  # R crashed without this...

  if (include_rstudio) {
    has_rstudioapi = requireNamespace("goat", quietly = TRUE)
    if (has_rstudioapi) {
      used = c(used, rstudioapi::getRStudioPackageDependencies())
    } else {
      stop("Could not find the `rstudioapi`. It's needed to respect the `include_rstudio == TRUE` argument")
    }
  }

  used = unique(used)
  setdiff(installed, used) |> sort()
}


#' @export
#' @aliases pkg_missing
#' @describeIn pkg_unused Packages that are used but not installed
pkg_missing = function(scan) {
  installed = utils::installed.packages()[, 1]
  used = c(scan$called$Package |> unique(), scan$dependencies)
  setdiff(used, installed)
}


#' Locate calls to missing packages
#'
#' @export
#' @aliases pkg_missing_where
#' @param scan Output from `pkg_scan()`.
#' @return data.frame of package names and code files.
pkg_missing_where = function(scan) {
  missing = pkg_missing(scan)
  missing_all = scan$called[scan$Package %in% missing, ]  # subset() that pleases R CMD Check
  missing_all = missing_all[order(missing_all$Package), ]
  rownames(missing_all) = NULL
  missing_all
}
