# Introduction
The R script `text-mining.R` replicates the analysis from the paper "What we talk about when we talk about EEMs: Using text mining and topic modeling to understand building energy efficiency measures (1836-RP)."

# Setup
It is recommended that you update to the latest versions of both R and RStudio (if using RStudio) prior to running this script. 

## Load packages
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
# Load required packages for anlaysis: UpSet plot, topic modeling, cosine similarity
library(UpSetR)
library(topicmodels)
library(reshape2)
library(text2vec)
library(corrplot)
```

Third, install the packages required for the part of speech (POS) tagging.  Note that this process may be time-intensive and is not required to run the majority of this script.  In addition, the POS tagging output is already provided in the `/results/text-mining/` directory.  The POS tagging analysis requires the installation of the `RDRPOSTagger` package via GitHub.  In order to install this package, you first need to do the following: 

1. Install [RTools](https://cran.r-project.org/bin/windows/Rtools/)
2. Install [Java](https://www.oracle.com/java/)

After installing both of those, run the following code in R to load the `devtools` package, and then install and load the `RDRPOSTagger` package.   

```
# Load required packages for analysis: POS Tagging
library(devtools)
devtools::install_github("bnosac/RDRPOSTagger", build_vignettes = TRUE)
library(RDRPOSTagger)
```
## Import list of EEMs
Import the main list of EEMs in the [eem-list-main.csv](data/eem-list-main.csv) file.  The relative filepaths in this script follow the same directory structure as this Github repository, and it is recommended that you use this same structure.  If you are not using RStudio, you can use `setwd()` to set the working directory to the location of the EEM list.  

```
# Import EEM list
all_docs <- read_csv("../data/eem-list-main.csv")
```
# Data cleaning and pre-processing

## Tokenization
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

## Remove stop words

After tokenization, stopwords are removed from the list of tokens using the `stopwords` package.  >> WHAT IS source=snowball? Stop words based on the Snowball stemmer's word lists (Ref: stopwords package).  

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

## Remove numeric tokens

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

## Lemmatization

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

# Analysis and Results

## Summary statistics

The number of EEMs and duplicate EEMs per document are computed, and the tokenized data is used to determine the minimum, median, and maximum EEM word lengths for each document. 

```
# EEMs per doc stats

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

# Words per EEM stats

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

# Create summary stats table
summary_stats <- eem_counts %>% 
  left_join(words_per_eem, by = "document")

# Include the totals row
summary_stats_totals <- tribble(
	~document, ~Total, ~Duplicates, ~minimum, ~median, ~average, ~maximum,
    "TOTAL", total_eems, total_duplicates, words_per_eem_corpus$minimum, 
	words_per_eem_corpus$median, words_per_eem_corpus$average, words_per_eem_corpus$maximum)

# Bind total and per document stats
summary_stats <- summary_stats %>% bind_rows(summary_stats_totals)
```

Summary statistics for each document:  

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

## Top 20 words

The 20 most frequently occurring words in the list of EEMs are determined using the lemmatized data, as well as their frequency of occurrence in each document.  

```
# Find top 20 words overall
top_20_words <- head(lemma_all_docs %>% count(word, sort = TRUE), n = 20) %>% 
  arrange(n)

# Counts of top 20 words in each document
word_doc_pairs <- lemma_all_docs %>% 
  semi_join(top_20_words, by = "word") %>% 
  count(document, word, sort = TRUE) 
```
A plot of the top 20 words and their frquency of occurrence:

![Frequency of top 20 words by document.](/results/top-20-words.png)

## Top 20 bigrams

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
  mutate(bigram = fct_reorder(bigram, n))
```
A plot of the top 20 bigrams and their frquency of occurrence:

![Frequency of top 20 bigrams by document.](/results/top-20-bigrams.png)

## UpSet plot

Five words are used to explore co-occurrence of terms in EEMs.  

```
# Create lists of EEMs containing top 5 words of interest
controls_EEMs <- lemma_all_docs[grepl("^control", lemma_all_docs$word, ignore.case = TRUE),]
pump_EEMs <- lemma_all_docs[grepl("^Pump", lemma_all_docs$word, ignore.case = TRUE),]
fan_EEMs <- lemma_all_docs[grepl("^Fan", lemma_all_docs$word, ignore.case = TRUE),]
boiler_EEMs <- lemma_all_docs[grepl("^Boiler", lemma_all_docs$word, ignore.case = TRUE),]
insulation_EEMs <- lemma_all_docs[grepl("^Insulation", lemma_all_docs$word, ignore.case = TRUE),]

# Combine list to pass to upset()
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

The set intersectons are plotted as an UpSet plot: 

![UpSet plot.](/results/upset-plot.png)

## Part of Speech (POS) tagging

POS tagging requires the `RDRPOSTagger` package.  Each token in the orgininal (pre-cleaned) data is tagged with a part of speech.   
 
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

## Topic modeling: Perplexity analysis

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

## Topic modeling: k=6 topics 

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
  mutate(term = fct_reorder(term, beta),
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

The gamma matrix shows the distibution of topics across documents:

![Topic model gamma distribution.](/results/topic-model-gamma.png)


## Cosine similarity

Cosine similarity quantifies similarity between documents.  

```
# Compute cosine similarities
similarity <- round(100*sim2(all_docs_matrix, method = "cosine"), 0)
```

The cosine similarity can be shown in matrix format:

![Cosine similarity matrix.](/results/cosine-similarity.png)