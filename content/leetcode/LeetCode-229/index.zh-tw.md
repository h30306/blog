---
title: "LeetCode 229: Majority Element II"
summary: "LeetCode 229 解題筆記：超過 n / 3 的數最多兩個；Boyer-Moore 維護兩個候選人，最後再掃一次確認次數"
description: "2022-11-12 的 LeetCode 229 解題紀錄"
date: 2022-11-12
tags: ["medium", "array", "hash-table", "sorting", "counting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-11-12
- 提交紀錄：Accepted ×2

## 解題思路

超過 `n / 3` 次的數最多只有兩個。Boyer-Moore 的推廣：維護兩個候選人和各自的票數，遇到其中一個就加票；遇到別的數時，有空位就換成它，否則兩個候選人**各減一票**（三個不同的數互相抵消）。最後候選人不一定真的超過 `n / 3`，要再數一次確認。用雜湊表計數也可以（[Hash Table]({{< relref "/algorithm/Hash-Table" >}}) 模板一），但不是 `O(1)` 空間。

## 我的嘗試

兩次都一次 AC，當時是先排序，用兩個指標數每一段相同的數有幾個，超過 `n // 3` 就加入答案，`O(n log n)`，沒有用投票法。

## 正確解法

```python
class Solution:
    def majorityElement(self, nums: List[int]) -> List[int]:
        c1, c2, n1, n2 = None, None, 0, 0
        for x in nums:
            if x == c1:
                n1 += 1
            elif x == c2:
                n2 += 1
            elif n1 == 0:
                c1, n1 = x, 1
            elif n2 == 0:
                c2, n2 = x, 1
            else:
                n1, n2 = n1 - 1, n2 - 1
        return [c for c in (c1, c2) if c is not None and nums.count(c) > len(nums) // 3]
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 先判斷是不是其中一個候選人，再判斷有沒有空位，不然同一個數可能佔兩個位置。
- 最後一定要再數一次。

## 面試口說整理

超過三分之一的數最多兩個，所以我維護兩個候選人和票數，遇到其他數時兩個都減一票，等於三個不同的數互相抵消，最後再數一次確認是否超過三分之一。時間 `O(n)`、空間 `O(1)`。
