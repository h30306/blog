---
title: "LeetCode 394: Decode String"
summary: "LeetCode 394 解題筆記：遇到 [ 就把目前的字串和次數存進 stack，遇到 ] 再取出組合；次數可能有好幾位"
description: "2025-10-08 的 LeetCode 394 解題紀錄"
date: 2025-10-08
tags: ["medium", "stack", "string", "recursion"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2025-10-08
- 提交紀錄：Wrong Answer → Accepted

## 解題思路

`k[encoded]` 可以巢狀，例如 `3[a2[c]]`。這是典型的 stack 題：

- 遇到 `[`：把「目前累積的字串」和「這個括號的次數」推進 stack，開始累積括號裡面的字串。
- 遇到 `]`：括號裡面的字串累積完了，取出上一層的字串和次數，組合成 `上一層 + 這一層 * 次數`。

## 我的第一版：假設次數只有一位數

```python
stack.pop()                       # 彈出 "["
repeat_time = int(stack.pop())    # 只取了一個字元當次數
```

第一版把每個字元都推進 stack，遇到 `]` 時往回彈到 `[`。問題是次數只彈了一個字元，`10[a]` 就會被當成 `0[a]`。第二版改成一直彈到不是數字為止，就 AC 了。

## 正確解法

```python
class Solution:
    def decodeString(self, s: str) -> str:
        stack = []
        cur, num = "", 0
        for ch in s:
            if ch.isdigit():
                num = num * 10 + int(ch)
            elif ch == "[":
                stack.append((cur, num))
                cur, num = "", 0
            elif ch == "]":
                prev, k = stack.pop()
                cur = prev + cur * k
            else:
                cur += ch
        return cur
```

stack 裡存的是「上一層的字串和次數」，而不是一個一個字元，這樣遇到 `]` 時不用往回找 `[`，也不用把字元重新拼起來。

## 複雜度

時間 `O(輸出長度)`，空間 `O(輸出長度)`。

## 要特別避免的錯誤

- 假設次數只有一位數。
- 把每個字元都推進 stack，遇到 `]` 時再往回拼：可以 AC，但比較慢也比較容易出錯。

## 面試口說整理

我用 stack 處理巢狀的括號：遇到數字就累加次數（可能有好幾位），遇到 `[` 就把目前的字串和次數推進 stack 並重新開始，遇到 `]` 就彈出上一層的字串和次數，把這一層重複次數後接到上一層後面。最後累積的字串就是答案，時間和輸出長度成正比。
