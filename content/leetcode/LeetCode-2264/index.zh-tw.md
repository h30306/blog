---
title: "LeetCode 2264: Largest 3-Same-Digit Number in String"
summary: "LeetCode 2264 解題筆記：候選只有 "000" 到 "999" 十個，從 "999" 往下檢查有沒有在字串裡"
description: "2025-08-14 的 LeetCode 2264 解題紀錄"
date: 2025-08-14
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
第一次嘗試：2025-08-14
- 提交紀錄：Accepted（一次通過）

## 解題思路

好的整數一定是 `"ddd"` 的形式，只有 10 種。從最大的 `"999"` 往下，第一個出現在 `num` 裡的就是答案（[String]({{< relref "/algorithm/String" >}}) 模板三）。

## 我的解法

我當時用長度 3 的滑動視窗加 `Counter`，視窗裡只有一種字元時跟目前答案比大小。枚舉 10 個候選更簡單：

```python
class Solution:
    def largestGoodInteger(self, num: str) -> str:
        for d in "9876543210":
            if d * 3 in num:
                return d * 3
        return ""
```

## 複雜度

時間 `O(10 · n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 答案是字串，`"000"` 也是合法的答案，不能轉成整數。

## 面試口說整理

好的整數只有 `"000"` 到 `"999"` 十種，我從大到小檢查哪一個出現在字串裡，第一個找到的就是答案。時間 `O(n)`。
