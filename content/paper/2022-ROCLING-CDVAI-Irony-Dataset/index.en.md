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

## Experiments

- BERT is the base model, with three prediction setups compared.
- The third setup, **concatenating the sentence with its context before predicting**, clearly improves context-level arousal prediction.
- The CDVAI labels give BERT a learning signal for the structure of irony.

## Limitations

The dataset is still small for machine learning and cannot cover every domain or ironic pattern. It works best as seed data for collecting more samples, as an annotation-guideline template, or combined with other irony corpora.
