---
title: "LeetCode 40: Combination Sum II"
summary: "LeetCode 40 解題筆記：每個數只能用一次而且有重複，排序後下一層從 i + 1 開始，同一層跳過跟前一個相同的值"
description: "2022-10-21 的 LeetCode 40 解題紀錄"
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
- 提交紀錄：Wrong Answer ×2 → Runtime Error → Time Limit Exceeded ×2 → Runtime Error ×2 → Accepted → Runtime Error ×2 → Accepted → Wrong Answer ×3 → Runtime Error → Accepted → Wrong Answer ×3 → Accepted

## 解題思路

跟 LC 39 差兩個地方（[Backtracking]({{< relref "/algorithm/Backtracking" >}}) 變化四）：

1. 每個數只能用一次：下一層從 `i + 1` 開始。
2. `candidates` 有重複：排序後，同一層如果 `candidates[i] == candidates[i - 1]`（而且 `i > start`）就跳過。同一層選相同的值會產生一模一樣的子樹。

注意是**同一層**跳過，不同層選相同的值是允許的，例如 `[1, 1, 6]`。

## 我的嘗試

這題提交了 20 次，分三個階段：

- 2022-10-21：第一版下一層從 `i` 開始，**同一個數被重複使用**：`[1]`、`target = 6` 回傳 `[[1, 1, 1, 1, 1, 1]]`；改成 `i + 1` 之後沒有去重，`[3, 3, 5]`、`target = 8` 回傳兩次 `[3, 5]`；接著用 `not in self.res` 去重，TLE 了兩次。
- 2022-10-30 重寫，同樣沒有去重的問題又出現了三次。
- 2022-11-23：一版先檢查「`candidates` 是空的就回傳」，**最後一個數剛好湊滿時還沒記錄就回傳了**：`[1]`、`target = 1` 回傳空的。最後加上「同一層跳過相同的值」才 AC。

## 正確解法

```python
class Solution:
    def combinationSum2(self, candidates: List[int], target: int) -> List[List[int]]:
        candidates.sort()
        res = []
        def dfs(start, remain, path):
            if remain == 0:
                res.append(path[:])
                return
            for i in range(start, len(candidates)):
                if i > start and candidates[i] == candidates[i - 1]:
                    continue
                if candidates[i] > remain:
                    break
                path.append(candidates[i])
                dfs(i + 1, remain - candidates[i], path)
                path.pop()
        dfs(0, target, [])
        return res
```

## 複雜度

時間 `O(2^n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 下一層從 `i + 1` 開始，每個數只用一次。
- 去重要在同一層做（`i > start`），而且要先排序。
- 用 `not in res` 去重會 TLE。
- 先判斷 `remain == 0` 再判斷「沒有數可以選」，不然最後一個數剛好湊滿時會漏掉。

## 面試口說整理

每個數只能用一次而且陣列有重複，所以我先排序，回溯時下一層從 i + 1 開始，同一層遇到跟前一個相同的值就跳過，避免產生一樣的組合；超過剩下的目標就停止。
