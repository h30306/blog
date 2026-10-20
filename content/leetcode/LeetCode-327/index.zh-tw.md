---
title: "LeetCode 327: Count of Range Sum"
summary: "LeetCode 327 解題筆記：前綴和 + merge sort 計數，兩個指針卡出區間；重打十幾次的練習紀錄"
description: "2026-08-01 的 LeetCode 327 解題紀錄"
date: 2026-08-01
tags: ["hard", "merge-sort", "divide-and-conquer", "prefix-sum", "binary-indexed-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-08-01
- 提交紀錄：AC（08-01）→ AC ×5（09-01）→ AC ×4（09-27）→ WA ×2 → AC（10-18）→ AC（10-19，改成左閉右開）

## 解題思路

要數有幾個子陣列和落在 `[lower, upper]`。

用前綴和 `P`，子陣列 `[i, j)` 的和是 `P[j] - P[i]`，問題變成：

```text
有幾對 i < j 滿足 lower <= P[j] - P[i] <= upper
```

這是「數 `i < j` 的 pair」的題型，對前綴和陣列做 merge sort 計數：合併兩半之前，對左半的每個 `P[i]`，右半合法的 `P[j]` 是一段連續區間，用兩個只往右走的指針卡出左右邊界。

完整的推導寫在 [Merge Sort 與分治計數]({{< relref "/algorithm/Merge-Sort" >}}) 那篇。

## 我的練習紀錄

這題我重打了很多次：

- **08-01**：第一次寫，用閉區間 `[start, end]` 的寫法，一次 AC。
- **09-01、09-27**：同一份解法又重打、提交了 9 次。
- **10-18**：把參數改名成 `(i, j)`，結果跟迴圈變數 `i` 撞名，連續 WA 兩次：
    - 遞迴寫成 `countAndMergeSort(0, mid)`，左半的起點錯了。
    - 拿掉了 `for i in range(...)` 迴圈，只算了一個 `i`。
- **10-19**：照著 merge sort 練習梯子的寫法，改成左閉右開 `[low, high)`，一次 AC。

**參數名稱不要跟迴圈變數撞名**，這種錯誤不會報錯，只會悄悄算錯。

## 正確解法（左閉右開）

```python
class Solution:
    def countRangeSum(self, nums: List[int], lower: int, upper: int) -> int:
        n = len(nums)
        prefix = [0] * (n + 1)
        for i in range(n):
            prefix[i + 1] = prefix[i] + nums[i]

        def mergeAndSort(low: int, high: int) -> int:
            if high - low <= 1:
                return 0
            mid = (low + high) // 2
            count = mergeAndSort(low, mid) + mergeAndSort(mid, high)

            j1 = j2 = mid
            for i in range(low, mid):
                while j1 < high and prefix[j1] - prefix[i] < lower:
                    j1 += 1                       # 第一個 >= lower 的位置
                while j2 < high and prefix[j2] - prefix[i] <= upper:
                    j2 += 1                       # 第一個 > upper 的位置
                count += j2 - j1

            prefix[low:high] = sorted(prefix[low:high])
            return count

        return mergeAndSort(0, n + 1)
```

注意遞迴範圍是 `[0, n + 1)`：前綴和陣列有 `n + 1` 個元素。

## 另一種解法：BIT + 離散化

從左到右掃前綴和，對每個 `P[j]` 查「前面有幾個 `P[i]` 落在 `[P[j] - upper, P[j] - lower]`」，再把 `P[j]` 加進 BIT。前綴和的值很大，要先離散化，查詢邊界用 `bisect` 換成 rank。

## 複雜度

時間 `O(n log n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 參數名稱跟迴圈變數撞名。
- 遞迴的左半起點寫成 0。
- 前綴和陣列有 `n + 1` 個元素，左閉右開的遞迴範圍是 `[0, n + 1)`。
- 上下界方向寫反：`P[i]` 的範圍是 `[P[j] - upper, P[j] - lower]`，`upper` 在左邊。

## 面試口說整理

我先建前綴和，子陣列和就是兩個前綴和的差，問題變成數 `i < j` 且 `lower <= P[j] - P[i] <= upper` 的 pair。對前綴和做 merge sort：合併前兩半都已排序，對左半每個 `P[i]`，右半合法的 `P[j]` 是一段連續區間，用兩個只往右的指針找出邊界相減。每層 `O(n)`，共 `O(n log n)`。也可以用 BIT 加離散化。
