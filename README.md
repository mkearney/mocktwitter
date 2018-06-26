
<!-- README.md is generated from README.Rmd. Please edit that file -->

# mocktwitter

🐧🐦 Generate HTML pages for Twitter statuses.

## Installation

You can install the current version of mocktwitter from
[Github](https://github.com) with:

``` r
## install from github
devtools::install_github("mkearney/mocktwitter")
```

## `mocktwitter_status()`

Use `mocktwitter_status()` with a status URL, status ID, or tweets data
returned by [**{rtweet}**](http://rtweet.info) to create a [mock-up of a
Twitter status HTML page](htols/readme/ex.html):

``` r
## (1) URL to twitter status data byrealDonaldTrump
mocktwitter_status("https://twitter.com/realDonaldTrump/status/1010900865602019329")

## (2) mockup an HTML twitter page for a readDonaldTrump status
mocktwitter_status("1010900865602019329")

## (3) twitter status data from rtweet for a realDonaldTrump tweet
rdt <- rtweet::lookup_statuses("1010900865602019329")

## override with custom text
rdt$text <- "Give me your tired, your poor, your huddled masses yearning to breathe free, the wretched refuse of your teeming shore. Send these, the homeless, tempest-tossed to me, I lift my lamp beside the golden door!"

## mock-up an HTML twitter page
mocktwitter_status(rdt, file = "tools/readme/ex.html")
```

<p align="center">

<img src="tools/readme/ex.png" >

</p>

In Rstudio, a preview will be displayed in the viewer pane.

<p align="center">

<img src="tools/readme/ex2.png" >

</p>

## `mocktwitter_timeline()` (**dev in progress**)

Use `mocktwitter_timeline()` with a user URL, screen name, user ID, or
timeline data returned by [**{rtweet}**](http://rtweet.info) to create a
[mock-up of a Twitter status HTML page](tools/readme/ex2.html):

``` r
## (1) URL to a twitter timeline
mocktwitter_timeline("https://twitter.com/kearneymw")

## (2) screen name or user ID of twitter account
mocktwitter_timeline("kearneymw", file = "tools/readme/ex2.html")
```

<p align="center">

<img src="tools/readme/ex3.png" >

</p>
