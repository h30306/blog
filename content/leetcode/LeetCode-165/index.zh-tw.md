---
title: "LeetCode 165: Compare Version Numbers"
summary: "LeetCode 165 解題筆記：用 . 切開後轉成整數逐段比較，比較短的版本缺的段當作 0"
description: "2022-11-19 的 LeetCode 165 解題紀錄"
date: 2022-11-19
tags: ["medium", "two-pointers", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-11-19
- 提交紀錄：Accepted（一次通過）

## 解題思路

用 `.` 切開後每一段轉成 `int`（前導零自然消失），兩個版本各一個指標逐段比較（[Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) 模板二）。比較短的那邊缺少的段當作 `0`，所以 `1.0` 和 `1` 相同。

## 我的解法

```python
class Solution:
    def compareVersion(self, version1: str, version2: str) -> int:
        a = list(map(int, version1.split(".")))
        b = list(map(int, version2.split(".")))
        for i in range(max(len(a), len(b))):
            x = a[i] if i < len(a) else 0
            y = b[i] if i < len(b) else 0
            if x != y:
                return 1 if x > y else -1
        return 0
```

## 複雜度

時間 `O(n + m)`，空間 `O(n + m)`。

## 要特別避免的錯誤

- 要轉成整數比，`"01"` 和 `"1"` 相同。
- 長度不同時缺的段補 0，不是直接判定比較長的比較大。

## 面試口說整理

我用點切開，每段轉成整數，逐段比較，比較短的版本缺的段當成 0，第一個不同的段決定結果。時間 `O(n + m)`。
