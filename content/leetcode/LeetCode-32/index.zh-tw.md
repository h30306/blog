---
title: "LeetCode 32: Longest Valid Parentheses"
summary: "LeetCode 32 解題筆記：堆疊存索引，底部放目前這段合法括號開始前的位置，長度是 i - stack[-1]"
description: "2026-11-03 的 LeetCode 32 解題紀錄"
date: 2026-11-03
tags: ["hard", "string", "dynamic-programming", "stack", "bracket-sequences"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-11-03
- 提交紀錄：Wrong Answer ×5 → Accepted ×2

## 解題思路

用堆疊存**索引**（[Stack]({{< relref "/algorithm/Stack" >}})）。堆疊最底下放「目前這段合法括號開始之前的位置」，一開始是 `-1`：
- 遇到 `(`：把索引放進去。
- 遇到 `)`：先 pop 一個。
  - pop 完堆疊空了：這個 `)` 沒有配對，它成為新的邊界，把 `i` 放進去。
  - 否則：`i - stack[-1]` 就是以 `i` 結尾的合法括號長度。

關鍵是一定要存索引，才算得出長度。只數配對了幾對，分不出那些配對是不是連在一起。

## 我的嘗試

錯了五次，五次都在數「配對了幾對」：
1. `s.count("()") * 2`：只數得到相鄰的 `()`，巢狀的算不到。`"(())"` 回傳 2，答案是 4。
2. 堆疊放字元，配對一次就加 2：數到的是**全部**配對的數量，不管是不是連續的。`"()(()"` 回傳 4，答案是 2，因為中間那個 `(` 沒配對，把兩段隔開了。
3. 加了 `prev`、`curr` 兩個計數器，堆疊清空時把 `curr` 加進 `prev`，再令 `curr = prev`，同一段被加了兩次。`"()()"` 回傳 6，答案是 4。
4. 改成 `prev += curr` 但不重置 `curr`，一樣重複計算，`"()()"` 回傳 6。
5. 加上 `curr = 0` 重置之後，`"(()(()"` 回傳 4，答案是 2。兩組 `()` 中間隔著一個沒配對的 `(`，但堆疊沒清空，計數器就一直累加。計數器只記數量、不記位置，分不出這兩組有沒有連在一起。
6. 改成堆疊存索引、最底下放 `-1` 當邊界，才過；之後再寫一次也過了。

## 正確解法

```python
class Solution:
    def longestValidParentheses(self, s: str) -> int:
        stack = [-1]                  # 目前這段合法括號開始之前的位置
        longest = 0
        for i, c in enumerate(s):
            if c == "(":
                stack.append(i)
            else:
                stack.pop()
                if not stack:         # 這個 ) 沒有配對，成為新的邊界
                    stack.append(i)
                else:
                    longest = max(longest, i - stack[-1])
        return longest
```

也有 `O(1)` 空間的寫法：從左到右數 `(` 和 `)` 的個數，相等時更新答案，`)` 比較多時兩個都歸零；再從右到左做一次，處理 `(` 比較多的情況（例如 `"(()"`）。

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 只數配對數量、不記位置：分不出配對是不是連續的。
- 堆疊最底下忘了放 `-1`：`"()"` 配對完堆疊是空的，就沒有東西可以拿來算長度。
- pop 完堆疊空了，要把目前的 `i` 放進去當新邊界，不能只是跳過。

## 面試口說整理

我用堆疊存索引，最底下放目前這段合法括號開始之前的位置，一開始是 -1。遇到左括號就放索引；遇到右括號先 pop，如果堆疊空了，代表這個右括號沒配對，把它的索引放進去當新邊界；否則 `i` 減掉堆疊頂端，就是以 `i` 結尾的合法長度。要存索引而不是只數配對數量，因為中間如果有沒配對的括號，兩段就不連續。時間、空間 `O(n)`。
