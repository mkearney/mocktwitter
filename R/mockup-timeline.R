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
mocktwitter_timeline <- function(x, file = NULL) UseMethod("mocktwitter_timeline")

mocktwitter_timeline.default <- function(x, file = NULL) {
  stop("must supply screen name, user id, or twitter timeline data frame returned by an rtweet function")
}

#' @export
mocktwitter_timeline.factor <- function(x, file = NULL) {
  x <- as.character(x)
  mocktwitter_timeline(x, file)
}

#' @export
mocktwitter_timeline.character <- function(x, file = NULL) {
  stop("this isn't ready yet")
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
  x <- rtweet::get_timeline(x)
  mocktwitter_status(x, file)
}


#' @export
mocktwitter_status.data.frame <- function(x, file = NULL) {
  stop("this isn't ready yet")
  if (any(!req_vars() %in% names(x))) {
    missing <- req_vars()[!req_vars() %in% names(x)]
    stop(paste("Missing the following variables:", paste(missing, collapse = ", ")))
  }
  if (length(unique(x$user_id)) > 1L) {
    warning("Can only create one timeline at a time. Using the first user...")
    x <- x[x$user_id == x$user_id[1], ]
  }
  x$retweet_count <- ifelse(x$retweet_count >= 1000,
    prettyNum(x$retweet_count, big.mark = ","),
    x$retweet_count)
  x$favorite_count <- ifelse(x$favorite_count >= 1000,
    prettyNum(x$favorite_count, big.mark = ","),
    x$favorite_count)
  if (is.null(file)) {
    file <- tempfile(fileext = ".html")
    message("Saving as ", file)
    writeLines(y, file)
    file.copy(file, tmp)
  } else {
    tmp <- tempfile(fileext = ".html")
    message("Saving as ", file)
    writeLines(y, file)
    file.copy(file, tmp)
  }
  if (rstudioapi::isAvailable()) {
    rstudioapi::viewer(tmp)
  } else {
    browseURL(file)
  }
}

mocktwitter_mytimeline <- function() {
  sn <- rtweet:::authenticating_user_name()
  tml <- read_source(sprintf("https://twitter.com/%s", sn))
  tml <- sub(".{0,97}signin-l.{0,148}", "", tml)
  tml <- sub(
    ".{0,112}SignupCallOut.*personalized timeline.*signup_callout.{0,60}",
    "", tml)
  css <- "
  body { font-size: 12px !important; line-height: 14px !important; }
  .u-size1of3 { width: 200px !important; }
  .ProfileCanopy--large, .ProfileCanopy-header { height: 140px !important; }
  .ProfileHeaderCard-bio { font-size: 12px !important; }
  </style>"
  tml <- sub("</style>", css, tml)
  tmp <- tempfile(fileext = ".html")
  writeLines(tml, tmp)
  rstudioapi::viewer(tmp)
  invisible(tmp)
}
