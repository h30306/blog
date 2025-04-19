---
title: "LeetCode 1534: Count Good Triplets"
summary: "LeetCode 解題紀錄"
description: "LeetCode Daily"
date: 2025-04-14
tags: ["LeetCode", "blog", "daily", "easy"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試： 2025-04-14
- 總花費時間：2:00.00

## 解題思路

我們很容易會想到用暴力解法來處理這題。  
由於 `nums` 的範圍相對較小，一個 `O(n^3)` 的解法是可以接受的，不會導致 TLE（Time Limit Exceeded）。

從 Leetcode 討論區看到一個很棒的提示：我們其實不需要三重迴圈遍歷陣列。只要遍歷 `j` 和 `k`，並透過條件去反推出可能的 `i` 值的範圍，搭配前綴和（prefix sum）來加速計算，就能有效求解。這個方法的精髓有兩個：

### 20250419 更新

#### 1. 找出合法的 `arr[i]` 範圍

根據題目的條件：

- `|arr[i] - arr[j]| <= a`
- `|arr[i] - arr[k]| <= c`

我們可以反推出 `arr[i]` 合法值的上下界：

- **最小值**為以下三者的最大值：
  - `arr[j] - a`
  - `arr[k] - c`
  - `0`
  
- **最大值**為以下三者的最小值：
  - `arr[j] + a`
  - `arr[k] + c`
  - `max(arr)`

這樣我們就得到了 `arr[i]` 合法的範圍 `[left, right]`。

---

#### 2. Prefix Sum 的建立方式

與傳統的 prefix sum 從一開始就建立整份陣列不同，這個方法是**在每次遍歷到索引 `j` 時才動態更新 prefix sum**。

為什麼這樣設計？因為題目要求 `i < j`，所以我們只需要統計在 `j` 之前出現過的 `arr[i]` 值。因此，在處理 `(j, k)` 組合時，我們可以直接查 prefix sum 裡有多少值是落在合法的 `arr[i]` 區間內。

舉例來說，若 `arr = [3, 0, 1, 1, 9, 7]`，當 `j = 3`, `k = 0` 時，prefix sum 尚未更新，因此仍是全為 0，因為還沒有任何值加入過。等到處理完所有 `k` 之後，我們會把 `arr[j] = 3` 加入 prefix sum 中，更新如下：
```
ps = [0, 0, 0, 1, 1, 1, 1, 1, 1, 1]
```
接下來在後續的 `(j, k)` 遍歷中，只要計算出 `[left, right]`，就能利用這個 prefix sum 快速查出有多少個 `i` 值是符合條件的。例如某個區間剛好包含數字 `3`，那就代表 `3` 是合法的 `arr[i]` 候選值。

---

這樣的做法能夠有效地將原本暴力解法的時間複雜度從 `O(n^3)` 降低為 `O(n^2)`，大大提升效率。

## 解法

```python
class Solution:
    def countGoodTriplets(self, arr: List[int], a: int, b: int, c: int) -> int:
        res = 0
        n = len(arr)
        for i in range(n):
            for j in range(i+1, n):
                for k in range(j+1, n):
                    if abs(arr[i]-arr[j]) <= a and abs(arr[j]-arr[k]) <= b and abs(arr[i]-arr[k]) <= c:
                        res +=1

        return res
```

### O(n^2)
```python
class Solution:
    def countGoodTriplets(self, arr: List[int], a: int, b: int, c: int) -> int:
        
        # iter j,k and use prefix sum to count i
        limit = max(arr)+1

        n = len(arr)
        ps = [0]*limit
        res = 0

        for j in range(n):
            for k in range(j+1, n):
                if abs(arr[j]-arr[k]) <= b:
                    left = max(arr[j] - a, arr[k] - c, 0)
                    right = min(arr[j] + a, arr[k] + c, limit-1)
                    if left <= right:
                        res += ps[right] - (0 if left == 0 else ps[left-1])

            for idx in range(arr[j], limit):
                ps[idx] += 1

        return res
```


## 學習
這個技巧的關鍵在於動態更新 prefix sum，在遍歷元素的同時即時取得符合條件的數量。

## 遇到的問題
NA