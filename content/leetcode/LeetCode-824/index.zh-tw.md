---
title: "LeetCode 824: Goat Latin"
summary: "LeetCode 824 解題筆記：切成單字後逐一轉換：子音開頭把第一個字母移到最後，再加 ma 和 i + 1 個 a"
description: "2022-09-15 的 LeetCode 824 解題紀錄"
date: 2022-09-15
tags: ["easy", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-09-15
- 提交紀錄：Accepted ×2

## 解題思路

切成單字後逐一處理（[String]({{< relref "/algorithm/String" >}}) 模板六）：開頭是母音（大小寫都算）就不動，否則把第一個字母移到最後；接著加上 `"ma"`，再加上 `i + 1` 個 `"a"`（`i` 是單字的 index，從 0 開始）。

## 我的解法

```python
class Solution:
    def toGoatLatin(self, sentence: str) -> str:
        res = []
        for i, w in enumerate(sentence.split()):
            if w[0] not in "aeiouAEIOU":
                w = w[1:] + w[0]
            res.append(w + "ma" + "a" * (i + 1))
        return " ".join(res)
```

## 複雜度

時間 `O(n + w²)`（`w` 是單字數，加上的 `a` 總共 `O(w²)` 個），空間同上。

## 要特別避免的錯誤

- 母音包含大寫。
- 第一個單字加 1 個 `a`，不是 0 個。

## 面試口說整理

我把句子切成單字，子音開頭的把第一個字母移到最後，每個單字加上 ma 和 index 加一個 a，最後用空白接起來。
