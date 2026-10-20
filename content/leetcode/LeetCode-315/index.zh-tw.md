---
title: "LeetCode 315: Count of Smaller Numbers After Self"
summary: "LeetCode 315 解題筆記：帶 index 的 merge sort，以及 BIT 解法"
description: "2026-10-18 merge sort 練習梯子的 LeetCode 315 紀錄"
date: 2026-10-18
tags: ["hard", "merge-sort", "divide-and-conquer", "binary-indexed-tree", "counting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-10-18
來源：Merge sort 練習梯子，第 2 階

## 解題思路

跟 LCR 170 的差別是：這題要**每個元素各自**的答案，不只是總數。

- 排序後元素位置會變，所以要把 `(值, 原 index)` 一起排，才知道要加到答案的哪一格。
- 計數的對象是左邊的元素，所以要在 merge **取出左邊元素時**計數。此時右半已經取走的 `j - mid` 個元素都比它嚴格小，而且在原陣列裡都在它右邊。

## 我的第一版

```python
sorted_nums = [(nums[i], i) for i in range(n)]
...
            if j >= high or (i < mid and sorted_nums[i][0] <= sorted_nums[j][0]):
                tmp[k] = sorted_nums[i]
                i += 1
            else:
                tmp[k] = sorted_nums[i]      # 應該是 sorted_nums[j]
                j += 1
...
        return [index for _, index in sorted_nums]   # 回傳的不是計數
```

## 檢討

1. **`else` 取錯元素**：跟 LC 912 的 `temp[i]` 同一類 bug。`j += 1` 的分支要搭配 `[j]`。
2. **少了計數**：方向對了，帶 index 一起排是關鍵，但還沒開始數。
3. **回傳值錯**：回傳的是排序後的原 index，要另外開 `res = [0] * n`。

跟 LCR 170 對照：

| | LCR 170 | LC 315 |
|---|---|---|
| 問的是 | 總共有幾對 | 每個元素右邊有幾個比它小 |
| 什麼時候算 | 取**右邊**時 | 取**左邊**時 |
| 加多少 | `mid - i` | `j - mid` |

記法：**算誰的答案，就在取出誰的時候計數。**

## 正確解法

```python
class Solution:
    def countSmaller(self, nums: list[int]) -> list[int]:
        n = len(nums)
        sorted_nums = [(nums[i], i) for i in range(n)]
        tmp = [(0, 0)] * n
        res = [0] * n

        def mergeAndSort(low: int, high: int):
            if high - low <= 1:
                return

            mid = (low + high) // 2
            mergeAndSort(low, mid)
            mergeAndSort(mid, high)

            i, j, k = low, mid, low
            while i < mid or j < high:
                if j >= high or (i < mid and sorted_nums[i][0] <= sorted_nums[j][0]):
                    res[sorted_nums[i][1]] += j - mid    # 右半已經取走的，都比它小
                    tmp[k] = sorted_nums[i]
                    i += 1
                else:
                    tmp[k] = sorted_nums[j]
                    j += 1
                k += 1

            sorted_nums[low:high] = tmp[low:high]

        mergeAndSort(0, n)
        return res
```

`tmp = [(0, 0)] * n` 沒問題，因為 tuple 不可變，不會有 DP 表共用同一列的問題。

### BIT 解法

從右往左掃，查「已經看過的數裡有幾個比它小」，再把自己加進 BIT。值域只有 `-10^4 ~ 10^4`，平移成正數就能當 index，不用離散化：

```python
class Solution:
    def countSmaller(self, nums: list[int]) -> list[int]:
        OFFSET = 10**4 + 1                 # 把 -1e4..1e4 平移到 1..20001
        size = 2 * 10**4 + 1
        bit = [0] * (size + 1)

        def add(i):
            while i <= size:
                bit[i] += 1
                i += i & -i

        def query(i):                      # 值在 1..i 的個數
            s = 0
            while i > 0:
                s += bit[i]
                i -= i & -i
            return s

        res = [0] * len(nums)
        for idx in range(len(nums) - 1, -1, -1):
            v = nums[idx] + OFFSET
            res[idx] = query(v - 1)        # 嚴格小於
            add(v)
        return res
```

## 複雜度

| 解法 | 時間 | 空間 |
|---|---|---|
| Merge sort | `O(n log n)` | `O(n)` |
| BIT | `O(n log U)`，`U` 是值域 | `O(U)` |
| 暴力 | `O(n^2)` | `n = 10^5` 時 TLE |

`bisect.insort` 維護有序 list 在 Python 會 AC，但插入是 `O(n)`，面試不能說它是最佳解。

## 要特別避免的錯誤

- 排序後忘記元素已經不在原位，沒帶 index。
- 在 `else` 分支計數：那是 LCR 170 的做法，這題要在取左邊時算。
- 用 `<`：相等的值會被算成「比它小」。

## 面試口說整理

我把 `(值, 原 index)` 一起做 merge sort。merge 時取出左邊的元素，代表右半已經取走的 `j - mid` 個元素都嚴格比它小，而且原本都在它右邊，所以把這個數加到它原 index 的答案上。相等時先取左邊，避免把相等的值算進去。時間 `O(n log n)`，空間 `O(n)`。另一種解法是從右往左掃，用 BIT 查比它小的個數。
