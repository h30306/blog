---
title: "LeetCode 851: Loud and Rich"
summary: "LeetCode 851 解題筆記，依照原始 learning note 重新整理"
description: "2026-04-13 的 LeetCode 851 學習紀錄，包含筆記修正點與正確解法"
date: 2026-04-13
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
第一次嘗試：2026-04-13
來源：Day 4 learning note

## 學習脈絡

這篇是從 learning note 裡該 LeetCode 題目的段落重新整理出來的版本。我保留當天筆記中的修正點、比較點、容易犯錯的地方，並移除同一天其他非 LeetCode 主題，避免文章內容混題。

## 當天筆記摘錄

#### LC 851 - Loud and Rich
- **Status:** Completed.
- **Pattern:** Topological BFS propagation.
- **Target:** 練習在 medium-level dependency graph 上做 topo propagation。
- **Interview focus:** 選對 graph direction，並把 quietest richer person 從 richer node 傳到 poorer node。
- **Graph direction:** `richer -> poorer`。
- **Why this direction:** richer node 已知的最安靜人選，會影響所有比它 poorer 的人。
- **State meaning:** `answer[i]` 存的是 person index，代表目前已知「至少跟 i 一樣有錢的人」裡最安靜的人，不是 quiet value 本身。
- **Update rule:** 處理 `rich -> poor` 時，如果 `quiet[answer[rich]] < quiet[answer[poor]]`，就設定 `answer[poor] = answer[rich]`。
- **Queue initialization:** 從 indegree 0 的人開始，也就是沒有人比他更 rich。
- **Complexity:** O(n + richer.length), Space O(n + richer.length).


## 整理補充

關鍵是 richer information 要從 richer people 流向 poorer people。`answer[i]` 存的是 index，不是 quietness value；它代表目前已知所有至少跟 `i` 一樣 rich 的人裡，最安靜的那個人。從沒有人比他更 rich 的節點開始做 topo，處理 `rich -> poor` 時，要比較 `quiet[answer[rich]]` 和 `quiet[answer[poor]]`，不能比較 person id。

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
from collections import deque
from typing import List

class Solution:
    def loudAndRich(self, richer: List[List[int]], quiet: List[int]) -> List[int]:
        n = len(quiet)
        graph = [[] for _ in range(n)]
        indeg = [0] * n
        for rich, poor in richer:
            graph[rich].append(poor)
            indeg[poor] += 1

        ans = list(range(n))
        q = deque(i for i in range(n) if indeg[i] == 0)
        while q:
            person = q.popleft()
            for poor in graph[person]:
                if quiet[ans[person]] < quiet[ans[poor]]:
                    ans[poor] = ans[person]
                indeg[poor] -= 1
                if indeg[poor] == 0:
                    q.append(poor)

        return ans
```

## 複雜度

Time O(n+e), Space O(n+e).

## 要特別避免的錯誤

- Reversing richer/poorer edge direction.
- Comparing person index instead of quiet value.

## 面試口說整理

我會說明 richer-to-poorer 是資訊流方向。`answer[i]` 存目前已知最安靜的 richer-or-equal person。處理 `rich -> poor` 時，rich 的最佳答案可能改善 poor；topo order 讓這個資訊能一路往下傳。
