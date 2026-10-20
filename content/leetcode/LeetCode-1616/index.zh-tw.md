---
title: "LeetCode 1616: Split Two Strings to Make Palindrome"
summary: "LeetCode 1616 解題筆記：外側用 a 的前綴配 b 的後綴貪心比對，配不下去時，剩下的中間段必須整段在 a 或 b 裡是回文；兩個方向都要檢查"
description: "2026-01-24 的 LeetCode 1616 解題紀錄"
date: 2026-01-24
tags: ["medium", "two-pointers", "string", "greedy"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-24
- 提交紀錄：WA → TLE ×2 → WA → AC → WA → AC

## 解題思路

在同一個位置把 `a` 和 `b` 切開，檢查 `a 前綴 + b 後綴` 或 `b 前綴 + a 後綴` 能不能是回文。

以 `a 前綴 + b 後綴` 為例，用對撞指針：左指針在 `a` 上往右、右指針在 `b` 上往左，**只要 `a[left] == b[right]` 就繼續往內**。這段外側一定能用「`a` 的前綴配 `b` 的後綴」湊成回文。

停下來時，中間還沒配好的 `[left, right]` 這段，**整段只能來自同一個字串**（切點一定落在這段裡），所以它必須是 `a[left..right]` 或 `b[left..right]` 自己就是回文。

另一個方向 `b 前綴 + a 後綴` 也要檢查一次。

## 我的嘗試

| 版本 | 問題 |
|---|---|
| 第一版 WA | 只檢查了 `a 前綴 + b 後綴` 一個方向，切點也只到 `n - 1`。例如 `a = "aa"`、`b = "ab"`：取整個 `a` 就是回文，答案是 `True`，這版回傳 `False` |
| 兩次 TLE | 補上另一個方向、切點改成 `0..n`，但每個切點都重新組字串檢查回文，`O(n^2)` |
| 第四版 WA | 改成貪心比對 + 檢查中間段，但 `is_palindrome` 裡寫成 `i -= 1`、`j += 1`，指針往外走，直接越界 |
| 第六版 WA | 最後一行寫成 `check(a, b) or check(a, b)`，第二個應該是 `check(b, a)`。例如 `a = "aaab"`、`b = "babb"`：`b` 前綴 `"ba"` 加 `a` 後綴 `"ab"` 是 `"baab"`，答案是 `True`，這版只檢查了一個方向，回傳 `False` |

## 正確解法

```python
class Solution:
    def checkPalindromeFormation(self, a: str, b: str) -> bool:
        def is_palindrome(s: str, i: int, j: int) -> bool:
            while i < j:
                if s[i] != s[j]:
                    return False
                i += 1
                j -= 1
            return True

        def check(x: str, y: str) -> bool:            # x 的前綴 + y 的後綴
            left, right = 0, len(x) - 1
            while left < right and x[left] == y[right]:
                left += 1
                right -= 1
            return is_palindrome(x, left, right) or is_palindrome(y, left, right)

        return check(a, b) or check(b, a)
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 只檢查一個方向。
- 每個切點都重新組字串：`O(n^2)`。
- 判斷回文時指針往外走。
- 同一個函式呼叫兩次卻沒有交換參數。

## 面試口說整理

以 `a` 的前綴加 `b` 的後綴為例，我用對撞指針從外往內，只要 `a[left]` 等於 `b[right]` 就繼續。停下來時，中間剩下的那段只能整段來自同一個字串，所以檢查它在 `a` 或 `b` 裡是不是回文。另一個方向交換 `a`、`b` 再檢查一次，時間 `O(n)`。
