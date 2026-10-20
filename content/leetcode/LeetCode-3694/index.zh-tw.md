---
title: "LeetCode 3694: Distinct Points Reachable After Substring Removal"
summary: "LeetCode 3694 解題筆記：終點 = 全部的位移 − 被刪掉那段的位移；用長度 k 的視窗維護那段的位移，把每個終點放進 set"
description: "2025-12-27 的 LeetCode 3694 解題紀錄"
date: 2025-12-27
tags: ["medium", "sliding-window", "prefix-sum", "hash-table", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2025-12-27
- 提交紀錄：Wrong Answer → Accepted ×2

## 解題思路

移動是向量相加，順序不影響終點。刪掉一段長度 `k` 的子字串後：

```text
終點 = 整個字串的位移 − 被刪掉那段的位移
```

所以先算整個字串的總位移，再用長度 `k` 的固定視窗維護「視窗內的位移」，每個視窗算出一個終點放進 `set`，答案是 `set` 的大小。

## 我的嘗試

第一版更新答案的條件寫在 `if i - k >= 0` 裡面，也就是只有視窗**滿了而且已經移出一個元素**之後才記錄，少了第一個視窗（刪掉 `s[0..k-1]`）。例如 `s = "UL"`、`k = 1`：刪 `U` 剩 `L` 到 `(-1, 0)`，刪 `L` 剩 `U` 到 `(0, 1)`，答案是 2；這版只記到後者，回傳 1。

把「移出元素」和「記錄終點」分開，記錄的條件改成 `i - k + 1 >= 0` 就 AC 了。

## 正確解法

```python
class Solution:
    def distinctPoints(self, s: str, k: int) -> int:
        move = {"U": (0, 1), "D": (0, -1), "L": (-1, 0), "R": (1, 0)}
        total_x = sum(move[c][0] for c in s)
        total_y = sum(move[c][1] for c in s)

        wx = wy = 0                                # 視窗內的位移
        points = set()
        for i, c in enumerate(s):
            wx += move[c][0]
            wy += move[c][1]
            if i >= k:
                out = s[i - k]
                wx -= move[out][0]
                wy -= move[out][1]
            if i >= k - 1:                         # 第一個視窗在 i == k - 1
                points.add((total_x - wx, total_y - wy))
        return len(points)
```

`k == n` 時只有一個視窗，終點是 `(0, 0)`，不需要另外特判。

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 漏掉第一個視窗：記錄答案的條件是 `i >= k - 1`，移出元素的條件是 `i >= k`，兩個要分開。

## 面試口說整理

移動是向量相加，所以刪掉一段之後的終點等於總位移減掉那段的位移。我先算總位移，再用長度 `k` 的滑動視窗維護視窗內的位移，每個視窗算出一個終點放進 `set`。注意第一個視窗在 `i == k - 1` 就要記錄。時間 `O(n)`。
