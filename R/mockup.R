

li_favuser <- function(x) {
  sprintf('<a class="js-profile-popup-actionable js-tooltip" href="/%s" data-user-id="%s" original-title="%s" title="%s" rel="noopener">
  <img class="avatar size24 js-user-profile-link" src="%s" alt="%s">
</a>', x$user_id, x$screen_name, x$user_id, x$name,
  x$profile_image_url, x$name)
}

li_favusers <- function(x) {
  paste(map(seq_len(nrow(x)), ~ li_favuser(x[.x, ])), collapse = "\n\n")
}

req_vars <- function() {
  c("retweet_count", "favorite_count", "status_id", "user_id", "screen_name",
    "profile_image_url", "profile_url", "profile_banner_url", "created_at", "text",
    "name", "description", "location")
}

#' Create a mockup of a Twitter status
#'
#' Generates HTML twitter status page.
#'
#' @param x Twitter status data frame (as returned by rtweet).
#' @param file File name to save as. Defaults to temporary file.
#' @return Saves an html file
#' @export
mocktwit <- function(x, file = NULL) {
  stopifnot(is.data.frame(x), nrow(x) > 0)
  if (any(!req_vars() %in% names(x))) {
    missing <- req_vars()[!req_vars() %in% names(x)]
    stop(paste("Missing the following variables:", paste(missing, collapse = ", ")))
  }
  if (nrow(x) > 1L) {
    warning("Can only create one status at a time. Using the first observation...")
    x <- x[1, ]
  }
  if (x$retweet_count >= 1000) {
    x$retweet_count <- prettyNum(x$retweet_count, big.mark = ",")
  }
  if (x$favorite_count >= 1000) {
    x$favorite_count <- prettyNum(x$favorite_count, big.mark = ",")
  }
  if (x$favorite_count > 0) {
    favs <- httr::GET(sprintf("https://twitter.com/%s/status/%s", x$screen_name, x$status_id))
    favs <- httr::content(favs, as = "text", encoding = "UTF-8")
    m <- gregexpr("(?<=data-user-id=.{1})\\d+(?=.{1} original-title)", favs, perl = TRUE)
    if (length(m[[1]]) > 0) {
      favs <- unique(regmatches(favs, m)[[1]])
    } else {
      favs <- NULL
    }
  } else {
    favs <- NULL
  }
  if (x$retweet_count > 0) {
    rts <- rtweet::get_retweeters(x$status_id)
    rts <- c(favs, rts$user_id)
  } else {
    rts <- favs
  }
  rts <- unique(rts)
  if (length(rts) > 9) {
    rts <- rts[sample(seq_along(rts), 9)]
  }
  if (length(rts) > 0) {
    fav_users <- rtweet::lookup_users(rts)
  } else {
    fav_users <- NULL
  }
  y <- gsub("\\{status_text\\}", x$text, y)
  y <- gsub("\\{screen_name\\}", x$screen_name, y)
  y <- gsub("\\{user_id\\}", x$user_id, y)
  y <- gsub("\\{status_id\\}", x$status_id, y)
  y <- gsub("\\{retweet_count\\}", x$retweet_count, y)
  y <- gsub("\\{favourites_count\\}", x$favorite_count, y)
  y <- gsub("\\{name\\}", x$name, y)
  y <- gsub("\\{description\\}", x$description, y)
  y <- gsub("\\{location\\}", x$location, y)
  y <- gsub("\\{profile_url\\}", sub("(https?://www\\.)|(https?://)", "",
    x$profile_expanded_url), y)
  y <- gsub("\\{account_created_at\\}", x$account_created_at, y)
  y <- gsub("\\{created_at\\}", x$created_at, y)
  y <- gsub("\\{profile_image_url\\}",
    sub("_[^_]+\\.jpg", "_", x$profile_image_url), y)
  y <- gsub("\\{profile_banner_url\\}", x$profile_banner_url, y)
  if (!is.null(fav_users)) {
    fav_users_code <- li_favusers(fav_users)
    y <- gsub("\\{fav_users\\}", fav_users_code, y)
  }
  if (is.null(file)) {
    file <- tempfile(fileext = ".html")
  }
  writeLines(y, file)
  browseURL(file)
}
