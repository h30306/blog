---
title: "LeetCode 60: Permutation Sequence"
summary: "LeetCode 60 解題筆記：k 改成 0-indexed，第一位決定之後剩下 (n-1)! 種排法；k // (n-1)! 就是第一位在剩下的數字裡排第幾，取出後繼續處理下一位"
description: "2026-07-29 的 LeetCode 60 解題紀錄"
date: 2026-07-29
tags: ["hard", "math", "combinatorics", "recursion"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-07-29
- 提交紀錄：Accepted（2026-07-29）→ Wrong Answer（2026-10-13 重寫）

## 解題思路

`1..n` 的排列依字典序排好，**第一位固定之後，剩下的 `n - 1` 個數有 `(n - 1)!` 種排法**，所以排列被分成 `n` 塊，每塊 `(n - 1)!` 個。

把 `k` 改成 0-indexed：

- `idx = k // (n - 1)!`：第 `k` 個排列在第 `idx` 塊，第一位就是剩下數字裡第 `idx` 小的。
- `k %= (n - 1)!`：在這一塊裡的位置。
- 把用掉的數字從候選中**拿掉**，對剩下的 `n - 1` 個數重複。

## 我的嘗試

第一次 AC 就是上面的做法。三個月後重寫時沒有維護「剩下的數字」，而是直接把 `k // (n-1)! + 1` 當成數字輸出，算階乘的函式也寫錯了（乘的是 `n - 1`），結果位數和數字都不對。例如 `n = 3`、`k = 3`：答案是 `"213"`，回傳 `"3"`。

## 正確解法

```python
from math import factorial

class Solution:
    def getPermutation(self, n: int, k: int) -> str:
        k -= 1                                     # 改成 0-indexed
        digits = [str(i) for i in range(1, n + 1)]
        res = []
        for i in range(n - 1, -1, -1):
            block = factorial(i)                   # 剩下 i 個數的排法
            idx, k = divmod(k, block)
            res.append(digits.pop(idx))            # 用掉的數字要拿掉
        return "".join(res)
```

## 複雜度

時間 `O(n^2)`（`pop` 是 `O(n)`），`n <= 9`。空間 `O(n)`。

## 要特別避免的錯誤

- `k` 要先減 1 變成 0-indexed，否則整除會差一。
- 用掉的數字要從候選拿掉，下一位是在**剩下的**數字裡選。

## 面試口說整理

第一位固定之後剩下的有 `(n - 1)!` 種排法，所以把 `k` 改成從 0 開始，`k` 除以 `(n - 1)!` 就知道第一位是剩下數字裡第幾小的，取出來、`k` 取餘數，再處理下一位。用掉的數字要拿掉。時間 `O(n^2)`。
