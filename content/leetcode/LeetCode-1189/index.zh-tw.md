---
title: "LeetCode 1189: Maximum Number of Balloons"
summary: "LeetCode 1189 解題筆記：每個字母可以組幾個 balloon 是 次數 // 需要數，l 和 o 需要兩個，取最小值"
description: "2022-10-18 的 LeetCode 1189 解題紀錄"
date: 2022-10-18
tags: ["easy", "hash-table", "string", "counting"]
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
- 提交紀錄：Runtime Error → Wrong Answer ×4 → Accepted → Runtime Error ×3 → Wrong Answer → Accepted ×2

## 解題思路

`balloon` 需要 `b, a, n` 各一個、`l, o` 各兩個。數 `text` 的字元（[Hash Table]({{< relref "/algorithm/Hash-Table" >}}) 模板一），每個字母能組出 `cnt[c] // need[c]` 個，答案是這五個值的最小值。

## 我的嘗試

這題提交了 12 次：

- 第一版把字母 `s` 本身指定給 `res`，而不是次數 `C[s]`，TypeError。
- 接下來四版外層先用 `C[s] < res` 篩選，**比的是原始次數而不是除以 2 之後的**，`l` 只有一個時 `1 < 1` 不成立，就被跳過了：`"nolab"` 答案 0，回傳 1。
- 改成 walrus 之後先是語法錯誤，然後寫成 `(new := C[s] // 2 < res)`，**`new` 拿到的是比較結果 `True`**：`"ban"` 回傳 `True`。括號移到 `(new := C[s] // 2) < res` 才 AC。

## 正確解法

```python
class Solution:
    def maxNumberOfBalloons(self, text: str) -> int:
        cnt = Counter(text)
        need = Counter("balloon")
        return min(cnt[c] // need[c] for c in need)
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 先把次數除以需要的數量，再取最小值；不要先用原始次數篩選。
- walrus 要加括號：`(new := x // 2) < res`，不然 `new` 拿到的是比較的結果。

## 面試口說整理

我數 text 的字元，每個字母除以 balloon 裡需要的數量，l 和 o 要兩個，五個值取最小就是答案。時間 `O(n)`。
