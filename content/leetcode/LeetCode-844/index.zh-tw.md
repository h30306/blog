---
title: "LeetCode 844: Backspace String Compare"
summary: "LeetCode 844 解題筆記：用 stack 模擬退格；O(1) 空間的話從尾巴往前，遇到 # 就記下要跳過幾個字元"
description: "2022-09-15 的 LeetCode 844 解題紀錄"
date: 2022-09-15
tags: ["easy", "two-pointers", "string", "stack", "simulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-09-15
- 提交紀錄：Runtime Error → Wrong Answer → Accepted ×2 → Runtime Error ×5 → Time Limit Exceeded ×3 → Runtime Error ×3 → Accepted

## 解題思路

Stack 寫法（[Stack]({{< relref "/algorithm/Stack" >}}) 模板二）：一般字元 `push`，`#` 就 `pop`（stack 是空的時不動），最後比較兩個 stack。

`O(1)` 空間：從尾巴往前走，因為 `#` 只影響**前面**的字元。每個字串維護 `skip`：遇到 `#` 就 `skip += 1`，遇到字元且 `skip > 0` 就跳過它並 `skip -= 1`，直到找到下一個真正留下來的字元，兩邊比較。

## 我的嘗試

這題 2022 年和 2026 年都寫過，總共錯了 13 次：

- 2022-09 第一版用 stack，**`#` 出現在開頭時對空的 stack `pop`**（IndexError）。
- 接著試 `O(1)` 空間的雙指針，指標從 `len(S)` 開始（超出範圍），內層 `while` 沒有讓指標前進，**無限迴圈 TLE 了三次**。
- 2026 年重寫雙指針，兩版都把 `t` 的部分寫成了 `s[j]`（複製貼上沒改），改成 `t[j]` 才 AC。

## 正確解法

```python
class Solution:
    def backspaceCompare(self, s: str, t: str) -> bool:
        def next_char(x, i):
            skip = 0
            while i >= 0:
                if x[i] == "#":
                    skip += 1
                elif skip:
                    skip -= 1
                else:
                    return i
                i -= 1
            return -1
        i, j = len(s) - 1, len(t) - 1
        while True:
            i, j = next_char(s, i), next_char(t, j)
            if i < 0 or j < 0:
                return i < 0 and j < 0
            if s[i] != t[j]:
                return False
            i, j = i - 1, j - 1
```

## 複雜度

時間 `O(n + m)`，空間 `O(1)`。

## 要特別避免的錯誤

- 空字串遇到 `#` 不動，`pop` 之前要檢查。
- 雙指針的迴圈每一輪都要讓指標前進，不然會無限迴圈。
- 兩個字串的 index 不要用錯：`s[i]` 對 `t[j]`。

## 面試口說整理

直覺的作法是用 stack 模擬退格再比較。要 `O(1)` 空間的話，我從兩個字串的尾巴往前，因為退格只影響前面的字元，遇到井字號就記下要跳過幾個，找到下一個真正留下的字元再兩邊比較。時間 `O(n + m)`。
