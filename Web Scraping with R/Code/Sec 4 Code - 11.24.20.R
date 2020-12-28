#Scrape ASDA groceries
#Date: 11.24.20
#---------------------------------#
#install.packages("tidyverse")
library(tidyverse)
library(rvest)

url <- "https://groceries.asda.com/search/yoghurt"

html_data <- read_html(url)
html_data


html_data %>%
  html_nodes(".co-product__title")
#{xml_nodeset(0)} --> were getting a javascript here, client side rendering webpages


#server side webpages render HTML so its easy to pull data from them

#client side rendered pages are more difficult to pull data from --> server 
#sends data to client (me), but client needs to render HTML

#then we set up selenium as a middle man --> query server, send code to client, 
#under hood running browser to run code and interpret and build relevant HTML and then passes on to R
#then we have HTML to scrape just like in previous lessons

#install.packages("RSelenium")
library(RSelenium)

#Connect to Selenium
#remDr <- remoteDriver(remoteServerAddr = "selenium",port = 4444)

#remDr$open()

#Type in terminal
#docker run -d -p 4445:4444 selenium/standalone-firefox
#docker ps


#we have a connection to Selenium and opened a driver
remDr <- remoteDriver(port=4445L)
remDr$open()

#Connect to URL using Selenium
url <- "https://groceries.asda.com/search/yoghurt"
remDr$navigate(url)

#Get the site
remDr$getPageSource() #we are interested in the first element of the list
remDr$getPageSource()[[1]]

html_data <- read_html(remDr$getPageSource()[[1]])

#Now lets see if we can get the product titles
html_data %>%
  html_nodes(".co-product__title")


#Let's get the product list
products <- html_data %>%
              html_node(".co-product-list") %>%
              html_nodes(".co-item")

#product <- products[[5]]

parse_product <-function(product){
  
  product_title <- product %>%
    html_node(".co-product__title") %>%
    html_text()
  
  
  product_volume <- product %>%
    html_node(".co-product__volume") %>%
    html_text()
  
  product_price <- product %>%
    html_node(".co-product__price") %>%
    html_text()
  
  review_count <- product %>%
    html_node(".co-product__review-count") %>%
    html_text()
  
  rating_stars <- product %>%
    html_node(".rating-stars") %>%
    html_attr("aria-label")
  
  
  tibble(
    product_title,
    product_volume,
    product_price,
    review_count,
    rating_stars
  )
  
  
  
}

#parse_product(product)

#feed in list of products to loop over and apply function
df<-map_dfr(products,parse_product)

#YAY, we have a data frame

#Loop for all pages
library(tidyverse)
library(rvest)
library(RSelenium)

remDr <- remoteDriver(port=4445L)
remDr$open()

baseurl<-"https://groceries.asda.com/search/yoghurt/products?page={page}"
page <- 1
url <- glue::glue(baseurl)

#Run this together
remDr$navigate(url)
Sys.sleep(10)


html_data <- read_html(remDr$getPageSource()[[1]])

last_page<-html_data %>%
            html_node(".co-pagination__last-page") %>%
            html_text() %>%
            as.integer()


walk(1:last_page,function(page){
  
  url_page <- glue::glue(baseurl)
  message(glue::glue("\nFetching: {url_page}"))
  remDr$navigate(url_page)
  Sys.sleep(15)
  
  html_raw <- remDr$getPageSource()[[1]]
  htmlfile <-str_c("Desktop/Udemy Courses/Web Scraping with R/download/",page,".html")
  write_file(html_raw, htmlfile)
  
})



remDr$close()

#----------Extract product-info from HTML files----------#
html_files <- list.files("Desktop/Udemy Courses/Web Scraping with R/download/") %>%
  str_c("Desktop/Udemy Courses/Web Scraping with R/download/",.)


all_products <- map_dfr(html_files, function(html_file){
  
      html_data <-read_html(html_file)
      
      products <-html_data %>%
        html_node(".co-product-list") %>%
        html_nodes(".co-item")
      
      df <- map_dfr(products, parse_product)
      
      df
  
})


#---------- Clean up data ----------#

all_products$product_volume

x <- "3x113g"

parse_volume <- function(product_volume){
  map_dbl(product_volume, function(x){
    
    
    if(!str_detect(x,"\\d")){
      return(NA_real_)
    }
    
    to_eval<- x %>%
      str_remove("[[:alpha:]]+$") %>%
      str_replace("x","*")
    
    volume <- eval(parse(text=to_eval))
    volume
    
  })
    
}

parse_volume(all_products$product_volume)


all_products %>%
  mutate(
    product_price = product_price %>% str_remove("£") %>% as.numeric(),
    review_count = review_count %>% str_remove_all("\\(|\\)|\\+") %>% as.integer(),
    rating_stars = rating_stars %>% str_extract("\\d{1}.{0,1}\\d{0,2}") %>% as.numeric(),
    volume = parse_volume(product_volume),
    volume_unit = product_volume %>% str_extract("[[:alpha:]]+$")
  )

