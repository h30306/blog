---
title: "Factor Detection Task of Cyberbullying Using the Deep Learning Model"
summary: "IEEE BigData 2022 Workshop: six cyberbullying factors, a Chinese PTT corpus, and BERT-based analysis of bullying patterns around public figures"
description: "Moving from cyberbullying detection to factor detection: intimidation, harassment, insult, sarcasm, arousal, and valence"
date: 2022-12-17
tags: ["paper", "nlp", "cyberbullying", "bert", "big-data", "annotation"]
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
| Venue | 2022 IEEE International Conference on Big Data (Big Data) Workshop, pp. 4323–4329 |
| Authors | Yu-Hsuan Wu, Sheng-Wei Huang, **Wei-Yi Chung**, Chen-Chia Yu, Jheng-Long Wu |
| DOI | [10.1109/BigData55660.2022.10020779](https://doi.org/10.1109/BigData55660.2022.10020779) |
| Slides | [BigD809.pdf](https://github.com/h30306/Factor-Detection-Task-of-Cyberbullying-Using-the-Deep-Learning-Model/blob/main/BigD809.pdf) |
| Code | The [repo](https://github.com/h30306/Factor-Detection-Task-of-Cyberbullying-Using-the-Deep-Learning-Model) only has the slides; no code yet |

This paper continues the lab's MOST-funded cyberbullying project, which started in 2019. The early proposals pre-trained BERT on valence–arousal and transferred it to bullying detection; this paper moves the question from "is this bullying?" to "which factors make up the bullying?".

## Motivation

Social media spreads opinions quickly and amplifies the harm of malicious comments. Cyberbullying is loosely defined, which makes it hard to punish or prevent, and most prior work only does binary **bullying detection**; few studies analyze its **factors**.

## Pipeline and Model Architecture

![Pipeline and the six cyberbullying factors](pipeline.svg)

1. **Define six factors** with annotation rules: intimidation, harassment, insult, sarcasm, arousal, and valence.
2. **Build a Chinese corpus**: 5,926 comments collected from PTT over several years and labeled by three annotators. The labels are highly imbalanced: only 48 intimidation comments, versus 3,641 sarcasm and 2,175 harassment; negative and neutral valence are balanced, but positive is rare.
3. **Train classifiers**: one BERT classifier per factor. A comment `{[CLS], w1, …, wn}` goes through BERT, `h_CLS` represents the whole comment, and `softmax(W·h_CLS + b)` outputs the class probabilities for that factor, fine-tuned end to end with cross-entropy and Adam.
4. **Large-scale labeling and case studies**: label many PTT posts with the trained models and track how the factors combine and change over time in several incidents involving public figures.

## Findings

- Comments with bullying factors usually have high arousal.
- Incidents differ: some are dominated by high arousal plus sarcasm, insults, and harassment; others mainly by insults and harassment, with sarcasm surging only after a turning point.
- Intimidation is rare online, perhaps because of the moral pressure of public discussion, but its trend partly overlaps with insults and harassment.

## Code and Resources

The GitHub repo currently has only the slide PDF and a README, no model code. My local folders for the cyberbullying project (2019–2021) keep every MOST proposal draft, the review comments, and the architecture diagrams.
