---
title: "LeetCode 189: Rotate Array"
summary: "LeetCode 189 解題筆記：先 k %= n，再用三次反轉：整個反轉、前 k 個反轉、後 n - k 個反轉；O(1) 額外空間"
description: "2022-11-11 的 LeetCode 189 解題紀錄"
date: 2022-11-11
tags: ["medium", "array", "math", "two-pointers"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-11-11
- 提交紀錄：Wrong Answer ×3 → Accepted → Wrong Answer → Accepted

## 解題思路

往右轉 `k` 格等於把最後 `k` 個搬到前面。`k` 可能比長度大，先 `k %= n`。不用額外陣列的做法是三次反轉（[Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) 模板一）：

1. 整個反轉：最後 `k` 個跑到前面，但順序是反的。
2. 前 `k` 個反轉回來。
3. 後 `n - k` 個反轉回來。

## 我的嘗試

前幾版用切片，沒有先對 `k` 取餘數：`k` 比長度大時切錯了，例如 `[7, 8]`、`k = 7` 回傳 `[7, 8]`，答案 `[8, 7]`；有一版用 `n % k`，`k = 0` 時除以 0。

## 正確解法

```python
class Solution:
    def rotate(self, nums: List[int], k: int) -> None:
        def rev(l, r):
            while l < r:
                nums[l], nums[r] = nums[r], nums[l]
                l, r = l + 1, r - 1
        n = len(nums)
        k %= n
        rev(0, n - 1)
        rev(0, k - 1)
        rev(k, n - 1)
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- `k` 要先對長度取餘數。
- 用切片 `nums[-k:]` 時，`k = 0` 會變成整個陣列。

## 面試口說整理

我先把 `k` 對長度取餘數，再整個反轉、前 `k` 個反轉、後面的反轉，就完成右轉。時間 `O(n)`、額外空間 `O(1)`。
