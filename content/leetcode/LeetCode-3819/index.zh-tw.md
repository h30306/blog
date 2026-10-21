---
title: "LeetCode 3819: Rotate Non Negative Elements"
summary: "LeetCode 3819 解題筆記：把非負數抽出來左旋 k 格，再依序放回原本非負數的位置；一個非負數都沒有時不能對 0 取模"
description: "2026-01-25 的 LeetCode 3819 解題紀錄"
date: 2026-01-25
tags: ["medium", "array", "simulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-25
- 提交紀錄：Runtime Error → Accepted

## 解題思路

負數不動，所以只處理非負數（[Array]({{< relref "/algorithm/Array" >}}) 模板五）：記下非負數的位置和值，值左旋 `k % m`（`m` 是非負數個數），再依序填回那些位置。

## 我的嘗試

第一版沒處理「一個非負數都沒有」：`k % len(non_neg)` 變成對 0 取模。例如 `nums = [-1]`、`k = 2`：直接 ZeroDivisionError。加上特判就 AC 了。

## 正確解法

```python
class Solution:
    def rotateElements(self, nums: List[int], k: int) -> List[int]:
        idx = [i for i, x in enumerate(nums) if x >= 0]
        if not idx:
            return nums
        vals = [nums[i] for i in idx]
        k %= len(vals)
        vals = vals[k:] + vals[:k]                 # 左旋 k 格
        res = nums[:]
        for i, v in zip(idx, vals):
            res[i] = v
        return res
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 取模之前先確定非負數的個數不是 0。
- 左旋是 `vals[k:] + vals[:k]`。

## 面試口說整理

我把非負數的位置和值抽出來，值左旋 `k` 格之後依序放回那些位置，負數保持不動。非負數一個都沒有就直接回傳。時間 `O(n)`。
