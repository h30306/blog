---
title: "LeetCode 1944: Number of Visible People in a Queue"
summary: "LeetCode 1944 解題筆記：從右往左維護遞減的單調棧，被彈出的都看得到，彈完剩下的那個也看得到"
description: "2026-09-04 的 LeetCode 1944 解題紀錄"
date: 2026-09-04
tags: ["hard", "stack", "monotonic-stack"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-09-04
- 提交紀錄：Accepted → Accepted（隔天重打一次）

## 解題思路

第 `i` 個人看得到右邊的 `j`，條件是中間每個人都比他們兩個矮。

從右往左處理，stack 裡保持**由頂到底遞增**（越下面越高）。處理第 `i` 個人時：

1. stack 頂端比他矮的人，他都看得到，而且這些人之後會被他擋住，左邊的人再也看不到他們，所以直接彈出、計數加 1。
2. 彈完之後，如果 stack 還有人，那個人比他高，他也看得到，但看不到更後面的人，計數再加 1。
3. 把他自己推進 stack。

## 我的解法

```python
class Solution:
    def canSeePersonsCount(self, heights: List[int]) -> List[int]:
        n = len(heights)
        res = [0] * n
        stack = []
        for i in range(n - 1, -1, -1):
            count = 0
            while stack and stack[-1] < heights[i]:
                stack.pop()
                count += 1
            if stack:
                count += 1
            res[i] = count
            stack.append(heights[i])
        return res
```

題目保證身高都不同，所以不用處理相等的情況。

## 複雜度

時間 `O(n)`：每個人最多進出 stack 一次。空間 `O(n)`。

## 要特別避免的錯誤

- 彈完之後忘記加上「擋住視線的那個比較高的人」。
- 從左往右做：從左往右時不知道右邊的情況，要從右往左。
- 對每個人往右掃：`O(n^2)`。

## 面試口說整理

我從右往左維護一個單調棧。處理每個人時，stack 頂端比他矮的人他都看得到，而且這些人之後會被他擋住，所以直接彈出並計數；彈完如果還有人，那個比較高的人也看得到，再加 1。最後把自己推進去。每個人只進出一次，時間 `O(n)`。
