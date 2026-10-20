---
title: "LeetCode 1526: Minimum Number of Increments on Subarrays to Form a Target Array"
summary: "LeetCode 1526 解題筆記：從左往右看，每次比前一個高，多出來的高度都要新開那麼多次操作；變矮的部分可以沿用之前的操作"
description: "2026-07-04 的 LeetCode 1526 解題紀錄"
date: 2026-07-04
tags: ["hard", "dynamic-programming", "greedy", "monotonic-stack", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-07-04
- 提交紀錄：Accepted（一次通過）

## 解題思路

把 `target` 想成一排高度。每次操作是把連續的一段加高 1。

從左往右看：

- 第一格需要 `target[0]` 次操作。
- 如果 `target[i] <= target[i - 1]`，第 `i` 格可以直接沿用涵蓋前一格的那些操作（把它們延伸過來），不用新的。
- 如果 `target[i] > target[i - 1]`，多出來的 `target[i] - target[i - 1]` 層一定要**新開**操作，因為前一格只有那麼高。

所以答案是 `target[0] + Σ max(0, target[i] - target[i - 1])`。

## 我的解法

```python
class Solution:
    def minNumberOperations(self, target: List[int]) -> int:
        ops = target[0]
        for i in range(1, len(target)):
            ops += max(0, target[i] - target[i - 1])   # 變高的部分要新開操作
        return ops
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 變矮的時候不用加：之前的操作在這裡停下來就好。

## 面試口說整理

把陣列想成高度，每次操作是把一段連續的加高一層。從左往右，比前一格高的部分一定要新開操作，比前一格矮或一樣，就沿用前面的操作。所以答案是第一格的高度加上所有上升的差。時間 `O(n)`。
