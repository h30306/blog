---
title: "LeetCode 942: DI String Match"
summary: "LeetCode 942 解題筆記：兩個指標分別指向還沒用的最小值和最大值，遇到 I 放最小、遇到 D 放最大"
description: "2022-09-26 的 LeetCode 942 解題紀錄"
date: 2022-09-26
tags: ["easy", "array", "two-pointers", "string", "greedy"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-09-26
- 提交紀錄：Accepted ×3

## 解題思路

`lo = 0`、`hi = n` 分別是還沒用過的最小值和最大值。遇到 `I` 就放 `lo`：之後放的數一定都比它大；遇到 `D` 就放 `hi`：之後放的數一定都比它小。最後 `lo == hi`，把它放在最後。

## 我的解法

```python
class Solution:
    def diStringMatch(self, s: str) -> List[int]:
        lo, hi = 0, len(s)
        res = []
        for ch in s:
            if ch == "I":
                res.append(lo)
                lo += 1
            else:
                res.append(hi)
                hi -= 1
        res.append(lo)
        return res
```

## 複雜度

時間 `O(n)`，空間 `O(n)`（輸出）。

## 要特別避免的錯誤

- 答案有 `n + 1` 個數，迴圈結束後還要補最後一個。

## 面試口說整理

我用兩個指標記錄還沒用過的最小值和最大值，遇到 I 放最小值、遇到 D 放最大值，這樣下一個數一定符合大小關係，最後剩下的那個數放在結尾。時間 `O(n)`。
