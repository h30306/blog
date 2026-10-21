---
title: "LeetCode 77: Combinations"
summary: "LeetCode 77 解題筆記：從 1 到 n 選 k 個，dfs(start, path)，下一個只從 start 之後選，避免重複的組合"
description: "2022-10-26 的 LeetCode 77 解題紀錄"
date: 2022-10-26
tags: ["medium", "backtracking"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-10-26
- 提交紀錄：Runtime Error ×3 → Accepted ×3

## 解題思路

組合不看順序，所以每次只從比上一個大的數開始選（[Backtracking]({{< relref "/algorithm/Backtracking" >}}) 模板）：`dfs(start, path)`，`path` 長度到 `k` 就記錄。剪枝：剩下的數不夠湊滿 `k` 個時直接停，`i` 只需要跑到 `n - (k - len(path)) + 1`。

## 我的嘗試

這題提交了 6 次：

- 2022-10-26 的第一版呼叫 helper 時忘了 `self.`（NameError），helper 本身也有問題：在 `for` 迴圈裡**直接 `return` 遞迴的結果**，只會走第一條分支；`range(0, now[-1])` 在 `now` 是空的時候 IndexError。
- 一個月後重寫成「下一個數必須比上一個大」的回溯才 AC。

## 正確解法

```python
class Solution:
    def combine(self, n: int, k: int) -> List[List[int]]:
        res = []
        def dfs(start, path):
            if len(path) == k:
                res.append(path[:])
                return
            for i in range(start, n - (k - len(path)) + 2):
                path.append(i)
                dfs(i + 1, path)
                path.pop()
        dfs(1, [])
        return res
```

## 複雜度

時間 `O(k · C(n, k))`，空間 `O(k)`（不算輸出）。

## 要特別避免的錯誤

- 遞迴的 helper 要用 `self.` 呼叫，或寫成內部函式。
- `for` 迴圈裡直接 `return` 遞迴的結果，只會走第一條分支。
- 記錄答案時要複製 `path[:]`。

## 面試口說整理

組合不看順序，我用回溯，每次只從比上一個大的數開始選，選滿 k 個就記錄；剩下的數不夠湊滿 k 個時就剪掉。時間 `O(k · C(n, k))`。
