---
title: "LeetCode 258: Add Digits"
summary: "LeetCode 258 解題筆記：反覆把位數相加直到剩一位；O(1) 解法是 digital root：1 + (n - 1) % 9"
description: "2022-08-22 的 LeetCode 258 解題紀錄"
date: 2022-08-22
tags: ["easy", "math", "simulation", "number-theory"]
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
- 提交紀錄：Runtime Error ×2 → Accepted ×4

## 解題思路

直接模擬：位數和不是個位數就繼續加（[Math]({{< relref "/algorithm/Math" >}}) 模板五）。進階要求 `O(1)`：一個數跟它的位數和除以 9 的餘數相同（因為 `10 ≡ 1 (mod 9)`），所以最後剩下的個位數就是 `n mod 9`，只是 9 的倍數要回傳 9 而不是 0：`0 if n == 0 else 1 + (n - 1) % 9`。

## 我的嘗試

前兩版都是 `sum(list(str(num)))`，**加的是字元**（TypeError），第一版還把參數名稱寫成 `nums`。改成先轉 `int` 就 AC 了，2025 年又用 Python 和 C++ 各寫了一次。每次都是模擬，沒有用公式。

## 正確解法

```python
class Solution:
    def addDigits(self, num: int) -> int:
        return 0 if num == 0 else 1 + (num - 1) % 9
```

## 複雜度

時間 `O(1)`，空間 `O(1)`。

## 要特別避免的錯誤

- `sum(list(str(n)))` 加的是字元，要先轉成 `int`。
- 公式要處理 0 和 9 的倍數。

## 面試口說整理

直接做是反覆把位數相加；`O(1)` 的做法是一個數和它的位數和除以 9 同餘，所以答案是 1 + (n - 1) % 9，n 是 0 時回傳 0。
