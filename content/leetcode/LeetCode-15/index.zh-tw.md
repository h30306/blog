---
title: "LeetCode 15: 3Sum"
summary: "LeetCode 15 解題筆記：排序後固定第一個數，剩下用對撞指針找兩數和；三個位置都要跳過相同的值，才不會有重複的組合"
description: "2022-10-20 的 LeetCode 15 解題紀錄"
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
- 提交紀錄：Runtime Error ×2 → Wrong Answer ×2 → Runtime Error ×3 → Time Limit Exceeded ×2 → Runtime Error → Accepted → Wrong Answer → Time Limit Exceeded ×4 → Runtime Error → Wrong Answer → Accepted → Runtime Error → Wrong Answer ×3 → Memory Limit Exceeded → Time Limit Exceeded ×4 → Accepted → Wrong Answer ×2 → Accepted ×2 → Wrong Answer → Accepted ×2

## 解題思路

排序後固定 `nums[i]`，在 `i + 1` 到結尾用對撞指針找和為 `-nums[i]` 的兩個數（[Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) 模板一）。去重有三個地方：

- `nums[i]` 跟前一個一樣就跳過。
- 找到一組之後，`left` 和 `right` 都要跳過相同的值。

## 我的嘗試

這題提交了 36 次，是這批最多的：

- 一開始左右指針從 0 和結尾開始、夾著 `i` 找，範圍不對而且一直產生重複的組合，例如 `[2, -2, 0, 0]` 回傳兩個 `[-2, 0, 2]`。
- 用集合或三層迴圈去重的版本 TLE / MLE。
- 2022 年 10 月底幾版找到一組之後沒有跳過相同的值，例如 `[4, -2, -2, 4]` 回傳兩個 `[-2, -2, 4]`；補上去重之後 10 月 31 日才 AC。2026 年重寫時一次就寫對了。

## 正確解法

```python
class Solution:
    def threeSum(self, nums: List[int]) -> List[List[int]]:
        nums.sort()
        n, res = len(nums), []
        for i in range(n - 2):
            if i and nums[i] == nums[i - 1]:
                continue
            l, r = i + 1, n - 1
            while l < r:
                s = nums[i] + nums[l] + nums[r]
                if s < 0:
                    l += 1
                elif s > 0:
                    r -= 1
                else:
                    res.append([nums[i], nums[l], nums[r]])
                    l += 1
                    while l < r and nums[l] == nums[l - 1]:
                        l += 1
                    r -= 1
        return res
```

## 複雜度

時間 `O(n²)`，空間 `O(1)`（不算排序和輸出）。

## 要特別避免的錯誤

- 找到一組之後要跳過相同的值，不然同一組會被加好幾次。
- 第二、三個數的範圍要從 `i + 1` 開始，不是從 0 開始。

## 面試口說整理

排序後我固定第一個數，剩下兩個用左右指針往中間找。第一個數和找到之後的左指針都要跳過相同的值，結果才不會重複。時間 `O(n²)`。
