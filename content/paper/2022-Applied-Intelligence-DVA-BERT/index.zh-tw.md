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

## 模型架構：DVA-BERT

![DVA-BERT 模型架構（論文原圖）](model.jpg)

圖中的例句是「I hate you very much」，「hate」是情緒詞，被換成 `[MASK]`。整個流程分四步：

**1. 斷詞**：用 CKIP tagger 把句子切成詞 `X = {x1, …, xN}`。

**2. 情緒詞強度 → 遮罩機率**：情緒詞典（CVAW）裡每個詞都有 1–9 分的 Valence、Arousal。

- Valence 先取「離中間值多遠」：`TI = |I_V − mid(I_V)|`，越正面或越負面，分數越高。
- 再做 min–max 正規化，然後用 `|norm − 1|` **反轉**，讓情緒強度越低的詞遮罩機率越高。原因是低強度的情緒詞最容易讓模型搞混，要逼模型多學。
- Arousal 也做同樣的正規化與反轉。

**3. 產生遮罩序列**：只有情緒詞有機會被遮，非情緒詞的機率是 0。每個情緒詞用 Bernoulli 抽樣決定要不要遮：

```text
P_mask(x_n) = Bernoulli(β · P_V(x_n)) × Bernoulli(β · P_A(x_n))
```

β 是初始遮罩機率（超參數），避免一句話裡的情緒詞全被遮掉，導致模型學不到東西。最後得到 `X' = [<CLS>, mn_1, …, mn_N, <EOS>]`。

**4. 雙任務訓練**：`X'` 進 BERT 後得到每個位置的隱藏向量。

| 任務 | 用哪個輸出 | 做什麼 | 損失 |
|---|---|---|---|
| VAIE（主任務） | `h_CLS` | 兩個 Linear 分別輸出句子的 Valence、Arousal | MSE |
| RMSWP（輔助任務） | `[MASK]` 位置的 `h` | 預測被遮掉的是哪個情緒詞 | Cross-entropy |

兩個損失一起訓練，BERT 的參數全部會微調。

### 資料與比較模型

資料是精神健康相關的社群貼文，共 2,300 句，分成憂鬱情緒、自殺、失眠、工作與活動、焦慮、身體症狀六類。每句至少由 10 位標註者給 1–9 分的 Valence、Arousal，去掉超出平均 ±1.5 個標準差的分數後取平均。資料按 7:1:2 切成訓練、驗證、測試集，並做五折交叉驗證。

論文一共比較 11 種遮罩方式：

| 模型 | 遮罩方式 |
|---|---|
| DVA-BERT | 本文方法：V、A 都反轉，兩個機率相乘 |
| DVA-BERT-VAI | 同上但不反轉（強度越高越容易被遮） |
| DVA-BERT-NM | 不遮罩，只做 VAIE |
| DVA-BERT-RM | 原始 BERT 的隨機遮罩 |
| DVA-BERT-MS | 只遮情緒詞，但不依強度調整機率 |
| DVA-BERT-MV / MRV | 只看 Valence，不反轉 / 反轉 |
| DVA-BERT-MA / MRA | 只看 Arousal，不反轉 / 反轉 |
| DVA-BERT-VAU / RVAU | V、A 機率相加（聯集），不反轉 / 反轉 |

結果是反轉的版本，也就是多遮低強度情緒詞，表現比不反轉的 MV、MA、VAU 好。

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
