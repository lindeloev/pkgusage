# TO DO static
 * Does not work with non-CRAN packages (not maintained on CRAN or installed locally). 
   - See https://cran.r-project.org/web/packages/packages.rds
   - Scan the DESCRIPTION for locally installed packages that are not on CRAN and input it to tools::package_dependencies(... db = x)
 * Input check everything
 


# TO DO listener
 * Only build dependency list upon evaluation (`tools::package_dependencies()`); not when registering.
 * save to .pkgusage in session
 * save to disk between sessions (`on.exit()`?)


# TO DO docs
 * Worked examples. Including using `remove.packages()`.


# TO DO test
 * Make a dummy package, include it for tests, and write unit tests.
