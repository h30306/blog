---
title: "LeetCode 2697: Lexicographically Smallest Palindrome"
summary: "LeetCode 2697 解題筆記：對撞指針，兩端不同時都改成比較小的那個字元"
description: "2026-01-24 的 LeetCode 2697 解題紀錄"
date: 2026-01-24
tags: ["easy", "two-pointers", "string", "greedy"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2026-01-24
- 提交紀錄：Accepted（一次通過）

## 解題思路

要用最少的修改次數把字串變成回文，次數相同時取字典序最小的。

回文的條件是每一對 `(i, n - 1 - i)` 都相等。對每一對：

- 已經相等：不用改。
- 不相等：**最少要改一個**，而改成比較小的那個字元，字典序最小。

每一對各自獨立，所以兩件事可以同時做到。

## 我的解法

```python
class Solution:
    def makeSmallestPalindrome(self, s: str) -> str:
        chars = list(s)
        left, right = 0, len(chars) - 1
        while left < right:
            smaller = min(chars[left], chars[right])
            chars[left] = chars[right] = smaller
            left += 1
            right -= 1
        return "".join(chars)
```

原本的版本用 `if / elif` 分別處理「左邊比較小」和「右邊比較小」，這裡直接取 `min`。

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 改成比較大的字元：修改次數一樣，但字典序變大。
- 兩邊都改：只需要改比較大的那一邊。

## 面試口說整理

回文要求每一對對稱位置相等，所以我用對撞指針一對一對看：不同的話至少要改一個，改成比較小的那個字元，修改次數最少、字典序也最小。每一對互不影響，時間 `O(n)`。
