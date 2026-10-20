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
