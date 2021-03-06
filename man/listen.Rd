% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/listener.R
\name{listen}
\alias{listen}
\alias{start_listening}
\title{Start listening for package usage}
\usage{
listen()
}
\description{
This is a quite violent solution, so use with care. It overwrites
\code{library()}, \code{require()}, \code{::}, and \code{:::} from the base package in the
current session. Consider adding \code{pkgusage::start_listening()} to your
\code{.Rprofile} to start it every session.

It enhances these functions by saving which packages are used.
}
