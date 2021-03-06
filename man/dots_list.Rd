% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dots.R
\name{dots_list}
\alias{dots_list}
\alias{tidy-dots}
\title{Collect dots tidily}
\usage{
dots_list(..., .ignore_empty = c("trailing", "none", "all"))
}
\arguments{
\item{...}{Arguments with explicit (\code{dots_list()}) or list
(\code{dots_splice()}) splicing semantics. The contents of spliced
arguments are embedded in the returned list.}

\item{.ignore_empty}{Whether to ignore empty arguments. Can be one
of \code{"trailing"}, \code{"none"}, \code{"all"}. If \code{"trailing"}, only the
last argument is ignored if it is empty.}
}
\value{
A list of arguments. This list is always named: unnamed
arguments are named with the empty string \code{""}.
}
\description{
\code{dots_list(...)} is equivalent to \code{list(...)} but provides tidy
dots semantics:
\itemize{
\item You can splice other lists with the
\link[=quasiquotation]{unquote-splice} \code{!!!} operator.
\item You can unquote names by using the \link[=quasiquotation]{unquote}
operator \code{!!} on the left-hand side of \code{:=}.
}

We call quasiquotation support in dots \strong{tidy dots} semantics and
functions taking dots with \code{dots_list()} tidy dots functions.
Quasiquotation is an alternative to \code{do.call()} idioms and gives
the users of your functions an uniform syntax to supply a variable
number of arguments or a variable name.
}
\details{
Note that while all tidy eval \link[=quotation]{quoting functions} have
tidy dots semantics, not all tidy dots functions are quoting
functions. \code{dots_list()} is for standard functions, not quoting
functions.
}
\section{Life cycle}{

\itemize{
\item \code{dots_list()} returns named dots, even if no names were supplied.
This behaviour is for consistency with dots returned by \code{\link[=exprs]{exprs()}}
or \code{\link[=quos]{quos()}} or their capturing variants. However we now question
this feature. It makes sense in quoting functions that are
building up function calls and where usage of \code{\link[=names2]{names2()}} was
rather systematic before tidy evaluation. However in the case of
standard functions such as created by \code{dots_list()}, the cost of
allocating an empty character vector of names can be expensive.

For this reason we may break the API in the future by returning
\code{NULL} names when no arguments were named. Please use
\code{dots_list()} accordingly (i.e. \code{set_names(dots, names2(dots))}).
}
}

\examples{
# Let's create a function that takes a variable number of arguments:
numeric <- function(...) {
  dots <- dots_list(...)
  num <- as.numeric(dots)
  set_names(num, names(dots))
}
numeric(1, 2, 3)

# The main difference with list(...) is that dots_list(...) enables
# the `!!!` syntax to splice lists:
x <- list(2, 3)
numeric(1, !!! x, 4)

# As well as unquoting of names:
nm <- "yup!"
numeric(!!nm := 1)


# One useful application of splicing is to work around exact and
# partial matching of arguments. Let's create a function taking
# named arguments and dots:
fn <- function(data, ...) {
  dots_list(...)
}

# You normally cannot pass an argument named `data` through the dots
# as it will match `fn`'s `data` argument. The splicing syntax
# provides a workaround:
fn("wrong!", data = letters)  # exact matching of `data`
fn("wrong!", dat = letters)   # partial matching of `data`
fn(some_data, !!! list(data = letters))  # no matching
}
\seealso{
\code{\link[=exprs]{exprs()}} for extracting dots without evaluation.
}
