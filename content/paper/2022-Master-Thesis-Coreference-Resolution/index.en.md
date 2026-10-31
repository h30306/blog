---
title: "Master's Thesis: Entity Representation Learning and Density Estimation for Coreference Resolution"
summary: "Adding entity representation estimation, within-group density, and between-group density to a SpanBERT coreference model for about +0.9 F1"
description: "Master's thesis at the School of Big Data Management, Soochow University, improving entity representations and representation density for coreference resolution"
date: 2022-02-06
tags: ["paper", "nlp", "coreference-resolution", "spanbert", "representation-learning", "thesis"]
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
| Type | Master's thesis, School of Big Data Management, Soochow University |
| Title | 基於實體表徵學習與密度估計於指代消解 (Entity Representation Learning and Density Estimation for Coreference Resolution) |
| Author | **Wei-Yi Chung** (advisor: Jheng-Long Wu) |
| Dataset | OntoNotes 5.0 / CoNLL-2012 |
| Code | Not on GitHub (the `e2e-coref` repo on my GitHub is an unmodified fork of the original authors' code) |

## What Coreference Resolution Is

Coreference resolution finds every mention in a document that refers to the same entity. In the cover image, "Prime Minister Junichiro Koizumi" and the later "Koizumi" are the same person, and "Japan" and "itself" are the same country. It is often a preprocessing step for information retrieval and stance analysis.

## Motivation

Current models score a new **mention** against existing **entities** during inference, so the quality of the entity representation matters a lot. Prior work usually takes the **centroid** of all mention representations in an entity, which has problems:

- Mentions are not equally representative. Pronouns such as "you", "I", and "he" carry little information, and averaging dilutes the important mentions.
- If a mention is clustered wrongly during inference, the averaged entity representation drifts more easily.
- Mentions in the same entity all corefer, so their representations should have **high within-group density**, and different entities should have **low between-group density**. Prior work did not model this directly.

## Model Architecture

![Coreference model architecture](coref.svg)

The baseline is the open-source long-document coreference model of Toshniwal et al. (2020). It has two stages; the red boxes are the three components this thesis adds.

### Stage 1: Mention Detection

1. **Document encoding**: SpanBERT pre-trained on OntoNotes encodes the document. Long documents exceed the length limit T, so a segment of length T starts every T/2 tokens; segments overlap by half, and each token's final representation is a weighted mix of its two segments.
2. **Candidate mentions**: every span up to length L is a candidate with mention score `s_m`; the top 0.4 × document length spans are kept. Mention detection is first fine-tuned on gold mentions, otherwise almost every early candidate is invalid and clustering gets no useful signal.

### Stage 2: Clustering Mentions in Order

The model walks through candidate mentions `x_i` in document order and keeps a list of entities so far:

1. **Within-group density (WS, proposed)**: for each entity `e_j`, average the cosine similarity between each mention and the entity centroid to get `δ_j`. High density means a tight, trustworthy cluster; low density suggests a wrongly added mention.
2. **Coreference score**: a feed-forward network scores the new mention against each entity from the mention representation, the entity representation, their element-wise product, and feature embeddings (mention count in the entity, distance to its last mention, mention type). The score is **multiplied by `δ_j`**, so a suspicious entity is less likely to absorb more mentions and errors do not snowball.
3. **Pick an entity**: take the highest-scoring entity `e*` and add `x_i` to it, or output ε to start a new entity if nothing matches.
4. **Entity representation (ER, proposed)**: only `e*` changed, so only its representation is updated. Instead of averaging, soft attention weights each mention: `α = softmax(W·c_e* + b)`, `ẽ* = Σ α_h · mention_h`. Pronouns and wrongly clustered mentions get low weights, so the entity representation does not drift.

### Training Objective

- **Coreference loss**: for each mention, softmax over all candidate entities (including ε) and maximize the marginal likelihood of the gold cluster.
- **Between-group density loss (BS, proposed)**: compare every pair of entity representations by cosine similarity and only count pairs above threshold λ, pushing confusable entities apart; pairs below λ produce no gradient.
- The total loss is `L = (1 − r)·L_coref + r·L_BS`, with r the weight of the density loss. Mention detection and inference train end to end and share SpanBERT's parameters.

### Experimental Setup

To isolate each component, the thesis runs nine variants: the reproduced baseline (COREF_BASE), the last mention as entity representation (COREF_LM), ER / WS / BS alone, every pair, and all three (COREF_ERWSBS). The data are the English OntoNotes documents converted to CoNLL-2012 format, with 2,802 / 343 / 348 documents for train / validation / test.

## Results

- The baseline paper reports 79.6 F1; my best of 21 independent reruns was 78.3, so improvements are measured against the reproduced 78.3.
- All three components help, for an overall gain of **about 0.9 F1** over the baseline, with significance tests.
- In the λ experiments, performance mostly rises with the threshold and drops only at 0.9: a low threshold updates many entities that no longer need it, and around 0.6 and above the model picks the entities that actually get confused.
- Between-group density estimation effectively widens the distance between different entity representations.

## Limitations

- The baseline could not be reproduced to its reported score, so improvements build on the reproduced version.
- OntoNotes does not annotate singletons, so singleton performance cannot be evaluated.

## Local Archive

`Project/2021Q2 碩士論文/` keeps every draft of the first three chapters, the seminar-course version, the defense slides, the final PDFs (color and black-and-white), and the forms for the defense application and graduation.
