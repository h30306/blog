---
title: "LeetCode 90: Subsets II"
summary: "LeetCode 90 解題筆記：先排序；遇到跟前一個相同的數，只延伸上一步新產生的那些子集合"
description: "2022-10-26 的 LeetCode 90 解題紀錄"
date: 2022-10-26
tags: ["medium", "array", "backtracking", "bit-manipulation"]
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
- 提交紀錄：Accepted ×2 → Runtime Error → Wrong Answer ×2 → Runtime Error ×3 → Wrong Answer → Accepted → Wrong Answer → Accepted → Wrong Answer ×2 → Accepted

## 解題思路

有重複元素時要去重（[Backtracking]({{< relref "/algorithm/Backtracking" >}}) 變化四）。先排序讓相同的數相鄰。迭代寫法：一般的數會延伸所有子集合；如果它跟前一個數相同，只延伸**上一步新產生的**那些（它們已經包含前一個相同的數），否則會再產生一次一樣的子集合。回溯寫法則是「同一層跳過跟前一個相同的選擇」：`if i > start and nums[i] == nums[i - 1]: continue`。

## 我的嘗試

這題提交了 15 次：

- 第一次 AC 是用 `if c + [num] not in combs` 去重，每次檢查都要掃過所有子集合，很慢。
- 之後改成「相同的數只延伸上一步新產生的子集合」，好幾次**忘了先排序**，相同的數不相鄰：`[1, 2, 1]` 回傳了兩個 `[1]`、兩個 `[1, 2]`。
- 其他幾次是記錄「上一步產生了幾個」的變數用錯、條件寫反（`nums[i] == nums[i - 1]` 時才更新），補上排序並把條件改成 `!=` 才穩定 AC。

## 正確解法

```python
class Solution:
    def subsetsWithDup(self, nums: List[int]) -> List[List[int]]:
        nums.sort()
        res = []
        def dfs(start, path):
            res.append(path[:])
            for i in range(start, len(nums)):
                if i > start and nums[i] == nums[i - 1]:
                    continue
                path.append(nums[i])
                dfs(i + 1, path)
                path.pop()
        dfs(0, [])
        return res
```

## 複雜度

時間 `O(n · 2^n)`，空間 `O(n)`（不算輸出）。

## 要特別避免的錯誤

- 去重前一定要先排序。
- 跳過的條件是 `i > start`（同一層），不是 `i > 0`，不然 `[1, 1]` 這種會被跳過。
- 用 `not in res` 去重是 `O(2^n)` 一次，很慢。

## 面試口說整理

我先排序讓相同的數相鄰，回溯時同一層如果跟前一個選擇相同就跳過，這樣相同的子集合只會產生一次。時間 `O(n · 2^n)`。
