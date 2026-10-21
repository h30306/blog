---
title: "LeetCode 896: Monotonic Array"
summary: "LeetCode 896 解題筆記：單調可以是非遞增或非遞減，兩個方向各檢查一次，相等的元素都可以"
description: "2022-09-24 的 LeetCode 896 解題紀錄"
date: 2022-09-24
tags: ["easy", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-09-24
- 提交紀錄：Wrong Answer ×3 → Accepted ×3

## 解題思路

單調有兩種方向，而且是**非嚴格**的（相等可以）。掃一次，分別記錄「有沒有出現上升」和「有沒有出現下降」，兩者不能同時出現（[Array]({{< relref "/algorithm/Array" >}}) 模板一）。

## 我的嘗試

前兩版各自**只檢查一個方向**：只允許非遞增時 `[0, 3]` 回傳 `False`，只允許非遞減時 `[1, 0]` 回傳 `False`。第三版兩個方向都檢查了，但用了**嚴格**的 `<`、`>`：`[0, 0]` 回傳 `False`。改成 `<=`、`>=` 就 AC 了。

## 正確解法

```python
class Solution:
    def isMonotonic(self, nums: List[int]) -> bool:
        up = down = False
        for i in range(1, len(nums)):
            if nums[i] > nums[i - 1]:
                up = True
            elif nums[i] < nums[i - 1]:
                down = True
        return not (up and down)
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 兩個方向都要考慮。
- 用 `<=`、`>=`，相等的相鄰元素不會破壞單調。

## 面試口說整理

我掃一次，記錄有沒有出現上升和有沒有出現下降，只要兩種沒有同時出現就是單調的，相等的元素不影響。時間 `O(n)`、空間 `O(1)`。
