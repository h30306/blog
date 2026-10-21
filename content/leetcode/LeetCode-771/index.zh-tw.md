---
title: "LeetCode 771: Jewels and Stones"
summary: "LeetCode 771 解題筆記：把 jewels 放進集合，數 stones 裡有幾個字元在集合裡"
description: "2022-09-06 的 LeetCode 771 解題紀錄"
date: 2022-09-06
tags: ["easy", "hash-table", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-09-06
- 提交紀錄：Accepted → Runtime Error ×2 → Accepted

## 解題思路

把 `jewels` 轉成集合，`stones` 每個字元查一次是不是寶石，`O(1)` 查詢（[Hash Table]({{< relref "/algorithm/Hash-Table" >}})）。大小寫不同。

## 我的嘗試

中間兩次 RE 是用了舊版題目的參數名稱 `J`、`S`（NameError），改成 `jewels`、`stones` 就好了。

## 正確解法

```python
class Solution:
    def numJewelsInStones(self, jewels: str, stones: str) -> int:
        jewel_set = set(jewels)
        return sum(s in jewel_set for s in stones)
```

## 複雜度

時間 `O(n + m)`，空間 `O(m)`。

## 要特別避免的錯誤

- 大小寫是不同的石頭。

## 面試口說整理

我把 jewels 放進集合，數 stones 裡有幾個字元在集合中，時間 `O(n + m)`。
