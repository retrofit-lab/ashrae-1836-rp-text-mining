## -----------------------------------------------------------------------------------------------
## Title: text-mining.R
## Purpose: Replicates analysis from the paper "What we talk about when we talk about EEMs: Using 
## text mining and topic modeling to understand building energy efficiency  measures (1836-RP)"
## Author: Apoorv Khanuja and Amanda Webb
## Date: June 22, 2022
## -----------------------------------------------------------------------------------------------

## Setup

# Load required packages for data cleaning 
library(readr)
library(tidyverse)
library(tidytext)
library(textstem)

# Load required packages for analysis: UpSet plot, topic modeling, cosine similarity
library(UpSetR)
library(topicmodels)
library(reshape2)
library(text2vec)
library(corrplot)

# Load required packages for analysis: POS Tagging
library(devtools)
devtools::install_github("bnosac/RDRPOSTagger", build_vignettes = TRUE)
library(RDRPOSTagger)

# Import EEM list
all_docs <- read_csv("../data/eem-list-main.csv")

## Data cleaning and pre-processing

### Tokenization

# Tokenize EEMs into single words
token_all_docs <- all_docs %>% 
  select(eem_id, document, eem_name) %>% 
  # no need to keep the categorization levels 1 and 2
  # since we are not doing any categorization analysis
  unnest_tokens(word, eem_name, drop = FALSE, token = "words")
    
### Remove stop words

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
  
# Display list of unique stopwords getting removed in markdown format
knitr::kable(unique_stopwords %>% 
  dplyr::summarise(`stop words` = paste(word, collapse = ", "))) 
 
### Remove tokens that begin with a number as additional stop words

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

# Markdown display list of unique numeric stop words getting removed
knitr::kable(unique_num_stopwords %>% 
  dplyr::summarise(`numeric stop words` = paste(word, collapse = ", ")))

### Lemmatization

# Lemmatize EEM tokens into root form
lemma_all_docs <- minus_numerics_all_docs %>% 
  mutate(word = lemmatize_words(word))

## Analysis and Results

### Summary statistics

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

# Markdown display summary stats table
knitr::kable(summary_stats)

# Export the stats as a CSV file
write_csv(summary_stats, "../results/summary-stats.csv")

### Top 20 words

# Find top 20 words overall
top_20_words <- head(lemma_all_docs %>% count(word, sort = TRUE), n = 20) %>% 
  arrange(n)

# Counts of top 20 words in each document
word_doc_pairs <- lemma_all_docs %>% 
  semi_join(top_20_words, by = "word") %>% 
  count(document, word, sort = TRUE) 

# Bind both data frames to include marginal totals in the figure
word_doc_pairs_w_totals <- top_20_words %>% 
  mutate(document = paste0("TOTAL")) %>% 
  select(document, word, n) %>% 
  bind_rows(word_doc_pairs) %>% 
  arrange(n)

# How many of the top 20 words occur in each source? 
knitr::kable(word_doc_pairs %>% count(document))

# Plot count of top 20 words by document
ggplot(word_doc_pairs_w_totals, 
       aes(x = fct_inorder(document), 
           y = factor(word, levels = fct_inorder(top_20_words$word)), 
           label = n)) + 
  geom_raster(fill = "light grey", show.legend = FALSE) +
  geom_text(col = "black") +
  theme_minimal() +
  labs(x = "Documents", y = "Words") +
  theme(axis.text.x=element_text(angle=90, vjust=0.3))

### Top 20 bigrams

# Use the lemmatized bag of words to find bigrams within each EEM in the list
bigram_table <- tribble(~eem_id, ~document, ~eem_name, ~word)
for (i in unique(lemma_all_docs$eem_id)) {
    bigram_table_x <- lemma_all_docs %>% 
      filter(eem_id == i) 
    bigram_table_x <- bigram_table_x %>% 
      mutate(bigram = paste(.$word[row_number()], .$word[row_number()+1], sep = " "))
    bigram_table <- bigram_table %>% bind_rows(bigram_table_x)
}

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

