---
title: "LeetCode 219: Contains Duplicate II"
summary: "LeetCode 219 解題筆記：雜湊表記錄每個值最後一次出現的位置，只需要跟最近的那次比距離"
description: "2022-08-21 的 LeetCode 219 解題紀錄"
date: 2022-08-21
tags: ["easy", "array", "hash-table", "sliding-window"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-21
- 提交紀錄：Wrong Answer → Runtime Error → Wrong Answer ×2 → Accepted ×4

## 解題思路

用雜湊表記住每個值**最後一次**出現的 index（[Hash Table]({{< relref "/algorithm/Hash-Table" >}})）。掃到 `nums[i]` 時，只要跟上一次出現的位置比：如果最近的那次距離都超過 `k`，更早的就更不可能。也可以想成長度 `k + 1` 的固定視窗裡有沒有重複（[Sliding Window]({{< relref "/algorithm/Sliding-Window" >}}) 模板一）。

## 我的嘗試

前四版是先把每個值的所有 index 存成 list，再比較：

- 第一版只建好表就結束，沒有回傳值。
- 第二版寫成 `d.values` 少了括號（TypeError）。
- 第三版比的是**第一次和最後一次**出現的距離，而且只出現一次的值距離是 0，也被當成重複：例如 `[3]`、`k = 2` 回傳 `True`。
- 第四版排除了只出現一次的值，但仍然比頭尾：`[0, 0, 0]`、`k = 1` 相鄰的兩個 0 距離是 1，答案 `True`，頭尾距離 2 所以回傳 `False`。

改成只記最後一次出現的位置就 AC 了。

## 正確解法

```python
class Solution:
    def containsNearbyDuplicate(self, nums: List[int], k: int) -> bool:
        last = {}
        for i, v in enumerate(nums):
            if v in last and i - last[v] <= k:
                return True
            last[v] = i
        return False
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 要比的是**相鄰兩次**出現的距離，不是第一次和最後一次。
- 只出現一次的值不算重複。

## 面試口說整理

我用雜湊表存每個值上一次出現的位置，掃到同樣的值就比距離是否不超過 k，然後更新位置。只需要比最近的那一次，因為更早的距離只會更遠。時間 `O(n)`、空間 `O(n)`。
