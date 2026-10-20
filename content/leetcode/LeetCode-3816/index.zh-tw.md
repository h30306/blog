---
title: "LeetCode 3816: Lexicographically Smallest String After Deleting Duplicate Characters"
summary: "LeetCode 3816 解題筆記：單調棧，頂端比較大而且還有別的副本就刪；最後把尾巴重複的也刪掉，因為前綴一定比較小"
description: "2026-01-18 的 LeetCode 3816 解題紀錄"
date: 2026-01-18
tags: ["hard", "stack", "monotonic-stack", "greedy", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-01-18
- 提交紀錄：Wrong Answer ×5（01-18）→ RE、WA、RE、WA → Accepted → Accepted（07-27）

## 解題思路

可以刪除「目前出現至少兩次」的字母的任何一個，讓字串字典序最小。跟 LC 316 很像，差別是：**每個字母至少要留一個，但不必剛好一個**。

用 `cnt[ch]` 記錄「目前字串裡 `ch` 還有幾個」（stack 裡的加上還沒處理的）。從左到右：

1. 看到 `c` 時，如果 stack 頂端比 `c` 大，而且 `cnt[頂端] > 1`（還有別的副本），就刪掉它，`cnt` 減 1。
2. 把 `c` 推進 stack。

處理完之後還有一步：**尾巴的字母如果還有別的副本，也要刪掉**。因為一個字串的前綴，字典序一定比它自己小，例如 `"ab" < "abb"`。

## 我的嘗試

### 一月：從右往左刪，五次 WA

一開始想從右往左掃，記錄要刪掉的 index，最後再組回字串。邏輯一直沒有對應到「前面的大字母遇到後面的小字母就該刪」，五次 WA。

### 七月：單調棧，但記錄的東西太多

改成單調棧，同時維護 `count`（還沒處理的）和 `seen`（stack 裡的）兩個計數。中間兩次 Runtime Error 是先 `pop` 才去讀 `stack[-1]`，順序寫反；兩次 WA 是最後刪尾巴時，只檢查了原本的最後一個字元，沒有在刪掉之後更新成新的尾巴。

最後一版只用一個 `cnt`：它代表「目前字串裡這個字母還有幾個」，刪除時減 1，就同時處理了 stack 裡和後面的副本。

## 正確解法

```python
from collections import Counter

class Solution:
    def lexSmallestAfterDeletion(self, s: str) -> str:
        cnt = Counter(s)
        stack = []
        for ch in s:
            while stack and stack[-1] > ch and cnt[stack[-1]] > 1:
                cnt[stack.pop()] -= 1
            stack.append(ch)
        while cnt[stack[-1]] > 1:                 # 尾巴重複的也刪掉
            cnt[stack.pop()] -= 1
        return "".join(stack)
```

### 跟 LC 316 的差別

| | LC 316 | LC 3816 |
|---|---|---|
| 要求 | 每個字母剛好一個 | 每個字母至少一個 |
| 可以刪的條件 | 後面還會出現 | 目前還有不只一個 |
| 已在 stack 裡的字母 | 跳過 | 照樣推進去 |
| 結尾 | 不用處理 | 尾巴重複的要刪掉 |

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 先 `pop` 再讀 `stack[-1]`：讀到的是新的頂端，而且 stack 可能已經空了。
- 刪尾巴時沒有每次都重新看新的尾巴。
- 套用 LC 316 的寫法：這題不需要 `seen`，而且結尾要多刪一步。

## 面試口說整理

我用 `cnt` 記錄每個字母目前還有幾個，從左到右用單調棧建答案：頂端比目前字母大、而且還有別的副本時就刪掉它，`cnt` 減 1。全部處理完之後，尾巴的字母如果還有別的副本也刪掉，因為前綴的字典序一定更小。每個字元最多進出一次，時間 `O(n)`。
