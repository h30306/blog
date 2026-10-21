---
title: "LeetCode 18: 4Sum"
summary: "LeetCode 18 解題筆記：排序後兩層迴圈固定前兩個數，剩下用對撞指針；四個位置都要跳過相同的值"
description: "2022-10-20 的 LeetCode 18 解題紀錄"
date: 2022-10-20
tags: ["medium", "array", "two-pointers", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-10-20
- 提交紀錄：Runtime Error ×9 → Wrong Answer ×9 → Accepted ×3 → Wrong Answer → Accepted ×2

## 解題思路

在 3sum 外面再包一層（[Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) 模板一）：`i`、`j` 固定前兩個，`l`、`r` 對撞找剩下兩個。去重跟 3sum 一樣，`i`、`j` 跟前一個相同就跳過，找到一組之後 `l` 跳過相同的值。

## 我的嘗試

這題 2022 年提交了 24 次：

- 前面十次 RE 大多是變數沒定義、`None` 取值或 index 超出範圍。
- 之後的 WA 都在去重：找到一組之後沒有跳過相同的值，例如 `[2, 1, 3, -2, 1]`、`target = 4` 回傳兩個 `[-2, 1, 2, 3]`；也有一版跳過太多，`[1, -1, 3, 0]`、`target = 3` 什麼都沒找到。

## 正確解法

```python
class Solution:
    def fourSum(self, nums: List[int], target: int) -> List[List[int]]:
        nums.sort()
        n, res = len(nums), []
        for i in range(n - 3):
            if i and nums[i] == nums[i - 1]:
                continue
            for j in range(i + 1, n - 2):
                if j > i + 1 and nums[j] == nums[j - 1]:
                    continue
                l, r = j + 1, n - 1
                while l < r:
                    s = nums[i] + nums[j] + nums[l] + nums[r]
                    if s < target:
                        l += 1
                    elif s > target:
                        r -= 1
                    else:
                        res.append([nums[i], nums[j], nums[l], nums[r]])
                        l += 1
                        while l < r and nums[l] == nums[l - 1]:
                            l += 1
                        r -= 1
        return res
```

## 複雜度

時間 `O(n³)`，空間 `O(1)`（不算輸出）。

## 要特別避免的錯誤

- `j` 的去重條件是 `j > i + 1`，不是 `j > 0`，不然會跳過合法的組合。

## 面試口說整理

排序後我用兩層迴圈固定前兩個數，再用左右指針找後兩個，四個位置都跳過相同的值避免重複。時間 `O(n³)`。
