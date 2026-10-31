---
title: "CDVAI: A Dimensional Valence-Arousal-Irony Dataset for Chinese Sentence and Context"
summary: "ROCLING 2022 + IJCLCLP 2022：擴充台大反諷語料，標註句子的 V/A/I 強度與反諷語境的 V/A 強度"
description: "建立中文維度式反諷資料集 CDVAI，分析標註者差異並以 BERT 評估句子與語境層級的預測表現"
date: 2022-11-21
tags: ["paper", "nlp", "dataset", "irony", "valence-arousal", "annotation", "bert"]
categories: ["paper"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 論文資訊

這個題目有兩篇發表：

| 項目 | 研討會版 | 期刊版 |
|---|---|---|
| 發表 | ROCLING 2022 | IJCLCLP Vol. 27, No. 2 (Dec 2022) |
| 標題 | A Dimensional Valence-Arousal-Irony Dataset for Chinese Sentence and Context | A Chinese Dimensional Valence-Arousal-Irony Detection on Sentence-level and Context-level Using Deep Learning Model |
| 作者 | Sheng-Wei Huang, **Wei-Yi Chung**, Yu-Hsuan Wu, Chen-Chia Yu, Jheng-Long Wu | Jheng-Long Wu, Sheng-Wei Huang, **Wei-Yi Chung**, Yu-Hsuan Wu, Chen-Chia Yu |
| 連結 | [ACL Anthology](https://aclanthology.org/2022.rocling-1.19/) · [PDF](https://aclanthology.org/2022.rocling-1.19.pdf) | [ACL Anthology](https://aclanthology.org/2022.ijclclp-2.5/) · [PDF](https://aclanthology.org/2022.ijclclp-2.5.pdf) |
| 程式碼 | 沒有公開 repo | 同左 |

2022 年 1 月我以第一作者寫了這個題目的初稿（當時叫 VAI），之後的 ROCLING 與期刊版本由共同作者接續修改。標註用的是我在 2021 年做的 Irony Extension 標記網站。

## 研究動機

反諷的特徵是**字面意思和實際意思相反**，常見手法是情緒的對比，例如「好棒喔，下雨了又沒帶傘……」：語境「下雨沒帶傘」是負面情緒，關鍵字「好棒」是正面情緒。

過去的反諷資料集多半只標註整句是不是反諷、屬於哪一類，沒有提供句子與語境各自的情緒強度，模型就沒辦法學到反諷中的情緒轉折。

## 資料集：CDVAI

- 以台大反諷語料（NTU Irony Corpus）為基礎，篩選後保留 1,004 句，其中 843 句有需要標註的反諷語境。
- **句子層級**：標註 Valence、Arousal、Irony 三種強度。
- **語境層級**：標註 Valence、Arousal 兩種強度。
- 每筆資料由三位標註者標註（研究生與大學生，皆為中文母語者），取平均作為標籤，並分析標註者之間的差異。

## 模型架構

![語境 VA 的三種預測方式](cdvai-methods.svg)

資料以分層抽樣切成訓練、驗證、測試集（句子層級 632 / 71 / 301 句，語境層級 531 / 59 / 253 句）。

**句子層級**：句子進 BERT，取 `h_CLS` 接 Linear，輸出句子的 Valence、Arousal、Irony 分數。

**語境層級**：資料裡已經標好語境在句子中的位置，因此比較三種預測語境 VA 的方式：

| 方法 | 做法 |
|---|---|
| M1 | 整句進 BERT，取 `h_CLS` 接 Linear 直接預測語境的 VA |
| M2 | 整句進 BERT，只取語境那一段位置的隱藏向量，彙總後接 Linear |
| M3 | 句子和語境分別進 BERT，把兩個隱藏向量串接後接 Linear |

每種方法都用 6 個預訓練模型比較：4 個中文模型（ckiplab/albert-base-chinese、hfl/chinese-macbert-base、shibing624/macbert4csc-base-chinese、uer/chinese_roberta_L-4_H-256）和 2 個多語模型（bert-base-multilingual-uncased、flax-community/alberti-bert-base-multilingual-cased）。

## 實驗結果

- **語境 Valence**：多數模型以 M1 最好，M2、M3 可能引入了更多雜訊。最佳 MAE 約 0.39（M3 搭配多語 BERT）到 0.40（M1 搭配 macbert4csc）。
- **語境 Arousal**：整體比 Valence 難，MAE 大約落在 0.8。M3 在多數模型上表現最好，代表同時看整句和語境，對判斷激動程度有幫助。
- **錯誤分析**：BERT 很難推斷說話者的意圖，也缺乏常識，沒辦法判斷貼文描述的事件有多嚴重，所以很難準確判斷反諷的程度。

## 限制

資料量對機器學習來說還不夠大，也無法涵蓋所有領域與反諷句型；比較適合當作擴充更多樣本的種子資料或標註規範範本，或和其他反諷語料合併使用。
