---
title: "LeetCode 1842: Next Palindrome Using Same Digits"
summary: "LeetCode 1842 解題筆記：回文由左半邊決定，中間的數字固定不動；對左半邊做 next permutation，再鏡像回去"
description: "2026-09-27 的 LeetCode 1842 解題紀錄"
date: 2026-09-27
tags: ["hard", "two-pointers", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-09-27
- 提交紀錄：Wrong Answer → Runtime Error → Accepted ×2

## 解題思路

回文完全由**左半邊**決定：右半邊是左半邊的鏡像。奇數長度時，中間那個數字是唯一出現奇數次的數字，**只能放在中間**，不會變。

所以「用同樣的數字組成、比 `num` 大的最小回文」，就是「左半邊的下一個排列（next permutation）」再鏡像回去。左半邊已經是最大排列時，沒有答案，回傳 `""`。

Next permutation：

1. 從右往左找第一個 `half[i] < half[i + 1]` 的位置 `i`。找不到代表已經是最大排列。
2. 從右往左找第一個 `half[j] > half[i]`，交換 `half[i]`、`half[j]`。
3. 把 `half[i + 1:]` 反轉（對撞指針），讓這段變成最小。

## 我的嘗試

1. **WA**：中間數字取成 `nums[n // 2 + 1]`，應該是 `nums[n // 2]`。例如 `num = "12321"`：答案是 `"21312"`，這版把 `2` 當中間，回傳 `"21212"`，數字都不一樣了。
2. **RE**：修好中間，但 `n == 1` 時左半邊是空的，後面直接讀 `left[-1]` 越界。例如 `num = "3"`。
3. **AC**：特判 `n == 1` 回傳 `""`。

## 正確解法

```python
class Solution:
    def nextPalindrome(self, num: str) -> str:
        n = len(num)
        half = list(num[:n // 2])

        i = len(half) - 2
        while i >= 0 and half[i] >= half[i + 1]:
            i -= 1
        if i < 0:
            return ""                              # 左半邊已經是最大排列（含 n == 1）
        j = len(half) - 1
        while half[j] <= half[i]:
            j -= 1
        half[i], half[j] = half[j], half[i]

        lo, hi = i + 1, len(half) - 1              # 反轉後綴
        while lo < hi:
            half[lo], half[hi] = half[hi], half[lo]
            lo += 1
            hi -= 1

        left = "".join(half)
        mid = num[n // 2] if n % 2 else ""
        return left + mid + left[::-1]
```

`i` 從 `len(half) - 2` 開始，左半邊是空的或只有一位時迴圈直接不跑、`i < 0`，所以不需要另外特判 `n == 1`。

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 中間數字的位置是 `n // 2`。
- 左半邊是空的（`n == 1`）或只有一位時，沒有下一個排列。
- Next permutation 最後要反轉後綴，不是排序（反轉就夠了，因為那段是遞減的）。

## 面試口說整理

回文由左半邊決定，奇數長度時中間那個數字只能留在中間。所以比 `num` 大的最小回文，就是左半邊的下一個排列再鏡像回去。Next permutation 是從右邊找第一個變小的位置、跟右邊第一個比它大的交換、再用對撞指針反轉後綴。沒有下一個排列就回傳空字串。時間 `O(n)`。
