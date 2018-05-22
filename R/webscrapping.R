#' Scraping opentransportmap
#' 
#' This function downloads every .zip file for a given country from the opentransportmap website.
#' Right now, the funciton should be use with Firefox only, and the files are downloaded in the default download directory of the local computer.
#' There are a few preliminary steps to carry out before using it, please refer to the document XXX.
#'  
#' @param country Name of the country for which the map should be downloaded
#' @param browser Name of the browser used to download the data
#' @export
#' @import seleniumPipes
dropdown_values <- function(nuts = NULL, remDr = NULL){
    if(is.null(remDr)){
        remDr <- remoteDr(browserName = "chrome", port = 4444L)
        go(remDr, "http://www.opentransportmap.info/download")
    }
    
    nuts <- nuts + 1
    values_nuts <- vector()
    
    while(length(values_nuts) < 1){
        refresh(remDr)
        menu_nuts <- findElement(remDr, using = "id", value = paste0("sel", nuts)) %>% 
            findElementsFromElement("css selector", "option")
        values_nuts <- unlist(sapply(menu_nuts,getElementText))[-c(1,2)]
        return(values_nuts)        
    }
}



selecting_nuts <- function(nuts = NULL, n = NULL, remDr){
    remDr %>% 
        findElement(using = 'css selector', 
                    paste0('#sel', nuts + 1, ' > option:nth-child(', n + 2, ')')) %>%
        elementClick()
}


#' @export
download_map_country <- function(country = NULL, root_path = NULL){
    if(is.null(root_path))
        stop("Please provide a path to a download directory")
    
    if(!dir.exists(root_path))
        dir.create(rooth_path)
    
    if(!dir.exists(file.path(root_path, country)))
       dir.create(file.path(root_path, country))
    
    eCaps <- list(
        chromeOptions = 
            list(prefs = list(
                "profile.default_content_settings.popups" = 0L,
                "download.prompt_for_download" = FALSE,
                "download.default_directory" = file.path(root_path, country)
            )
            )
    )
    
    cat('A Chrome window will open shortly. Do not close it!')
    Sys.sleep(5)
    
    remDr <- remoteDr(browserName = "chrome", port = 4444L, extraCapabilities = eCaps) %>%
        go("http://www.opentransportmap.info/download")  
    
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
                remDr %>% findElement("id", "db") %>% elementClick()
                Sys.sleep(6)
                print(n_nuts3)
            }
        }
    }
}








