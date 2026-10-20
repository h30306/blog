---
title: "LeetCode 1763: Longest Nice Substring"
summary: "LeetCode 1763 解題筆記：沒有大小寫配對的字元一定不在答案裡，用它切開字串遞迴；長度相同時取左邊的"
description: "2026-01-17 的 LeetCode 1763 解題紀錄"
date: 2026-01-17
tags: ["easy", "sliding-window", "divide-and-conquer", "hash-table", "string", "bit-manipulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2026-01-17
- 提交紀錄：Wrong Answer ×3 → Accepted（滑動視窗）→ Accepted（分治）

## 解題思路

跟 [LeetCode 395]({{< relref "/leetcode/LeetCode-395" >}}) 是同一類：「每個字母大小寫都出現」不單調。

**分治**：如果某個字元的另一種大小寫在整個字串裡都沒出現，答案一定不包含它。用它切開，左右兩邊遞迴，取比較長的；一樣長取左邊的（題目要最早出現的）。

`n <= 100`，直接枚舉所有子字串 `O(n^2 · 26)` 也可以。

## 我的嘗試

我前四版用 395 的做法：枚舉視窗裡有幾種字母（不分大小寫），固定種類數滑動，再檢查大寫和小寫出現的字母是否一樣。三次 WA 都是移出左邊字元時的更新：

| 版本 | 問題 |
|---|---|
| 第一版 | 某個大小寫的數量歸零時就把種類數減一，但另一種大小寫可能還在視窗裡。例如 `s = "AabAAa"`：答案是 `"AAa"`，回傳 `"Aa"` |
| 第二版 | 改成兩種都歸零才減種類數，但數量歸零、另一種還在時，**key 沒有刪掉**，`keys()` 比較會把數量 0 的 key 也算進去。例如 `s = "acAbB"`：`"AbB"` 沒有小寫 `a`，卻被判成合法，答案是 `"bB"` |
| 第三版 | 比較改成整個 dict 相等，等於要求大寫和小寫的**數量**也一樣。例如 `s = "AaA"`：答案是 `"AaA"`，回傳 `"Aa"` |
| 第四版 AC | 數量歸零就刪 key，另一種也歸零才減種類數 |

之後改用分治，簡單很多。

## 正確解法

```python
class Solution:
    def longestNiceSubstring(self, s: str) -> str:
        chars = set(s)
        for i, c in enumerate(s):
            if c.swapcase() not in chars:          # c 不可能在答案裡
                left = self.longestNiceSubstring(s[:i])
                right = self.longestNiceSubstring(s[i + 1:])
                return left if len(left) >= len(right) else right   # 一樣長取左邊
        return s
```

## 複雜度

時間 `O(n^2)`（每層切一刀，最多 `n` 層，每層 `O(n)`），空間 `O(n)` 遞迴深度。

## 要特別避免的錯誤

- 長度相同時要取最早出現的。
- 用 `dict.keys()` 比較時，數量歸零的 key 要刪掉。

## 面試口說整理

如果某個字元的另一種大小寫在字串裡都沒有，它一定不在答案裡，所以我用它把字串切開，左右遞迴，取比較長的，一樣長取左邊。所有字元都有配對時整段就是答案。`n` 只有 100，最壞 `O(n^2)` 沒問題。
