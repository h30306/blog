---
title: "DVA-BERT: Sentiment-Based Masked Language Modeling for Valence–Arousal Prediction"
summary: "Applied Intelligence 2022: masking sentiment words instead of random tokens as an auxiliary task to improve sentence-level valence–arousal prediction"
description: "A multi-task BERT model that replaces random masking with sentiment-word masking and combines VA intensity estimation with masked sentiment word prediction"
date: 2022-03-22
tags: ["paper", "nlp", "sentiment-analysis", "bert", "masked-language-model", "valence-arousal"]
categories: ["paper"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Paper Info

| Item | Details |
|---|---|
| Venue | Applied Intelligence 52 (14), 16353–16369 (2022) |
| Title | Sentiment-based masked language modeling for improving sentence-level valence–arousal prediction |
| Authors | Jheng-Long Wu, **Wei-Yi Chung** |
| DOI | [10.1007/s10489-022-03384-9](https://doi.org/10.1007/s10489-022-03384-9) |
| Code | [h30306/Sentiment-Based-Masked-Language-Modeling-for-Improving-Sentence-Level-Valence-Arousal-Prediction](https://github.com/h30306/Sentiment-Based-Masked-Language-Modeling-for-Improving-Sentence-Level-Valence-Arousal-Prediction) |

This was one of the first research topics I started in the NLP Lab. In early 2020 I wrote the first version in the IJCAI-PRICAI 2020 format (*A Novel Dimensional Valence-Arousal Prediction Model Using Masked Sentiment Words Approach*), then extended it into a journal paper and, after several rounds of revision in IEEE format, submitted it to Applied Intelligence. Per the paper's CRediT statement, I was responsible for conceptualization, methodology, experiments, and writing.

## Motivation

Sentiment is more than positive versus negative. **Dimensional sentiment (valence–arousal, VA)** uses continuous scores: valence is how positive or negative, arousal is how excited or calm.

BERT's masked language modeling (MLM) masks every token with the same probability regardless of how much it contributes to sentiment, so the learned features do not emphasize the sentiment words in a sentence.

## Method: DVA-BERT

- **Main task**: sentence-level VA intensity estimation (regression).
- **Auxiliary task**: replace MLM with **random masked sentiment words**, so the model predicts which sentiment word was masked.
- The sentiment lexicon comes from CVAW (word-level VA annotated on a 1–9 scale).
- Several masking-probability schemes: by the word's valence or arousal intensity, their intersection or union, or reversed (lower intensity, more likely to be masked).

## Results

- DVA-BERT beats the original BERT and other word-masking methods.
- An interesting finding: **raising the masking probability of low-intensity sentiment words** works better than masking high-intensity ones. Low-intensity words are more frequent and used more diversely, so learning from them gives more general sentiment features.
- Limitation: training data are single sentences, so masking one word can change the meaning; multi-sentence text would give more masking choices.

## Code and Resources

Each `Models/VA_BERT_*` folder in the repo is one experiment setting:

- `VA_BERT_mask_sentiment`: basic sentiment-word masking
- `*_prob_V`, `*_prob_A`, `*_prob_Intersection`, `*_prob_Union`: masking probability from V/A intensity
- `*_reverse*`: reversed probability (low-intensity words masked more often)
- `*_multilabel`: multi-label variants
- `VA_BERT_no_mask`, `VA_BERT_random_mask`, `VA_BERT_random_init_weight`, `VA_RNN`: baselines

The repo also has `sense_data/` (positive and negative sentiment words; add your own), `data/` (five-fold splits and masking-coverage statistics), `result_statistic/` (collects metrics into CSV), and `Graph/` (paper figures).
