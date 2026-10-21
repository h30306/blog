---
title: "LeetCode 13: Roman to Integer"
summary: "LeetCode 13 解題筆記：從左到右加每個符號的值，如果它比右邊的符號小就改成減"
description: "2019-09-18 的 LeetCode 13 解題紀錄"
date: 2019-09-18
tags: ["easy", "hash-table", "math", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2019-09-18
- 提交紀錄：Accepted ×4

## 解題思路

羅馬數字裡，比較小的符號出現在比較大的符號**左邊**時代表減法（`IV = 4`、`XC = 90`）。所以用雜湊表查每個符號的值（[Hash Table]({{< relref "/algorithm/Hash-Table" >}})），如果 `val[s[i]] < val[s[i + 1]]` 就減，否則加。

## 我的解法

```python
class Solution:
    def romanToInt(self, s: str) -> int:
        val = {"I": 1, "V": 5, "X": 10, "L": 50, "C": 100, "D": 500, "M": 1000}
        total = 0
        for i, c in enumerate(s):
            if i + 1 < len(s) and val[c] < val[s[i + 1]]:
                total -= val[c]
            else:
                total += val[c]
        return total
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 比較右邊的符號前要確認 `i + 1` 沒有超出範圍。

## 面試口說整理

我用雜湊表存每個符號的值，從左到右掃，如果目前的符號比右邊的小就減掉，否則加上。時間 `O(n)`。
