---
title: "LeetCode 868: Binary Gap"
summary: "LeetCode 868 解題筆記：記錄上一個 1 的位置，每遇到新的 1 就算距離取最大值"
description: "2022-09-17 的 LeetCode 868 解題紀錄"
date: 2022-09-17
tags: ["easy", "bit-manipulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-09-17
- 提交紀錄：Runtime Error ×2 → Wrong Answer ×5 → Accepted

## 解題思路

從最低位往上掃（[Bit Manipulation]({{< relref "/algorithm/Bit-Manipulation" >}})），記錄上一個 1 的位置 `last`，遇到新的 1 時距離是 `i - last`，取最大值。只有一個 1 時答案是 0。

## 我的嘗試

前幾版用 `s.split('1')` 找最長的一串 0 再加 1：

- **結尾的 0 也被算進去**，但它們後面沒有 1：`24`（`11000`）回傳 4，答案 1。
- 用 `strip('0')` 去掉結尾之後，**相鄰的 1** 距離是 1，但切出來的空字串長度是 0：`7`（`111`）回傳 0，`5`（`101`）也一直差一。

改成記錄 1 的位置才 AC。

## 正確解法

```python
class Solution:
    def binaryGap(self, n: int) -> int:
        last, best, i = -1, 0, 0
        while n:
            if n & 1:
                if last >= 0:
                    best = max(best, i - last)
                last = i
            n >>= 1
            i += 1
        return best
```

## 複雜度

時間 `O(log n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 距離是兩個 1 的位置差，相鄰的 1 距離是 1，不是 0。
- 結尾的 0 後面沒有 1，不算間隔。

## 面試口說整理

我從最低位往上掃，記錄上一個 1 的位置，每遇到新的 1 就用位置差更新最大值。時間 `O(log n)`、空間 `O(1)`。
