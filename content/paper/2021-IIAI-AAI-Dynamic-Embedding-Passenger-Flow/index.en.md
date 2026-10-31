---
title: "A Dynamic Embedding Method for Passenger Flow Estimation"
summary: "IIAI-AAI 2021: BERT-pretrained dynamic MRT station embeddings replace GMAN's static station features; Competitive Paper Award"
description: "Learning time- and distance-aware dynamic MRT station embeddings with BERT and transferring them to GMAN for Taipei MRT passenger flow prediction"
date: 2021-07-01
tags: ["paper", "traffic-flow", "transfer-learning", "bert", "embedding", "spatio-temporal"]
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
| Venue | 2021 10th International Congress on Advanced Applied Informatics (IIAI-AAI) |
| Authors | **Wei-Yi Chung**, Yen-Nan Ho, Yu-Hsuan Wu, Jheng-Long Wu |
| DOI | [10.1109/IIAI-AAI53430.2021.00070](https://doi.org/10.1109/IIAI-AAI53430.2021.00070) |
| Code | [h30306/A-Dynamic-Embedding-Method-for-Passenger-Flow-Estimation](https://github.com/h30306/A-Dynamic-Embedding-Method-for-Passenger-Flow-Estimation) |
| Slides | [Conference_Howard_20210706.pdf](https://github.com/h30306/A-Dynamic-Embedding-Method-for-Passenger-Flow-Estimation/blob/main/Conference_Howard_20210706.pdf) |
| Award | [Competitive Paper Award](https://github.com/h30306/A-Dynamic-Embedding-Method-for-Passenger-Flow-Estimation/blob/main/Competitive%20Paper%20Award.pdf) |

This was the first paper from our MRT traffic project. As first author I designed the model, ran the experiments, wrote the paper, and presented it in English at the online conference. The extended journal version was later published in Knowledge-Based Systems; see [Dynamic Traffic Network Representation Model]({{< relref "/paper/2024-KBS-Dynamic-Traffic-Network-Representation" >}}).

## Motivation

MRT passenger flow is usually predicted with time-series models such as LSTM, or with spatio-temporal attention models such as GMAN. GMAN learns a **spatial embedding (SE)** per station with Node2Vec, but that embedding is **static**: a station gets the same vector at peak and off-peak hours, on weekdays and weekends.

Transfer stations and regular stations, peak and off-peak hours, behave very differently, and a static vector cannot express "the state of this station at this time". The idea of this paper is to make the station embedding **dynamic** so it changes with time and with the surrounding state.

## Method

1. **Preprocessing**: build a station distance matrix from station coordinates and turn hourly entry/exit counts into training sequences.
2. **BERT_SE pre-training**: encode station, time, and distance information as sentence-like inputs and pre-train BERT with several self-supervised objectives (`BERT_three_loss` in the repo), so the output vectors carry flow features of a station under different times and distance relations.
3. **Transfer to GMAN**: replace GMAN's static Node2Vec SE with the dynamic BERT_SE output and train the downstream flow predictor.

## Setup and Results

- Data: hourly entry/exit counts of the Taipei MRT from January 2017 to March 2019; 10 transfer and 10 non-transfer stations (20 in total); counts are log-normalized to reduce scale differences between stations.
- GMAN with dynamic embeddings beats the static-embedding version overall, with **the largest gains at transfer stations**, showing that the dynamic embedding captures how transfer-station flow varies over the day.
- Multi-objective pre-training gives embeddings that capture more aspects of traffic than a single objective.

## Code and Resources

The GitHub repo contains:

- `Project/data/`: station info, distance matrix, and sample 2019 flow data
- `Project/model/Data_preparing_threeloss.py`: builds the pre-training data
- `Project/model/BERT_three_loss/`: BERT_SE pre-training (`run_train.sh`) and embedding export (`predict_embeddings.py`)
- The downstream predictor reuses [GMAN](https://github.com/zhengchuanpan/GMAN) with SE swapped for the BERT output

My local archive also keeps every submission draft (`BERTSE_2021xxxx`), a Chinese draft, the talk script, and the acceptance notice.
