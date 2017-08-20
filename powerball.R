library(tidyverse)
library(magrittr)

save_winning_numbers <- function()
{
  # Unfortunately, I can't just read.table or read_table
  "http://www.powerball.com/powerball/winnums-text.txt" %>%
    readLines() %>%
    (function(x){x[1] <- sub("^Draw Date", "Date", x[1]); x}) %>%
    gsub("\\s+", ",", .) %>%
    writeLines("winnums.csv")
}

get_data <- function()
{
  sales <- "Tickets_Sold_post1997.csv" %>%
    read_csv(col_names = TRUE, col_types = cols()) %>%
    mutate(
      Date = replace(Date, Date == "7/26/2016", "7/27/2016"),
      Date = replace(Date, Date == "7/29/2016", "7/30/2016"),
      Date = as.Date(Date, format = "%m/%d/%Y")
    )

  numbers <- "winnums.csv" %>%
    read_csv(col_names = TRUE, col_types = cols()) %>%
    mutate(
      Date = as.Date(Date, format = "%m/%d/%Y"),
      WB1 = as.integer(WB1),
      WB2 = as.integer(WB2),
      WB3 = as.integer(WB3),
      WB4 = as.integer(WB4),
      WB5 = as.integer(WB5),
      PB = as.integer(PB)
    )

  full_join(sales, numbers, by = "Date") %>%
    arrange(Date)

}

