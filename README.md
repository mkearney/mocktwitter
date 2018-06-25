
<!-- README.md is generated from README.Rmd. Please edit that file -->

# mocktwitter

Generate HTML pages for Twitter statuses.

## Installation

You can install the current version of mocktwitter from
[Github](https://github.com) with:

``` r
## install from github
devtools::install_github("mkearney/mocktwitter")
```

## Example

This is a basic example:

``` r
## twitter status data for a realDonaldTrump tweet
rdt <- rtweet::lookup_statuses("1010900865602019329")

## override with custom text
rdt$text <- "Give me your tired, your poor, your huddled masses yearning to breathe free, the wretched refuse of your teeming shore. Send these, the homeless, tempest-tossed to me, I lift my lamp beside the golden door!"

## mockup an HTML twitter page
mocktwitter(rdt)
```

<p align="center">

<img src="tools/readme/ex.png" >

</p>
