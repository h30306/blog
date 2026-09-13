---
title: "LeetCode 2115: Find All Possible Recipes from Given Supplies"
summary: "LeetCode 2115 解題筆記，依照原始 learning note 重新整理"
description: "2026-04-11 的 LeetCode 2115 學習紀錄，包含筆記修正點與正確解法"
date: 2026-04-11
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
第一次嘗試：2026-04-11
來源：Day 3 learning note

## 學習脈絡

這篇是從 learning note 裡該 LeetCode 題目的段落重新整理出來的版本。我保留當天筆記中的修正點、比較點、容易犯錯的地方，並移除同一天其他非 LeetCode 主題，避免文章內容混題。

## 當天筆記摘錄

#### LC 2115 - Find All Possible Recipes from Given Supplies
- **Pattern:** Topological Sort / Dependency unlocking
- **Key insight:** Supplies are initially available nodes. A recipe becomes available when all its required ingredients are available.
- **Approach:** Build graph from `ingredient -> recipes depending on it`. Track each recipe's in-degree as number of missing ingredients. Start BFS queue with all supplies. When an available ingredient unlocks a recipe, decrement that recipe's in-degree. If it becomes 0, add recipe to answer and queue because it can become an ingredient for other recipes.
- **Mental model:** This is like Course Schedule, but starting nodes are supplies instead of zero in-degree recipes only.
- **Cycle behavior:** Recipes in cycles or recipes depending on unavailable ingredients never reach in-degree 0.
- **Complexity:** Time O(total ingredients + recipes), Space O(total ingredients + recipes)
- **Common bugs:** Building edge direction as `recipe -> ingredient`, not adding newly created recipes back into the queue, treating unavailable ingredients as immediate failure instead of simply never unlocking.

#### LC 310 - Minimum Height Trees
- **Pattern:** Topological-style leaf trimming on an undirected tree
- **Key insight:** The root of a minimum height tree must be the center of the tree. A tree has either 1 or 2 centers.
- **Approach:** Build undirected adjacency sets and degree array. Start with all leaves where degree is 1. Remove leaves layer by layer. Each removal reduces neighbor degree. New leaves are added to the queue. Stop when remaining nodes <= 2.
- **Why leaf trimming works:** The farthest nodes from the center are leaves. Removing outer layers repeatedly leaves the center node(s).
- **Special case:** If `n == 1`, return `[0]`.
- **Complexity:** Time O(n), Space O(n)
- **Common bugs:** Treating this as directed topo sort, forgetting `n == 1`, returning removed leaves instead of remaining centers, not decrementing remaining node count.

#### Pattern Comparison
- **Alien Dictionary:** Directed graph ordering problem.
- **Recipes:** Directed dependency unlocking problem.
- **Minimum Height Trees:** Undirected tree center problem using topo-style pruning.
- **Interview distinction:** Topological sort is not only one template. The same in-degree idea can model ordering, availability, or layer removal, but the graph direction and meaning must be explained clearly.

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
from collections import defaultdict, deque
from typing import List

class Solution:
    def findAllRecipes(self, recipes: List[str], ingredients: List[List[str]], supplies: List[str]) -> List[str]:
        graph = defaultdict(list)
        need = {}

        for recipe, ing_list in zip(recipes, ingredients):
            need[recipe] = len(ing_list)
            for ing in ing_list:
                graph[ing].append(recipe)

        q = deque(supplies)
        ans = []
        while q:
            item = q.popleft()
            for recipe in graph[item]:
                need[recipe] -= 1
                if need[recipe] == 0:
                    ans.append(recipe)
                    q.append(recipe)

        return ans
```

## 複雜度

Time O(total ingredients + supplies + recipes), Space O(total ingredients).

## 要特別避免的錯誤

- Adding unavailable ingredients to the queue.
- Forgetting recipes can become ingredients for later recipes.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
