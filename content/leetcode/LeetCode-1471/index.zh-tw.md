---
title: "LeetCode 1471: The k Strongest Values in an Array"
summary: "LeetCode 1471 解題筆記：排序後離中位數最遠的一定在兩端，對撞指針每次從兩端挑比較強的那個，挑 k 次"
description: "2026-01-25 的 LeetCode 1471 解題紀錄"
date: 2026-01-25
tags: ["medium", "two-pointers", "sorting", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-25
- 提交紀錄：Wrong Answer → Accepted

## 解題思路

先排序找中位數 `m = arr[(n - 1) // 2]`。強度是 `|arr[i] - m|`，一樣時比較大的值比較強。

排序後，**離 `m` 最遠的一定在兩端**之一。所以用對撞指針，每次比較兩端：

- `m - arr[left] > arr[right] - m`：左端比較強，取左端。
- 否則取右端（距離一樣時右端的值比較大，也是右端比較強）。

取 `k` 次就是答案。

## 我的嘗試

第一版中位數寫成 `arr[n // 2]`，題目定義是 `arr[(n - 1) // 2]`，偶數長度時會差一格。例如 `arr = [2, -5]`、`k = 1`：排序後 `[-5, 2]`，中位數是 `-5`，最強的是 `2`；這版用 `2` 當中位數，回傳 `[-5]`。

## 正確解法

```python
class Solution:
    def getStrongest(self, arr: List[int], k: int) -> List[int]:
        arr.sort()
        m = arr[(len(arr) - 1) // 2]
        left, right = 0, len(arr) - 1
        res = []
        while len(res) < k:
            if m - arr[left] > arr[right] - m:
                res.append(arr[left])
                left += 1
            else:
                res.append(arr[right])            # 距離相同時右端的值比較大
                right -= 1
        return res
```

原本的版本用 `left < right` 當迴圈條件，`k == n` 時最後一個元素另外補；這裡直接用 `len(res) < k`，`left == right` 時兩個分支取到的都是同一個元素。

## 複雜度

時間 `O(n log n)`，空間 `O(1)`（不算輸出和排序）。

## 要特別避免的錯誤

- 中位數的位置用錯：題目是 `(n - 1) // 2`。
- 距離相同時要取值比較大的，也就是右端。

## 面試口說整理

排序後找出中位數，強度是離中位數的距離，最強的一定在兩端之一。我用對撞指針比較兩端，左端距離嚴格比較大就取左端，否則取右端（距離一樣時右端值比較大），取 `k` 次。時間 `O(n log n)`。
