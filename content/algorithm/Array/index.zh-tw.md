---
title: "Array 陣列掃描"
summary: "相鄰比較與走過單調段（上坡、下坡、山峰與山谷）、一次掃描維護前綴 / 後綴的最大值與總和、小範圍枚舉配對，以及用 tuple 當 key 處理平手"
description: "演算法學習"
date: 2026-10-21
tags: ["array", "simulation", "enumeration"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 介紹

很多陣列題只需要掃一次，重點在「掃的時候要記住什麼」：

| 要判斷的東西 | 掃描時記住的 | 例子 |
|---|---|---|
| 形狀（遞增、遞減、山峰） | 目前在第幾段、上一個不同的方向 | 三段式陣列、山峰與山谷 |
| 連續的一段 | 目前這段的長度 | 最長的費氏子陣列、遞增的後綴 |
| 跟左邊或右邊全部比較 | 前綴最大值、後綴總和 | 比左邊全部都大、比右邊平均大 |
| 最多改一次 | 已經用掉的次數，和改哪一個 | 改一個數讓陣列不遞減 |

需要「任意一段區間」的總和時，見 [Prefix Sum]({{< relref "/algorithm/Prefix-Sum" >}})。

## 模板一：走過單調段

用一個 index 一段一段往前走，每段走完檢查長度：

```python
i, n = 0, len(nums)
while i + 1 < n and nums[i] < nums[i + 1]:   # 上坡
    i += 1
p = i
while i + 1 < n and nums[i] > nums[i + 1]:   # 下坡
    i += 1
q = i
while i + 1 < n and nums[i] < nums[i + 1]:   # 再上坡
    i += 1
ok = 0 < p < q < n - 1 and i == n - 1
```

- **三段式陣列**（LC 3637）：上面的程式，三段都要非空，而且要剛好走到最後。
- **雙調陣列的兩邊總和**（LC 3909）：走到山頂，左右兩邊各自加總（山頂兩邊都算，比大小時可以都不算）。
- **最短要刪的前綴**（LC 3818）：從右邊往左走，最長的嚴格遞增後綴之前都要刪。
- **最長的費氏子陣列**（LC 3708）：`nums[i] == nums[i-1] + nums[i-2]` 就延長，否則長度回到 2。
- **山峰與山谷**（LC 2210）：相等的鄰居當成同一點，只記「上一個不同的方向」，方向從上變下是山峰、從下變上是山谷。
- **環狀陣列的相鄰差**（LC 3423）：別忘了最後一個和第一個也相鄰。

## 模板二：最多改一次

```python
changed = False
for i in range(1, len(nums)):
    if nums[i] < nums[i - 1]:
        if changed:
            return False
        changed = True
        if i >= 2 and nums[i] < nums[i - 2]:
            nums[i] = nums[i - 1]        # 只能把 nums[i] 拉高
        # 否則把 nums[i - 1] 降下來就好，不影響後面
return True
```

只數「下降了幾次」不夠：`[3, 4, 1, 2]` 只有一次下降，但不管改 4 還是改 1 都不行（LC 665）。

## 模板三：跟左邊或右邊全部比較

「比左邊所有元素都大」就是「比前綴最大值大」，「比右邊的平均大」就是用後綴總和：

```python
best = float("-inf")
for i, x in enumerate(nums):             # 左往右：前綴最大值
    if x > best:
        ...                              # x 比左邊全部都大
    best = max(best, x)

suffix = 0
for i in range(n - 1, -1, -1):           # 右往左：後綴總和
    cnt = n - 1 - i                      # 右邊有幾個
    if cnt and nums[i] * cnt > suffix:   # 用乘法比較平均，避免浮點數
        ...
    suffix += nums[i]
```

- **比左邊全部大或比右邊全部大**（LC 3912）：兩個方向各掃一次，聯集起來照原本順序輸出。
- **比右邊平均大**（LC 3833）：上面的第二段；平均不包含自己。
- **右邊奇偶相反的個數**（LC 3917）：右往左掃，記目前看過幾個奇數、幾個偶數。
- **給完糖果之後是不是最多**（LC 1431）：跟全域最大值比，平手也算。

## 模板四：小範圍枚舉，或用 tuple 處理平手

- **相等而且 `i * j` 能被 `k` 整除的配對**（LC 2176）：`n <= 100`，直接枚舉所有配對；條件是 **index** 的乘積，不是值。
- **最好的塔**（LC 3809）：「品質最大，平手時座標最小」可以寫成一個 key：`(-q, x, y)` 取最小。

## 主要參數說明

- 走單調段時，每段的條件用 `i + 1 < n` 先擋邊界，再比較 `nums[i]` 和 `nums[i + 1]`。
- 比較平均時改成乘法：`a > s / c` 等於 `a * c > s`（`c > 0`）。

## 複雜度

一次或兩次掃描，時間 `O(n)`，空間 `O(1)` 或 `O(n)`。

## 常見錯誤

這些都是我練習時實際寫錯過的：

- **`>` 和 `>=` 搞混**：跟最大值一樣多也算最多（LC 1431）。
- **條件用值而不是 index**：題目要 `i * j` 能被 `k` 整除，我寫成值的乘積（LC 2176）。
- **只數下降次數**：一次下降也可能改不好；邊界 `i + 2` 也超出範圍過（LC 665）。
- **在 `for` 迴圈裡 `return False`**：只試了第一個 `p` 就結束；另一版沒檢查最後一段上坡（LC 3637）。
- **平均用整數除法、而且包含自己**（LC 3833）。

## 相關 LeetCode

- `LC 1431` Kids With the Greatest Number of Candies
- `LC 2176` Count Equal and Divisible Pairs in an Array
- `LC 3423` Maximum Difference Between Adjacent Elements in a Circular Array
- `LC 665` Non-decreasing Array
- `LC 2210` Count Hills and Valleys in an Array
- `LC 3637` Trionic Array I
- `LC 3708` Longest Fibonacci Subarray
- `LC 3809` Best Reachable Tower
- `LC 3818` Minimum Prefix Removal to Make Array Strictly Increasing
- `LC 3909` Compare Sums of Bitonic Parts
- `LC 3912` Valid Elements in an Array
- `LC 3917` Count Indices With Opposite Parity
- `LC 3833` Count Dominant Indices
