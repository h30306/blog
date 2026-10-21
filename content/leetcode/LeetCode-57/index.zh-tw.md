---
title: "LeetCode 57: Insert Interval"
summary: "LeetCode 57 解題筆記：把區間分成三組：完全在左邊的、完全在右邊的、和新區間重疊的；重疊的合併成一個"
description: "2022-10-22 的 LeetCode 57 解題紀錄"
date: 2022-10-22
tags: ["medium", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-10-22
- 提交紀錄：Wrong Answer → Runtime Error → Wrong Answer → Runtime Error → Wrong Answer ×3 → Runtime Error → Accepted → Runtime Error → Wrong Answer → Accepted

## 解題思路

區間已經排好而且互不重疊，所以每個區間跟新區間 `[s, e]` 的關係只有三種：

- `end < s`：完全在左邊，原樣保留。
- `start > e`：完全在右邊，原樣保留。
- 其他：重疊，把 `s` 更新成 `min(s, start)`、`e` 更新成 `max(e, end)`。

答案是 `left + [[s, e]] + right`。`s`、`e` 從新區間本身開始，這樣沒有重疊或區間是空的時也正確。

## 我的嘗試

這題提交了 12 次：

- 前幾版從後往前原地修改 `intervals`，一邊 `pop` 一邊判斷，情況越寫越多：空的 `intervals` 回傳 `[]`（應該是 `[[5, 8]]`）、`[[2, 5]]` 插入 `[0, 4]` 也回傳 `[]`。
- 改成「左、重疊、右」三組之後，第一次寫成 `left += i`，**把區間的兩個數字攤平接進 list**：回傳 `[[0, 4], 5, 9]`。改成 `left += [i]` 就 AC 了。
- 2022-10-31 重寫時，合併的範圍從 `inf`、`-inf` 開始，沒有包含新區間本身，而且右端點用了 `min`：空的 `intervals` 回傳 `[[inf, -inf]]`。

## 正確解法

```python
class Solution:
    def insert(self, intervals: List[List[int]], newInterval: List[int]) -> List[List[int]]:
        s, e = newInterval
        left, right = [], []
        for a, b in intervals:
            if b < s:
                left.append([a, b])
            elif a > e:
                right.append([a, b])
            else:
                s, e = min(s, a), max(e, b)
        return left + [[s, e]] + right
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 合併的範圍從新區間本身開始，不要從 `inf` 開始。
- 右端點取 `max`，不是 `min`。
- `left += [a, b]` 會把兩個數字直接接進 list，要用 `append`。
- 區間是空的時要回傳 `[newInterval]`。

## 面試口說整理

區間排好而且不重疊，所以我把每個區間分成完全在左邊、完全在右邊和跟新區間重疊三種，重疊的跟新區間合併成一個，最後接起來。時間 `O(n)`。
