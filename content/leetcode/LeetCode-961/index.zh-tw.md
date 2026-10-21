---
title: "LeetCode 961: N-Repeated Element in Size 2N Array"
summary: "LeetCode 961 解題筆記：其他 n 個數都不同，所以第一個出現第二次的數就是答案"
description: "2022-09-26 的 LeetCode 961 解題紀錄"
date: 2022-09-26
tags: ["easy", "array", "hash-table", "pigeonhole-principle"]
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
- 提交紀錄：Accepted ×3

## 解題思路

長度 `2n` 的陣列有 `n + 1` 種數，其中一個出現 `n` 次，其他都只出現一次。所以邊掃邊放進集合，**第一個重複的數**就是答案（[Hash Table]({{< relref "/algorithm/Hash-Table" >}})）。`O(1)` 空間的做法：重複 `n` 次的數一定會在某個距離 3 以內的位置對上自己。

## 我的解法

```python
class Solution:
    def repeatedNTimes(self, nums: List[int]) -> int:
        seen = set()
        for x in nums:
            if x in seen:
                return x
            seen.add(x)
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 只有答案會重複，所以不用真的數到 `n` 次。

## 面試口說整理

其他數都只出現一次，所以第一個出現第二次的數就是答案，我邊掃邊放進集合。時間 `O(n)`。
