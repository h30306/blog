---
title: "LeetCode 278: First Bad Version"
summary: "LeetCode 278 解題筆記：找第一個 isBadVersion 為 True 的版本，lower bound 二分；呼叫 API 的次數是 O(log n)"
description: "2022-08-23 的 LeetCode 278 解題紀錄"
date: 2022-08-23
tags: ["easy", "binary-search", "interactive"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-23
- 提交紀錄：Accepted ×3

## 解題思路

壞掉之後的版本都是壞的，`isBadVersion` 從某個版本開始一直是 `True`，找第一個（[Binary Search]({{< relref "/algorithm/Binary-Search" >}}) 模板一）：`mid` 是壞的就 `r = mid`，否則 `l = mid + 1`。

## 我的解法

```python
class Solution:
    def firstBadVersion(self, n: int) -> int:
        l, r = 1, n
        while l < r:
            mid = (l + r) // 2
            if isBadVersion(mid):
                r = mid
            else:
                l = mid + 1
        return l
```

## 複雜度

時間 `O(log n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 壞的版本可能就是第一個，`r = mid` 而不是 `mid - 1`。

## 面試口說整理

壞版本之後都是壞的，所以我用 lower bound 二分：中間是壞的就把右界縮到中間，否則左界移到中間的下一個。時間 `O(log n)`。
