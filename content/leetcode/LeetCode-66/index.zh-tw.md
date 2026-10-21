---
title: "LeetCode 66: Plus One"
summary: "LeetCode 66 解題筆記：從最後一位往前加一，遇到 9 變 0 繼續進位，全部都是 9 時前面補 1"
description: "2022-05-11 的 LeetCode 66 解題紀錄"
date: 2022-05-11
tags: ["easy", "array", "math"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-05-11
- 提交紀錄：Runtime Error ×3 → Wrong Answer → Accepted ×4 → Runtime Error ×2 → Accepted → Wrong Answer ×4 → Accepted ×3

## 解題思路

直式加法（[Math]({{< relref "/algorithm/Math" >}}) 模板六）：從最後一位開始，不是 9 就直接加一回傳；是 9 就變成 0、繼續往前進位。迴圈跑完代表每一位都是 9，前面補一個 1。

## 我的嘗試

前面幾版都是「轉成整數加一再拆回來」：

- 2022-05：`''.join(digits)` 的元素是整數（TypeError）；改好之後用 `str(...).split()` 拆，**`split` 是用空白切，整個數字只是一個元素**：`[9]` 回傳 `[10]`，答案 `[1, 0]`。
- 2022-08 改成自己算 `digits[i] * 10 ** k`：先寫成 `10^k`，**`^` 在 Python 是 XOR**：`[1]` 回傳 `[1, 1]`；改成 `10**len(digits)-1-i` 又**少了括號**，算成 `10**len - 1 - i`：`[1]` 回傳 `[1, 0]`。
- 2022-10 才改成上面的逐位進位寫法。

## 正確解法

```python
class Solution:
    def plusOne(self, digits: List[int]) -> List[int]:
        for i in range(len(digits) - 1, -1, -1):
            if digits[i] < 9:
                digits[i] += 1
                return digits
            digits[i] = 0
        return [1] + digits
```

## 複雜度

時間 `O(n)`，空間 `O(1)`（不算全部是 9 時的新陣列）。

## 要特別避免的錯誤

- `10^k` 在 Python 是 XOR，次方是 `10**k`；而且 `10**len - 1 - i` 要加括號。
- 回傳的是數字的 list，`str(...).split()` 只會得到一個元素。

## 面試口說整理

我從最後一位往前做進位：不是 9 就加一直接回傳，是 9 就變 0 繼續往前，全部都是 9 的話最前面補 1。時間 `O(n)`，不需要轉成整數。
