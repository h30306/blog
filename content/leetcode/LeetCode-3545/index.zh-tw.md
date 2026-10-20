---
title: "LeetCode 3545: Minimum Deletions for At Most K Distinct Characters"
summary: "LeetCode 3545 解題筆記：要減少種類就得整種刪掉，從出現次數最少的開始刪"
description: "2025-05-11 的 LeetCode 3545 解題紀錄"
date: 2025-05-11
tags: ["easy", "greedy", "hash-table", "string", "sorting", "counting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2025-05-11
- 提交紀錄：Accepted（一次通過）

## 解題思路

只刪掉某種字元的一部分，種類數不會變少，所以**要刪就整種刪掉**。有 `m` 種、最多留 `k` 種，就要刪掉 `m - k` 種，挑出現次數最少的那幾種刪，刪的字元數最少。

## 我的解法

```python
class Solution:
    def minDeletion(self, s: str, k: int) -> int:
        freq = sorted(Counter(s).values())
        drop = max(0, len(freq) - k)
        return sum(freq[:drop])
```

我當時把 `Counter` 依次數排序成 dict，再數到 `len - k` 個；排序 `values()` 就夠了。

## 複雜度

時間 `O(n + σ log σ)`，`σ` 是字元種類數（最多 26），空間 `O(σ)`。

## 要特別避免的錯誤

- 種類本來就 `<= k` 時 `len(freq) - k` 是負的，`freq[:負數]` 會從後面切掉，要先跟 0 取 `max`。

## 面試口說整理

部分刪除不會減少種類，所以只能整種刪。我統計每種字元的次數、由小到大排序，刪掉最少的 `m - k` 種，加總它們的次數。時間 `O(n)`。
