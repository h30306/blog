---
title: "LeetCode 39: Combination Sum"
summary: "LeetCode 39 解題筆記：同一個數可以重複選，所以遞迴時下一層從 i 開始（不是 i + 1），這樣也避免了順序不同的重複"
description: "2022-10-21 的 LeetCode 39 解題紀錄"
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
- 提交紀錄：Wrong Answer → Accepted ×2 → Wrong Answer ×2 → Runtime Error → Wrong Answer → Accepted → Wrong Answer → Accepted

## 解題思路

每個數可以用無限次，但答案不看順序。`dfs(start, remain, path)` 的下一層從 **`i`** 開始（[Backtracking]({{< relref "/algorithm/Backtracking" >}}) 模板）：可以再選自己，但不會回頭選前面的數，所以 `[2, 2, 3]` 和 `[3, 2, 2]` 只會出現一次。排序後 `candidates[i] > remain` 就可以 `break`。

## 我的嘗試

- 2022-10-21 第一版每一層都從頭選，**同一組數字的不同順序都被記錄了**：`[2, 3]`、`target = 9` 回傳了四次 `[2, 2, 2, 3]`。
- 2022-10-30 重寫時一版把 0 也放進了組合（`[[0, 5]]`），另一版遞迴的條件寫錯，`[2]`、`target = 8` 回傳空的。
- 2022-11-23 改成「下一個數不能比上一個小」才 AC。

## 正確解法

```python
class Solution:
    def combinationSum(self, candidates: List[int], target: int) -> List[List[int]]:
        candidates.sort()
        res = []
        def dfs(start, remain, path):
            if remain == 0:
                res.append(path[:])
                return
            for i in range(start, len(candidates)):
                if candidates[i] > remain:
                    break
                path.append(candidates[i])
                dfs(i, remain - candidates[i], path)
                path.pop()
        dfs(0, target, [])
        return res
```

## 複雜度

時間指數級（取決於 target 和最小的數），空間 `O(target / min)`。

## 要特別避免的錯誤

- 下一層從 `i` 開始：從 0 開始會產生順序不同的重複答案，從 `i + 1` 開始就不能重複使用。
- `remain == 0` 時記錄，不要記錄空的組合。

## 面試口說整理

每個數可以重複選，但答案不看順序，所以我回溯時下一層從同一個 index 開始，可以再選自己但不會回頭選前面的數；排序後超過剩下的目標就停止。
