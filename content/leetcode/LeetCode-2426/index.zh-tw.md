---
title: "LeetCode 2426: Number of Pairs Satisfying Inequality"
summary: "LeetCode 2426 解題筆記：先化簡式子，再判斷符合的是前綴還是後綴"
description: "2026-10-19 merge sort 練習梯子的 LeetCode 2426 紀錄"
date: 2026-10-19
tags: ["hard", "merge-sort", "divide-and-conquer", "two-pointers", "counting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-10-19
來源：Merge sort 練習梯子，第 5 階

## 解題思路

條件是 `nums1[i] - nums1[j] <= nums2[i] - nums2[j] + diff`，`i < j`。把同一個 index 的項移到同一邊：

```text
(nums1[i] - nums2[i]) - (nums1[j] - nums2[j]) <= diff
令 d = nums1 - nums2
d[i] - d[j] <= diff
```

化簡完就是對 `d` 做 merge sort 計數，跟 LC 493 一樣先掃再合併。

## 我的第一版

化簡是對的，計數迴圈直接照搬 LC 493：

```python
j = mid
for i in range(low, mid):
    while j < high and nums[i] - nums[j] >= diff:   # 條件寫反
        j += 1
    count += j - mid                                # 數錯邊
```

## 檢討

1. **不等式方向寫反**：題目要的是 `<= diff`，寫成了 `>= diff`。
2. **符合的 `j` 是後綴，不是前綴**：把條件改寫成跟 `j` 有關的形式：

```text
d[i] - d[j] <= diff  ⟺  d[j] >= d[i] - diff
```

右半遞增，`d[j]` 要夠大才符合，所以是右半的**後綴**，個數是 `high - j`。LC 493 是 `nums[j]` 要夠小，所以是前綴。

用 `nums1 = [3,2,5]`、`nums2 = [2,2,1]`、`diff = 1` 驗證：`d = [1, 0, 4]`，三個 pair 都符合，答案是 3；第一版只數到 1。

**寫計數迴圈之前先問：把條件改寫成 `d[j] ? 某個值` 之後，符合的 `j` 是前綴還是後綴？**

| 改寫後的條件 | 右半遞增時，符合的 `j` | 計數 |
|---|---|---|
| `d[j] < X` 或 `d[j] <= X` | 前綴 | `j - mid` |
| `d[j] > X` 或 `d[j] >= X` | 後綴 | `high - j` |

## 正確解法

```python
class Solution:
    def numberOfPairs(self, nums1: list[int], nums2: list[int], diff: int) -> int:
        # d[i] - d[j] <= diff  ⟺  d[j] >= d[i] - diff
        n = len(nums1)
        nums = [nums1[i] - nums2[i] for i in range(n)]

        def mergeAndSort(low: int, high: int) -> int:
            if high - low <= 1:
                return 0

            mid = (low + high) // 2
            count = mergeAndSort(low, mid) + mergeAndSort(mid, high)

            j = mid
            for i in range(low, mid):
                while j < high and nums[i] - nums[j] > diff:   # 跳過不符合的
                    j += 1
                count += high - j                              # 剩下的都符合

            nums[low:high] = sorted(nums[low:high])
            return count

        return mergeAndSort(0, n)
```

`i` 往右時 `d[i]` 變大，門檻 `d[i] - diff` 也變大，要跳過的部分只會變多，所以 `j` 不回頭。

## 複雜度

時間 `O(n log n)`，空間 `O(n)`。`sorted()` 在兩段已排序的 run 上接近線性；面試官可能會要求手寫 merge。

## 要特別避免的錯誤

- 沒有先把條件改寫成「`d[j]` 跟某個值比較」，就直接套前一題的計數方式。
- 化簡時把 `i` 和 `j` 的項放錯邊。

## 面試口說整理

我先把同一個 index 的項移到同一邊，令 `d = nums1 - nums2`，條件就變成 `d[i] - d[j] <= diff`，也就是 `d[j] >= d[i] - diff`。接著對 `d` 做 merge sort 計數：兩半排序後，對左半的每個 `d[i]`，右半符合條件的是一段後綴，用一個只往前走的指針找到起點，加上 `high - j`。時間 `O(n log n)`，空間 `O(n)`。
