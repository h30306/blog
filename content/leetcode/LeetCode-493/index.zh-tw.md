---
title: "LeetCode 493: Reverse Pairs"
summary: "LeetCode 493 解題筆記：計數條件和排序條件不同時，先掃再合併"
description: "2026-10-19 merge sort 練習梯子的 LeetCode 493 紀錄"
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
來源：Merge sort 練習梯子，第 3 階

## 解題思路

要數 `i < j` 且 `nums[i] > 2 * nums[j]` 的 pair。

這題的新難點是：**計數條件和排序條件不一樣**，所以不能像 LCR 170 那樣在 merge 的同時計數。例如左邊 `[3]`、右邊 `[2]`：

- 合併判斷 `3 <= 2` 不成立，先取右邊的 2。
- 計數判斷 `3 > 2 * 2 = 4` 也不成立，這不是 reverse pair。

merge 時「先取右邊」不代表「這對要計數」。所以要**先用雙指針單獨掃一遍計數，再合併**。

雙指針成立的原因是兩個單調性：

1. 右半遞增，所以對固定的 `nums[i]`，滿足 `nums[i] > 2 * nums[j]` 的 `j` 是右半的**前綴**。
2. 左半遞增，`i` 往右時 `nums[i]` 變大，這段前綴只會變長，`j` 不需要回頭。

## 我的第一版

這次一次寫對：

```python
class Solution:
    def reversePairs(self, nums: list[int]) -> int:
        n = len(nums)
        tmp = [0] * n
        count = 0

        def mergeAndSort(low: int, high: int):
            nonlocal count
            if high - low <= 1:
                return

            mid = (low + high) // 2
            mergeAndSort(low, mid)
            mergeAndSort(mid, high)

            i, j, k = low, mid, low
            pair = 0
            while i < mid:
                while j < high and nums[i] > 2 * nums[j]:
                    pair += 1
                    j += 1
                count += pair
                i += 1

            i, j, k = low, mid, low
            while i < mid or j < high:
                if j >= high or (i < mid and nums[i] <= nums[j]):
                    tmp[k] = nums[i]
                    i += 1
                else:
                    tmp[k] = nums[j]
                    j += 1
                k += 1

            nums[low: high] = tmp[low: high]

        mergeAndSort(0, n)
        return count
```

可以精簡的地方：`pair` 其實就是 `j - mid`；計數段的 `k` 沒用到。

## 當時的疑問：為什麼一定要 `nonlocal`？

Python 規則：**函式裡只要對某個名字賦值（`=`、`+=`），這個名字在整個函式裡都是 local。**

`count += pair` 等於 `count = count + pair`，int 不可變，所以這是對名字賦值，Python 會把 `count` 當成 local，讀取時出現 `UnboundLocalError`。

`tmp[k] = x` 和 `nums[low:high] = ...` 改的是 list 的內容，沒有對 `tmp`、`nums` 這兩個名字賦值，所以不需要 `nonlocal`。

注意：`lst += [1]` 雖然實際是原地修改，語法上仍然是對名字賦值，一樣會報錯。判斷標準是語法，不是物件有沒有被修改。

## 正確解法（回傳值版本）

```python
class Solution:
    def reversePairs(self, nums: list[int]) -> int:
        n = len(nums)
        tmp = [0] * n

        def mergeAndSort(low: int, high: int) -> int:
            if high - low <= 1:
                return 0

            mid = (low + high) // 2
            count = mergeAndSort(low, mid) + mergeAndSort(mid, high)

            j = mid
            for i in range(low, mid):          # 先掃一遍計數
                while j < high and nums[i] > 2 * nums[j]:
                    j += 1
                count += j - mid

            i, j, k = low, mid, low            # 再合併
            while i < mid or j < high:
                if j >= high or (i < mid and nums[i] <= nums[j]):
                    tmp[k] = nums[i]
                    i += 1
                else:
                    tmp[k] = nums[j]
                    j += 1
                k += 1

            nums[low:high] = tmp[low:high]
            return count

        return mergeAndSort(0, n)
```

## 複雜度

時間 `O(n log n)`：每層計數是 `O(n)`（`j` 只往前走），merge 也是 `O(n)`，共 `log n` 層。空間 `O(n)`。

## 要特別避免的錯誤

- 試圖在 merge 的同時計數：比較條件不同，結果會錯。
- Java/C++ 的 `2 * nums[j]` 會溢位，要轉 `long`。Python 沒有這個問題，但面試時要主動提。

## 面試口說整理

計數條件 `nums[i] > 2 * nums[j]` 和排序用的比較不同，所以每層先用雙指針計數再合併。兩半都已排序，對左半的每個 `nums[i]`，符合條件的 `j` 是右半的前綴，而且 `i` 往右時這段前綴只會變長，所以 `j` 不回頭，計數是 `O(n)`。總時間 `O(n log n)`，空間 `O(n)`。在 Java 要注意 `2 * nums[j]` 溢位。
