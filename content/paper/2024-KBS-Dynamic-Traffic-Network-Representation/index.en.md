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

## Model Architecture

There are still two stages: pre-train BERT flow embeddings, then feed them to a three-level Hierarchical Attention Network (HAN) that predicts flow.

### Stage 1: Pre-training with Four Objectives

The input is the same as in the conference version: two stations' binned flows for the past 5 hours, joined as `[CLS] … [SEP] … [SEP]` and randomly masked (see the figure below; the journal version replaces NSP with the spatial objectives listed after it).

![BERT pre-training input and heads](bert-se.svg)

The journal version uses one main objective plus three auxiliary ones, so the model learns more **spatial concepts** beyond numeric change:

| Objective | Output used | Predicts | Loss |
|---|---|---|---|
| MFP (main) | `h` at masked positions | The masked flow bin, capturing peak/off-peak change | Cross-entropy |
| SRP (Same Route Prediction) | `h_CLS` | Whether the two sequences come from the same line | Cross-entropy |
| ASP (Adjacent Station Prediction) | `h_CLS` | Whether the two sequences come from adjacent stations | Cross-entropy |
| SDE (Station Distance Estimation) | `h_CLS` | Straight-line distance, separating downtown and suburban stations | MSE |

The four losses are summed and trained together.

### Stage 2: Hierarchical Attention Network (HAN)

![HAN three-level attention](han.svg)

HAN has three levels, bottom to top, each handling one aspect:

1. **Temporal encoder**: for each station, the raw flow sequence goes through an RNN and is **concatenated** with the BERT dynamic embedding; soft attention weights each past hour to give the station's temporal state.
2. **Spatial encoder**: along one line, the temporal states of stations near the target are fed through an RNN in station order (stations on a line are sequential), then soft attention gives that line's influence on the target station.
3. **Route encoder**: a station's flow can come from several lines (more at transfer stations), and each line draws from different areas (downtown, suburbs, residential), so a final soft attention weights the lines. Lines have no order, so this level uses attention only, no RNN.

A final linear layer outputs the next time step's flow, trained with MSE.

## Results

- Pre-trained features improve HAN, especially at **high-variation stations and hours**.
- The per-hour MAE comparison in the draft (the cover image of this post) shows plain HAN with large errors at the 08:00 and 17:00–18:00 peaks, which the BERT-representation variants cut substantially.
- The full model generalizes and holds up better across different flow scenarios.

## Code and Resources

- The BERT pre-training code is in the [IIAI-AAI 2021 repo](https://github.com/h30306/A-Dynamic-Embedding-Method-for-Passenger-Flow-Estimation).
- The HAN downstream model is not on GitHub.
- My local archive keeps every journal draft (`交通期刊_Howard_202106xx` to `交通期刊_英文_Howard_20220105`) and the curated traffic-forecasting literature (EndNote).
