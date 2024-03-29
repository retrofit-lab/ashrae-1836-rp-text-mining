# What we talk about when we talk about EEMs: Using text mining and topic modeling to understand building energy efficiency measures (1836-RP)

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.6726629.svg)](https://doi.org/10.5281/zenodo.6726629)

This repository contains the data and code for the paper ["What we talk about when we talk about EEMs: Using text mining and topic modeling to understand building energy efficiency measures (1836-RP)"](https://doi.org/10.1080/23744731.2022.2133329), published in *Science and Technology for the Built Environment*.  This study was conducted as part of ASHRAE Research Project 1836, Developing a standardized categorization system for energy efficiency measures.  

## Contents  
- [Citation](#citation)  
- [Related Publications](#related-publications)  
- [Repository Structure](#repository-structure)  
- [Objective](#objective)  
- [Data](#data)  
    - [ASHRAE 1836-RP main list of EEMs](#ashrae-1836-rp-main-list-of-eems)  
- [Analysis](#analysis)  
    - [Setup](#setup)  
    - [Data cleaning and pre-processing](#data-cleaning-and-pre-processing)  
    - [Results](#results)  

## Citation
To cite the paper:
- Khanuja, Apoorv, and Amanda L. Webb. 2023. “What We Talk about When We Talk about EEMs: Using Text Mining and Topic Modeling to Understand Building Energy Efficiency Measures (1836-RP).” Science and Technology for the Built Environment 29 (1): 4–18. https://doi.org/10.1080/23744731.2022.2133329.

To cite the dataset:
- Khanuja, Apoorv, and Webb, Amanda. (2022). ASHRAE 1836-RP main list of energy efficiency measures (v1.0) [Data set]. Zenodo. https://doi.org/10.5281/zenodo.6726629

## Related Publications
- [Webb, Amanda, and Apoorv Khanuja. 2023. “Developing a Standardized Categorization System for Energy Efficiency Measures.” Final Report RP-1836. ASHRAE.](https://www.techstreet.com/ashrae/standards/rp-1836-developing-a-standardized-categorization-system-for-energy-efficiency-measures?product_id=2255440) (ASHRAE members can access for free from the [ASHRAE Technology Portal](https://www.ashrae.org/technical-resources/technology-portal))

## Repository Structure
The repository is divided into three directories:
- `/data/`: Dataset of EEMs created and analyzed as part of 1836-RP
- `/analysis/`: R script for text mining analysis
- `/results/`: Output produced by R script

## Objective
Energy Efficiency Measures (EEMs) play a central role throughout the building energy efficiency industry, and lists of EEMs therefore exist in a variety of resources. However, each of these use different conventions for describing and organizing measures, which presents a major challenge for aggregating information across these resources. The goal of this study was to discover trends in how existing resources describe and organize EEMs using topic modeling and other text mining methods. 

## Data
There is one dataset associated with this project. 

### ASHRAE 1836-RP main list of EEMs
The file [eem-list-main.csv](data/eem-list-main.csv) contains the complete list of 3,490 EEMs assembled and analyzed as part of 1836-RP.  This data file is used for the text mining analysis in [text-mining.R](analysis/text-mining.R).  The EEMs were collected from 16 different source documents during the 1836-RP literature review from September 2019 through July 2020.  An initial list of suggested sources was provided by the members of the 1836-RP Project Advisory Board, and additional documents were added through the authors’ literature review.  In order for a source to be included in the review, it needed to contain a list of EEMs.

The file contains five variables:

-	`eem_id`: A unique ID assigned to each measure in the list.
-	`document` : An alphanumeric abbreviation code 3-6 characters in length representing the name of the original source document from which the measure was collected. The 16 document codes and their corresponding citations are:

    | Document | Citation |
    | ----------- | ----------- |
    | 1651RP | Glazer, Jason. 2015. Development of Maximum Technically Achievable Energy Targets for Commercial Buildings: Ultra-Low Energy Use Building Set. ASHRAE Research Project 1651-RP Final Report. Arlington Heights, IL: Gard Analytics. |
    | ATT | Pacific Northwest National Laboratory. 2020. Audit Template, Release 2020.2.0. https://buildingenergyscore.energy.gov/. |
    | BCL | National Renewable Energy Laboratory. 2020. Building Component Library. https://bcl.nrel.gov/. |
    | BEQ | ASHRAE. 2020. Building EQ. https://buildingeq.ashrae.org/. |
    | BSYNC | National Renewable Energy Laboratory. 2020. BuildingSync, Version 2.0. https://buildingsync.net/. |
    | CBES | Lawrence Berkeley National Laboratory. 2020. Commercial Building Energy Saver. http://cbes.lbl.gov/. |
    | DOTY | Doty, Steve. 2011. Commercial Energy Auditing Reference Handbook. 2nd ed. Boca Raton: Fairmont Press. |
    | IEA11 | Lyberg, Mats Douglas, ed. 1987. Source Book for Energy Auditors. Vol. 1. Stockholm, Sweden: Swedish Council for Building Research. https://www.iea-ebc.org/projects/project?AnnexID=11. |
    | IEA46 | Zhivov, Alexander, and Cyrus Nasseri, eds. 2014. Energy Efficient Technologies and Measures for Building Renovation: Sourcebook. IEA ECBS Annex 46. https://www.iea-ebc.org/Data/publications/EBC_Annex_46_Technologies_and_Measures_Sourcebook.pdf. |
    | ILTRM | Illinois Energy Efficiency Stakeholder Advisory Group. 2019. 2020 Illinois Statewide Technical Reference Manual for Energy Efficiency Version 8.0. https://www.ilsag.info/technical-reference-manual/il_trm_version_8/. |
    | NYTRM | New York State Joint Utilities. 2019. New York Standard Approach for Estimating Energy Savings from Energy Efficiency Programs - Residential, Multi-Family, and Commercial/Industrial Measures Version 7. http://www3.dps.ny.gov/W/PSCWeb.nsf/All/72C23DECFF52920A85257F1100671BDD. |
    | REMDB | National Renewable Energy Laboratory. National Residential Energy Efficiency Measures Database, Version 3.1.0. https://remdb.nrel.gov/. |
    | STD100 | ASHRAE. 2018. ASHRAE Standard 100-2018, Energy Efficiency in Existing Buildings. Atlanta: ASHRAE |
    | THUM | Thumann, Albert, ed. 1992. Energy Conservation in Existing Buildings Deskbook. Lilburn, GA: Fairmont Press. |
    | WSU | Washington State University Cooperative Extension and Energy Program. 2003. Washington State University Energy Program Energy Audit Workbook. WSUCEEP2003-043. http://www.energy.wsu.edu/PublicationsandTools.aspx. |
    | WULF | Wulfinghoff, Donald. 1999. Energy Efficiency Manual: For Everyone Who Uses Energy, Pays for Utilities, Controls Energy Usage, Designs and Builds, Is Interested in Energy and Environmental Preservation. Wheaton, MD: Energy Institute Press. |

-	`cat_lev1`: The name of the Level 1 category (i.e., highest level) under which the measure was categorized in the original source document.
-	`cat_lev2`: The name of the Level 2 category (i.e., subcategory, if present), under which the measure was categorized in the original source document.  If a Level 2 category was not present, the value of this variable was coded as “0”. 
-	`eem_name`: The name of the measure as written in the original source document.

## Analysis
The R script `text-mining.R` replicates the analysis from the paper.

### Setup
It is recommended that you update to the latest versions of both R and RStudio (if using RStudio) prior to running this script. 

#### Load packages
First, load (or install if you do not already have them installed) the packages required for data handling, tokenization, stop word removal, and lemmatization. 

```
# Load required packages for data cleaning 
library(readr)
library(tidyverse)
library(tidytext)
library(textstem)
```

Second, load the packages required for the text mining and topic modeling analysis. 

```
# Load required packages for analysis: UpSet plot, topic modeling, cosine similarity
library(UpSetR)
library(topicmodels)
library(reshape2)
library(text2vec)
library(corrplot)
```

Third, install the packages required for the part of speech (POS) tagging.  Note that this process may be time-intensive and is not required to run the majority of this script.  In addition, the POS tagging output is already provided in the `/results/` directory.  The POS tagging analysis requires the installation of the `RDRPOSTagger` package via GitHub.  In order to install this package, you first need to do the following: 

1. Install [RTools](https://cran.r-project.org/bin/windows/Rtools/)
2. Install [Java](https://www.oracle.com/java/)

After installing both of those, run the following code in R to load the `devtools` package, and then install and load the `RDRPOSTagger` package.   

```
# Load required packages for analysis: POS Tagging
library(devtools)
devtools::install_github("bnosac/RDRPOSTagger", build_vignettes = TRUE)
library(RDRPOSTagger)
```
#### Import list of EEMs
Import the main list of EEMs in the [eem-list-main.csv](data/eem-list-main.csv) file.  The relative filepaths in this script follow the same directory structure as this Github repository, and it is recommended that you use this same structure.  You might have to use `setwd()` to set the working directory to the location of the R script.  

```
# Import EEM list
all_docs <- read_csv("../data/eem-list-main.csv")
```
### Data cleaning and pre-processing

#### Tokenization
Each EEM is tokenized into individual words.  

```
# Tokenize EEMs into single words
token_all_docs <- all_docs %>% 
  select(eem_id, document, eem_name) %>% 
  # no need to keep the categorization levels 1 and 2
  # since we are not doing any categorization analysis
  unnest_tokens(word, eem_name, drop = FALSE, token = "words")
```

This produces a list of each token in the main list, by EEM, by document.  The first 10 lines:   

```
   eem_id document eem_name                                    word       
    <dbl> <chr>    <chr>                                       <chr>      
 1      1 1651RP   Daylighting and Occupant Control by Fixture daylighting
 2      1 1651RP   Daylighting and Occupant Control by Fixture and        
 3      1 1651RP   Daylighting and Occupant Control by Fixture occupant   
 4      1 1651RP   Daylighting and Occupant Control by Fixture control    
 5      1 1651RP   Daylighting and Occupant Control by Fixture by         
 6      1 1651RP   Daylighting and Occupant Control by Fixture fixture  
 7      2 1651RP   Dimming daylight controls                   dimming    
 8      2 1651RP   Dimming daylight controls                   daylight   
 9      2 1651RP   Dimming daylight controls                   controls
10      3 1651RP   Optimal Daylighting Control                 optimal   
```    

#### Remove stop words

After tokenization, stopwords are removed from the list of tokens using the `stopwords` package.  

```
# Remove stop words from EEMs
minus_stopwords_all_docs <- token_all_docs %>% 
  filter(!(word %in% stopwords::stopwords(source = "snowball")))

# List of stop words removed from each EEM
removed_stopwords <- token_all_docs %>% 
  filter((word %in% stopwords::stopwords(source = "snowball")))

# List of unique stop words getting removed 
unique_stopwords <- removed_stopwords %>% 
  select(word) %>% 
  unique() %>%
  arrange(word)
``` 
`unique_stopwords` provides a list of all of the stop words that were removed from the EEMs. 

|stop words |
|:----------|
|a, about, above, after, again, against, all, an, and, any, are, as, at, be, been, before, being, below, between, both, but, by, cannot, do, does, doesn't, down, during, each, for, from, further, has, have, having, here, i, if, in, into, is, it, its, more, most, no, not, of, off, on, once, only, or, other, out, over, own, same, should, so, some, such, than, that, the, their, them, then, there, these, they, they're, this, those, through, to, too, under, until, up, was, when, where, which, while, who, will, with, would |

#### Remove numeric tokens

Tokens that begin with a number are then removed as additional stop words.  Within the context of an EEM, these generallly provide overly specific detail (e.g., airflow rates, lighting color temperatures) not essential for describing an EEM.    

```
# Remove numeric stop words from EEMs
minus_numerics_all_docs <- minus_stopwords_all_docs %>% 
  filter(!str_detect(minus_stopwords_all_docs$word, "^\\d"))

# List of numeric stop words removed from each EEM
numeric_tokens <- minus_stopwords_all_docs %>% 
  filter(str_detect(minus_stopwords_all_docs$word, "^\\d"))

# List of unique numeric stop words getting removed
unique_num_stopwords <- numeric_tokens %>% 
  select(word) %>% 
  unique() %>%
  arrange(word)
```

`unique_num_stopwords` provides a list of all of the numeric tokens that were removed from the EEMs. 

|numeric stop words |
|:------------------|
|0.18, 0.2, 0.25, 0.29, 0.4cfm, 0.67w, 0.6w, 0.7w, 0.82, 0.93, 0.95, 020, 1, 1.5, 1.6, 1.75, 10, 10.6, 100, 11, 11.0, 11.2, 113, 12, 12.5, 120, 125, 14, 140, 15, 180, 189.1, 2, 20, 2007, 2010, 2011, 25, 27, 2700, 2700k, 3, 3.2, 3.3, 3.7, 30, 300, 3000, 3000k, 350, 3500, 3500k, 4, 40, 4000, 4000k, 42, 45, 49, 5, 5.3.3, 50, 50w, 55, 59, 6.27, 60, 62.1, 65, 7, 70, 746, 8, 80, 81, 8258, 83, 9.4.1, 9.5, 90.1, 92, 95 |

#### Lemmatization

The remaining tokens are then lemmatized into their root form. 

```
# Lemmatize EEM tokens 
lemma_all_docs <- minus_numerics_all_docs %>% 
  mutate(word = lemmatize_words(word))
```

The first 10 lines of the EEM token list now read:   

```
   eem_id document eem_name                                    word       
    <dbl> <chr>    <chr>                                       <chr>      
 1      1 1651RP   Daylighting and Occupant Control by Fixture daylighting
 2      1 1651RP   Daylighting and Occupant Control by Fixture occupant   
 3      1 1651RP   Daylighting and Occupant Control by Fixture control    
 4      1 1651RP   Daylighting and Occupant Control by Fixture fixture    
 5      2 1651RP   Dimming daylight controls                   dim        
 6      2 1651RP   Dimming daylight controls                   daylight   
 7      2 1651RP   Dimming daylight controls                   control    
 8      3 1651RP   Optimal Daylighting Control                 optimal    
 9      3 1651RP   Optimal Daylighting Control                 daylighting
10      3 1651RP   Optimal Daylighting Control                 control    
```

### Results

#### Summary statistics

The number of EEMs and duplicate EEMs per document are then computed using the original (i.e., pre-cleaned) data. 

```
# Total number of EEMs per doc
eems_per_doc <- all_docs %>% 
  count(document) %>% 
  rename(Total = n)

# Total number of EEMs across all docs
total_eems <- nrow(all_docs)

# Convert EEMs to lower case since unique() is case sensitive
all_docs$eem_name <- tolower(all_docs$eem_name)

# Number of unique EEMs per doc
unique_eems_per_doc <- all_docs %>% 
  select(document, eem_name) %>% 
  unique() %>% 
  count(document) %>% 
  rename(Uniques = n)

# Number of unique EEMs across all docs
total_unique_eems <- all_docs %>% 
  select(eem_name) %>% 
  unique() %>% 
  nrow()

# Number of duplicate EEMs per doc
eem_counts <- eems_per_doc %>% 
  full_join(unique_eems_per_doc, by = "document") %>% 
  mutate(Duplicates = Total - Uniques) %>% 
  select(-Uniques)

# Number of duplicate EEMs across all docs
total_duplicates <- total_eems - total_unique_eems
```

The tokenized data is then used to determine the minimum, median, and maximum EEM word lengths for each document.

```
# Words per EEM by doc
words_per_eem <- token_all_docs %>% 
  group_by(document) %>% 
  count(eem_id) %>% 
  summarise(minimum = min(n),
            median = round(median(n),1),
            average = round(mean(n),1),
            maximum = max(n))

# Words per EEM across all documents
words_per_eem_corpus <- token_all_docs %>% 
  count(eem_id) %>% 
  summarise(minimum = min(n),
            median = round(median(n),1),
            average = round(mean(n),1),
            maximum = max(n))
```

These are compiled into a table of summary statistics for each document:  

|document | Total| Duplicates| minimum| median| average| maximum|
|:--------|-----:|----------:|-------:|------:|-------:|-------:|
|1651RP   |   398|          0|       1|    5.0|     5.2|      17|
|ATT      |   223|         82|       1|    4.0|     4.2|      14|
|BCL      |   302|          0|       1|    3.0|     3.9|      14|
|BEQ      |   295|          1|       2|   12.0|    11.9|      41|
|BSYNC    |   223|         82|       1|    4.0|     4.2|      14|
|CBES     |   102|          0|       2|    7.0|     7.5|      19|
|DOTY     |    69|          0|       1|    4.0|     4.8|      11|
|IEA11    |   232|          0|       2|    5.0|     5.3|      13|
|IEA46    |   420|          4|       1|   12.5|    16.7|     109|
|ILTRM    |   193|          4|       2|    4.0|     4.5|      12|
|NYTRM    |   108|         20|       1|    4.0|     4.2|      13|
|REMDB    |   136|          3|       1|    4.0|     4.5|      14|
|STD100   |   241|          1|       2|   15.0|    18.3|     103|
|THUM     |    52|          0|       2|    6.0|     5.8|      15|
|WSU      |   130|          0|       2|    6.0|     6.5|      17|
|WULF     |   366|         13|       2|   11.0|    12.6|      41|
|TOTAL    |  3490|        511|       1|    6.0|     8.6|     109|

#### Top 20 words

The lemmatized data is used to find the 20 most frequently occurring words in the list of EEMs.  Their frequency of occurrence in each document is then determined.   

```
# Find the top 20 words overall
top_20_words <- head(lemma_all_docs %>% count(word, sort = TRUE), n = 20) %>% 
  arrange(n)

# Counts of top 20 words in each document
word_doc_pairs <- lemma_all_docs %>% 
  semi_join(top_20_words, by = "word") %>% 
  count(document, word, sort = TRUE) 
```
A plot of the top 20 words and their frequency of occurrence:

![Frequency of top 20 words by document.](/results/top-20-words.png)

#### Top 20 bigrams

The lemmatized data is used to create bigrams from each token in the list.  The last token in each EEM is paired with "NA" to indicate that it is not a valid bigram. 

```
# Use the lemmatized bag of words to find bigrams within each EEM in the list
bigram_table <- tribble(~eem_id, ~document, ~eem_name, ~word)
for (i in unique(lemma_all_docs$eem_id)) {
    bigram_table_x <- lemma_all_docs %>% 
      filter(eem_id == i) 
    bigram_table_x <- bigram_table_x %>% 
      mutate(bigram = paste(.$word[row_number()], .$word[row_number()+1], sep = " "))
    bigram_table <- bigram_table %>% bind_rows(bigram_table_x)
}
```

The first 10 lines of the EEM token list now read: 

```
   eem_id document eem_name                                    word        bigram              
    <dbl> <chr>    <chr>                                       <chr>       <chr>               
 1      1 1651RP   Daylighting and Occupant Control by Fixture daylighting daylighting occupant
 2      1 1651RP   Daylighting and Occupant Control by Fixture occupant    occupant control    
 3      1 1651RP   Daylighting and Occupant Control by Fixture control     control fixture     
 4      1 1651RP   Daylighting and Occupant Control by Fixture fixture     fixture NA          
 5      2 1651RP   Dimming daylight controls                   dim         dim daylight        
 6      2 1651RP   Dimming daylight controls                   daylight    daylight control    
 7      2 1651RP   Dimming daylight controls                   control     control NA          
 8      3 1651RP   Optimal Daylighting Control                 optimal     optimal daylighting 
 9      3 1651RP   Optimal Daylighting Control                 daylighting daylighting control 
10      3 1651RP   Optimal Daylighting Control                 control     control NA          
```

The bigrams containing "NA" are removed and the 20 most frequently occurring bigrams in the list of EEMs are determined, as well as their frequency of occurrence in each document.  

```
# Remove the erroneous bigrams of the form "[last word of the EEM] [NA]"
bigram_table_minus_NAs <- bigram_table %>% 
  filter(!grepl("NA$", .$bigram))

# Find top 20 bigrams overall
top_20_bigrams <- head(bigram_table_minus_NAs %>% 
                         count(bigram, sort = TRUE), n = 20) %>% 
  arrange(n)

# Counts of top 20 bigrams in each document
bigram_doc_pairs <- bigram_table %>% 
  semi_join(top_20_bigrams, by = "bigram") %>% 
  count(document, bigram, sort = TRUE) %>% 
  mutate(bigram = forcats::fct_reorder(bigram, n))
```
A plot of the top 20 bigrams and their frequency of occurrence:

![Frequency of top 20 bigrams by document.](/results/top-20-bigrams.png)

#### UpSet plot

Five words are used to explore the co-occurrence of terms in EEMs.  

```
# Create lists of EEMs containing top 5 words of interest
controls_EEMs <- lemma_all_docs[grepl("^control", lemma_all_docs$word, ignore.case = TRUE),]
pump_EEMs <- lemma_all_docs[grepl("^Pump", lemma_all_docs$word, ignore.case = TRUE),]
fan_EEMs <- lemma_all_docs[grepl("^Fan", lemma_all_docs$word, ignore.case = TRUE),]
boiler_EEMs <- lemma_all_docs[grepl("^Boiler", lemma_all_docs$word, ignore.case = TRUE),]
insulation_EEMs <- lemma_all_docs[grepl("^Insulation", lemma_all_docs$word, ignore.case = TRUE),]

# Combine list to pass upSet()
listInput <- list(Controls = controls_EEMs$eem_id, 
                  Pump = pump_EEMs$eem_id, 
                  Fan = fan_EEMs$eem_id, 
                  Boiler = boiler_EEMs$eem_id,
                  Insulation = insulation_EEMs$eem_id)

# Plot set intersections as UpSet plot
upset(fromList(listInput), 
      order.by = "freq", 
      text.scale = c(1.3, 1.7, 1.3, 1.6, 2, 1.75))
```

The set intersections are plotted as an UpSet plot: 

![UpSet plot.](/results/upset-plot.png)

#### Part of Speech (POS) tagging

POS tagging requires the `RDRPOSTagger` package.  Each token in the original (pre-cleaned) data is tagged with a part of speech.   
 
```
# The following lines of code only work if RDRPOSTagger package was installed and loaded
tagger <- rdr_model(language = "English", annotation = "UniversalPOS")
pos_tags <- rdr_pos(tagger, x = all_docs$eem_name)
```

The first 10 lines:

|doc_id | token_id|token       |pos   |
|:------|--------:|:-----------|:-----|
|d1     |        1|Daylighting |VERB  |
|d1     |        2|and         |CCONJ |
|d1     |        3|Occupant    |ADJ   |
|d1     |        4|Control     |PROPN |
|d1     |        5|by          |ADP   |
|d1     |        6|Fixture     |NOUN  |
|d2     |        1|Dimming     |VERB  |
|d2     |        2|daylight    |NOUN  |
|d2     |        3|controls    |NOUN  |
|d3     |        1|Optimal     |ADJ   |

#### Topic modeling: Perplexity analysis

Perplexity analysis is performed to help determined the number of topics for the topic model.  

```
# Create DTM using word counts 
all_docs_matrix <- lemma_all_docs %>% 
  count(document, word) %>% 
  cast_dtm(document, word, n) %>% 
  as.matrix()

# Sample 80% (12) sources as training data and 20% (4) sources as test data
set.seed(42)
sample_size <- floor(0.80 * nrow(all_docs_matrix))
train_ind <- sample(nrow(all_docs_matrix), size = sample_size)
train <- all_docs_matrix[train_ind, ]
test <- all_docs_matrix[-train_ind, ]

# Perplexity analysis for k = 2 to 12. Selected k=6.
values <- c()
for (i in c(2:12)) {
  lda_model <- LDA(train, k = i, method = "Gibbs", control = list(seed = 42))
  values <- c(values, topicmodels::perplexity(lda_model, newdata = test))
}
```

The perplexity for each potential model is plotted:  

![Perplexity analysis.](/results/perplexity.png)

#### Topic modeling: k=6 topics 

Topic models are created for k=6 topics.  

```
# Create topic model for k=6
LDA_6_topics <- LDA(all_docs_matrix, k = 6, method = "Gibbs", control = list(seed = 42))

# Extract topic model beta matrix
beta_6_topics <- LDA_6_topics %>% 
  tidy(matrix = "beta") %>% 
  group_by(topic) %>% 
  top_n(15, beta) %>% 
  ungroup() %>% 
  mutate(term = forcats::fct_reorder(term, beta),
         topic = paste0("Topic ", topic),
         beta = round(beta, 3)) %>% 
  arrange(topic, desc(beta))
```
The beta matrix shows the distribution of words within topics.  For Topics 1-3:  

|topic   |term        |  beta|topic   |term     |  beta|topic   |term       |  beta|
|:-------|:-----------|-----:|:-------|:--------|-----:|:-------|:----------|-----:|
|Topic 1 |heat        | 0.041|Topic 2 |install  | 0.035|Topic 3 |add        | 0.031|
|Topic 1 |cool        | 0.037|Topic 2 |system   | 0.026|Topic 3 |zone       | 0.018|
|Topic 1 |control     | 0.036|Topic 2 |light    | 0.020|Topic 3 |set        | 0.018|
|Topic 1 |air         | 0.032|Topic 2 |water    | 0.018|Topic 3 |build      | 0.015|
|Topic 1 |system      | 0.031|Topic 2 |use      | 0.016|Topic 3 |cop        | 0.014|
|Topic 1 |use         | 0.027|Topic 2 |replace  | 0.016|Topic 3 |eer        | 0.012|
|Topic 1 |water       | 0.023|Topic 2 |reduce   | 0.015|Topic 3 |doas       | 0.011|
|Topic 1 |high        | 0.022|Topic 2 |energy   | 0.011|Topic 3 |story      | 0.011|
|Topic 1 |temperature | 0.021|Topic 2 |hour     | 0.009|Topic 3 |area       | 0.010|
|Topic 1 |reduce      | 0.018|Topic 2 |consider | 0.009|Topic 3 |demand     | 0.010|
|Topic 1 |efficiency  | 0.017|Topic 2 |lamp     | 0.009|Topic 3 |economizer | 0.010|
|Topic 1 |light       | 0.016|Topic 2 |sensor   | 0.008|Topic 3 |hvac       | 0.010|
|Topic 1 |chill       | 0.014|Topic 2 |build    | 0.008|Topic 3 |value      | 0.010|
|Topic 1 |fan         | 0.014|Topic 2 |zone     | 0.008|Topic 3 |type       | 0.010|
|Topic 1 |motor       | 0.012|Topic 2 |space    | 0.008|Topic 3 |efficiency | 0.009|

The gamma matrix shows the distribution of topics across documents:

![Topic model gamma distribution.](/results/topic-model-gamma.png)


#### Cosine similarity

Cosine similarity quantifies the similarity between documents.  

```
# Compute cosine similarities
similarity <- round(100*sim2(all_docs_matrix, method = "cosine"), 0)
```

The cosine similarity can be shown in matrix format:

![Cosine similarity matrix.](/results/cosine-similarity.png)
