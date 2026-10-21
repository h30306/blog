---
title: "LeetCode 1089: Duplicate Zeros"
summary: "LeetCode 1089 解題筆記：先數有幾個 0 決定每個數要往後移幾格，再從後往前搬，遇到 0 時把複製的那個 0 也寫進去"
description: "2022-10-18 的 LeetCode 1089 解題紀錄"
date: 2022-10-18
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
第一次嘗試：2022-10-18
- 提交紀錄：Runtime Error → Wrong Answer → Accepted

## 解題思路

每個數最後的位置是「原位置 + 它前面（含自己之前）有幾個 0」。從**後往前**搬才不會覆蓋還沒搬的數（[Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) 模板二）：

- `zeros` 一開始是 0 的總數。
- 從尾巴往前，`nums[i]` 寫到 `i + zeros`（超出範圍就丟掉）。
- `nums[i]` 是 0 時，先把複製的那個 0 寫到 `i + zeros`，`zeros -= 1`，再把原本的 0 寫到 `i + zeros`。

## 我的嘗試

第一版從前往後處理，index 超出範圍；第二版從後往前搬了，但**遇到 0 時只寫了一次**（複製的那個沒寫），例如 `[0, 0, 3]`：答案 `[0, 0, 0]`，回傳 `[0, 0, 3]`。

## 正確解法

```python
class Solution:
    def duplicateZeros(self, arr: List[int]) -> None:
        n, zeros = len(arr), arr.count(0)
        for i in range(n - 1, -1, -1):
            if arr[i] == 0:
                if i + zeros < n:
                    arr[i + zeros] = 0                   # 複製出來的 0
                zeros -= 1
            if i + zeros < n:
                arr[i + zeros] = arr[i]
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 從前往後搬會覆蓋還沒處理的數。
- 遇到 0 要寫兩次，而且兩次的位置差一格。

## 面試口說整理

每個數要往後移的格數等於它前面有幾個 0，所以我先數 0 的總數，再從後往前搬，遇到 0 時多寫一個 0 並把位移減一。時間 `O(n)`、空間 `O(1)`。
