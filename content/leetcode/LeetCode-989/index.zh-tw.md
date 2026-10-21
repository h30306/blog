---
title: "LeetCode 989: Add to Array-Form of Integer"
summary: "LeetCode 989 解題筆記：把 k 當成進位，從陣列最後一位往前加，k 還沒用完就繼續往前補位"
description: "2022-09-26 的 LeetCode 989 解題紀錄"
date: 2022-09-26
tags: ["easy", "array", "math"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-09-26
- 提交紀錄：Runtime Error ×2 → Wrong Answer → Runtime Error → Accepted

## 解題思路

直式加法的技巧（[Math]({{< relref "/algorithm/Math" >}}) 模板六）：把整個 `k` 當成進位，從最後一位開始 `k += num[i]`，這一位是 `k % 10`，剩下的 `k //= 10` 繼續往前。陣列走完 `k` 還有剩，就把 `k` 的位數補在前面。

## 我的嘗試

跟 LC 66 一樣，第一次是「轉成整數加 `k` 再拆回來」：`''.join(num)` 的元素是整數（TypeError），之後用 `str(...).split()` 拆，**`split` 只會得到一個元素**：`[0]`、`22` 回傳 `[22]`，答案 `[2, 2]`。改成 `list(str(...))` 就 AC 了。

## 正確解法

```python
class Solution:
    def addToArrayForm(self, num: List[int], k: int) -> List[int]:
        res = []
        i = len(num) - 1
        while i >= 0 or k:
            if i >= 0:
                k += num[i]
                i -= 1
            res.append(k % 10)
            k //= 10
        return res[::-1]
```

## 複雜度

時間 `O(max(n, log k))`，空間 `O(max(n, log k))`。

## 要特別避免的錯誤

- `k` 可能比陣列表示的數還長，陣列走完之後要繼續處理 `k`。
- 回傳數字的 list，不是字串切出來的一個元素。

## 面試口說整理

我把 k 整個當成進位，從陣列最後一位往前加，每次取個位數放進答案、剩下的繼續進位，陣列走完 k 還有剩就繼續補位，最後反轉。時間 `O(max(n, log k))`，不用把陣列轉成大整數。
