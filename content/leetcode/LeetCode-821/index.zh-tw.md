---
title: "LeetCode 821: Shortest Distance to a Character"
summary: "LeetCode 821 解題筆記：左往右掃一次記錄到左邊最近的 c 的距離，右往左再掃一次取較小值"
description: "2022-09-15 的 LeetCode 821 解題紀錄"
date: 2022-09-15
tags: ["easy", "array", "two-pointers", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-09-15
- 提交紀錄：Wrong Answer → Accepted

## 解題思路

每個位置的答案是「左邊最近的 `c`」和「右邊最近的 `c`」兩個距離取小。從左往右掃一次，記住上一次看到 `c` 的位置；再從右往左掃一次，做一樣的事並取最小值。還沒看到 `c` 時把位置設成無限遠。

## 我的嘗試

第一版的第二輪（從右往左）取最小值時**忘了 `+1`**，而且漏了 `return`，回傳 `None`；補上兩個就 AC 了。

## 正確解法

```python
class Solution:
    def shortestToChar(self, s: str, c: str) -> List[int]:
        n = len(s)
        res = [0] * n
        last = float("-inf")
        for i in range(n):
            if s[i] == c:
                last = i
            res[i] = i - last
        last = float("inf")
        for i in range(n - 1, -1, -1):
            if s[i] == c:
                last = i
            res[i] = min(res[i], last - i)
        return res
```

## 複雜度

時間 `O(n)`，空間 `O(n)`（輸出）。

## 要特別避免的錯誤

- 兩個方向都要掃，只掃一邊會漏掉另一邊比較近的 `c`。
- 從右邊傳回來的距離要 `+1`。

## 面試口說整理

我從左往右掃一次算到左邊最近的 `c` 的距離，再從右往左掃一次算到右邊最近的，兩者取小。時間 `O(n)`。
