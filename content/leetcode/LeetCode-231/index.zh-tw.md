---
title: "LeetCode 231: Power of Two"
summary: "LeetCode 231 解題筆記：2 的次方只有一個位元是 1，n & (n - 1) 會把最低的 1 消掉，結果是 0 就是；n 要是正數"
description: "2022-08-22 的 LeetCode 231 解題紀錄"
date: 2022-08-22
tags: ["easy", "math", "bit-manipulation", "recursion"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-22
- 提交紀錄：Wrong Answer ×3 → Accepted → Wrong Answer → Accepted

## 解題思路

`n & (n - 1)` 會把最低位的 1 變成 0（[Bit Manipulation]({{< relref "/algorithm/Bit-Manipulation" >}})）。2 的次方只有一個 1，消掉之後就是 0。0 和負數不是 2 的次方，要先排除。

## 我的嘗試

- 第一版寫成 `(n > 0) & (n & (n - 1)) == 0`，**`&` 比 `==` 先算**，`n = 0` 時變成 `(False & 0) == 0`，回傳 `True`。
- 下一版拿掉 `== 0`，意思變成「`n & (n - 1)` 不是 0」，**剛好相反**：`4` 回傳 0。2022-11 重寫時又寫了一次 `n > 0 and n & (n - 1)`，加上 `not` 才 AC。

## 正確解法

```python
class Solution:
    def isPowerOfTwo(self, n: int) -> bool:
        return n > 0 and n & (n - 1) == 0
```

## 複雜度

時間 `O(1)`，空間 `O(1)`。

## 要特別避免的錯誤

- Python 的 `&` 比 `==` **先算**：`(n > 0) & (n & (n - 1)) == 0` 會變成 `((n > 0) & (n & (n - 1))) == 0`。用 `and` 連接兩個條件。
- `n & (n - 1)` 是 0 才是 2 的次方，不要寫反。

## 面試口說整理

2 的次方只有一個位元是 1，n & (n - 1) 會消掉最低位的 1，所以我檢查 n 是正數而且 n & (n - 1) 是 0。時間 `O(1)`。
