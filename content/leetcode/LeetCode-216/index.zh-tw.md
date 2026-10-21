---
title: "LeetCode 216: Combination Sum III"
summary: "LeetCode 216 解題筆記：只能用 1 到 9，每個數最多一次，選剛好 k 個加起來是 n"
description: "2022-11-12 的 LeetCode 216 解題紀錄"
date: 2022-11-12
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
第一次嘗試：2022-11-12
- 提交紀錄：Wrong Answer → Accepted ×2

## 解題思路

跟 LC 77 一樣的組合回溯（[Backtracking]({{< relref "/algorithm/Backtracking" >}}) 模板），候選數固定是 **1 到 9**，下一層從 `i + 1` 開始。剪枝：數量超過 `k` 或總和超過 `n` 就停。

## 我的嘗試

第一版的候選數寫成 `range(min_number + 1, n + 1)`，**用了 1 到 `n` 而不是 1 到 9**：`k = 3`、`n = 24` 回傳了 `[1, 2, 21]` 這種組合。改成只用 1 到 9 才 AC。

## 正確解法

```python
class Solution:
    def combinationSum3(self, k: int, n: int) -> List[List[int]]:
        res = []
        def dfs(start, remain, path):
            if len(path) == k:
                if remain == 0:
                    res.append(path[:])
                return
            for x in range(start, 10):
                if x > remain:
                    break
                path.append(x)
                dfs(x + 1, remain - x, path)
                path.pop()
        dfs(1, n, [])
        return res
```

## 複雜度

時間 `O(C(9, k) · k)`，空間 `O(k)`。

## 要特別避免的錯誤

- 候選數只有 1 到 9，不是 1 到 `n`。

## 面試口說整理

候選數只有 1 到 9，每個最多用一次，我用組合的回溯，下一層從比目前大的數開始，選滿 k 個時檢查總和是否為 n，超過就剪掉。
