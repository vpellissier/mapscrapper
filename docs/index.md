Webscrapping data with RSelenium
================

Preliminary steps
-----------------

### Installing a usable web browser

Before we can actually scrap data from the website, we need to setup a web browser that will run in the background. I recommand using Firefox (mainly because I could not manage doing it with Chrome, but you're free to try it).

### Installing Rtools

RSelenium also needs an external software to create a profile file for Firexox, called RTools. The installer can be downloaded here: <https://cran.r-project.org/bin/windows/Rtools/index.html>. During the instalation tick the box "Add Rtools to system path"

### Installing RSelenium and dependencies

RSelenium is a great package to scrap data from website but it is unfortunately not maintained anymore and should be installed manually from the CRAN archive. For that, yo'll need to have the library devtools installed first

``` r
install.packages("devtools")
```

Then, you can install the latest archived version of RSelenium (1.7.1), wdman and binman

``` r
devtools::install_version("RSelenium", "1.7.1")
devtools::install_version("wdman", "0.2.2")
devtools::install_version("binman", "0.1.0")
```

### Installing the mapscrapper package

A brand new, not super efficient and certainly not optimized package to scrap the opentransportmap website!

``` r
devtools::install_github("vpellissier/mapscrapper")
```

Scrapping the website
---------------------

Downloading all the zip file for a given country is quite straightforward. First, we need to know the name of the countries in the first dropdownlist

### Gathering the names of the countries (NUTS0)

The first step is to start a Selenium server and open the website through R (this open a firefox windows that you should not close):

``` r
library(RSelenium)
rDr <- rsDriver(port = 4567L, browser = "firefox", verbose = F)
remDr <- rDr[["client"]]
Sys.sleep(5)
remDr$navigate("http://opentransportmap.info/download/")
```

Then, one can use the dropdown\_values function wich lists all the possible values of a given NUTS level (here, 0):

``` r
library(mapscrapper)
names_nuts0 <- dropdown_values(nuts = 0, remDr = remDr)
```

If this return an error message, you need to re-run the lines in the last two code snippets!

The function returns a vector containing the names of the NUTS0 as they are in the website:

    ## character(0)

### Downloading the maps for a given country

The zip files are going to be downloaded in the default download folder of your computer:

``` r
download_map_country("Estonia")
```

Because the website we are trying to scrap constantly returns Error500 messages, the function might either not start at all (error message) or stop in the middle (without downloading anything). Even worse, it can start downloading, and then skip one item! I have not yet figured out a way to control for that, but I'll look into it.
