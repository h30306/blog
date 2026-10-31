---
title: "Dynamic Traffic Network Representation Model for MRT Passenger Flow"
summary: "Knowledge-Based Systems 2024: BERT dynamic station representations plus a hierarchical attention model over time, station, and route"
description: "Journal extension of the IIAI-AAI 2021 dynamic embedding method, combining multi-objective pre-training with a Hierarchical Attention Network for MRT passenger flow prediction"
date: 2024-11-01
tags: ["paper", "traffic-flow", "transfer-learning", "bert", "attention", "spatio-temporal"]
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
| Venue | Knowledge-Based Systems, Vol. 304, 112442 (2024) |
| Title | Dynamic traffic network representation model for improving the prediction performance of passenger flow for mass rapid transit |
| Authors | Jheng-Long Wu, **Wei-Yi Chung**, Yu-Hsuan Wu, Yen-Nan Ho |
| DOI | [10.1016/j.knosys.2024.112442](https://doi.org/10.1016/j.knosys.2024.112442) |
| Code | No separate repo; the pre-training part is in the [IIAI-AAI 2021 repo](https://github.com/h30306/A-Dynamic-Embedding-Method-for-Passenger-Flow-Estimation) |

This is the journal extension of [A Dynamic Embedding Method for Passenger Flow Estimation]({{< relref "/paper/2021-IIAI-AAI-Dynamic-Embedding-Passenger-Flow" >}}). From June 2021 to January 2022 I wrote the Chinese and English journal drafts and ran the experiments; the paper was published in 2024. The summary below follows my submission draft; the published version is authoritative.

## Motivation

The conference version showed that dynamic station embeddings beat static ones, but the downstream model was still GMAN. The journal version asks two more questions:

- Peak and off-peak flows differ a lot, so a single set of station features biases predictions. Can dynamic features make predictions more stable at **stations and hours with large flow changes**?
- Flow into a station comes from at least two directions, and more at transfer stations. Can the model attend separately to **time, station, and route**?

## Method

1. **Multi-objective pre-training**: pre-train dynamic station representations with BERT using several self-supervised objectives.
2. **Hierarchical Attention Network (HAN)**: each attention level focuses on one aspect (time, station, or route), and the levels are combined to predict future flow.
3. The pre-trained dynamic vectors are fed to HAN as station features.

## Results

- Pre-trained features improve HAN, especially at **high-variation stations and hours**.
- The per-hour MAE comparison in the draft (the cover image of this post) shows plain HAN with large errors at the 08:00 and 17:00–18:00 peaks, which the BERT-representation variants cut substantially.
- The full model generalizes and holds up better across different flow scenarios.

## Code and Resources

- The BERT pre-training code is in the [IIAI-AAI 2021 repo](https://github.com/h30306/A-Dynamic-Embedding-Method-for-Passenger-Flow-Estimation).
- The HAN downstream model is not on GitHub.
- My local archive keeps every journal draft (`交通期刊_Howard_202106xx` to `交通期刊_英文_Howard_20220105`) and the curated traffic-forecasting literature (EndNote).
