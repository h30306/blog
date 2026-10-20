---
title: "LeetCode 1498: Number of Subsequences That Satisfy the Given Sum Condition"
summary: "LeetCode 1498 解題筆記：子序列只看最小值和最大值，排序後順序無關；固定最小值 nums[left]，中間的元素任意選，共 2^(right - left) 種"
description: "2026-01-24 的 LeetCode 1498 解題紀錄"
date: 2026-01-24
tags: ["medium", "two-pointers", "sorting", "binary-search", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-24
- 提交紀錄：Accepted ×2 → Wrong Answer → Accepted ×2

## 解題思路

子序列是否合法只看**最小值 + 最大值**，跟元素的原本順序無關，所以可以先排序。

排序後用對撞指針：

- `nums[left] + nums[right] > target`：`nums[right]` 跟目前最小的都配不起來，跟更大的更不可能，丟掉它，`right -= 1`。
- 否則，以 `nums[left]` 當最小值：一定要選 `nums[left]`，`left + 1..right` 這 `right - left` 個元素可選可不選，最大值一定 `<= nums[right]`，共 `2^(right - left)` 種。加完 `left += 1`。

`2` 的次方要取模，用 `pow(2, e, MOD)`，或先預處理次方表。

## 我的嘗試

第一次 AC 之後我自己重寫了幾次。中間有一版 WA：把判斷改成 `while ... else`，內層 `while` 沒有加 `left <= right`，`right` 會一路減到 `left` 左邊。這時 `right - left` 是負的，而 Python 的 `pow(2, -1, MOD)` **不會報錯**，會回傳 2 的模反元素 `500000004`，答案就被加進一個奇怪的大數。

例如 `nums = [3, 5, 6, 7]`、`target = 9`：答案是 4，這版回傳 `500000008`。

內層 `while` 加上 `left <= right` 後 AC。

## 正確解法

```python
class Solution:
    def numSubseq(self, nums: List[int], target: int) -> int:
        MOD = 10 ** 9 + 7
        nums.sort()
        left, right = 0, len(nums) - 1
        ans = 0
        while left <= right:
            if nums[left] + nums[right] > target:
                right -= 1                         # nums[right] 沒有可以配的最小值
            else:
                ans = (ans + pow(2, right - left, MOD)) % MOD
                left += 1                          # 以 nums[left] 為最小值的都算完了
        return ans
```

## 複雜度

時間 `O(n log n)`（每次 `pow` 是 `O(log n)`，預處理次方表可以變成 `O(1)`），空間 `O(1)`（不算排序）。

## 要特別避免的錯誤

- 以為子序列要保持順序就不能排序：這題只看最小值和最大值。
- `right` 跑到 `left` 左邊：Python 的 `pow` 負指數加模數不會報錯，會默默算錯。
- `2^(right - left)` 不是 `2^(right - left + 1)`：最小值 `nums[left]` 一定要選。

## 面試口說整理

合法與否只看最小值加最大值，所以先排序。對撞指針：兩端加起來太大，就把右端丟掉；夠小的話，以左端當最小值，它一定要選，中間 `right - left` 個任意選，共 `2^(right - left)` 種，加完左端前進。時間 `O(n log n)`。
