---
title: "LeetCode 1078: Occurrences After Bigram"
summary: "LeetCode 1078 解題筆記：切成單字後檢查每個連續三個單字，前兩個符合 first 和 second 就收第三個"
description: "2022-10-04 的 LeetCode 1078 解題紀錄"
date: 2022-10-04
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
第一次嘗試：2022-10-04
- 提交紀錄：Runtime Error → Accepted ×3

## 解題思路

切成單字後看每個位置 `i`（[String]({{< relref "/algorithm/String" >}}) 模板六）：`words[i] == first`、`words[i + 1] == second` 就收 `words[i + 2]`。迴圈只跑到 `len(words) - 2`，第三個字一定存在。

## 我的嘗試

第一版的邊界只檢查了 `i + 1 < len(text)`，**卻存取 `text[i + 2]`**：`"b b"`、`first = second = "b"` 時 IndexError。改成檢查 `i + 2` 就 AC 了。

## 正確解法

```python
class Solution:
    def findOcurrences(self, text: str, first: str, second: str) -> List[str]:
        w = text.split()
        return [w[i + 2] for i in range(len(w) - 2)
                if w[i] == first and w[i + 1] == second]
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 要用到 `i + 2`，邊界就要檢查到 `i + 2`。

## 面試口說整理

我把文字切成單字，檢查每個連續的三個單字，前兩個等於 first 和 second 就把第三個加進答案，迴圈只跑到倒數第三個。時間 `O(n)`。
