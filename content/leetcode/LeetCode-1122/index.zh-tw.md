---
title: "LeetCode 1122: Relative Sort Array"
summary: "LeetCode 1122 解題筆記：計數後先按照 arr2 的順序輸出，剩下的數由小到大接在後面"
description: "2022-10-18 的 LeetCode 1122 解題紀錄"
date: 2022-10-18
tags: ["easy", "array", "hash-table", "sorting", "counting-sort"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-10-18
- 提交紀錄：Wrong Answer ×2 → Accepted ×2

## 解題思路

先用 `Counter` 數 `arr1`（[Hash Table]({{< relref "/algorithm/Hash-Table" >}}) 模板一）。照 `arr2` 的順序，每個值輸出它出現的次數，然後從計數中移除。剩下不在 `arr2` 裡的值要**由小到大**排序、而且保留出現次數，接在後面。值的範圍只有 `0..1000`，也可以直接用長度 1001 的陣列做計數排序。

## 我的嘗試

- 第一版剩下的數用 `C.most_common()` 輸出，**順序是按出現次數，不是由小到大**：`[6, 0, 9]`、`[9]` 回傳 `[9, 6, 0]`，答案 `[9, 0, 6]`。
- 第二版改成 `sorted(C.keys())`，排序對了但**每個值只剩一個**：`[2, 2, 6]`、`[6]` 回傳 `[6, 2]`。改成 `sorted(C.elements())` 就 AC 了。

## 正確解法

```python
class Solution:
    def relativeSortArray(self, arr1: List[int], arr2: List[int]) -> List[int]:
        cnt = Counter(arr1)
        res = []
        for x in arr2:
            res += [x] * cnt.pop(x)
        for x in sorted(cnt):
            res += [x] * cnt[x]
        return res
```

## 複雜度

時間 `O(n + k log k)`，空間 `O(n)`。

## 要特別避免的錯誤

- 剩下的數要由小到大，不是按出現次數。
- 剩下的數要保留重複的次數。

## 面試口說整理

我先計數，照 arr2 的順序把每個值輸出它出現的次數，再把剩下的值由小到大、連同次數接在後面。時間 `O(n + k log k)`。
