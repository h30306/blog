---
title: "LeetCode 441: Arranging Coins"
summary: "LeetCode 441 解題筆記：找最大的 k 讓 k(k + 1) / 2 <= n；二分時往右更新要寫 l = mid + 1，不然會卡住"
description: "2022-08-24 的 LeetCode 441 解題紀錄"
date: 2022-08-24
tags: ["easy", "math", "binary-search"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-24
- 提交紀錄：Accepted → Time Limit Exceeded → Accepted

## 解題思路

排滿 `k` 列需要 `k(k + 1) / 2` 枚硬幣，隨 `k` 遞增，找最大的 `k` 讓它 `<= n`（[Binary Search]({{< relref "/algorithm/Binary-Search" >}}) 模板二）。閉區間二分，結束時 `r` 是最後一個成立的。

## 我的嘗試

第一次就 AC 了；之後想練二分時寫成 `while l < r` 加上 `l = mid`，`r = l + 1` 時 `mid` 一直等於 `l`，無限迴圈（TLE），例如 `n = 8`。

## 正確解法

```python
class Solution:
    def arrangeCoins(self, n: int) -> int:
        l, r = 0, n
        while l <= r:
            mid = (l + r) // 2
            if mid * (mid + 1) // 2 <= n:
                l = mid + 1
            else:
                r = mid - 1
        return r
```

## 複雜度

時間 `O(log n)`，空間 `O(1)`。也可以直接用公式 `isqrt(8n + 1)`。

## 要特別避免的錯誤

- `while l < r` 配 `l = mid` 時，`mid` 往下取整，`l` 可能永遠不動，無限迴圈。

## 面試口說整理

排滿 `k` 列要 `k(k+1)/2` 枚，所以我二分找最大的 `k` 讓它不超過 `n`。時間 `O(log n)`。
