---
title: "LeetCode 809: Expressive Words"
summary: "LeetCode 809 解題筆記：兩個指針一段一段比對連續相同字元的長度；長度不同時，s 的那段必須至少 3 個且不少於 word；最後兩個字串都要剛好走完"
description: "2026-01-31 的 LeetCode 809 解題紀錄"
date: 2026-01-31
tags: ["medium", "two-pointers", "string", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-31
- 提交紀錄：Runtime Error → Wrong Answer ×2 → Accepted

## 解題思路

把字串看成一段一段「連續相同字元」的組合，例如 `"heeellooo"` 是 `h1 e3 l2 o3`。`word` 能擴張成 `s`，代表兩邊的段數相同，而且每一段：

- 字元相同；
- 長度相同，**或** `s` 那段長度 `>= 3` 且 `>= word` 那段的長度（只能擴張成 3 個以上，不能縮短）。

用兩個指針分別走 `s` 和 `word`，每次各自吃掉一整段、比較長度。**迴圈結束後兩邊都必須剛好走完**，否則有一邊多出整段字元。

## 我的嘗試

這題的錯都出在「結束條件」：

| 版本 | 問題 |
|---|---|
| 第一版 RE | 迴圈只看 `left < n`，`word` 先走完時還去讀 `word[right]`。例如 `s = "aab"`、`word = "aa"` 直接 IndexError |
| 第二版 WA | 改成 `left < n and right < m`，但結束後直接回傳 `True`，沒檢查 `s` 有沒有剩。同一個例子 `"aab"` / `["aa"]` 回傳 1，答案是 0 |
| 第三版 WA | 補上 `left == n`，但沒檢查 `word` 有沒有剩。例如 `s = "abc"`、`word = "abcd"` 回傳 1，答案是 0 |

最後改成 `left == n and right == m` 才 AC。

## 正確解法

```python
class Solution:
    def expressiveWords(self, s: str, words: List[str]) -> int:
        def run_end(t: str, i: int) -> int:           # 從 i 開始這段相同字元的結尾（不含）
            j = i
            while j < len(t) and t[j] == t[i]:
                j += 1
            return j

        def stretchy(word: str) -> bool:
            i = j = 0
            while i < len(s) and j < len(word):
                if s[i] != word[j]:
                    return False
                ni, nj = run_end(s, i), run_end(word, j)
                len_s, len_w = ni - i, nj - j
                if len_s != len_w and (len_s < 3 or len_s < len_w):
                    return False
                i, j = ni, nj
            return i == len(s) and j == len(word)

        return sum(stretchy(w) for w in words)
```

## 複雜度

時間 `O(len(s) · 字數 + 所有 word 的總長度)`，空間 `O(1)`。

## 要特別避免的錯誤

- 只用一個字串的長度控制迴圈：另一個先走完就越界。
- 結束時沒檢查**兩邊**都走完。
- 長度條件寫反：`s` 那段可以比較長，但不能比 `word` 短。

## 面試口說整理

我把字串看成一段一段相同字元，兩個指針各自吃掉一整段，比較字元和長度：長度相同可以，不同的話 `s` 那段要至少 3 個而且不少於 `word`。迴圈結束後要確定兩個字串都剛好走完。每個 word 都是線性掃一次。
