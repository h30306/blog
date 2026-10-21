---
title: "Binary Search 二分搜尋"
summary: "lower / upper bound、對答案二分、第 k 小、整數開根號，以及兩種區間寫法不能混用"
description: "演算法學習"
date: 2026-10-20
tags: ["binary-search", "prefix-sum", "two-pointers"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 介紹

二分搜尋的本質是：**在一個單調的條件上，找到從 False 變成 True 的那個分界點。**

```text
index:     0     1     2     3     4     5
條件:    False False False True  True  True
                             ↑ 要找的位置
```

兩種常見的用法：

1. **在已排序的陣列上找位置**：例如第一個 `>= x` 的 index。
2. **對答案二分**：答案的範圍很大，但可以寫一個 `check(x)` 判斷「答案能不能是 `x`」，而且 `check` 是單調的。

## 模板一：lower bound / upper bound（左閉右開）

我固定用**左閉右開** `[lo, hi)`，搜尋結束時 `lo == hi`，就是答案的位置：

```python
def lower_bound(arr, x):              # 第一個 >= x 的 index
    lo, hi = 0, len(arr)              # hi 是 len(arr)，不是 len(arr) - 1
    while lo < hi:
        mid = (lo + hi) // 2
        if arr[mid] < x:
            lo = mid + 1
        else:
            hi = mid
    return lo

def upper_bound(arr, x):              # 第一個 > x 的 index
    lo, hi = 0, len(arr)
    while lo < hi:
        mid = (lo + hi) // 2
        if arr[mid] <= x:
            lo = mid + 1
        else:
            hi = mid
    return lo
```

Python 內建的 `bisect.bisect_left` 和 `bisect.bisect_right` 就是這兩個函式。

### 主要參數說明：

- **`hi = len(arr)`**：所有元素都比 `x` 小時，答案是 `len(arr)`，所以 `hi` 必須能等於它（LC 3508）。
- **`mid = (lo + hi) // 2` 要加括號**：寫成 `lo + hi // 2` 會先算 `hi // 2`（LC 3709）。
- **區間 `[a, b]` 內的個數** = `upper_bound(b) - lower_bound(a)`。

## 模板二：對答案二分

找「讓 `check(x)` 成立的最小 `x`」：

```python
lo, hi = 最小可能的答案, 最大可能的答案
while lo < hi:
    mid = (lo + hi) // 2
    if check(mid):
        hi = mid                      # mid 可行，答案在 mid 或更左邊
    else:
        lo = mid + 1                  # mid 不可行，答案在右邊
return lo
```

### 主要參數說明：

- **確認 `check` 是單調的**：`x` 可行時，所有比 `x` 大的也都可行。
- **上界要夠大**：LC 3824 一開始把上界設成 `max(nums)`，但答案可能超過它。
- **找最大值時反過來**：`check(mid)` 成立就 `lo = mid`，這時 `mid` 要改成 `(lo + hi + 1) // 2`，不然會無限迴圈。或者換成「找第一個不成立的位置再減 1」。

## 模板三：第 k 小，用「≤ mid 的有幾個」二分

不直接找第 k 小的數，而是對答案二分：**第一個讓「`<= mid` 的數量 `>= k`」成立的 `mid`，就是第 k 小。**

```python
lo, hi = 最小值, 最大值
while lo < hi:
    mid = (lo + hi) // 2
    if count_at_most(mid) < k:
        lo = mid + 1
    else:
        hi = mid
return lo
```

LC 719 的 `count_at_most` 用滑動窗口在 `O(n)` 內數出「距離 `<= mid` 的 pair 數」，總共 `O(n log W)`。

## 模板四：整數開 k 次方根

`x ** (1 / k)` 是浮點數運算，會有誤差。要精確的 `floor(n^(1/k))`，用整數二分：

```python
def kth_root_floor(n, k):             # 最大的 x，使得 x ** k <= n
    lo, hi = 0, n + 1
    while lo < hi:
        mid = (lo + hi) // 2
        if mid ** k <= n:
            lo = mid + 1
        else:
            hi = mid
    return lo - 1
```

LC 3932 數 `[l, r]` 內的完全 k 次方數，答案就是 `kth_root_floor(r) - kth_root_floor(l - 1)`。

## 模板五：排序 + 前綴和 + bisect

很多「查詢一個範圍內的總和或個數」的題目，可以先排序、建前綴和，每次查詢用 bisect 找邊界：

```python
pairs = sorted(zip(keys, values))
sorted_keys = [k for k, _ in pairs]
prefix = [0]
for _, v in pairs:
    prefix.append(prefix[-1] + v)

def query(limit):                     # key <= limit 的 value 總和
    return prefix[bisect.bisect_right(sorted_keys, limit)]
```

LC 2838、2300、3709 都是這個模式。

## 模板六：旋轉陣列

切在 `mid`，左右兩半至少有一邊是排序好的，先判斷哪一邊有序，再看目標在不在那一邊：

```python
while l <= r:
    mid = (l + r) // 2
    if nums[mid] == target:
        return mid
    if nums[l] <= nums[mid]:             # 左半有序
        if nums[l] <= target < nums[mid]:
            r = mid - 1
        else:
            l = mid + 1
    else:                                # 右半有序
        if nums[mid] < target <= nums[r]:
            l = mid + 1
        else:
            r = mid - 1
```

- **搜尋**（LC 33）：上面的程式；**有重複值**（LC 81）時 `nums[l] == nums[mid]` 分不出哪邊有序，只能 `l += 1`。
- **找最小值**（LC 153）：拿 `nums[mid]` 跟 `nums[r]` 比，比較大就 `l = mid + 1`，否則 `r = mid`；**有重複值**（LC 154）時相等就 `r -= 1`。
- **山峰**（LC 162）：`nums[mid] < nums[mid + 1]` 代表右邊一定有山峰。
- **配對中落單的那個**（LC 540）：在它之前每一對都從偶數 index 開始。

## 兩種區間寫法不能混用

| | 左閉右開 `[lo, hi)` | 左閉右閉 `[lo, hi]` |
|---|---|---|
| 初始 `hi` | `len(arr)` | `len(arr) - 1` |
| 迴圈條件 | `while lo < hi` | `while lo <= hi` |
| 往左縮 | `hi = mid` | `hi = mid - 1` |
| 往右縮 | `lo = mid + 1` | `lo = mid + 1` |

**挑一種固定用。** LC 1292 原本用左閉右閉的寫法 AC，改成 `while lo < hi` 卻沒有同時改 `hi = mid - 1`，就 WA 了。

## 複雜度

- 在長度 `n` 的陣列上二分：`O(log n)`。
- 對答案二分：`O(log(答案範圍) × check 的成本)`。

## 常見錯誤

這些都是我練習時實際寫錯過的：

- **`mid = left + right // 2`**：運算子優先順序，少了括號（LC 3709）。
- **`hi = len(arr) - 1` 卻用左閉右開的迴圈**：找不到「插在最後」的位置（LC 3508）。
- **混用兩種區間寫法**：只改了迴圈條件，沒改更新方式（LC 1292）。
- **對答案二分的上界不夠大**（LC 3824）。
- **用浮點數開根號再比較相等**：`64 ** (1/3)` 在 Python 裡是 `3.9999999999999996`，不是 `4.0`（LC 3932）。
- **用浮點數除法算門檻**：`success / spell` 在數字大時可能有誤差，改用整數的 `ceil`（LC 2300）。
- **雙指針的指標往回走**：`j_low = min(i + 1, j_low)` 讓指標每次都被拉回來，變成 `O(n^2)`（LC 1712）。

- **`mid = (l + r) / 2`**：Python 3 的 `/` 得到浮點數，不能當 index（LC 704、74、35）。
- **找最小的可行值時，剛好等於就回傳**：可能還有更小的也可行（LC 875）。
- **旋轉陣列只拿 `nums[mid]` 跟目標比**：要先判斷哪一半有序（LC 33、81）。
- **每次只移一格**：寫成 `l += 1` / `r -= 1` 等於線性搜尋，TLE（LC 981）。
- **用 `start < end` 判斷有沒有找到**：只出現一次時開頭等於結尾（LC 34）。
- **`while l < r` 配 `l = mid`**：`mid` 往下取整時 `l` 不動，無限迴圈（LC 441、34）。

## 相關 LeetCode

- `LC 2300` Successful Pairs of Spells and Potions
- `LC 2838` Maximum Coins Heroes Can Collect
- `LC 3709` Design Exam Scores Tracker
- `LC 3508` Implement Router
- `LC 3814` Maximum Capacity Within Budget
- `LC 1712` Ways to Split Array Into Three Subarrays
- `LC 3639` Minimum Time to Activate String
- `LC 3824` Minimum K to Reduce Array Within Limit
- `LC 1292` Maximum Side Length of a Square with Sum Less than or Equal to Threshold
- `LC 719` Find K-th Smallest Pair Distance
- `LC 3932` Count K-th Roots in a Range
- `LC 327` Count of Range Sum
- `LC 704` Binary Search
- `LC 35` Search Insert Position
- `LC 34` Find First and Last Position of Element in Sorted Array
- `LC 74` Search a 2D Matrix
- `LC 240` Search a 2D Matrix II
- `LC 33` Search in Rotated Sorted Array
- `LC 81` Search in Rotated Sorted Array II
- `LC 153` Find Minimum in Rotated Sorted Array
- `LC 154` Find Minimum in Rotated Sorted Array II
- `LC 162` Find Peak Element
- `LC 875` Koko Eating Bananas
- `LC 275` H-Index II
- `LC 1337` The K Weakest Rows in a Matrix
- `LC 268` Missing Number
- `LC 367` Valid Perfect Square
- `LC 69` Sqrt(x)
- `LC 888` Fair Candy Swap
- `LC 278` First Bad Version
- `LC 374` Guess Number Higher or Lower
- `LC 441` Arranging Coins
- `LC 287` Find the Duplicate Number
- `LC 981` Time Based Key-Value Store
- `LC 540` Single Element in a Sorted Array
- `LC 744` Find Smallest Letter Greater Than Target
