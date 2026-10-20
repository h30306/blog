---
title: "LeetCode 1147: Longest Chunked Palindrome Decomposition"
summary: "LeetCode 1147 解題筆記：從兩端同時往內累積字串，左右一相等就切成一對；越早切越好，剩下的中間（如果有）算一塊"
description: "2026-07-01 的 LeetCode 1147 解題紀錄"
date: 2026-07-01
tags: ["hard", "dynamic-programming", "greedy", "two-pointers", "rolling-hash", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-07-01
- 提交紀錄：Accepted ×2（2026-07-01、08-24 各寫一次）

## 解題思路

**貪心：左右兩端一出現相同的前綴和後綴就切**。

為什麼越早切越好：如果最短的相同前後綴是 `A`，而某個更長的相同前後綴 `B` 被選成一塊，那 `B` 的開頭和結尾都是 `A`，可以把 `B` 再拆成 `A + 中間 + A`，塊數只會更多。

做法：兩個指針從兩端往內，左邊累積 `left_str`、右邊往前累積 `right_str`，相等就塊數 +2、清空重來。最後：

- 兩個指針剛好碰在同一個字元上（奇數長度的中心），或
- 還有沒配對完的字串，

中間那段算一塊，+1。

## 我的解法

```python
class Solution:
    def longestDecomposition(self, text: str) -> int:
        left, right = 0, len(text) - 1
        left_str = right_str = ""
        chunks = 0
        while left < right:
            left_str += text[left]
            right_str = text[right] + right_str
            if left_str == right_str:              # 能切就切
                chunks += 2
                left_str = right_str = ""
            left += 1
            right -= 1
        if left == right or left_str:              # 中間剩下的算一塊
            chunks += 1
        return chunks
```

## 複雜度

時間 `O(n^2)`（每次比較字串最多 `O(n)`），`n <= 1000`。用滾動雜湊比較可以做到 `O(n)`。空間 `O(n)`。

## 要特別避免的錯誤

- 最後中間剩下的部分要算一塊。
- 右邊的字串要往**前面**接（`text[right] + right_str`），順序才會跟原字串一樣。

## 面試口說整理

我用貪心，從兩端同時往內累積字串，左右一相等就切成一對，因為更長的相同前後綴一定可以再拆成更短的，塊數只會更多。最後如果中間還有剩，就算一塊。時間 `O(n^2)`，用滾動雜湊可以到 `O(n)`。
