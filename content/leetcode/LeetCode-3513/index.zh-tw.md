---
title: "LeetCode 3513: Number of Unique XOR Triplets I"
summary: "LeetCode 解題紀錄"
description: "LeetCode 雙周賽 154"
date: 2025-04-12
series: ["LeetCode Bi-Weekly Contest 154"]
series_order: 2
tags: ["LeetCode", "bi-weekly", "medium", "unsolved", "bit"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試： 2025-04-12
- 總花費時間：20:00.00 (TLE)

## 解題思路

我最初的想法是使用三層 for 迴圈（`O(n^3)`）來遍歷 `nums` 中所有可能的組合，並將每組的 XOR 結果存入一個名為 `seen` 的集合中。然而，這種作法顯然會因為三層巢狀迴圈而導致 TLE（Time Limit Exceeded，超出時間限制）。

接著，我嘗試套用 Digit DP，認為可以藉由減少重複計算來優化效能。例如：

- (0, 0, 0) → 3 XOR 3 XOR 3 = 3  
- (0, 0, 1) → 3 XOR 3 XOR 1 = 1  
- (0, 0, 2) → 3 XOR 3 XOR 2 = 2  
- (0, 1, 2) → 3 XOR 1 XOR 2 = 0

像是 `3 XOR 3` 這樣的表達式，如果已經計算過並被 `lru_cache` 快取，就不需要重複計算。

但問題在於，和多數經典 Digit DP 題目中「結果空間相對較小」不同，本題的 XOR 結果集合範圍非常大。因此，`lru_cache` 的命中率會很低，導致效能提升有限，最終仍然會遇到 TLE。

我認為這題唯一可行的作法可能是透過位元運算（bit manipulation），但我目前仍未找到明確的說明或最佳解法。


## 解法
```python
class Solution:
    def uniqueXorTriplets(self, nums: List[int]) -> int:
        
        from functools import lru_cache

        n = len(nums)

        @lru_cache(None)
        def dfs(position, num_index, xor_result):
            if position == 3:
                return {xor_result}

            result = set()
            for idx in range(num_index, n):
                result.update(
                    dfs(
                        position + 1,
                        idx,
                        xor_result ^ nums[idx]
                    )
                )

            return result

        return len(dfs(0, 0, 0))
```

## 收穫
1. 可能的 `xor_result` 結果集合太大，導致在這種作法下快取命中率非常低，最終會造成 TLE（Time Limit Exceeded）。


## 遇到的問題