is_id <- function(x) {
  x <- gsub("\\s|/", "", x)
  nchar(gsub("\\d", "", x)) == 0
}

is_token_configured <- function() {
  if (exists(".rtweet_token_config")) {
    return(get("rtweet_token_config", envir = .rtweet_token_config))
  }
  .rtweet_token_config <- new.env()
  assign(".rtweet_token_config", .rtweet_token_config, envir = .GlobalEnv)
  if (identical(Sys.getenv("TWITTER_PAT"), "")) {
    assign("rtweet_token_config", FALSE, envir = .rtweet_token_config)
    return(FALSE)
  }
  token <- readRDS(Sys.getenv("TWITTER_PAT"))
  if (!inherits(token, c("Token", "Token1.0"))) {
    assign("rtweet_token_config", FALSE, envir = .rtweet_token_config)
    return(FALSE)
  }
  x <- tryCatch(rtweet:::authenticating_user_name(token),
    error = function(e) return(FALSE),
    warning = function(w) return(FALSE))
  if (identical(x, FALSE) || length(x) != 1L || !is.character(x)) {
    assign("rtweet_token_config", FALSE, envir = .rtweet_token_config)
    return(FALSE)
  }
  assign("rtweet_token_config", TRUE, envir = .rtweet_token_config)
  TRUE
}

is_status_id <- function(x) {
  x <- tryCatch(rtweet::lookup_statuses(x),
    error = function(e) return(NULL),
    warning = function(w) return(NULL))
  is.data.frame(x) && nrow(x) == 1L
}
