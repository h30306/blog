---
title: "LeetCode 541: Reverse String II"
summary: "LeetCode 541 解題筆記：每 2k 個為一段，反轉每段的前 k 個；最後一段不足 k 個時全部反轉，切片會自動處理"
description: "2022-08-25 的 LeetCode 541 解題紀錄"
date: 2022-08-25
tags: ["easy", "two-pointers", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-25
- 提交紀錄：Wrong Answer ×2 → Runtime Error → Wrong Answer ×2 → Runtime Error → Accepted → Runtime Error ×2 → Wrong Answer ×2 → Accepted

## 解題思路

從 0 開始每次跳 `2k`，把 `[i, i + k)` 反轉（[Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) 模板一）。最後剩不到 `k` 個時題目要求全部反轉，用切片 `a[i:i + k]` 超出範圍會自動截斷，剛好符合。

## 我的嘗試

2022 年的版本只反轉了**第一段**的前 `k` 個，例如 `"cddebd"`、`k = 2`：答案 `"dcdedb"`，回傳 `"dcdebd"`。2026 年重寫時條件寫成 `i + k <= n` 才反轉，**剩不到 `k` 個的最後一段沒有反轉**，例如 `"cd"`、`k = 4`：答案 `"dc"`，回傳 `"cd"`。

## 正確解法

```python
class Solution:
    def reverseStr(self, s: str, k: int) -> str:
        a = list(s)
        for i in range(0, len(a), 2 * k):
            a[i:i + k] = reversed(a[i:i + k])
        return "".join(a)
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 不是只有第一段，是每 `2k` 一段都要做。
- 剩不到 `k` 個也要反轉。

## 面試口說整理

我每 `2k` 個跳一次，把每段的前 `k` 個反轉，最後一段不夠 `k` 個時切片會自動只反轉剩下的。時間 `O(n)`。
