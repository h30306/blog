---
title: "LeetCode 3697: Compute Decimal Representation"
summary: "LeetCode 3697 解題筆記：每個非 0 的位數乘上它的位值就是一個分量，從高位到低位輸出"
description: "2025-09-28 的 LeetCode 3697 解題紀錄"
date: 2025-09-28
tags: ["easy", "math", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2025-09-28
- 提交紀錄：Accepted（一次通過）

## 解題思路

一個分量只能是「一個 1~9 的位數 × 10 的次方」，所以每一個非 0 的位數剛好對應一個分量，例如 `537 = 500 + 30 + 7`。0 的位數不用分量。要用最少個，就是每個非 0 位數各一個，不能再少（每個分量只能貢獻一個位數）。

用 `% 10` 從低位拿位數，同時記錄位值 `place`，最後反轉成由大到小。

## 我的解法

```python
class Solution:
    def decimalRepresentation(self, n: int) -> List[int]:
        res = []
        place = 1
        while n:
            d = n % 10
            if d:
                res.append(d * place)
            n //= 10
            place *= 10
        return res[::-1]                   # 由大到小
```

我當時用字串 `f"{r}{'0' * zeros}"` 組出分量，效果一樣，乘上 `place` 比較直接。

## 複雜度

時間 `O(d)`，`d` 是位數，空間 `O(d)`。

## 要特別避免的錯誤

- 位數是 0 時不要放進答案。
- 從低位拿出來的順序是由小到大，要反轉。

## 面試口說整理

每個非 0 的位數乘上它的位值就是一個分量，而且每個分量只能代表一個位數，所以這就是最少的。我從低位用 `% 10` 拿位數、跳過 0，最後反轉成由大到小。時間 `O(d)`。
