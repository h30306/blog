---
title: "LeetCode 859: Buddy Strings"
summary: "LeetCode 859 解題筆記：長度要相同；完全相同時要有重複字元；否則剛好兩個位置不同而且交叉相等"
description: "2022-09-17 的 LeetCode 859 解題紀錄"
date: 2022-09-17
tags: ["easy", "hash-table", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-09-17
- 提交紀錄：Runtime Error ×2 → Wrong Answer ×3 → Accepted ×3

## 解題思路

分三種情況：

1. 長度不同：不可能。
2. `s == goal`：必須交換兩個**相同的字元**，所以 `s` 要有重複字元（`len(set(s)) < len(s)`）。
3. 其他：找出所有不同的位置，必須**剛好兩個** `i, j`，而且 `s[i] == goal[j]`、`s[j] == goal[i]`。

## 我的嘗試

這題提交了 8 次，每次補一種情況：

- 前兩版是變數問題：計數器在設定 `d1`、`d2` 之前就加一，`d1` 永遠沒被設定（NameError）。
- 第三版沒處理**兩個字串相同**的情況：`"c"`、`"c"` 必須交換一次，沒有重複字元就做不到，答案 `False`，回傳 `True`。
- 補上之後，**只有一個位置不同**時也回傳 `True`：`"a"`、`"c"`。最後加上「不同的位置剛好一個就失敗」才 AC。

## 正確解法

```python
class Solution:
    def buddyStrings(self, s: str, goal: str) -> bool:
        if len(s) != len(goal):
            return False
        if s == goal:
            return len(set(s)) < len(s)
        diff = [i for i in range(len(s)) if s[i] != goal[i]]
        return len(diff) == 2 and s[diff[0]] == goal[diff[1]] and s[diff[1]] == goal[diff[0]]
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 一定要交換一次：相同的字串只有在有重複字元時才成立。
- 只有一個位置不同時，交換不可能修好。

## 面試口說整理

我先排除長度不同；兩個字串相同時要有重複字元才能交換；否則找出不同的位置，必須剛好兩個而且交叉相等。時間 `O(n)`。
