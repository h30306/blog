---
title: "LeetCode 912: Sort an Array"
summary: "LeetCode 912 解題筆記：手寫 merge sort，以及兩次寫錯的地方"
description: "2026-10-18 merge sort 練習梯子的 LeetCode 912 紀錄"
date: 2026-10-18
tags: ["medium", "sorting", "merge-sort", "divide-and-conquer"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-10-18
來源：Merge sort 練習梯子，第 0 階

## 解題思路

不能用內建排序，要在 `O(n log n)` 內排好。這題不建議用 quick sort：測資有大量重複值和已排序的陣列，pivot 選不好會退化成 `O(n^2)`。Merge sort 最壞也是 `O(n log n)`。

## 我的嘗試

### 第一版：右半邊沒有被排序

```python
mid = (lo + hi) // 2
sort(lo, mid)
sort(mid, lo)        # 應該是 sort(mid, hi)
```

`sort(mid, lo)` 進去時 `hi - lo` 算出來是 `lo - mid`，一定 `<= 0`，直接 return。用 `[5, 2, 3, 1]` 跑會得到 `[2, 3, 1, 5]`。

當時我不懂為什麼「最外層還是有 merge `0:n`」卻會錯。原因是 **merge 只會合併，不會排序**：

- merge 每一步只比較兩邊的隊頭，前提是隊頭就是那半邊的最小值。
- merge 不會改變同一半內部的順序。右半原本 3 在 1 前面，合併後 3 還是在 1 前面。

所以兩半必須先被遞迴排好。另一個角度：如果一次 `O(n)` 的 merge 就能排好任何陣列，比較排序就能做到 `O(n)`，但比較排序的下限是 `O(n log n)`。

### 第二版：merge 時讀錯陣列

```python
temp[k] = temp[i]    # 應該是 nums[i]
temp[k] = temp[j]    # 應該是 nums[j]
```

`temp` 是用來寫入的，從它讀到的是 `0` 或上一次 merge 留下的舊資料。`[5, 2, 3, 1]` 會變成 `[0, 0, 0, 0]`。

規則：merge 時 **`nums` 只讀、`temp` 只寫**，賦值號左右兩邊不應該出現同一個陣列名稱。

## 正確解法

```python
class Solution:
    def sortArray(self, nums: list[int]) -> list[int]:
        n = len(nums)
        temp = [0] * n

        def sort(low: int, high: int):
            if high - low <= 1:
                return

            mid = (low + high) // 2
            sort(low, mid)
            sort(mid, high)

            i, j, k = low, mid, low
            while i < mid or j < high:
                if j >= high or (i < mid and nums[i] <= nums[j]):
                    temp[k] = nums[i]
                    i += 1
                else:
                    temp[k] = nums[j]
                    j += 1
                k += 1

            nums[low:high] = temp[low:high]

        sort(0, n)
        return nums
```

## 複雜度

- 時間 `O(n log n)`：切 `log n` 層，每層 merge 的總工作量是 `O(n)`。遞迴式是 `T(n) = 2T(n/2) + O(n)`。不管輸入長怎樣都會切滿，所以最好情況也是 `O(n log n)`。
- 空間 `O(n)`：`temp` 加上 `O(log n)` 的遞迴深度。

## 要特別避免的錯誤

- 區間寫法混用：左閉右開就統一用 `[low, high)`，終止條件 `high - low <= 1`。
- merge 完忘記抄回 `nums`。
- 每次 merge 都新開 list：還是 `O(n log n)`，但常數大，Python 有機會 TLE。
- 用 `<` 而不是 `<=`：這題不影響結果，但排序會不穩定，之後的計數題會算錯。

## 面試口說整理

我用 merge sort，因為它最壞也是 `O(n log n)`，不像 quick sort 會被重複值或已排序的輸入打到 `O(n^2)`。遞迴把兩半各自排好，再用雙指針合併到暫存陣列，最後抄回原陣列。總共 `log n` 層，每層 `O(n)`，所以時間 `O(n log n)`，空間是 `O(n)` 的暫存陣列。用 `<=` 讓排序保持穩定。
