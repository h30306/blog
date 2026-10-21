---
title: "LeetCode 1047: Remove All Adjacent Duplicates In String"
summary: "LeetCode 1047 解題筆記：stack 頂端跟目前字元相同就一起消掉，否則放進 stack；消掉之後新的頂端可能又能跟下一個消"
description: "2022-09-30 的 LeetCode 1047 解題紀錄"
date: 2022-09-30
tags: ["easy", "string", "stack"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-09-30
- 提交紀錄：Runtime Error → Accepted → Wrong Answer → Runtime Error → Accepted ×3

## 解題思路

跟前一個字元互動（[Stack]({{< relref "/algorithm/Stack" >}}) 模板二）：stack 頂端等於目前字元就 `pop`（兩個一起消掉），否則 `push`。消掉之後新的頂端會變成「前一個字元」，連鎖的消除自然就處理好了。

## 我的嘗試

第一版沒有檢查 stack 是不是空的就讀 `stack[-1]`（IndexError）。中間有一版多加了一個 `temp` 想跳過連續相同的字元，**一次把三個相同的都消掉了**：`"aaa"` 回傳空字串，答案 `"a"`。

## 正確解法

```python
class Solution:
    def removeDuplicates(self, s: str) -> str:
        st = []
        for c in s:
            if st and st[-1] == c:
                st.pop()
            else:
                st.append(c)
        return "".join(st)
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 取 `st[-1]` 前要確認 stack 不是空的。
- 一次只消一對：`"aaa"` 剩下 `"a"`。

## 面試口說整理

我用 stack，頂端跟目前字元相同就一起消掉，否則放進去；消掉之後新的頂端會跟下一個字元比，連鎖消除自然就處理了。時間 `O(n)`。