# Bind both data frames to include marginal totals in the figure
bigram_doc_pairs_w_totals <- top_20_bigrams %>% 
  mutate(document = paste0("TOTAL")) %>% 
  select(document, bigram, n) %>% 
  bind_rows(bigram_doc_pairs) %>% 
  arrange(n)

# How many of the top 20 bigrams occur in each source? 
knitr::kable(bigram_doc_pairs %>% count(document))

# Plot count of top 20 bigrams by document
ggplot(bigram_doc_pairs_w_totals, 
       aes(x = fct_inorder(document), 
           y = factor(bigram, levels = fct_inorder(top_20_bigrams$bigram)), 
           label = n)) + 
  geom_raster(fill = "light grey", show.legend = FALSE) + 
  geom_text(col = "black") +
  labs(x = "Documents", y = "Bigrams") +
  theme_minimal() +
  theme(axis.text.x=element_text(angle=90, vjust=0.3))

### UpSet plot

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

### Part of Speech (POS) tagging

# The following lines of code only work if RDRPOSTagger package was installed and loaded
tagger <- rdr_model(language = "English", annotation = "UniversalPOS")
pos_tags <- rdr_pos(tagger, x = all_docs$eem_name)

# Export the POS tagged EEMs as a CSV file
write_csv(pos_tags, "../results/pos-tags.csv")

# Subset the first 5 EEMs tagged with their parts of speech
first_5 <- pos_tags %>%
  filter(doc_id %in% paste0("d", 1:5))

# Display the first 5 EEMs tagged with their parts of speech
knitr::kable(first_5)

### Topic modeling: Perplexity analysis

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

# Perplexity analysis for k = 2 to 20. Selected k=6.
values <- c()
for (i in c(2:12)) {
  lda_model <- LDA(train, k = i, method = "Gibbs", control = list(seed = 42))
  values <- c(values, topicmodels::perplexity(lda_model, newdata = test))
}

plot(c(2:12), values, main = "Perplexity for Topics", xlab = "Number of topics", ylab = "Perplexity")

### Topic modeling: k=6 topics 

# Create topic model for k=6
LDA_6_topics <- LDA(all_docs_matrix, k = 6, method = "Gibbs", control = list(seed = 42))

# Extract topic model beta matrix
beta_6_topics <- LDA_6_topics %>% 
  tidy(matrix = "beta") %>% 
  group_by(topic) %>% 
  arrange(desc(beta)) %>% 
  slice_head(n = 15) %>% 
  ungroup() %>% 
  mutate(term = fct_reorder(term, beta),
         topic = paste0("Topic ", topic),
         beta = round(beta, 3)) %>% 
  arrange(topic, desc(beta))

# Display topic model beta matrix
knitr::kable(list(cbind(beta_6_topics[1:15,], beta_6_topics[16:30,], beta_6_topics[31:45,]),
	cbind(beta_6_topics[46:60,], beta_6_topics[61:75,],beta_6_topics[76:90,])))

# Export topic model beta matrix as a CSV file
write_csv(beta_6_topics, "../results/topic-model-beta.csv")

# Plot topic model gamma matrix
LDA_6_topics %>% 
  tidy(matrix = "gamma") %>% 
  ggplot(aes(x=document, y=gamma, label=round(100*gamma, 0), order=as.factor(topic))) +
  geom_col(aes(fill=as.factor(topic))) +
  geom_text(size = 3, position = position_fill(vjust = 0.5)) +
  guides(fill=guide_legend(title="Topic")) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90)) +
  labs(x = "Documents", y = "Percentage") +
  scale_y_continuous(labels =  c("0", "25", "50", "75", "100"))

### Cosine similarity

# Compute cosine similarities
similarity <- round(100*sim2(all_docs_matrix, method = "cosine"), 0)

# Plot cosine similarity matrix
corrplot(similarity, method = "number",
         col = 'black',
         type = "upper", is.corr = FALSE,
         tl.col = "black", tl.srt = 45, cl.pos = "n",
         number.digits = 0,
         tl.cex = 0.9, number.cex = 0.6)

# Export cosine similarity matrix matrix as a CSV file
write.csv(similarity, "../results/cosine-similarity.csv")
