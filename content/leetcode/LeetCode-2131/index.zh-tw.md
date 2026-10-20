---
title: "LeetCode 2131: Longest Palindrome by Concatenating Two Letter Words"
summary: "LeetCode 2131 解題筆記：每個字跟它的反轉配成一對放兩邊；本身是回文的字也能兩兩配對，只有剩下的一個能放正中間"
description: "2025-08-21 的 LeetCode 2131 解題紀錄"
date: 2025-08-21
tags: ["medium", "greedy", "hash-table", "string", "counting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2025-08-21
- 提交紀錄：Wrong Answer → Accepted

## 解題思路

回文左右對稱，所以每個字要在另一邊放它的反轉：

- `"ab"` 跟 `"ba"` 配一對，一左一右，長度 +4。
- `"cc"` 這種本身是回文的字，**跟另一個 `"cc"` 也能配一對**；如果剩下一個，可以放正中間，長度 +2，而且全部只能放一個。

## 我的嘗試

第一版把所有本身是回文的字都當成「中間候選」，直接跳過不配對。例如 `["cc", "cc"]`：可以排成 `"cccc"`，答案是 4，這版回傳 2。

改成所有字都先跟反轉配對（`"cc"` 的反轉是自己），最後剩下的字裡有回文的話再加 2，就 AC 了。

## 正確解法

```python
class Solution:
    def longestPalindrome(self, words: List[str]) -> int:
        cnt = Counter(words)
        res, mid = 0, False
        for w, c in cnt.items():
            r = w[::-1]
            if w == r:
                res += c // 2 * 4          # 兩兩配對放兩邊
                mid |= c % 2 == 1          # 剩一個可以放中間
            elif w < r:                    # 每一對只算一次
                res += min(c, cnt[r]) * 4
        return res + (2 if mid else 0)
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 本身是回文的字也能兩兩配對，不是全部都只能放中間。
- 中間最多只能放一個字。
- 用 `w < r` 避免 `"ab"` 和 `"ba"` 各算一次。

## 面試口說整理

我數每個字出現幾次。不是回文的字跟它的反轉配對，取兩者次數較小的；本身是回文的字自己跟自己配對，奇數個時剩一個可以放中間。每一對貢獻 4，中間貢獻 2。時間 `O(n)`。
