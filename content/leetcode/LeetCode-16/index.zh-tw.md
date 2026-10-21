---
title: "LeetCode 16: 3Sum Closest"
summary: "LeetCode 16 解題筆記：排序後固定一個數，對撞指針找另外兩個；比較的是和跟 target 的距離 abs(sum - target)"
description: "2022-10-20 的 LeetCode 16 解題紀錄"
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
- 提交紀錄：Wrong Answer ×2 → Accepted → Wrong Answer ×2 → Accepted ×2

## 解題思路

跟 3sum 一樣固定 `nums[i]`、用對撞指針（[Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) 模板一），每一組都用 `abs(s - target)` 更新最接近的和。和比 target 小就 `l += 1` 讓和變大，比較大就 `r -= 1`，剛好相等就可以直接回傳。

## 我的嘗試

第一版有三個錯：把第一個數取了負號（從 3sum 改過來時留下的）、比較距離沒有加 `abs`、指針移動只看兩個數的和。例如 `[1, 1, 4]`、`target = 1` 回傳的不是 6。2022 年 11 月重寫時又錯了兩次，都是比較距離的寫法不對。

## 正確解法

```python
class Solution:
    def threeSumClosest(self, nums: List[int], target: int) -> int:
        nums.sort()
        best = nums[0] + nums[1] + nums[2]
        for i in range(len(nums) - 2):
            l, r = i + 1, len(nums) - 1
            while l < r:
                s = nums[i] + nums[l] + nums[r]
                if abs(s - target) < abs(best - target):
                    best = s
                if s < target:
                    l += 1
                elif s > target:
                    r -= 1
                else:
                    return s
        return best
```

## 複雜度

時間 `O(n²)`，空間 `O(1)`。

## 要特別避免的錯誤

- 比較要用絕對值；沒加 `abs` 時，比 target 小很多的和會被當成更接近。
- 指針移動的條件要看整個三數和，不是只看兩個數。

## 面試口說整理

排序後我固定一個數，用左右指針找另外兩個，每一組用跟目標的距離更新答案；和太小就左指針右移，太大就右指針左移，相等直接回傳。時間 `O(n²)`。
