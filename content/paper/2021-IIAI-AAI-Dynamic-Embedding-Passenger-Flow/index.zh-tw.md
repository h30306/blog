---
title: "A Dynamic Embedding Method for Passenger Flow Estimation"
summary: "IIAI-AAI 2021：用 BERT 預訓練動態捷運站嵌入，取代 GMAN 的靜態站點特徵，獲 Competitive Paper Award"
description: "以 BERT 學習隨時間、距離變化的捷運站動態嵌入，遷移到 GMAN 預測台北捷運進出站人流"
date: 2021-07-01
tags: ["paper", "traffic-flow", "transfer-learning", "bert", "embedding", "spatio-temporal"]
categories: ["paper"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 論文資訊

| 項目 | 內容 |
|---|---|
| 發表 | 2021 10th International Congress on Advanced Applied Informatics (IIAI-AAI) |
| 作者 | **Wei-Yi Chung**, Yen-Nan Ho, Yu-Hsuan Wu, Jheng-Long Wu |
| DOI | [10.1109/IIAI-AAI53430.2021.00070](https://doi.org/10.1109/IIAI-AAI53430.2021.00070) |
| 程式碼 | [h30306/A-Dynamic-Embedding-Method-for-Passenger-Flow-Estimation](https://github.com/h30306/A-Dynamic-Embedding-Method-for-Passenger-Flow-Estimation) |
| 簡報 | [Conference_Howard_20210706.pdf](https://github.com/h30306/A-Dynamic-Embedding-Method-for-Passenger-Flow-Estimation/blob/main/Conference_Howard_20210706.pdf) |
| 獎項 | [Competitive Paper Award](https://github.com/h30306/A-Dynamic-Embedding-Method-for-Passenger-Flow-Estimation/blob/main/Competitive%20Paper%20Award.pdf) |

這篇是交通計畫的第一篇論文，我是第一作者，負責模型設計、實驗、論文撰寫，並在線上研討會用英文報告。期刊延伸版後來發表在 Knowledge-Based Systems，見 [Dynamic Traffic Network Representation Model]({{< relref "/paper/2024-KBS-Dynamic-Traffic-Network-Representation" >}})。

## 研究動機

捷運人流預測常見的做法是用 LSTM 這類時間序列模型，或是像 GMAN 這種 spatio-temporal attention 模型。GMAN 會用 Node2Vec 在路網上學一組 **站點嵌入（Spatial Embedding, SE）**，但這組嵌入是**靜態**的：同一個站在尖峰、離峰、平日、假日都拿到同一個向量。

實際上轉乘站和一般站、尖峰和離峰的人流型態差很多，靜態嵌入沒辦法表達「這個站在這個時間點的狀態」。所以這篇的想法是：讓站點嵌入變成**動態**的，隨時間與周邊狀態改變。

## 模型架構

![BERT_SE 預訓練與遷移到 GMAN 的架構](bert-se.svg)

整個方法分成兩階段：先預訓練 BERT_SE，再把它產生的動態站點嵌入遷移到 GMAN。

### 第一階段：BERT_SE 預訓練

**輸入怎麼組**：每筆訓練資料取兩個捷運站 A、B，各自取過去 5 個小時的進出站人流。人流是連續數值，直接預測太難，所以先**分箱（binning）** 成類別，讓每個小時的人流變成一個 token，就像一個字一樣。兩段序列用 BERT 的格式串起來：

```text
[CLS] A(t-4) A(t-3) A(t-2) A(t-1) A(t) [SEP] B(t-4) B(t-3) B(t-2) B(t-1) B(t) [SEP]
```

再沿用 BERT 的做法隨機遮掉部分人流 token。

**三個學習目標**（就是 repo 裡 `BERT_three_loss` 的由來）：

| 目標 | 用哪個輸出 | 預測什麼 | 損失 |
|---|---|---|---|
| NSP | `h_CLS` | 沿用 BERT 原本的 Next Sentence Prediction | Cross-entropy |
| SDE（Station Distance Estimation） | `h_CLS` | A、B 兩站的直線距離，讓模型學到站點之間的空間關係 | MSE |
| MFP（Masked Flow Prediction） | 被遮住位置的 `h` | 被遮住的那個小時落在哪個人流區間，讓模型學到人流隨時間的變化 | Cross-entropy |

總損失是三者直接相加：`L = L_NSP + L_SDE + L_MFP`，用 Adam 最佳化。MFP 的預測頭是 `Linear → GELU → LayerNorm → Linear`，和 BERT 原本 MLM 的 head 一樣。

為什麼這樣能得到「動態」嵌入？因為輸入本身就是**某個站在某段時間的人流**，同一個站在尖峰和離峰會餵進不同的序列，BERT 輸出的向量自然就不同；而 SDE 讓這個向量同時帶有空間位置的資訊。

### 第二階段：遷移到 GMAN

GMAN 原本的時空嵌入 STE = SE（站點嵌入）+ TE（時間嵌入），其中 SE 是用 Node2Vec 在路網上算出來的固定向量。這篇把 **SE 換成 BERT_SE 依當下人流輸出的向量**，TE 和 GMAN 其他部分不變，再訓練 GMAN 預測下一個小時的人流。

## 實驗設定與結果

- 資料：台北捷運 2017/01–2019/03 每小時進出站人流，挑選轉乘站與非轉乘站各 10 站，共 20 站；人流做 log 正規化以降低站點間的量級差異。
- 結果：使用動態嵌入的 GMAN 在整體預測上優於靜態嵌入，**轉乘站的改善特別明顯**，代表動態嵌入能捕捉到轉乘站人流在不同時段的變化。
- 多目標預訓練讓嵌入學到更多面向的交通特徵，比單一目標效果好。

## 程式碼與資源

GitHub repo 包含：

- `Project/data/`：站點資訊、距離矩陣、2019 年範例人流資料
- `Project/model/Data_preparing_threeloss.py`：產生預訓練資料
- `Project/model/BERT_three_loss/`：BERT_SE 預訓練（`run_train.sh`）與產生嵌入（`predict_embeddings.py`）
- 下游預測沿用 [GMAN](https://github.com/zhengchuanpan/GMAN)，把 SE 換成 BERT 輸出即可

本機資料夾另外保留了投稿各版本（`BERTSE_2021xxxx`）、中文版論文初稿、研討會講稿與錄取通知。
