---
title: "LeetCode 27: Remove Element"
summary: "LeetCode 27 解題筆記：寫入指標只寫不等於 val 的數，最後回傳寫入的個數"
description: "2022-05-11 的 LeetCode 27 解題紀錄"
date: 2022-05-11
tags: ["easy", "array", "two-pointers"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-05-11
- 提交紀錄：Wrong Answer → Accepted ×3

## 解題思路

寫入指標 `k`（[Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) 模板五）：每個不等於 `val` 的數寫到 `nums[k]`，`k += 1`。前 `k` 個就是保留下來的，順序不重要。

## 我的嘗試

第一版的條件寫成 `v != nums`（拿數字跟整個 list 比），永遠成立，等於沒有刪任何東西，例如 `[2]`、`val = 2` 回傳 1。

## 正確解法

```python
class Solution:
    def removeElement(self, nums: List[int], val: int) -> int:
        k = 0
        for x in nums:
            if x != val:
                nums[k] = x
                k += 1
        return k
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 條件比的是 `val`。

## 面試口說整理

我用寫入指標，把不等於 `val` 的數依序寫到前面，最後回傳寫入的個數。時間 `O(n)`、空間 `O(1)`。
