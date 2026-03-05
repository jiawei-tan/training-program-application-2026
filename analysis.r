# ---------------------------------------------------------

# Melbourne Bioinformatics Training Program

# This exercise to assess your familiarity with R and git. Please follow
# the instructions on the README page and link to your repo in your application.
# If you do not link to your repo, your application will be automatically denied.

# Leave all code you used in this R script with comments as appropriate.
# Let us know if you have any questions!


# You can use the resources available on our training website for help:
# Intro to R: https://mbite.org/intro-to-r
# Version Control with Git: https://mbite.org/intro-to-git/

# ----------------------------------------------------------

# Load libraries -------------------
# You may use base R or tidyverse for this exercise

# ex. library(tidyverse)
library(tidyverse)

# Load data here ----------------------
# Load each file with a meaningful variable name.
getwd()
setwd("/vast/scratch/users/tan.j/training-program-application-2026")
metadata <- read.csv("data/GSE60450_filtered_metadata.csv")
expr <- read.csv("data/GSE60450_GeneLevel_Normalized(CPM.and.TMM)_data.csv")

# Inspect the data -------------------------

# What are the dimensions of each data set? (How many rows/columns in each?)
# Keep the code here for each file.

## Expression data
dim(expr)

## Metadata
dim(metadata)

# Prepare/combine the data for plotting ------------------------
# How can you combine this data into one data.frame?

# 1. Rename the 'X' in expr to 'gene_id'
expr <- expr %>% 
  rename(gene_id = X)

# 2. Reshape the expression data from wide to long
expr_long <- expr %>%
  pivot_longer(
    cols = starts_with("GSM"), 
    names_to = "X", 
    values_to = "expression_value"
  )

# 3. Merge with metadata based on the sample ID column 'X'
combined_df <- expr_long %>%
  left_join(metadata, by = "X")

# 4. View the result
head(combined_df)

# Plot the data --------------------------
## Plot the expression by cell type
## Can use boxplot() or geom_boxplot() in ggplot2

# Create the boxplot
ggplot(combined_df, aes(x = immunophenotype, y = log2(expression_value + 1), fill = immunophenotype)) +
  geom_boxplot(outlier.size = 0.5, alpha = 0.7) +
  theme_minimal() +
  labs(
    title = "Distribution of Gene Expression by Cell Type",
    subtitle = "Log2 transformed values",
    x = "Cell Type",
    y = "log2(Expression + 1)"
  ) +
  theme(legend.position = "none")

## Save the plot
### Show code for saving the plot with ggsave() or a similar function
ggsave(
  filename = "results/expression_by_cell_type.png", 
  width = 8, 
  height = 6, 
  dpi = 300
)
