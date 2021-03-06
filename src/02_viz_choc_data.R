# Rachel K. Riggs and Carrie Cheung, Nov 2018

# This script reads in cleaned data produced by 01_load_choc_data.R and 
# produces an exploratory visualization.
# This script takes 2 arguments:
# arg1 is the input file
# arg2 is the output file
# Input filepath specifies location of the cleaned chocolate dataset and 
# Output filepath specifies where to save .png file of exploratory visualization.

# Usage: 
# bash Rscript src/02_viz_choc_data.R data/cleaned_choc_data.csv results/choc_data_viz.png


# load libraries
suppressPackageStartupMessages(library(tidyverse))

# Read in input parameters from command line
# input <- "data/cleaned_choc_data.csv"
# output <- "results/choc_data_viz.png"
args = commandArgs(trailingOnly=TRUE)
input <- args[1]
output <- args[2]

main <- function() {
  
  # Read in data
  data <- read.csv(input)
  
  # Code in Venezuela vs other countries explicitly to allow for colouring on Venezeula
  data <- data %>%
    mutate(origin = ifelse(Broad.Bean.Origin == "Venezuela", 1, 0))
  
  # Visualize mean rating by bean's region of origin. 
  # Note: We removed 45 regions which only had 1 rating from the visualization (i.e., 
  # only regions with >1 rating are shown). We did this because many of these cases
  # represented beans which come from a combination of multiple countries
  # and which made the visualization difficut to interpret with so many (i.e. 100+) countries.
  
  (mean_rating_plot <- data %>% 
    group_by(Broad.Bean.Origin) %>%
    summarize(mean_rating = mean(Rating, na.rm = TRUE),
              origin = mean(origin), 
              n = n()) %>%
    filter(n > 1) %>%
    ggplot(aes(x = mean_rating, 
               y = fct_reorder(Broad.Bean.Origin, mean_rating), 
               colour = origin)) +
    geom_point(show.legend = FALSE) +
    xlab("Average Rating") +
    ylab("Cocoa Bean Origin") +
    scale_colour_gradient(low = "black", high = "red") +
    ggtitle("Average Chocolate Ratings by Bean Country of Origin") +
    theme_bw())
  
  # Save plot to file at specified output path
  ggsave(output)
}

# call main function
main()
