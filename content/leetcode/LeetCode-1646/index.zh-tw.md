---
title: "LeetCode 1646: Get Maximum in Generated Array"
summary: "LeetCode 1646 解題筆記：照規則生成陣列：偶數位置 nums[i // 2]，奇數位置 nums[i // 2] + nums[i // 2 + 1]，n = 0 要特別處理"
description: "2022-11-01 的 LeetCode 1646 解題紀錄"
date: 2022-11-01
tags: ["easy", "array", "simulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-11-01
- 提交紀錄：Runtime Error → Wrong Answer → Accepted → Runtime Error → Wrong Answer → Accepted

## 解題思路

直接模擬（[Array]({{< relref "/algorithm/Array" >}}) 模板五）：`nums[0] = 0`、`nums[1] = 1`，`i` 是偶數時 `nums[i] = nums[i // 2]`，奇數時 `nums[i] = nums[i // 2] + nums[i // 2 + 1]`。`n = 0` 時陣列只有 `[0]`，不能先放 `nums[1]`。

## 我的嘗試

- 2022-11-01：第一版 `n = 0` 時陣列只有一格，`res[1] = 1` 超出範圍；補上特例後，奇數位置寫成 `res[i // 2] + res[i % 2]`，**`i % 2` 永遠是 1**：`n = 9` 答案 4，回傳 3。
- 2022-11-15 重寫：先寫成 `j = i - 1 // 2`，**`//` 比 `-` 先算**，等於 `j = i`，直接超出範圍；修好之後又漏了 `n = 0`，`[0, 1]` 的最大值是 1，答案 0。

## 正確解法

```python
class Solution:
    def getMaximumGenerated(self, n: int) -> int:
        if n == 0:
            return 0
        nums = [0] * (n + 1)
        nums[1] = 1
        for i in range(2, n + 1):
            nums[i] = nums[i // 2] if i % 2 == 0 else nums[i // 2] + nums[i // 2 + 1]
        return max(nums)
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 奇數位置是 `nums[i // 2 + 1]`，不是 `nums[i % 2]`。
- `i - 1 // 2` 是 `i - 0`，要寫 `(i - 1) // 2`。
- `n = 0` 時答案是 0。

## 面試口說整理

我照規則生成到第 n 個，偶數位置是一半的位置，奇數位置是一半和一半加一的和，最後取最大值；n 是 0 時直接回傳 0。時間 `O(n)`。
