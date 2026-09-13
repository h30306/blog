---
title: "LeetCode 207: Course Schedule"
summary: "LeetCode 207 解題筆記，依照原始 learning note 重新整理"
description: "2026-04-08 的 LeetCode 207 學習紀錄，包含筆記修正點與正確解法"
date: 2026-04-08
tags: ["medium", "graph", "topological-sort"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-04-08
來源：Day 1 learning note

## 學習脈絡

這篇是從 learning note 裡該 LeetCode 題目的段落重新整理出來的版本。我保留當天筆記中的修正點、比較點、容易犯錯的地方，並移除同一天其他非 LeetCode 主題，避免文章內容混題。

## 當天筆記摘錄

#### LC 207 - Course Schedule (Topological Sort / Cycle Detection)
- **Pattern:** Topological Sort (Kahn's BFS)
- **Key insight:** 如果存在合法 topological ordering，代表沒有 cycle，可以回傳 true。
- **Approach:** 建 adjacency list 和 in-degree array。先把 in-degree 為 0 的課放進 queue。每 pop 一門課，就把後續課程的 in-degree 減 1；如果變成 0，就加入 queue。最後如果處理過的課數等於 `numCourses`，代表沒有 cycle。
- **Complexity:** Time O(V + E), Space O(V + E)
- **Why deque over list:** `list.pop(0)` 是 O(n)，因為會搬移元素；`deque.popleft()` 是 O(1)。


## 整理補充

這篇只保留 boolean cycle detection 版本。`LC 210` 也是 topo，但它要回傳 order；`LC 207` 只需要判斷能不能把所有課都處理完。兩個修正點最重要：edge direction 要是 `pre -> course`，而且不能在 queue 還沒處理完整張圖以前就提早回傳 true。

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
from collections import deque
from typing import List

class Solution:
    def canFinish(self, numCourses: int, prerequisites: List[List[int]]) -> bool:
        graph = [[] for _ in range(numCourses)]
        indeg = [0] * numCourses
        for course, pre in prerequisites:
            graph[pre].append(course)
            indeg[course] += 1

        q = deque(i for i in range(numCourses) if indeg[i] == 0)
        seen = 0
        while q:
            node = q.popleft()
            seen += 1
            for nei in graph[node]:
                indeg[nei] -= 1
                if indeg[nei] == 0:
                    q.append(nei)

        return seen == numCourses
```

## 複雜度

Time O(V+E), Space O(V+E).

## 要特別避免的錯誤

- Reversing edge direction inconsistently.
- Returning true before checking all nodes.

## 面試口說整理

我會先建 `pre -> course` 的 graph，然後用 Kahn topo 算可以處理幾門課。如果有 cycle，queue 會在所有課被處理完之前清空；所以 `seen == numCourses` 就是沒有 cycle、所有 prerequisite 可被滿足的證明。
