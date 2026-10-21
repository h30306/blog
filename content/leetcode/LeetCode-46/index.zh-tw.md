---
title: "LeetCode 46: Permutations"
summary: "LeetCode 46 解題筆記：每一層從還沒用過的數裡選一個，用 used 陣列標記，path 滿了就記錄"
description: "2022-10-21 的 LeetCode 46 解題紀錄"
date: 2022-10-21
tags: ["medium", "array", "backtracking"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-10-21
- 提交紀錄：Accepted → Memory Limit Exceeded → Runtime Error → Wrong Answer → Accepted ×2 → Wrong Answer → Runtime Error → Accepted → Runtime Error → Wrong Answer → Accepted

## 解題思路

排列看順序，每一層都可以選任何一個還沒用過的數（[Backtracking]({{< relref "/algorithm/Backtracking" >}}) 模板）。用 `used[i]` 標記，選之前檢查、回溯時取消標記。`path` 長度等於 `n` 時記錄一份複製。

## 我的嘗試

這題提交了 12 次，第一次就 AC 了（用「過濾掉跟目前值相同的數」的寫法），之後每次重寫都錯在小地方：

- 括號沒寫完、把 index `i` 而不是值 `nums[i]` 放進答案（`[3]` 回傳 `[[0]]`）。
- 忘了呼叫 `dfs` 或忘了 `return`、把答案多包了一層 list（`[[[3]]]`）。

## 正確解法

```python
class Solution:
    def permute(self, nums: List[int]) -> List[List[int]]:
        res, path = [], []
        used = [False] * len(nums)
        def dfs():
            if len(path) == len(nums):
                res.append(path[:])
                return
            for i, x in enumerate(nums):
                if used[i]:
                    continue
                used[i] = True
                path.append(x)
                dfs()
                path.pop()
                used[i] = False
        dfs()
        return res
```

## 複雜度

時間 `O(n · n!)`，空間 `O(n)`（不算輸出）。

## 要特別避免的錯誤

- 放進 `path` 的是值 `nums[i]`，不是 index `i`。
- 用 `j != i` 過濾掉用過的「值」，只在沒有重複時才對；用 index 標記比較安全。

## 面試口說整理

排列看順序，每一層可以選任何一個還沒用過的數，我用 used 陣列標記，選完遞迴再取消標記，path 滿了就記錄一份。時間 `O(n · n!)`。
