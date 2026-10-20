---
title: "LeetCode 1745: Palindrome Partitioning IV"
summary: "LeetCode 1745 解題筆記：先用區間 DP 建好 is_pal[i][j]，再枚舉兩個切點，三段都是回文就成立，O(n^2)"
description: "2026-06-27 的 LeetCode 1745 解題紀錄"
date: 2026-06-27
tags: ["hard", "dynamic-programming", "interval-dp", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-06-27
- 提交紀錄：Wrong Answer ×2 → Accepted（暴力）→ Accepted ×2（回文表）

## 解題思路

1. 用區間 DP 建 `is_pal[i][j]`：`s[i] == s[j]`，而且裡面那段是回文（長度 `<= 2` 時直接成立）。依長度由短到長填。
2. 枚舉兩個切點：第一段 `[0, i]`、第二段 `[i + 1, j]`、第三段 `[j + 1, n - 1]`，三段都非空：`0 <= i < j < n - 1`。

## 我的嘗試

前三版是直接切字串、用 `s == s[::-1]` 檢查，`O(n^3)`。兩次 WA 都是切點的範圍：

| 版本 | 問題 |
|---|---|
| 第一版 | 跳過了 `j == n - 1`（`j` 是第三段的起點），漏掉第三段只有一個字元的情況。例如 `s = "aab"`：`"a" + "a" + "b"`，答案是 `True`，回傳 `False` |
| 第二版 | 拿掉那個限制，但 `j` 從 `i` 開始，第二段可以是空的。例如 `s = "abab"`：`"aba" + "" + "b"` 被當成合法，答案是 `False`，回傳 `True` |
| 第三版 AC | `j` 從 `i + 1` 開始，但切字串的暴力版本跑了 8 秒 |

之後改成先建回文表，`O(n^2)`。

## 正確解法

```python
class Solution:
    def checkPartitioning(self, s: str) -> bool:
        n = len(s)
        is_pal = [[False] * n for _ in range(n)]
        for i in range(n - 1, -1, -1):
            for j in range(i, n):
                is_pal[i][j] = s[i] == s[j] and (j - i < 2 or is_pal[i + 1][j - 1])

        for i in range(n - 2):                     # 第一段 [0, i]
            if not is_pal[0][i]:
                continue
            for j in range(i + 1, n - 1):          # 第二段 [i+1, j]，第三段 [j+1, n-1]
                if is_pal[i + 1][j] and is_pal[j + 1][n - 1]:
                    return True
        return False
```

## 複雜度

時間 `O(n^2)`，空間 `O(n^2)`。

## 要特別避免的錯誤

- 三段都要非空，切點的範圍要寫清楚。
- 每次都切字串檢查回文：`O(n^3)`。

## 面試口說整理

我先用區間 DP 建回文表，`s[i]` 等於 `s[j]` 而且裡面是回文就是回文。接著枚舉兩個切點，確保三段都非空，三段都是回文就回傳 `True`。建表和枚舉都是 `O(n^2)`。
