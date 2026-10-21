---
title: "LeetCode 392: Is Subsequence"
summary: "LeetCode 392 解題筆記：兩個指針，t 的指針一直往前，對上 s 的字元時 s 的指針也前進；兩邊的邊界都要檢查"
description: "2022-08-23 的 LeetCode 392 解題紀錄"
date: 2022-08-23
tags: ["easy", "two-pointers", "string", "dynamic-programming"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-23
- 提交紀錄：Runtime Error ×2 → Accepted ×2 → Runtime Error → Accepted ×2 → Runtime Error → Wrong Answer → Accepted ×3 → Runtime Error → Wrong Answer → Runtime Error ×2 → Accepted

## 解題思路

兩個字串各一個指針（[Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) 模板二）：`j` 掃過 `t`，`t[j] == s[i]` 時 `i` 前進。迴圈條件是 `i < len(s) and j < len(t)`，最後 `i == len(s)` 就成立。這樣 `s` 或 `t` 是空字串都不用特別處理。進階題有很多個 `s` 時，先把 `t` 每個字元出現的位置存起來，對每個 `s` 用 binary search 找下一個位置。

## 我的嘗試

這題寫了很多次（2022、2025、2026），錯誤幾乎都在空字串和邊界：

- 2022-08 用 queue `pop(0)`，`s` 是空的時候 `queue[0]` 超出範圍。
- 2022-11 寫成 `if not t or not s: return False`，**`s` 是空字串時應該是 `True`**：`('', '')` 回傳 `False`。
- 2025 年內層 `while t[r] != s[l]` 在 `t` 是空的時直接 IndexError；補上 `if not t: return False` 又把 `('', '')` 弄錯了；配對後 `r += 1` 超出範圍也沒檢查：`('bb', 'b')` IndexError。
- 2026 年的版本只在不相同時檢查 `right == m`，`t` 是空字串時第一次比較就超出範圍；把邊界放進 `while` 條件才 AC。

## 正確解法

```python
class Solution:
    def isSubsequence(self, s: str, t: str) -> bool:
        i = 0
        for c in t:
            if i < len(s) and s[i] == c:
                i += 1
        return i == len(s)
```

## 複雜度

時間 `O(n + m)`，空間 `O(1)`。

## 要特別避免的錯誤

- `s` 是空字串時答案是 `True`，就算 `t` 也是空的。
- 存取 `t[j]` 之前要確認 `j` 沒有超出範圍，包括配對成功、`j` 前進之後。

## 面試口說整理

我用兩個指針，掃過 t 的每個字元，跟 s 目前的字元相同就把 s 的指針往前，最後 s 的指針走完就是子序列。時間 `O(n + m)`、空間 `O(1)`。
