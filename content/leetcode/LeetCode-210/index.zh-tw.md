---
title: "LeetCode 210: Course Schedule II"
summary: "LeetCode 210 解題筆記，依照原始 learning note 重新整理"
description: "2026-04-08 的 LeetCode 210 學習紀錄，包含筆記修正點與正確解法"
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

#### LC 210 — Course Schedule II (Topological Sort / Return Order)
- **Pattern:** Same as LC 207 but return the actual ordering
- **Key insight:** The order nodes are popped from the queue IS the topological order
- **Difference from LC 207:** Append each popped node to result list. If `len(result) == numCourses` → valid order exists.

## 整理補充

這是 `LC 207` 的回傳順序版本。建圖和 in-degree 一樣：edge 從 prerequisite 指向 course。差別是每個 pop 出來的 course 都要 append 到 `order`。只有當 `order` 長度等於 `numCourses` 時才是合法答案；如果有 cycle，就必須回傳空陣列，而不是 partial order。

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
from collections import deque
from typing import List

class Solution:
    def findOrder(self, numCourses: int, prerequisites: List[List[int]]) -> List[int]:
        graph = [[] for _ in range(numCourses)]
        indeg = [0] * numCourses
        for course, pre in prerequisites:
            graph[pre].append(course)
            indeg[course] += 1

        q = deque(i for i in range(numCourses) if indeg[i] == 0)
        order = []
        while q:
            node = q.popleft()
            order.append(node)
            for nei in graph[node]:
                indeg[nei] -= 1
                if indeg[nei] == 0:
                    q.append(nei)

        return order if len(order) == numCourses else []
```

## 複雜度

Time O(V+E), Space O(V+E).

## 要特別避免的錯誤

- Returning partial order when a cycle remains.
- Confusing prerequisite edge direction.

## 面試口說整理

我會使用和 Course Schedule 相同的 Kahn topo，只是每次 pop course 時把它加進 `order`。如果最後 `order` 沒有包含所有課，代表 cycle 擋住一些節點，這時必須回傳空陣列。
