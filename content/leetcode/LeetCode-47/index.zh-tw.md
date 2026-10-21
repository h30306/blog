---
title: "LeetCode 47: Permutations II"
summary: "LeetCode 47 解題筆記：先排序，同一層如果跟前一個值相同而且前一個還沒被用，就跳過"
description: "2022-10-22 的 LeetCode 47 解題紀錄"
date: 2022-10-22
tags: ["medium", "array", "backtracking", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-10-22
- 提交紀錄：Wrong Answer → Accepted

## 解題思路

有重複數字的排列要去重（[Backtracking]({{< relref "/algorithm/Backtracking" >}}) 變化四）。排序後，`nums[i] == nums[i - 1]` 而且 `nums[i - 1]` **這一輪還沒被用**，代表同一層已經試過這個值，跳過。這樣相同的數只會按照原本的順序出現，每種排列只產生一次。

## 我的嘗試

第一版去重的條件是對的，但**忘了先排序**，相同的數不相鄰，跳過的判斷沒有作用：`[0, 1, 0]` 回傳了重複的排列。加上 `nums.sort()` 就 AC 了。

## 正確解法

```python
class Solution:
    def permuteUnique(self, nums: List[int]) -> List[List[int]]:
        nums.sort()
        res, path = [], []
        used = [False] * len(nums)
        def dfs():
            if len(path) == len(nums):
                res.append(path[:])
                return
            for i in range(len(nums)):
                if used[i] or (i > 0 and nums[i] == nums[i - 1] and not used[i - 1]):
                    continue
                used[i] = True
                path.append(nums[i])
                dfs()
                path.pop()
                used[i] = False
        dfs()
        return res
```

## 複雜度

時間 `O(n · n!)`，空間 `O(n)`（不算輸出）。

## 要特別避免的錯誤

- 去重前要先排序，相同的值才會相鄰。

## 面試口說整理

有重複的數字，我先排序，回溯時如果目前的數跟前一個一樣、而且前一個這一輪還沒用，就代表同一層已經試過這個值，跳過。時間 `O(n · n!)`。
