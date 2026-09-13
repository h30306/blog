---
title: "Kadane's Algorithm"
summary: "用 ending-here invariant 解 Maximum Subarray"
description: "演算法學習"
date: 2025-07-25
tags: ["kadane", "dynamic-programming", "array"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 介紹

Kadane's Algorithm 用來在線性時間內解 Maximum Subarray。重點不是只記「running sum」，而是要講清楚 DP state：

```text
curr = 以目前 index 結尾的最大 subarray sum
best = 到目前為止看過的全域最大 subarray sum
```

這個 ending-here invariant 才是它能正確處理負數陣列的原因。

## 核心概念

對每個值 `x`，以目前位置結尾的最佳 subarray 只有兩種可能：

- 從 `x` 重新開始
- 接在前一個 ending-here subarray 後面

所以 recurrence 是：

```text
curr = max(x, curr + x)
best = max(best, curr)
```

`curr` 和 `best` 要用 `nums[0]` 初始化，不能用 `0`，因為答案可能是負數。

## 模板

```python
from typing import List

def max_subarray(nums: List[int]) -> int:
    curr = best = nums[0]

    for x in nums[1:]:
        curr = max(x, curr + x)
        best = max(best, curr)

    return best
```

### 主要參數說明

- `curr`: 必須以目前元素結尾的最佳 subarray sum。
- `best`: 到目前為止的全域最佳答案。
- `max(x, curr + x)`: 決定要重新開始，還是延續前一段。

## 常見錯誤

- 把 `curr` 或 `best` 初始化成 `0`，導致全負數陣列錯掉。
- 回傳 `curr`，但最佳答案可能早就出現在前面。
- 只說 `curr` 是 current sum，沒有講出「ending here」。

## 範例

對於：

```text
nums = [-2,1,-3,4,-1,2,1,-5,4]
```

最佳 subarray 是：

```text
[4, -1, 2, 1]
```

總和是：

```text
6
```

## 相關 LeetCode

- `LC 53` Maximum Subarray
- `LC 152` Maximum Product Subarray，因為負數會翻轉正負，所以需要同時追蹤 max-ending-here 和 min-ending-here。
