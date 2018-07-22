#' Create a mockup of a Twitter timeline
#'
#' Generates HTML twitter timeline page.
#'
#' @param x Twitter timeline data frame (as returned by rtweet).
#' @param file File name to save as. Defaults to temporary file.
#' @return Saves an html file
#' @examples
#' \dontrun{
#' ## create mock-up of Twitter timeline
#'
#' ## the timeline URL
#' mocktwitter_timeline("https://twitter.com/kearneymw")
#'
#' ## the screen name or user ID
#' mocktwitter_timeline("kearneymw")
#'
#' ## or get timeline data from rtweet
#' kmw <- rtweet::get_timeline("kearneymw")
#' mocktwitter_timeline(kmw)
#'
#' }
#' @export
mocktwitter_timeline <- function(x, file = NULL) {
  UseMethod("mocktwitter_timeline")
}

mocktwitter_timeline.default <- function(x, file = NULL) {
  stop("must supply screen name, user id, or twitter timeline data frame ",
    "returned by an rtweet function")
}

#' @export
mocktwitter_timeline.factor <- function(x, file = NULL) {
  x <- as.character(x)
  mocktwitter_timeline(x, file)
}

#' @export
mocktwitter_timeline.character <- function(x, file = NULL) {
  stopifnot(length(x) == 1L)
  if (!is_token_configured()) {
    stop("please setup your Twitter API token, see: ",
      "http://rtweet.info/articles/auth.html or ",
      "vignette(\"auth\", package = \"rtweet\") for more information")
  }
  if (grepl("^http", x)) {
    x <- gsub(
      "https://[[:graph:]]{0,30}twitter\\.com/|/$",
      "", x)
  }
  mocktwitter_mytimeline(x, file)
}


mocktwitter_mytimeline <- function(user, file) {
  tml <- read_source(sprintf("https://twitter.com/%s", user))
  tml <- sub(".{0,97}signin-l.{0,148}", "", tml)
  tml <- sub(
    ".{0,112}SignupCallOut.*personalized timeline.*signup_callout.{0,60}",
    "", tml)
  tml <- sub(".{0,12}nav secondary-nav session-dropdown.*page-outer",
    "</div>\n</div>\n</div>\n</div>\n</div>\n<div id=\"page-outer", tml)
  css <- "
  body { font-size: 12px !important; line-height: 14px !important; }
  .u-size1of3 { width: 200px !important; }
  .ProfileCanopy--large, .ProfileCanopy-header { height: 140px !important; }
  .ProfileHeaderCard-bio { font-size: 12px !important; }
  </style>"
  tml <- sub("</style>", css, tml)
  tmp <- tempfile(fileext = ".html")
  if (is.null(file)) {
    file <- tmp
  }
  writeLines(tml, file)
  message("Saving as ", file)
  file.copy(file, tmp)
  if (rstudioapi::isAvailable()) {
    rstudioapi::viewer(tmp)
  } else if (!exists(".mocktwitter_opened")) {
    assign(".mocktwitter_opened", new.env(), envir = .GlobalEnv)
    browseURL(file)
  }
  invisible(file)
}
