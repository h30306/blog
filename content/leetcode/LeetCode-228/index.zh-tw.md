---
title: "LeetCode 228: Summary Ranges"
summary: "LeetCode 228 解題筆記：掃一次，和前一個數連續就延長目前的區間，否則開一個新的區間，最後轉成字串"
description: "2022-08-21 的 LeetCode 228 解題紀錄"
date: 2022-08-21
tags: ["easy", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-21
- 提交紀錄：Runtime Error ×3 → Wrong Answer ×4 → Runtime Error ×2 → Accepted ×4 → Runtime Error → Accepted

## 解題思路

維護一個區間的 list：新的數 `x` 如果等於最後一個區間的結尾加一，就延長那個區間；否則新開一個 `[x, x]`。最後把 `a == b` 的區間寫成 `"a"`，其他寫成 `"a->b"`。這樣不用特別處理最後一段，也不用處理空陣列。

## 我的嘗試

這題提交了 15 次：

- 前幾版只在「和下一個數差超過 1」時輸出區間，**最後一段永遠沒輸出**，空陣列還回傳 `None`：`[3]` 回傳 `[]`。
- 改成用 index 處理最後一個元素之後，又一直存取 `nums[i + 1]` 超出範圍。
- 先 AC 的是一個特判很多的版本；最後重寫成「接得上就延長最後一個區間」，邊界問題就都不見了。

## 正確解法

```python
class Solution:
    def summaryRanges(self, nums: List[int]) -> List[str]:
        ranges = []
        for x in nums:
            if ranges and ranges[-1][1] == x - 1:
                ranges[-1][1] = x
            else:
                ranges.append([x, x])
        return [str(a) if a == b else f"{a}->{b}" for a, b in ranges]
```

## 複雜度

時間 `O(n)`，空間 `O(n)`（輸出）。

## 要特別避免的錯誤

- 最後一段要輸出。
- 空陣列回傳空 list，不是 `None`。
- 只有一個數的區間寫成 `"a"`。

## 面試口說整理

我掃一次，維護區間的 list，新的數接得上最後一個區間就延長，否則開新的區間，最後把每個區間轉成字串。時間 `O(n)`。
