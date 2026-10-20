---
title: "LeetCode 658: Find K Closest Elements"
summary: "LeetCode 658 解題筆記：雙指針從兩端縮成長度 k，或二分搜尋窗口的起點"
description: "2026-01-25 的 LeetCode 658 解題紀錄"
date: 2026-01-25
tags: ["medium", "two-pointers", "binary-search", "sliding-window"]
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
- 提交紀錄：Accepted（一次通過）

## 解題思路

陣列已排序，所以最接近 `x` 的 `k` 個數一定是**一段連續的區間**。

## 我的解法：雙指針從兩端往內縮

從整個陣列開始，每次比較兩端哪個離 `x` 比較遠，把比較遠的丟掉，直到剩下 `k` 個。距離相同時丟右邊，因為題目規定距離相同時小的數比較近。

```python
class Solution:
    def findClosestElements(self, arr: List[int], k: int, x: int) -> List[int]:
        left, right = 0, len(arr) - 1
        while right - left + 1 > k:
            if abs(arr[right] - x) >= abs(arr[left] - x):
                right -= 1
            else:
                left += 1
        return arr[left:right + 1]
```

原本開頭還有 `x <= arr[0]` 和 `x >= arr[-1]` 的特判，但雙指針本身就能處理這兩種情況，可以拿掉。

## 更快的解法：二分搜尋窗口起點

答案是 `arr[lo:lo + k]`，只要找到起點 `lo`。比較 `arr[mid]` 和 `arr[mid + k]` 誰離 `x` 比較遠：

- `x - arr[mid] > arr[mid + k] - x`：左端比較遠，起點要往右，`lo = mid + 1`。
- 否則起點在 `mid` 或更左邊，`hi = mid`。

```python
class Solution:
    def findClosestElements(self, arr: List[int], k: int, x: int) -> List[int]:
        lo, hi = 0, len(arr) - k
        while lo < hi:
            mid = (lo + hi) // 2
            if x - arr[mid] > arr[mid + k] - x:
                lo = mid + 1
            else:
                hi = mid
        return arr[lo:lo + k]
```

這裡刻意不用 `abs`：用帶號的差值比較，`x` 在兩者外側時也能判斷方向。

## 複雜度

| 解法 | 時間 |
|---|---|
| 雙指針 | `O(n - k)` |
| 二分搜尋 | `O(log(n - k) + k)` |

空間都是 `O(1)`，不算輸出。

## 要特別避免的錯誤

- 平手時丟掉左邊：題目規定平手時值小的優先，所以要丟右邊。
- 二分版用 `abs` 比較：`arr[mid]` 和 `arr[mid + k]` 相等時，`abs` 會讓窗口往錯的方向移。
- 先排序整個陣列依距離挑 `k` 個，再排序回來：`O(n log n)`，沒用到已排序的條件。

## 面試口說整理

陣列已排序，答案一定是一段長度 `k` 的連續區間。最直接的做法是雙指針從兩端往內縮，每次丟掉離 `x` 比較遠的一端，平手時丟右邊，`O(n - k)`。更快的是二分搜尋起點：比較 `x - arr[mid]` 和 `arr[mid + k] - x`，左端比較遠就往右找，時間 `O(log(n - k) + k)`。
