# pkgusage: scan files or console for package usage

This R package scans files or terminal usage to detect which packages are actually used. Here are two use cases:

-   You've just installed a new version of R and want to install all used packages rather than installing-as-you-go or transferring *all* packages from the previous installation.
-   You have an old R installation with many unused packages, e.g., packages you tried but never removed or dependencies to packages you removed.

If you just want to update to an new R and transfer all packages, check out the `installr` package.

## Package usage in files

To get started, run:

``` r
library(pkgusage)
scan_result = pkg_scan(path = "~")  # or whereever you want to search (recursively)
```

Find installed but unused packages. You can call \`remove.packages()\` on this if you feel brave.

``` r
pkg_unused(scan_result)
```

Used but not installed packages. You can call \`install.packages()\` on this.

``` r
pkg_missing(scan_result)
```

## Package usage in the console

Work in progress...
