---
title: "LeetCode 1631: Path With Minimum Effort"
summary: "LeetCode 1631 解題筆記，依照原始 learning note 重新整理"
description: "2026-04-25 的 LeetCode 1631 學習紀錄，包含筆記修正點與正確解法"
date: 2026-04-25
tags: ["medium", "graph", "dijkstra", "shortest-path"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-04-25
來源：Day 10 learning note

## 學習脈絡

這篇是從 learning note 裡該 LeetCode 題目的段落重新整理出來的版本。我保留當天筆記中的修正點、比較點、容易犯錯的地方，並移除同一天其他非 LeetCode 主題，避免文章內容混題。

## 筆記中提到的相關提醒

- 4. Explain why `LC 1631` is still Dijkstra even though the path cost is not a sum.

## 當天筆記摘錄

#### Problem 3 - LC 1631 Path With Minimum Effort Review
- **Status:** Good enough after wording repair.
- **Pattern:** Dijkstra on a grid with non-sum path cost.

#### Why Dijkstra Still Works
The path cost is not the sum of edge weights.

Instead:
```text
new_effort = max(current_effort, abs(height_diff))
```

That means the path effort is:
```text
non-decreasing as the path extends
```

not strictly increasing.

That monotonic property is why Dijkstra still works.

#### Heap State
```text
(effort, row, col)
```

#### Transition
For each neighbor:
```text
new_effort = max(current_effort, abs(heights[r][c] - heights[nr][nc]))
```

#### Finalization Rule
```text
when a cell is popped from the min-heap for the first time, its minimum effort is finalized
```

#### Complexity
```text
Time: O(R * C * log(R * C))
Space: O(R * C)
```

#### Common Mistakes
- Do not say the effort strictly increases.
- Do not say time is just `O(R * C)`; heap operations add a log factor.
- Do not say a public key decrypts a signature in the TLS analogy. That was a separate wording issue from the topic block.

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
from heapq import heappop, heappush
from typing import List

class Solution:
    def minimumEffortPath(self, heights: List[List[int]]) -> int:
        m, n = len(heights), len(heights[0])
        dist = [[float('inf')] * n for _ in range(m)]
        dist[0][0] = 0
        heap = [(0, 0, 0)]
        dirs = [(1,0), (-1,0), (0,1), (0,-1)]

        while heap:
            effort, r, c = heappop(heap)
            if (r, c) == (m - 1, n - 1):
                return effort
            if effort != dist[r][c]:
                continue
            for dr, dc in dirs:
                nr, nc = r + dr, c + dc
                if 0 <= nr < m and 0 <= nc < n:
                    ne = max(effort, abs(heights[r][c] - heights[nr][nc]))
                    if ne < dist[nr][nc]:
                        dist[nr][nc] = ne
                        heappush(heap, (ne, nr, nc))
        return 0
```

## 複雜度

Time O(mn log(mn)), Space O(mn).

## 要特別避免的錯誤

- Summing edge weights instead of taking max.
- Using plain BFS despite weighted efforts.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
