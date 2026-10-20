---
title: "LeetCode 1306: Jump Game III"
summary: "LeetCode 1306 解題筆記：每個 index 是節點、往左右跳是邊，BFS 或 DFS 看能不能走到值為 0 的位置"
description: "2026-01-05 的 LeetCode 1306 解題紀錄"
date: 2026-01-05
tags: ["medium", "bfs", "dfs", "graph", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-05
- 提交紀錄：Accepted（一次通過）

## 解題思路

在 index `i` 可以跳到 `i + arr[i]` 或 `i - arr[i]`。問從 `start` 出發，能不能跳到任何一個值為 0 的位置。

把每個 index 當成圖的節點、兩種跳法當成邊，就是**可達性**問題：BFS 或 DFS 都可以，記得標記走過的位置，避免來回跳。

## 我的解法

原本是遞迴 DFS：

```python
def dfs(idx):
    if arr[idx] == 0:
        return True
    reach[idx] = True
    res = False
    forward = idx + arr[idx]
    if forward < n and not reach[forward]:
        res |= dfs(forward)
    backward = idx - arr[idx]
    if backward >= 0 and not reach[backward]:
        res |= dfs(backward)
    return res
```

可以 AC，但 `n` 到 `5 * 10^4`，遞迴深度可能超過 Python 的上限。另外 `res |= ...` 在找到之後還會繼續探索另一邊，可以直接回傳。改成 BFS：

```python
from collections import deque

class Solution:
    def canReach(self, arr: List[int], start: int) -> bool:
        n = len(arr)
        seen = [False] * n
        seen[start] = True
        q = deque([start])
        while q:
            i = q.popleft()
            if arr[i] == 0:
                return True
            for j in (i + arr[i], i - arr[i]):
                if 0 <= j < n and not seen[j]:
                    seen[j] = True
                    q.append(j)
        return False
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 沒有標記走過的位置：會在兩個 index 之間來回跳，無限迴圈。
- 遞迴 DFS 在 `n` 很大時超過遞迴上限。

## 面試口說整理

我把每個 index 當成節點，往左右跳是兩條邊，問題就變成從 `start` 能不能走到值為 0 的節點。用 BFS 加上 `seen` 陣列，每個 index 最多進出 queue 一次，遇到 0 就回傳 `True`，時間 `O(n)`。
