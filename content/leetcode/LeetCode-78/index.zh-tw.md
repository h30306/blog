---
title: "LeetCode 78: Subsets"
summary: "LeetCode 78 解題筆記：每個元素選或不選；迭代寫法是每加入一個數，就把現有的每個子集合複製一份並加上它"
description: "2022-10-26 的 LeetCode 78 解題紀錄"
date: 2022-10-26
tags: ["medium", "array", "backtracking", "bit-manipulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-10-26
- 提交紀錄：Wrong Answer ×3 → Accepted → Memory Limit Exceeded → Accepted ×3

## 解題思路

子集合就是每個元素選或不選（[Backtracking]({{< relref "/algorithm/Backtracking" >}}) 變化一），共 `2^n` 個。迭代寫法：從 `[[]]` 開始，每處理一個數 `x`，把目前所有子集合各複製一份加上 `x`。回溯寫法：`dfs(start, path)` 先把 `path` 加入答案，再從 `start` 往後選下一個。

## 我的嘗試

前三版變數用錯，寫成 `c + [nums]`，**加進去的是整個陣列**而不是目前的數：`[5]` 回傳 `[[], [[5]]]`。改成 `num` 就 AC 了。2022-10-30 試了另一種寫法，Memory Limit Exceeded。

## 正確解法

```python
class Solution:
    def subsets(self, nums: List[int]) -> List[List[int]]:
        res = [[]]
        for x in nums:
            res += [s + [x] for s in res]
        return res
```

## 複雜度

時間 `O(n · 2^n)`，空間 `O(n · 2^n)`（輸出）。

## 要特別避免的錯誤

- 加上的是目前的數 `x`，不是整個 `nums`。

## 面試口說整理

每個元素選或不選，我從只有空集合開始，每處理一個數，就把現有的每個子集合複製一份加上它。總共 2 的 n 次方個子集合，時間 `O(n · 2^n)`。
