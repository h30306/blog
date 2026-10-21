---
title: "LeetCode 3804: Number of Centered Subarrays"
summary: "LeetCode 3804 解題筆記：固定左端點往右擴，邊加總邊把元素放進集合，總和在集合裡就算一個"
description: "2026-01-11 的 LeetCode 3804 解題紀錄"
date: 2026-01-11
tags: ["medium", "hash-table", "enumeration", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-11
- 提交紀錄：Accepted（一次通過，2.8 秒）

## 解題思路

`n <= 500`，枚舉所有子陣列是 `O(n²)` 個。固定左端點 `i`、右端點 `j` 往右擴：

- 總和邊擴邊加。
- 子陣列裡有哪些值，用一個集合邊擴邊加，查詢 `O(1)`。

## 我的解法

我當時用 `curr_sum in nums[i: j + 1]` 檢查，每次都切一段再線性搜尋，整體 `O(n³)`，跑了 2.8 秒。改成增量維護的集合：

```python
class Solution:
    def centeredSubarrays(self, nums: List[int]) -> int:
        n, res = len(nums), 0
        for i in range(n):
            seen, total = set(), 0
            for j in range(i, n):
                total += nums[j]
                seen.add(nums[j])
                res += total in seen
        return res
```

## 複雜度

時間 `O(n²)`，空間 `O(n)`。

## 要特別避免的錯誤

- 不要每次都切片再搜尋，那是 `O(n)` 的額外成本。

## 面試口說整理

我固定左端點往右擴，同時維護總和和看過的值的集合，總和在集合裡就算一個置中的子陣列。每次擴張 `O(1)`，總共 `O(n²)`。
