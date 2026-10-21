---
title: "LeetCode 3688: Bitwise OR of Even Numbers in an Array"
summary: "LeetCode 3688 解題筆記：只對偶數做 OR；初始值 0 剛好也是「沒有偶數」時的答案"
description: "2025-09-21 的 LeetCode 3688 解題紀錄"
date: 2025-09-21
tags: ["easy", "bit-manipulation", "array", "simulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2025-09-21
- 提交紀錄：Accepted（一次通過）

## 解題思路

偶數的最低位是 0，挑出來全部 OR 起來（[Bit Manipulation]({{< relref "/algorithm/Bit-Manipulation" >}}) 模板一）。OR 的初始值是 0，沒有偶數時不會被改到，剛好就是題目要的 0。

## 我的解法

```python
class Solution:
    def evenNumberBitwiseORs(self, nums: List[int]) -> int:
        res = 0
        for x in nums:
            if x % 2 == 0:
                res |= x
        return res
```

我當時先過濾、再特判空的情況；初始值用 0 就不需要特判。

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- OR 的單位元素是 0，AND 的是 -1，不要用錯。

## 面試口說整理

我只對偶數做 OR，初始值 0；沒有偶數時結果自然是 0。時間 `O(n)`。
