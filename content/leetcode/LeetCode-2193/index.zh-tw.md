---
title: "LeetCode 2193: Minimum Number of Moves to Make Palindrome"
summary: "LeetCode 2193 解題筆記：貪心處理最外層：拿最後一個字元，把它最左邊的同伴換到最前面，花費是那個位置；落單的字元最後在正中間，花費是它到中間的距離"
description: "2026-09-02 的 LeetCode 2193 解題紀錄"
date: 2026-09-02
tags: ["hard", "two-pointers", "greedy", "string", "binary-indexed-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-09-02
- 提交紀錄：Wrong Answer → Runtime Error → Wrong Answer → Accepted

## 解題思路

一次處理最外層的一對，相當於左右兩個指針往內收：

1. 看最後一個字元 `c = s[-1]`，找它在最左邊出現的位置 `i`。
2. 如果 `i` 不是最後一個位置：把 `s[i]` 一路換到最前面，花 `i` 步，兩端就配好了，把這兩個字元拿掉，繼續處理中間。
3. 如果 `i` 就是最後一個位置：`c` 只出現一次，它是落單的字元，**最後一定在正中間**。它到中間的距離是 `i // 2`，先把這個花費算掉、把它拿掉。

為什麼用最後一個字元當基準、去找它最左邊的同伴：固定右端不動、只移動左邊的同伴，這一對的花費最小；選最左邊的同伴，跨過的字元最少。落單的字元跟其他字元交換時，不會改變其他字元之間的相對順序，所以可以先把它的花費算掉再拿掉。

## 我的嘗試

演算法本身一開始就對了，錯在型別和貼程式：

1. **WA**：落單字元的花費寫成 `i / 2`，在 Python 3 是浮點數，最後回傳的是 `2.0` 這樣的浮點數，判定為錯。
2. **RE**：貼程式時漏了 `class Solution:` 那一行。
3. **WA**：同第一版，還是回傳浮點數。
4. **AC**：最後回傳 `int(res)`。

直接用整數除法 `i // 2` 就不會有這個問題：`i` 在這時一定是偶數（剩下的長度是奇數），`//` 和 `/` 的值一樣，但型別是整數。

## 正確解法

```python
class Solution:
    def minMovesToMakePalindrome(self, s: str) -> int:
        s = list(s)
        moves = 0
        while s:
            i = s.index(s[-1])                     # 最後一個字元在最左邊的位置
            if i == len(s) - 1:
                moves += i // 2                    # 落單的字元：到正中間的距離
            else:
                moves += i                         # 把同伴換到最前面
                s.pop(i)
            s.pop()
        return moves
```

## 複雜度

時間 `O(n^2)`：每輪的 `index` 和 `pop` 都是 `O(n)`，`n <= 2000` 沒問題。要更快可以用樹狀陣列（BIT）記錄哪些位置已經被拿掉，算出移動距離，做到 `O(n log n)`。

## 要特別避免的錯誤

- Python 3 的 `/` 是浮點除法，計數題要用 `//`。
- 落單字元的花費不是 `i`：它只要到中間，不用到最前面。

## 面試口說整理

我每次處理最外層：拿最後一個字元，找它最左邊的同伴，把同伴換到最前面，花費是同伴的位置，然後拿掉這一對。如果最後一個字元只出現一次，它最後會在正中間，花費是它到中間的距離，先算掉再拿掉。每輪 `O(n)`，總共 `O(n^2)`；用 BIT 維護位置可以做到 `O(n log n)`。
