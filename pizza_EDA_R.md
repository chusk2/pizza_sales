## Load the necessary libraries and the dataset

    library(tidyverse)

    ## ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.2 ──
    ## ✔ ggplot2 3.4.1      ✔ purrr   1.0.1 
    ## ✔ tibble  3.1.8      ✔ dplyr   1.0.10
    ## ✔ tidyr   1.3.0      ✔ stringr 1.5.0 
    ## ✔ readr   2.1.4      ✔ forcats 1.0.0 
    ## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()

    library(glue)
    # load dataset
    df <- read_csv('pizza_sales_clean.csv')

    ## Rows: 48620 Columns: 8
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr  (4): pizza_name, pizza_size, pizza_category, pizza_ingredients
    ## dbl  (3): unit_price, quantity, total_price
    ## dttm (1): order_timestamp
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

## KPI analysis

## Total Revenue

    glue('The total sales is ${round(sum(df$total_price), 2)}')

    ## The total sales is $817860.05

## Average Order Value

    glue('The total sales is ${round(mean(df$total_price), 2)}')

    ## The total sales is $16.82

## Total Pizza Sold

    glue('The total number of pizzas sold is {sum(df$quantity)}.')

    ## The total number of pizzas sold is 49574.

## Total Orders

    glue('A total of {nrow(df)} were placed.')

    ## A total of 48620 were placed.

## Average Pizzas Per Order

    glue('The average number of pizzas ordered by order is {round(mean(df$quantity), 2)}')

    ## The average number of pizzas ordered by order is 1.02

# Sales Performance Analysis

## What is the average unit price and revenue of pizza across different categories?

    df %>% group_by(pizza_category) %>% summarise(
        avg_unit_price = round(mean(unit_price),2),
        avg_revenue = round(mean(total_price),2 ) )

    ## # A tibble: 4 × 3
    ##   pizza_category avg_unit_price avg_revenue
    ##   <chr>                   <dbl>       <dbl>
    ## 1 Chicken                  17.7        18.1
    ## 2 Classic                  14.8        15.1
    ## 3 Supreme                  17.4        17.7
    ## 4 Veggie                   16.6        16.9

## What is the average unit price and revenue of pizza across different sizes?

    # convert the size to a factor variable
    df$pizza_size <- factor(df$pizza_size,
                            levels = unlist(str_split('S M L XL XXL', ' ')),
                            ordered=T)
    df %>% group_by(pizza_size) %>% summarise(
        avg_unit_price = round(mean(unit_price),2),
        avg_revenue = round(mean(total_price),2 ) )

    ## # A tibble: 5 × 3
    ##   pizza_size avg_unit_price avg_revenue
    ##   <ord>               <dbl>       <dbl>
    ## 1 S                    12.4        12.6
    ## 2 M                    16.0        16.2
    ## 3 L                    19.8        20.3
    ## 4 XL                   25.5        25.9
    ## 5 XXL                  36.0        36.0

## What is the average unit price and revenue of most sold 3 pizzas?

    df %>% group_by(pizza_name) %>% summarise(
        units_sold = sum(quantity),
        avg_unit_price = round(mean(unit_price),2),
        avg_revenue = round(mean(total_price),2 ) ) %>%
        arrange(-units_sold) %>% head(3)

    ## # A tibble: 3 × 4
    ##   pizza_name       units_sold avg_unit_price avg_revenue
    ##   <chr>                 <dbl>          <dbl>       <dbl>
    ## 1 classic deluxe         2453           15.6        15.8
    ## 2 barbecue chicken       2432           17.6        18.0
    ## 3 hawaiian               2422           13.3        13.6

# Seasonal Analysis

## Which days of the week have the highest number of orders?

    library(lubridate)

    ## 
    ## Attaching package: 'lubridate'

    ## The following objects are masked from 'package:base':
    ## 
    ##     date, intersect, setdiff, union

    df %>% group_by(week_day = wday(df$order_timestamp, label=T, abbr = F)) %>% 
        summarise(total_pizzas_ordered = sum(quantity)) %>% arrange(-total_pizzas_ordered)

    ## # A tibble: 7 × 2
    ##   week_day  total_pizzas_ordered
    ##   <ord>                    <dbl>
    ## 1 Friday                    8242
    ## 2 Saturday                  7493
    ## 3 Thursday                  7478
    ## 4 Wednesday                 6946
    ## 5 Tuesday                   6895
    ## 6 Monday                    6485
    ## 7 Sunday                    6035

## At what time do most orders occur?

    df %>% group_by(day_hour = hour(df$order_timestamp)) %>% 
        summarise(total_pizzas_ordered = sum(quantity)) %>% arrange(-total_pizzas_ordered)

    ## # A tibble: 15 × 2
    ##    day_hour total_pizzas_ordered
    ##       <int>                <dbl>
    ##  1       12                 6776
    ##  2       13                 6413
    ##  3       18                 5417
    ##  4       17                 5211
    ##  5       19                 4406
    ##  6       16                 4239
    ##  7       14                 3613
    ##  8       20                 3534
    ##  9       15                 3216
    ## 10       11                 2728
    ## 11       21                 2545
    ## 12       22                 1386
    ## 13       23                   68
    ## 14       10                   18
    ## 15        9                    4

## Which month has the highest revenue?

    df %>% group_by(month = month(df$order_timestamp,
                                  label=T, abbr=F)) %>% 
        summarise(total_revenue = sum(total_price)) %>% arrange(-total_revenue)

    ## # A tibble: 12 × 2
    ##    month     total_revenue
    ##    <ord>             <dbl>
    ##  1 July             72558.
    ##  2 May              71403.
    ##  3 March            70397.
    ##  4 November         70395.
    ##  5 January          69793.
    ##  6 April            68737.
    ##  7 August           68278.
    ##  8 June             68230.
    ##  9 February         65160.
    ## 10 December         64701.
    ## 11 September        64180.
    ## 12 October          64028.

