---
title: "LeetCode 599: Minimum Index Sum of Two Lists"
summary: "LeetCode 599 解題筆記：把 list1 的字串對應到 index，掃 list2 時算兩邊 index 的和，留下和最小的全部字串"
description: "2022-08-28 的 LeetCode 599 解題紀錄"
date: 2022-08-28
tags: ["easy", "array", "hash-table", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-28
- 提交紀錄：Runtime Error ×3 → Wrong Answer ×4 → Accepted → Runtime Error → Accepted ×4

## 解題思路

把 `list1` 存成「字串 → index」的雜湊表（[Hash Table]({{< relref "/algorithm/Hash-Table" >}})），掃 `list2` 時遇到共同的字串就算 index 和。比目前最小的還小就重設答案，相等就加進答案。

## 我的嘗試

這題提交了 13 次：

- 前三版是語法錯誤，第四版忘了 `return`。
- 接下來三版自己維護 `i` 當 index，但**迴圈裡忘了 `i += 1`**，`list1` 的每個字串 index 都是 0：`["c", "e"]`、`["e", "c"]` 兩個的 index 和都是 1，答案 `["c", "e"]`，回傳 `["e"]`。補上就 AC 了。
- 晚上重寫成兩個 dict 的版本時又有一次變數名稱錯誤（NameError）。

## 正確解法

```python
class Solution:
    def findRestaurant(self, list1: List[str], list2: List[str]) -> List[str]:
        pos = {s: i for i, s in enumerate(list1)}
        best, res = float("inf"), []
        for j, s in enumerate(list2):
            if s in pos:
                total = pos[s] + j
                if total < best:
                    best, res = total, [s]
                elif total == best:
                    res.append(s)
        return res
```

## 複雜度

時間 `O(n + m)`，空間 `O(n)`。

## 要特別避免的錯誤

- 自己維護 index 時要記得加一，或直接用 `enumerate`。
- `list.index` 每次 `O(m)`，整體會變 `O(nm)`。

## 面試口說整理

我把第一個 list 的字串對應到 index 存進雜湊表，掃第二個 list 時遇到共同的字串就算 index 和，比最小值小就重設答案、相等就加進去。時間 `O(n + m)`。
