---
title: "LeetCode 1021: Remove Outermost Parentheses"
summary: "LeetCode 1021 解題筆記：用深度計數取代 stack，深度從 0 變 1 的左括號和從 1 變 0 的右括號是外層，其他都保留"
description: "2022-09-27 的 LeetCode 1021 解題紀錄"
date: 2022-09-27
tags: ["easy", "string", "stack", "bracket-sequences"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-09-27
- 提交紀錄：Wrong Answer → Accepted

## 解題思路

括號只有一種，stack 裡只會有 `(`，所以只需要記深度（[Stack]({{< relref "/algorithm/Stack" >}}) 模板一）。遇到 `(`：深度原本 `> 0` 才保留，再加一；遇到 `)`：先減一，減完還 `> 0` 才保留。這樣每個 primitive 最外面那一對就被去掉了。

## 我的嘗試

第一版用 stack 找出每一段 primitive，再用 `temp[1:-1]` 去掉頭尾，邏輯是對的但**忘了 `return`**；第二版補上就 AC 了。

## 正確解法

```python
class Solution:
    def removeOuterParentheses(self, s: str) -> str:
        res, depth = [], 0
        for c in s:
            if c == "(":
                if depth > 0:
                    res.append(c)
                depth += 1
            else:
                depth -= 1
                if depth > 0:
                    res.append(c)
        return "".join(res)
```

## 複雜度

時間 `O(n)`，空間 `O(n)`（輸出）。

## 要特別避免的錯誤

- 左括號是加之前判斷，右括號是減之後判斷。

## 面試口說整理

括號只有一種，我用深度計數取代 stack：左括號在深度大於 0 時才保留，右括號減完之後深度還大於 0 才保留，這樣每一段最外層的括號就被去掉了。時間 `O(n)`。
