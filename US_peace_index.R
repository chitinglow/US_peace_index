library(rvest) #scarpping URl
library(ggplot2) #mapping the plot
library(dplyr) #data manipluation
library(fiftystater) #getting the map of USA
library(magrittr) #pipe


#getting the URL from website
url <- "https://en.wikipedia.org/wiki/United_States_Peace_Index"

#getting the html table 
US_peace_index <- url %>%
  read_html() %>%
  html_nodes(xpath='//*[@id="mw-content-text"]/div/table[3]') %>%
  html_table(fill = T)

#checking the data
head(US_peace_index)  
str(US_peace_index)

#conver into data frame
US_peace_index <- as.data.frame(US_peace_index)

#rename column
colnames(US_peace_index) <- c("Rank_2012", "Rank_2011", "State", "2012_score", "2011_score")

#getting USA map
data("fifty_states")

#lowercase 
US_peace_index$State <- tolower(US_peace_index$State)

#see wherether there is difference of state name between two data
setdiff(US_peace_index$State, fifty_states$id)

#join the data by id and state name
USA_joind <- left_join(fifty_states, US_peace_index, by = c('id' = 'State'))

#visualizing 
ggplot() +
  geom_polygon(data = USA_joind, aes(x = long, y = lat, group = group, fill = USA_joind$`2012_score`)) +
  labs(title = "United States Peace Index 2012") +
  scale_fill_gradient("United State Peace Index", low = 'green', high = 'red') +
  theme(
    panel.background = element_rect(fill = "grey"),
    plot.background = element_rect(fill = "grey"),
    legend.background = element_blank(),
    axis.title = element_blank(),
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    panel.grid = element_blank(),
    plot.title = element_text(size = 24),
    text = element_text(family = "Gill Sans"))

  
  