## Which season has the highest revenue?

    # function to classify the month
    classifySeason <- function(month) {
      # Ensure the input is in lowercase for uniformity
      month <- tolower(month)
      
      # Use switch statement to determine the season
      season <- switch(month,
                       "january" = "Winter",
                       "february" = "Winter",
                       "march" = "Spring",
                       "april" = "Spring",
                       "may" = "Spring",
                       "june" = "Summer",
                       "july" = "Summer",
                       "august" = "Summer",
                       "september" = "Autumn",
                       "october" = "Autumn",
                       "november" = "Autumn",
                       "december" = "Winter",
                       "Unknown month")  # Default case if the month doesn't match
      return(season)
    }

    # create a copy of the dataset
    df2 <- df

    # get the season
    df2$season <- sapply(month(df2$order_timestamp, label=T, abbr=F),
                         FUN=classifySeason)

    # get the ranking
    df2 %>% group_by(season) %>% summarise(
        total_revenue = sum(total_price) ) %>% arrange(-total_revenue)

    ## # A tibble: 4 × 2
    ##   season total_revenue
    ##   <chr>          <dbl>
    ## 1 Spring       210537.
    ## 2 Summer       209066.
    ## 3 Winter       199654.
    ## 4 Autumn       198603

    # remove the copy of the dataset
    rm(df2)

# Customer Behavior Analysis

## Which pizza is the favorite of customers (most ordered pizza)?

    df %>% group_by(pizza_name) %>% summarise(pizzas_ordered = sum(quantity)) %>% arrange(-pizzas_ordered)

    ## # A tibble: 32 × 2
    ##    pizza_name         pizzas_ordered
    ##    <chr>                       <dbl>
    ##  1 classic deluxe               2453
    ##  2 barbecue chicken             2432
    ##  3 hawaiian                     2422
    ##  4 pepperoni                    2418
    ##  5 thai chicken                 2371
    ##  6 california chicken           2370
    ##  7 sicilian                     1938
    ##  8 spicy italian                1924
    ##  9 southwest chicken            1917
    ## 10 big meat                     1914
    ## # ℹ 22 more rows

## Which pizza is ordered the most number of times?

    most_ordered_pizza <- df %>% group_by(pizza_name) %>% summarise(times_ordered = sum(quantity)) %>% arrange(-times_ordered) %>% head(1)

    glue('The most ordered pizza is {most_ordered_pizza$pizza_name}. It was ordered {most_ordered_pizza$times_ordered} times.')

    ## The most ordered pizza is classic deluxe. It was ordered 2453 times.

## Which pizza size is preferred by customers?

    sizes_value_counts <- table(df$pizza_size)
    most_ordered <- sizes_value_counts[
        which(sizes_value_counts == max(sizes_value_counts)) ]
    glue('The preferred pizza size is {names(most_ordered)}, ordered {unname(most_ordered)} times.')

    ## The preferred pizza size is L, ordered 18526 times.

## Which pizza category is preferred by customers?

    categories_value_counts <- table(df$pizza_category)
    most_ordered <- categories_value_counts[
        which(categories_value_counts == max(categories_value_counts)) ]
    glue('The preferred pizza category is {names(most_ordered)}, ordered {unname(most_ordered)} times.')

    ## The preferred pizza category is Classic, ordered 14579 times.

# Pizza Analysis

## The pizza with the least price and highest price

    # get list of pizzas and their prices
    pizza_names_prices <- unique(df[c("pizza_name", "unit_price")])
    # cheapest one
    cheapest_pizza = pizza_names_prices %>%
        filter(unit_price == min(pizza_names_prices$unit_price) )
    # most expensive one
    expensive_pizza = pizza_names_prices %>%
        filter(unit_price == max(pizza_names_prices$unit_price) )
                                                   
    glue('The cheapest pizza is {cheapest_pizza$pizza_name} (${cheapest_pizza$unit_price}).')

    ## The cheapest pizza is pepperoni ($9.75).

    glue('The most expensive pizza is {expensive_pizza$pizza_name} (${expensive_pizza$unit_price}).')

    ## The most expensive pizza is greek ($35.95).

## Number of pizzas per category

    df %>% group_by(pizza_category) %>% summarise(
        total_pizzas_ordered = sum(quantity) ) %>%
        arrange(-total_pizzas_ordered)

    ## # A tibble: 4 × 2
    ##   pizza_category total_pizzas_ordered
    ##   <chr>                         <dbl>
    ## 1 Classic                       14888
    ## 2 Supreme                       11987
    ## 3 Veggie                        11649
    ## 4 Chicken                       11050

## Number of pizzas per size

    df %>% group_by(pizza_size) %>% summarise(
        total_pizzas_ordered = sum(quantity) ) %>%
        arrange(-total_pizzas_ordered)

    ## # A tibble: 5 × 2
    ##   pizza_size total_pizzas_ordered
    ##   <ord>                     <dbl>
    ## 1 L                         18956
    ## 2 M                         15635
    ## 3 S                         14403
    ## 4 XL                          552
    ## 5 XXL                          28

## Pizzas with more than one category

    pizza_more_1_category =any(
        table(
            unique(df[c('pizza_name', 'pizza_category')])
            ) > 1
        ) 
    glue('Are there any pizzas belonging to more than one category? {pizza_more_1_category}')

    ## Are there any pizzas belonging to more than one category? FALSE
