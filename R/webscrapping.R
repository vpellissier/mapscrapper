#' Scraping opentransportmap
#' 
#' This function downloads every .zip file for a given country from the opentransportmap website.
#' Right now, the funciton should be use with Firefox only, and the files are downloaded in the default download directory of the local computer.
#' There are a few preliminary steps to carry out before using it, please refer to the document XXX.
#'  
#' @param country Name of the country for which the map should be downloaded
#' @export
#' @import RSelenium
dropdown_values <- function(nuts = NULL, remDr){
    nuts <- nuts + 1
    menu_nuts <- remDr$findElement(using = "id", value = paste0("sel", nuts))
    webElems <- menu_nuts$findChildElements("css selector", "option") # find every values in the dropdown list (first and second to be discarded)
    values_nuts <- unlist(sapply(webElems, function(x) x$getElementText()))[-c(1,2)]
    return(values_nuts)
}



selecting_nuts <- function(nuts = NULL, n = NULL, remDr){
    elem <- remDr$findElement(using = 'css selector', 
                              paste0('#sel', nuts + 1, ' > option:nth-child(', 
                                     n + 2, ')'))
    elem$clickElement()
}


#' @export
download_map_country <- function(country = NULL){
    fprof <- makeFirefoxProfile(list(browser.download.dir = "C:\\test"
                                     ,  browser.download.folderList = 2L
                                     , browser.download.manager.showWhenStarting = FALSE
                                     , browser.helperApps.neverAsk.saveToDisk = "application/zip"))
     
    cat('A firefox window will open shortly. Do not close it!')
    Sys.sleep(5)
    rDr <- rsDriver(port = 4567L, browser = "firefox", verbose = F, extraCapabilities = fprof)
    remDr <- rDr[["client"]]
    Sys.sleep(5)
    remDr$navigate("http://opentransportmap.info/download/")
    
    nuts <- 0
    names_countries <- dropdown_values(nuts = nuts, remDr = remDr)
    n <- which(names_countries == country)
    
    selecting_nuts(nuts = 0, n = n, remDr = remDr)
    
    for(n_nuts1 in seq(length(dropdown_values(nuts = 1, remDr = remDr)))){
        selecting_nuts(nuts = 1, n = n_nuts1, remDr = remDr)
        
        for(n_nuts2 in seq(length(dropdown_values(nuts = 2, remDr = remDr)))){
            selecting_nuts(nuts = 2, n = n_nuts2, remDr = remDr)
            
            for(n_nuts3 in seq(length(dropdown_values(nuts = 3, remDr = remDr)))){
                selecting_nuts(nuts = 3, n = n_nuts3, remDr = remDr)
                download_button <- remDr$findElement(using = "id", value = "db")
                download_button$clickElement()
                Sys.sleep(6)
                print(n_nuts3)
            }
        }
    }
}








