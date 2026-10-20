---
title: "LeetCode 1486: XOR Operation in an Array"
summary: "LeetCode 1486 解題筆記：依定義產生 start + 2i，逐一 XOR 起來"
description: "2025-12-18 的 LeetCode 1486 解題紀錄"
date: 2025-12-18
tags: ["easy", "math", "bit-manipulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2025-12-18
- 提交紀錄：Accepted（Python）→ Accepted（C++）→ Wrong Answer（C++）→ Accepted（C++）

## 解題思路

第 `i` 個數是 `start + 2 * i`，`n` 最多 1000，直接逐一 XOR 就好。

## 我的嘗試

Python 和 C++ 都一次 AC；之後重寫 C++ 時把 `2 * i` 打成 `n * i`。例如 `n = 5`、`start = 0`：應該是 `0 ^ 2 ^ 4 ^ 6 ^ 8 = 8`，這版算的是 `0 ^ 5 ^ 10 ^ 15 ^ 20 = 20`。

## 正確解法

```python
class Solution:
    def xorOperation(self, n: int, start: int) -> int:
        res = 0
        for i in range(n):
            res ^= start + 2 * i
        return res
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 步長是固定的 2，不是 `n`。

## 面試口說整理

照定義產生每個 `start + 2i`，用一個變數累積 XOR。`n` 很小，`O(n)` 就夠了；要 `O(1)` 的話可以用 `1 ^ 2 ^ ... ^ k` 的週期公式。
