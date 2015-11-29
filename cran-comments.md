## Release summary

This is the first attempted CRAN release of swirlify 0.4.1. This release is
in response to an email from Uwe Ligges indicating that file.size() is not 
compatible with versions of R older than 3.2.0. The minimum required
version of R has been updated in the DESCRIPTION file.

## Test environments

* local OSX Yosemite install, R 3.2.2
* Ubuntu 12.04 (on travis-ci), R 3.2.2
* win-builder (devel and release)

## R CMD check results

There were no ERRORs or WARNINGs. 

There is 1 NOTE:

* Days since last update: 4