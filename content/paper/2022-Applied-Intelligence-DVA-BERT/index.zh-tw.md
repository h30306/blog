---
title: "DVA-BERT: Sentiment-Based Masked Language Modeling for Valence–Arousal Prediction"
summary: "Applied Intelligence 2022：把 BERT 的隨機遮罩改成遮情緒詞，當作輔助任務來提升句子層級的 Valence–Arousal 預測"
description: "以情緒詞遮罩取代隨機遮罩，結合 VA 強度估計與遮罩情緒詞預測的多任務 BERT 模型"
date: 2022-03-22
tags: ["paper", "nlp", "sentiment-analysis", "bert", "masked-language-model", "valence-arousal"]
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
| 發表 | Applied Intelligence 52 (14), 16353–16369 (2022) |
| 標題 | Sentiment-based masked language modeling for improving sentence-level valence–arousal prediction |
| 作者 | Jheng-Long Wu, **Wei-Yi Chung** |
| DOI | [10.1007/s10489-022-03384-9](https://doi.org/10.1007/s10489-022-03384-9) |
| 程式碼 | [h30306/Sentiment-Based-Masked-Language-Modeling-for-Improving-Sentence-Level-Valence-Arousal-Prediction](https://github.com/h30306/Sentiment-Based-Masked-Language-Modeling-for-Improving-Sentence-Level-Valence-Arousal-Prediction) |

這是我在 NLP Lab 最早開始的研究題目之一。2020 年初先以 IJCAI-PRICAI 2020 的格式寫成第一版（*A Novel Dimensional Valence-Arousal Prediction Model Using Masked Sentiment Words Approach*），之後擴充成期刊版，經過 IEEE 格式的多輪修改後投到 Applied Intelligence。依論文的 CRediT 聲明，我負責概念發想、方法設計、實驗與撰寫。

## 研究動機

情緒分析不只有正面、負面兩類，**維度式情緒（Valence–Arousal, VA）** 用連續數值表示情緒：Valence 是正負向程度，Arousal 是激動程度。

BERT 的 Masked Language Modeling（MLM）在每個字上用相同機率隨機遮罩，不管這個字對情緒影響大不大，所以學到的特徵沒有特別強化句子裡的情緒詞。

## 方法：DVA-BERT

- **主任務**：句子層級的 VA 強度估計（回歸）。
- **輔助任務**：把 MLM 改成**隨機遮罩情緒詞（Random Masked Sentiment Words）**，讓模型預測被遮掉的是哪個情緒詞。
- 情緒詞典使用 CVAW（字詞層級 1–9 分的 VA 標註）。
- 進一步設計多種遮罩機率：依情緒詞的 Valence、Arousal 強度、兩者交集或聯集、或反向（強度越低越容易被遮）來決定遮罩機率。

## 結果

- DVA-BERT 優於原始 BERT 與其他遮字方式。
- 一個有趣的發現：**提高低情緒強度詞的遮罩機率**，反而比遮高強度詞的版本好。低強度情緒詞出現頻率高、用法多樣，讓模型從中學習能得到更泛化的情緒特徵。
- 限制：訓練資料是單句，遮掉一個詞就可能改變句意；未來可用多句文本讓遮罩選擇更多樣。

## 程式碼與資源

repo 中每個 `Models/VA_BERT_*` 資料夾對應一組實驗設定：

- `VA_BERT_mask_sentiment`：基本的情緒詞遮罩
- `*_prob_V`、`*_prob_A`、`*_prob_Intersection`、`*_prob_Union`：依 V/A 強度決定遮罩機率
- `*_reverse*`：反向機率（低強度詞較容易被遮）
- `*_multilabel`：多標籤版本
- `VA_BERT_no_mask`、`VA_BERT_random_mask`、`VA_BERT_random_init_weight`、`VA_RNN`：比較基線

另外還有 `sense_data/`（正負向情緒詞，可自行加詞）、`data/`（五折切分資料與遮罩覆蓋率統計）、`result_statistic/`（彙整實驗指標成 CSV）、`Graph/`（論文圖表）。
