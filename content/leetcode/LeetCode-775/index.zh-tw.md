---
title: "LeetCode 775: Global and Local Inversions"
summary: "LeetCode 775 解題筆記：把計數問題轉成存在性問題，O(n) 解決"
description: "2026-10-20 merge sort 練習梯子的 LeetCode 775 紀錄"
date: 2026-10-20
tags: ["medium", "array", "math"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-10-20
來源：Merge sort 練習梯子的延伸題，練「什麼時候不用 merge sort」

## 解題思路

`nums` 是 `0 ~ n-1` 的排列。global inversion 是一般的逆序對，local inversion 是相鄰的逆序對。兩者數量相等就回傳 `true`。

Baseline：用 merge sort 算 global、掃一遍算 local，`O(n log n)`。

關鍵觀察：**local inversion 一定也是 global inversion**，所以 local 是 global 的子集：

```text
global = local ∪ { 距離 >= 2 的逆序對 }
```

數量相等 ⟺ **不存在** `j >= i + 2` 且 `nums[i] > nums[j]` 的 pair。

題目從「數兩個數量再比較」變成「檢查一種 pair 存不存在」。固定 `j`，只要知道 `nums[0..j-2]` 的最大值有沒有比 `nums[j]` 大，這個最大值可以邊掃邊維護。

## 我的第一版

```python
local_inversions = 0
for i in range(n - 1):
    if nums[i] > nums[i + 1]:
        local_inversions += 1

mx = -1
for i in range(2, n):
    mx = max(mx, nums[i - 2])
    if nums[i - 2] > nums[i]:      # 應該比較 mx
        return False
return True
```

## 檢討

- **算了 `mx` 卻沒用到**：只比較 `nums[i - 2]`，漏掉距離 3 以上的元素。反例 `[2, 0, 3, 1]`：(2, 1) 是距離 3 的逆序對，正確答案是 `false`，這版回傳 `true`。
- **`local_inversions` 是多餘的**：這個解法的重點就是不需要計數。
- **`n == 1` 的特判也是多餘的**：`range(2, n)` 在 `n <= 2` 時是空的。

**寫完掃一遍：每個算出來的變數，後面都有被用到嗎？**

## 正確解法

```python
class Solution:
    def isIdealPermutation(self, nums: list[int]) -> bool:
        mx = -1                          # max(nums[0..i-2])
        for i in range(2, len(nums)):
            mx = max(mx, nums[i - 2])
            if mx > nums[i]:
                return False             # 找到距離 >= 2 的逆序對
        return True
```

### 另一種解法：每個元素離本位最多 1 格

討論區常見的寫法：

```python
class Solution:
    def isIdealPermutation(self, nums: list[int]) -> bool:
        return all(abs(x - i) <= 1 for i, x in enumerate(nums))
```

符合條件的排列，等於從 `[0, 1, ..., n-1]` 出發，做幾次**相鄰且互不重疊**的交換。只要有元素離本位 2 格以上，它就一定「跳過」了某個元素，形成距離 >= 2 的逆序對。

這個解法**依賴「是排列」的條件**，換成任意整數陣列就失效。前綴最大值的解法不依賴。

## 複雜度

兩種解法都是時間 `O(n)`、空間 `O(1)`。

## 要特別避免的錯誤

- 看到逆序對就直接用 merge sort，沒有先看題目問的是「有幾個」還是「相不相等」。
- 維護了變數卻比較錯對象。

## 面試口說整理

相鄰的逆序對一定也是逆序對，所以 local 是 global 的子集。兩者相等，等價於不存在距離至少 2 的逆序對。我從左往右掃，維護 `nums[0..i-2]` 的最大值，只要它大於 `nums[i]` 就回傳 `false`。這樣不需要真的計數，時間 `O(n)`、空間 `O(1)`，而且不依賴輸入是排列。
