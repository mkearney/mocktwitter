
library(usethis)
use_description()
devtools::document()
devtools::install()
use_git_config()
use_readme_rmd()
use_git()
use_git_ignore()


devtools::load_all()

writeLines(template, "/tmp/tmp.html")

con <- file("/tmp/tmp.html")
x <- readLines(con, warn = FALSE, encoding = "UTF-8")
close(con)

template <- x

save(template, file = "R/sysdata.rda")
rmarkdown::render("README.Rmd")
unlink("README.html")

rdt <- rtweet::lookup_statuses("1010900865602019329")

mocktwitter("1010900865602019329")
traceback()