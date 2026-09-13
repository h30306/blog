---
title: "LeetCode 269: Alien Dictionary"
summary: "LeetCode 269 解題筆記，依照原始 learning note 重新整理"
description: "2026-04-26 的 LeetCode 269 學習紀錄，包含筆記修正點與正確解法"
date: 2026-04-26
tags: ["hard", "graph", "topological-sort"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-04-26
來源：Day 12 learning note

## 學習脈絡

這篇是從 learning note 裡該 LeetCode 題目的段落重新整理出來的版本。我保留當天筆記中的修正點、比較點、容易犯錯的地方，並移除同一天其他非 LeetCode 主題，避免文章內容混題。

## 筆記中提到的相關提醒

- **LC 269 Alien Dictionary:** Good enough explanation; implementation can still be cleaned up with set adjacency later.

## 當天筆記摘錄

#### Problem 2 - LC 269 Alien Dictionary Review
- **Status:** Good enough pattern recognition; implementation detail still needs care.
- **Pattern:** Topological sort on characters.

#### Correct Graph Construction
- initialize all characters as graph nodes
- compare adjacent word pairs only
- use only the first different character
- invalid prefix case:
```text
["abc", "ab"] -> ""
```

#### Cycle Detection
Use Kahn's topological sort.

If the result length is smaller than the number of unique characters:
```text
cycle exists -> return ""
```

#### Important Implementation Detail
Today’s code using list adjacency is still workable, because duplicate indegree increments are matched by duplicate decrements later.

But interview-cleaner version is:
```text
use set adjacency to avoid parallel-edge bookkeeping
```

That is easier to explain and less fragile.

#### Interview-Ready Explanation
I build a directed graph over characters using adjacent word pairs only. For each pair, the first different character gives the ordering edge. If the first word is a strict prefix extension of the second, the order is invalid and I return an empty string. Then I run Kahn's topological sort. If I cannot process all characters, there is a cycle.

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
from collections import deque
from typing import List

class Solution:
    def alienOrder(self, words: List[str]) -> str:
        graph = {c: set() for word in words for c in word}
        indeg = {c: 0 for c in graph}

        for w1, w2 in zip(words, words[1:]):
            if len(w1) > len(w2) and w1.startswith(w2):
                return ''
            for a, b in zip(w1, w2):
                if a != b:
                    if b not in graph[a]:
                        graph[a].add(b)
                        indeg[b] += 1
                    break

        q = deque(c for c in indeg if indeg[c] == 0)
        order = []
        while q:
            c = q.popleft()
            order.append(c)
            for nei in graph[c]:
                indeg[nei] -= 1
                if indeg[nei] == 0:
                    q.append(nei)

        return ''.join(order) if len(order) == len(indeg) else ''
```

## 複雜度

Time O(total characters + edges), Space O(unique characters + edges).

## 要特別避免的錯誤

- Using every differing character instead of only the first.
- Missing invalid prefix case like abc before ab.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
