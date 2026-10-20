---
title: "LeetCode 3703: Remove K-Balanced Substrings"
summary: "LeetCode 3703 解題筆記：反覆 replace 是 O(n^2)；stack 存 (字元, 連續個數)，湊到 k 個 ( 加 k 個 ) 就整段消掉"
description: "2025-10-05 的 LeetCode 3703 解題紀錄"
date: 2025-10-05
tags: ["medium", "stack", "string", "simulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2025-10-05
- 提交紀錄：Accepted（5298ms）

## 解題思路

`k` 平衡的子字串是 `k` 個 `(` 接著 `k` 個 `)`。要一直刪掉這種子字串，直到沒有為止。

刪掉一段之後，左右兩邊會接起來，可能又形成新的 `k` 平衡子字串。這種「刪掉後跟前面接起來」的模式，就是 stack。

## 我的解法：反覆 replace

```python
class Solution:
    def removeSubstring(self, s: str, k: int) -> str:
        target = "(" * k + ")" * k
        while target in s:
            s = s.replace(target, "", 1)
        return s
```

AC 了，但跑了 5298ms。每次 `in` 和 `replace` 都要重新掃整個字串，最多要刪 `n / 2k` 次，總共 `O(n^2 / k)`。

## 更好的解法：stack 存連續段

stack 裡存 `[字元, 連續個數]`，相同字元就合併到同一段：

1. 讀到一個字元，如果跟頂端那段相同就個數加 1，否則開新的一段。
2. 如果頂端是 `)` 而且剛好 `k` 個，下面那段是 `(` 而且至少 `k` 個，就把這 `k` 個 `)` 和 `k` 個 `(` 一起消掉。
3. `(` 那段被消到 0 就整段移除，之後讀進來的字元會自動跟新的頂端合併。

```python
class Solution:
    def removeSubstring(self, s: str, k: int) -> str:
        stack = []                                 # [字元, 連續個數]
        for ch in s:
            if stack and stack[-1][0] == ch:
                stack[-1][1] += 1
            else:
                stack.append([ch, 1])
            if (ch == ")" and stack[-1][1] == k and len(stack) >= 2
                    and stack[-2][0] == "(" and stack[-2][1] >= k):
                stack.pop()
                stack[-1][1] -= k
                if stack[-1][1] == 0:
                    stack.pop()
        return "".join(ch * cnt for ch, cnt in stack)
```

只在 `)` 的個數**剛好等於** `k` 時檢查：個數超過 `k` 代表前面的 `(` 不夠，之後再多的 `)` 也湊不出來。

## 複雜度

| 解法 | 時間 |
|---|---|
| 反覆 replace | `O(n^2 / k)` |
| stack 存連續段 | `O(n)` |

## 要特別避免的錯誤

- 只刪一輪就停：刪掉之後左右接起來可能又形成新的 `k` 平衡子字串。
- stack 存單一字元：每次都要往回數 `k` 個，最壞會變慢；存連續段的個數就不用。

## 面試口說整理

刪掉一段之後左右會接起來，可能又能刪，所以用 stack。我讓 stack 存每段連續相同字元和它的個數，讀到 `)` 且這段剛好 `k` 個、下面的 `(` 段至少 `k` 個時，就把這兩段各減 `k`，空了就移除。每個字元只進出一次，時間 `O(n)`。原本反覆用 `replace` 雖然能過，但每次都重掃整個字串。
