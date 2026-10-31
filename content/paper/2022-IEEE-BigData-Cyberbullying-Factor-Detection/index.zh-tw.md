---
title: "Factor Detection Task of Cyberbullying Using the Deep Learning Model"
summary: "IEEE BigData 2022 Workshop：定義網路霸凌的六個因子、建立 PTT 中文語料，用 BERT 偵測並分析公眾人物事件的霸凌模式"
description: "從霸凌偵測延伸到霸凌因子偵測：恐嚇、騷擾、侮辱、反諷、激動程度與情緒正負向"
date: 2022-12-17
tags: ["paper", "nlp", "cyberbullying", "bert", "big-data", "annotation"]
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
| 發表 | 2022 IEEE International Conference on Big Data (Big Data) Workshop, pp. 4323–4329 |
| 作者 | Yu-Hsuan Wu, Sheng-Wei Huang, **Wei-Yi Chung**, Chen-Chia Yu, Jheng-Long Wu |
| DOI | [10.1109/BigData55660.2022.10020779](https://doi.org/10.1109/BigData55660.2022.10020779) |
| 簡報 | [BigD809.pdf](https://github.com/h30306/Factor-Detection-Task-of-Cyberbullying-Using-the-Deep-Learning-Model/blob/main/BigD809.pdf) |
| 程式碼 | [repo](https://github.com/h30306/Factor-Detection-Task-of-Cyberbullying-Using-the-Deep-Learning-Model) 目前只有簡報，沒有程式碼 |

這篇延續實驗室從 108 年開始的科技部網路霸凌計畫。前期計畫書是用 Valence–Arousal 預訓練 BERT 再遷移到霸凌偵測，這篇則把問題從「是不是霸凌」推進到「霸凌由哪些因子構成」。

## 研究動機

社群媒體讓意見快速流通，也放大了惡意留言的傷害。網路霸凌的定義模糊，難以懲處或預防；而過去研究大多只做**霸凌偵測**（二分類），很少分析霸凌的**因子**。

## 方法

1. **定義六個霸凌因子**並制定標註規則：恐嚇（Intimidation）、騷擾（Harassment）、侮辱（Insult）、反諷（Sarcasm）、激動程度（Arousal）、情緒正負向（Valence）。
2. **建立中文霸凌語料**：從 PTT 收集多年的留言，由三位標註者標註。標註結果中恐嚇只有 48 筆，騷擾、反諷相對多，資料分布相當不平衡。
3. **訓練 BERT 模型**偵測每則留言的六個因子。
4. **大規模自動標註與案例分析**：用模型標註大量 PTT 文章，分析幾位公眾人物事件中霸凌因子的組成與隨時間的變化。

## 發現

- 含霸凌因子的留言普遍有高激動程度。
- 不同事件的霸凌模式不同：有的以高激動加上反諷、侮辱、騷擾為主；有的以侮辱和騷擾為主，反諷在事件轉折後才大量出現。
- 恐嚇在網路上很少見，可能因為線上溝通仍有道德約束，但它的趨勢和侮辱、騷擾有部分重疊。

## 程式碼與資源

GitHub repo 目前只有簡報 PDF 和 README，沒有模型程式碼。本機的霸凌計畫資料夾（108、109、110）保留了科技部計畫書各版本、審查意見與架構圖。
