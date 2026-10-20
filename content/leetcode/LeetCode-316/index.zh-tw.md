---
title: "LeetCode 316: Remove Duplicate Letters"
summary: "LeetCode 316 解題筆記：單調棧 + 最後出現位置，頂端比較大而且後面還會出現就彈掉；已經在 stack 裡的直接跳過"
description: "2026-07-13 的 LeetCode 316 解題紀錄"
date: 2026-07-13
tags: ["medium", "stack", "monotonic-stack", "greedy", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-07-13
- 提交紀錄：Accepted → Accepted（07-27 重打）→ Wrong Answer → Accepted
- 同一題：LC 1081 Smallest Subsequence of Distinct Characters

## 解題思路

每個字母要**剛好留一個**，讓結果字典序最小。

從左到右建立答案。看到字元 `c` 時，如果 stack 頂端的字母比 `c` 大，**而且那個字母後面還會再出現**，就把它彈掉：等一下再用後面那個就好，換成 `c` 放在前面字典序更小。

三個要素：

1. `last[ch]`：每個字母最後出現的位置，用來判斷「後面還會不會出現」。
2. `seen`：已經在 stack 裡的字母。**如果 `c` 已經在 stack 裡，直接跳過**，因為每個字母只能留一個，而且它已經在一個比較好的位置。
3. 單調棧：彈出比較大、而且之後還能補回來的字母。

## 我的嘗試：把 LC 3816 的寫法套過來

7/27 我先寫了 LC 3816，接著回來重寫這題，想用一樣的寫法：

```python
cnt = Counter(s)
for ch in s:
    while stack and stack[-1] > ch and cnt[stack[-1]] > 1:
        cnt[stack.pop()] -= 1
    stack.append(ch)
```

WA。這個寫法**允許同一個字母在 stack 裡出現好幾次**，只保證每個字母至少留一個，這是 LC 3816 的要求。316 要每個字母剛好一個，所以一定要有 `seen` 把已經在 stack 裡的字母跳過。

## 正確解法

```python
class Solution:
    def removeDuplicateLetters(self, s: str) -> str:
        last = {ch: i for i, ch in enumerate(s)}
        stack, seen = [], set()
        for i, ch in enumerate(s):
            if ch in seen:
                continue
            while stack and stack[-1] > ch and last[stack[-1]] > i:
                seen.remove(stack.pop())
            stack.append(ch)
            seen.add(ch)
        return "".join(stack)
```

## 複雜度

時間 `O(n)`：每個字元最多進出 stack 一次。空間 `O(字母表大小)`。

## 要特別避免的錯誤

- 沒有 `seen`：同一個字母會出現兩次。
- 判斷「後面還會出現」用 `>=` 而不是 `>`：`last[ch] == i` 代表這是最後一個，不能刪。
- 跟 LC 3816 搞混：那題是「至少留一個」，這題是「剛好留一個」。

## 面試口說整理

我先記下每個字母最後出現的位置，然後用單調棧從左到右建答案。已經在 stack 裡的字母直接跳過；否則只要頂端比目前字母大、而且它後面還會出現，就把它彈掉，因為之後可以用後面那個。最後 stack 就是答案。每個字元最多進出一次，時間 `O(n)`。
