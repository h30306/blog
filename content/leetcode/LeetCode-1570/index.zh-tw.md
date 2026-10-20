---
title: "LeetCode 1570: Dot Product of Two Sparse Vectors"
summary: "LeetCode 1570 解題筆記：只存非零的 (index, value)，內積時用雙指針合併兩個依 index 排序的列表，index 相同才相乘"
description: "2026-02-10 的 LeetCode 1570 解題紀錄"
date: 2026-02-10
tags: ["medium", "two-pointers", "design", "hash-table", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-02-10
- 提交紀錄：Accepted（一次通過）

## 解題思路

稀疏向量大部分是 0，只存非零的 `(index, value)`。依 index 順序建立，列表本身就是排序的。

內積只有兩邊 index 相同的地方有貢獻，用雙指針合併：

- index 相同：相乘加進答案，兩個都前進。
- 否則 index 比較小的那個前進（另一邊在這個位置是 0）。

**Follow-up：只有一邊是稀疏的**：對稀疏的那邊逐一走過，在另一邊用二分搜尋找相同的 index（或直接用陣列 / 雜湊表查），時間 `O(k log m)`，`k` 是稀疏那邊的非零數量。

## 我的嘗試

我 AC 的版本直接存整個陣列、用 `zip` 相乘，每次是 `O(n)`，沒有用到「稀疏」這個條件。面試時這題就是要考怎麼存、怎麼合併，所以改成只存非零元素。

## 正確解法

```python
class SparseVector:
    def __init__(self, nums: List[int]):
        self.pairs = [(i, x) for i, x in enumerate(nums) if x != 0]

    def dotProduct(self, vec: "SparseVector") -> int:
        a, b = self.pairs, vec.pairs
        i = j = 0
        res = 0
        while i < len(a) and j < len(b):
            if a[i][0] == b[j][0]:
                res += a[i][1] * b[j][1]
                i += 1
                j += 1
            elif a[i][0] < b[j][0]:
                i += 1
            else:
                j += 1
        return res
```

另一種常見寫法是存成 `{index: value}` 的雜湊表，對比較小的那個字典逐一查另一個。雜湊表寫起來比較短；雙指針版本不需要雜湊，只靠依 index 排序的列表。

## 複雜度

建立 `O(n)`，內積 `O(k1 + k2)`（兩邊非零的數量），空間 `O(k)`。

## 要特別避免的錯誤

- 直接存整個陣列：沒用到稀疏的特性。
- index 不同時移動錯的指針：要移動 index 比較小的。

## 面試口說整理

我只存非零元素的 `(index, value)`，依 index 排序。內積時用雙指針合併兩個列表，index 相同才相乘，否則移動 index 比較小的那個。時間是兩邊非零數量的總和。如果只有一邊稀疏，就走稀疏那邊，在另一邊用二分搜尋或直接索引查。
