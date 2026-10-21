---
title: "LeetCode 914: X of a Kind in a Deck of Cards"
summary: "LeetCode 914 解題筆記：每種卡片的張數都要能被同一個 X >= 2 整除，也就是所有張數的 GCD >= 2"
description: "2022-09-25 的 LeetCode 914 解題紀錄"
date: 2022-09-25
tags: ["easy", "array", "hash-table", "math", "counting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-09-25
- 提交紀錄：Wrong Answer → Runtime Error ×3 → Wrong Answer → Runtime Error → Wrong Answer ×2 → Accepted ×2

## 解題思路

先數每種卡片幾張（[Hash Table]({{< relref "/algorithm/Hash-Table" >}})）。要分成每組 `X` 張，`X` 必須整除**每一種**的張數，所以 `X` 是所有張數的公因數；存在 `X >= 2` 等價於所有張數的 **GCD** `>= 2`（[Number Theory]({{< relref "/algorithm/Number-Theory" >}}) 模板一）。

## 我的嘗試

這題提交了 10 次，一步步接近「GCD」：

- 第一版要求每種卡片的張數**都一樣**：只有一張 `[2]` 時回傳 `True`，答案 `False`。補上「張數 `>= 2`」之後，張數不同但有公因數的情況又錯了：`[1, 3, 1, 1, 1, 3]` 的張數是 4 和 2，可以每組 2 張，回傳 `False`。
- 改成「每種的張數都要能被最小的張數整除」：張數 4 和 6 時回傳 `False`，但每組 2 張就可以。
- 再改成「每種的張數都跟最小的張數有公因數」：張數 6、10、15 兩兩都有公因數，但沒有一個 `X` 能同時整除三個，答案 `False`，這版回傳 `True`。
- 最後改成對**全部**張數取 GCD 才 AC。

## 正確解法

```python
class Solution:
    def hasGroupsSizeX(self, deck: List[int]) -> bool:
        return reduce(gcd, Counter(deck).values()) >= 2
```

## 複雜度

時間 `O(n + k log n)`，空間 `O(k)`。

## 要特別避免的錯誤

- 張數不需要都一樣：`[4, 6]` 張可以每組 2 張。
- 不能只用最小的張數去整除其他的：`4` 和 `6` 的 `X` 是 2，不是 4。
- 只跟最小的張數兩兩取 GCD 也不夠：`6, 10, 15` 兩兩都有公因數，但三個的 GCD 是 1。

## 面試口說整理

我先數每種卡片的張數，每組 X 張代表 X 要整除所有張數，所以我對所有張數取 GCD，大於等於 2 就成立。時間 `O(n + k log n)`。
