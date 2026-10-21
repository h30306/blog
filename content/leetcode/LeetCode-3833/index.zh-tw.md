---
title: "LeetCode 3833: Count Dominant Indices"
summary: "LeetCode 3833 解題筆記：從右往左維護後綴總和，比較 nums[i] × 右邊個數 > 右邊總和，不用浮點數也不會包含自己"
description: "2026-02-08 的 LeetCode 3833 解題紀錄"
date: 2026-02-08
tags: ["easy", "array", "enumeration"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2026-02-08
- 提交紀錄：Wrong Answer → Accepted

## 解題思路

`nums[i]` 要大於**右邊**元素的平均（不包含自己）。從右往左掃，維護右邊的總和和個數（[Array]({{< relref "/algorithm/Array" >}}) 模板三）。比較平均時改成乘法：`nums[i] > s / c` 等於 `nums[i] * c > s`，避免浮點數和整數除法的問題。最後一個元素右邊沒有東西，不算。

## 我的嘗試

第一版有兩個問題：平均用 `//` 整數除法，而且第 `i` 個的平均**包含了自己**。例如 `[4, 3, 5, 4]`：只有 `5 > 4`，答案 1；這版回傳 2。改成 `/`、並且跟 `i + 1` 開始的後綴平均比較就 AC 了。

## 正確解法

```python
class Solution:
    def dominantIndices(self, nums: List[int]) -> int:
        n, suffix, res = len(nums), 0, 0
        for i in range(n - 1, -1, -1):
            cnt = n - 1 - i
            if cnt and nums[i] * cnt > suffix:
                res += 1
            suffix += nums[i]
        return res
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 平均不包含自己。
- 用整數除法會把平均往下取整，比較就錯了；改成乘法最安全。

## 面試口說整理

我從右往左維護右邊的總和，每個位置比較自己乘上右邊個數是否大於右邊總和，等於比平均大，而且不用浮點數。時間 `O(n)`。
