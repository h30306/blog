---
title: "LeetCode 2781: Length of the Longest Valid Substring"
summary: "LeetCode 2781 解題筆記：禁字最長只有 10，每個右端只檢查最後 10 個字元組成的後綴；找到禁字就把左端推到它後面，要找最短的那個（最靠右的起點）"
description: "2026-01-14 的 LeetCode 2781 解題紀錄"
date: 2026-01-14
tags: ["hard", "sliding-window", "hash-table", "string", "trie"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-01-14
- 提交紀錄：WA ×2 → AC → TLE → WA → AC ×2（Trie 版本是 2026-01-15 寫的）

## 解題思路

視窗 `[left, right]` 合法 ⇔ 裡面沒有任何禁字。右端加入新字元後，**新出現的子字串都以 `right` 結尾**，所以只要檢查以 `right` 結尾的後綴。

禁字最長 10 個字元，只要檢查長度 1 到 10 的後綴：

- 從短到長檢查（起點 `i` 從 `right` 往左），第一個是禁字的後綴，起點最靠右。
- 左端推到 `i + 1`，然後 **`break`**：更長的禁字起點更左，推到那裡反而不夠。

後綴的起點不能小於 `left`（左邊的已經在視窗外）。

## 我的嘗試

前兩版都沒有 `break`：從短到長檢查時，找到一個短的禁字把 `left` 推到 `i + 1`，接著又找到一個更長的禁字，`left` 被改成更小的 `i + 1`，**左端往回走**，視窗裡又包含了短的那個禁字。

例如 `word = "baba"`、`forbidden = ["a", "ba"]`：任何含 `a` 的子字串都不合法，答案是 1（`"b"`）。在 `right = 1` 時先找到 `"a"`，`left = 2`；再找到 `"ba"`，`left` 被改回 1，視窗裡還留著禁字 `"a"`。下一步 `right = 2` 時，`"ab"` 就被當成合法，這兩版回傳 2。

加上 `break` 就 AC 了。之後用反向 Trie 重寫一次：第一版 TLE 是忘了 `right += 1`，第二版 WA 也是同樣少了 `break`。

## 正確解法

```python
class Solution:
    def longestValidSubstring(self, word: str, forbidden: List[str]) -> int:
        banned = set(forbidden)
        max_len = max(map(len, forbidden))         # 最多 10
        left = best = 0
        for right in range(len(word)):
            for i in range(right, max(left, right - max_len + 1) - 1, -1):
                if word[i:right + 1] in banned:
                    left = i + 1                   # 最短的禁字起點最靠右
                    break
            best = max(best, right - left + 1)
        return best
```

Trie 版本：把禁字**反過來**插入 Trie，從 `right` 往左走，一邊走一邊在 Trie 上往下，走不下去就停，碰到結尾標記就推 `left` 並 `break`。好處是不用每次切出子字串。

## 複雜度

時間 `O(n · L^2)`（每個右端最多 `L = 10` 個後綴，每個切片和雜湊是 `O(L)`）；Trie 版本是 `O(n · L)`。空間是禁字的總長度。

## 要特別避免的錯誤

- 找到禁字後沒有 `break`：更長的禁字會把左端往回拉。
- 後綴起點檢查到 `left` 之前：那些已經在視窗外。

## 面試口說整理

新加入的字元只會產生以它結尾的新子字串，而禁字最長 10，所以每個右端只檢查最後 10 個後綴。從短到長檢查，第一個禁字的起點最靠右，把左端推到它後面就停，不然更長的禁字會把左端往回拉。時間 `O(n · 10^2)`，用反向 Trie 可以省掉切字串。
