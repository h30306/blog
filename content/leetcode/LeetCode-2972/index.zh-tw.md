---
title: "LeetCode 2972: Count the Number of Incremovable Subarrays II"
summary: "LeetCode 2972 解題筆記：刪掉一段後留下嚴格遞增的前綴 + 後綴；對每個合法的前綴結尾，用只往右走的指針找第一個能接上的後綴起點，後面的起點都能選"
description: "2026-01-26 的 LeetCode 2972 解題紀錄"
date: 2026-01-26
tags: ["hard", "two-pointers", "binary-search", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-01-26
- 提交紀錄：Accepted ×2

## 解題思路

跟 [LeetCode 1574]({{< relref "/leetcode/LeetCode-1574" >}}) 同一個結構，只是這題要**數有幾種刪法**，而且要嚴格遞增。

刪掉 `nums[l..r]` 後，留下的前綴 `nums[0..l-1]` 和後綴 `nums[r+1..]` 都要嚴格遞增，而且 `nums[l-1] < nums[r+1]`（有一邊是空的就不用比）。

1. 從右邊找最長的嚴格遞增後綴，起點 `right`。如果整個陣列都是，任何非空子陣列都能刪，答案是 `n(n + 1) / 2`。
2. **前綴是空的**：後綴的起點可以是 `right, right + 1, ..., n`（`n` 代表後綴也是空的），共 `n - right + 1` 種。
3. **前綴到 `left`**（`nums[0..left]` 要嚴格遞增）：後綴起點要 `> left` 而且 `nums[起點] > nums[left]`。讓 `right` 往右走到第一個 `nums[right] > nums[left]`，之後的起點都可以，共 `n - right + 1` 種。

`left` 越大，`nums[left]` 越大，能接的後綴起點只會往右，所以 `right` 不用回頭。

## 我的解法

```python
class Solution:
    def incremovableSubarrayCount(self, nums: List[int]) -> int:
        n = len(nums)
        right = n - 1
        while right > 0 and nums[right - 1] < nums[right]:
            right -= 1
        if right == 0:
            return n * (n + 1) // 2                # 整個陣列嚴格遞增

        ans = n - right + 1                        # 前綴是空的
        for left in range(n):
            if left > 0 and nums[left - 1] >= nums[left]:
                break                              # 前綴不再嚴格遞增
            while right < n and nums[right] <= nums[left]:
                right += 1
            ans += n - right + 1                   # 後綴起點 right..n 都可以
        return ans
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 忘了「前綴是空的」和「後綴是空的」這兩種情況（`n - right + 1` 裡的 `+1` 就是後綴為空）。
- 這題是**嚴格**遞增，比較要用 `<`，跟 1574 的 `<=` 不一樣。
- 整個陣列已經遞增時要特判，否則 `right` 和 `left` 會重疊。

## 面試口說整理

刪掉一段之後留下的是前綴加後綴，兩段都要嚴格遞增、接起來也要遞增。我先找出最長的嚴格遞增後綴；前綴為空時後綴起點有 `n - right + 1` 種。接著依序把前綴延長到 `left`，讓後綴指針往右走到第一個比 `nums[left]` 大的位置，從那裡開始的起點都能接，也是 `n - right + 1` 種。兩個指針都不回頭，時間 `O(n)`。
