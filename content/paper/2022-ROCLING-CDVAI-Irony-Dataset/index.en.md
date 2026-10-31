---
title: "CDVAI: A Dimensional Valence-Arousal-Irony Dataset for Chinese Sentence and Context"
summary: "ROCLING 2022 + IJCLCLP 2022: extending the NTU irony corpus with sentence-level V/A/I and context-level V/A intensities"
description: "Building the Chinese dimensional irony dataset CDVAI, analyzing annotator differences, and evaluating BERT at the sentence and context level"
date: 2022-11-21
tags: ["paper", "nlp", "dataset", "irony", "valence-arousal", "annotation", "bert"]
categories: ["paper"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Paper Info

This topic has two publications:

| Item | Conference | Journal |
|---|---|---|
| Venue | ROCLING 2022 | IJCLCLP Vol. 27, No. 2 (Dec 2022) |
| Title | A Dimensional Valence-Arousal-Irony Dataset for Chinese Sentence and Context | A Chinese Dimensional Valence-Arousal-Irony Detection on Sentence-level and Context-level Using Deep Learning Model |
| Authors | Sheng-Wei Huang, **Wei-Yi Chung**, Yu-Hsuan Wu, Chen-Chia Yu, Jheng-Long Wu | Jheng-Long Wu, Sheng-Wei Huang, **Wei-Yi Chung**, Yu-Hsuan Wu, Chen-Chia Yu |
| Links | [ACL Anthology](https://aclanthology.org/2022.rocling-1.19/) · [PDF](https://aclanthology.org/2022.rocling-1.19.pdf) | [ACL Anthology](https://aclanthology.org/2022.ijclclp-2.5/) · [PDF](https://aclanthology.org/2022.ijclclp-2.5.pdf) |
| Code | No public repo | Same |

In January 2022 I wrote the first draft of this work as first author (then called VAI); co-authors carried it forward into the ROCLING and journal versions. Annotation used the Irony Extension labeling website I built in 2021.

## Motivation

Irony means **the literal meaning is the opposite of the intended one**, often through a sentiment contrast. In "Great, it's raining and I didn't bring an umbrella...", the context "raining without an umbrella" is negative while the keyword "Great" is positive.

Earlier irony datasets mostly label whether a whole sentence is ironic or which type it is. They do not give the sentiment intensity of the sentence and its context separately, so a model cannot learn the sentiment shift inside irony.

## Dataset: CDVAI

- Based on the NTU Irony Corpus; after filtering, 1,004 sentences remain, 843 of which have an ironic context to annotate.
- **Sentence level**: valence, arousal, and irony intensity.
- **Context level**: valence and arousal intensity.
- Each item was annotated by three native Chinese speakers (graduate and undergraduate students); labels are averaged, and annotator differences are analyzed.

## Model Architecture

![Three setups for context-level VA](cdvai-methods.svg)

The data are split by stratified sampling (sentence level 632 / 71 / 301, context level 531 / 59 / 253 for train / validation / test).

**Sentence level**: the sentence goes through BERT, and `h_CLS` feeds a linear layer that outputs valence, arousal, and irony.

**Context level**: the context span is already marked in each sentence, so three setups are compared:

| Setup | How |
|---|---|
| M1 | Whole sentence through BERT; `h_CLS` → linear predicts the context VA directly |
| M2 | Whole sentence through BERT; only the hidden states at the context span are pooled → linear |
| M3 | Sentence and context go through BERT separately; the two hidden vectors are concatenated → linear |

Each setup is tested with six pre-trained models: four Chinese (ckiplab/albert-base-chinese, hfl/chinese-macbert-base, shibing624/macbert4csc-base-chinese, uer/chinese_roberta_L-4_H-256) and two multilingual (bert-base-multilingual-uncased, flax-community/alberti-bert-base-multilingual-cased).

## Results

- **Context valence**: M1 is best for most models; M2 and M3 may add noise. The best MAE is about 0.39 (M3 with multilingual BERT) to 0.40 (M1 with macbert4csc).
- **Context arousal**: harder than valence, with MAE around 0.8. M3 wins for most models, so seeing both the sentence and the context helps judge arousal.
- **Error analysis**: BERT struggles to infer the speaker's intent, lacks common sense, and cannot judge how serious the described event is, which makes the irony level hard to predict accurately.

## Limitations

The dataset is still small for machine learning and cannot cover every domain or ironic pattern. It works best as seed data for collecting more samples, as an annotation-guideline template, or combined with other irony corpora.
