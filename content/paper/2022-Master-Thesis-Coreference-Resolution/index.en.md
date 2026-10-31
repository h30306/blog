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

## Method

The baseline is the open-source model of Toshniwal et al. (2020), using SpanBERT pre-trained on OntoNotes for span features (long documents are encoded in overlapping segments). I added three components:

1. **Entity representation estimation**: update the entity representation step by step as mentions join (for example with an LSTM) instead of simply averaging.
2. **Within-group density**: estimate how tightly the mentions of one entity cluster (MSE or cosine) and pull them closer.
3. **Between-group density**: compute a between-group loss only when two entity representations are more similar than a threshold λ, pushing confusable entities apart. λ can be fixed or learned.

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
