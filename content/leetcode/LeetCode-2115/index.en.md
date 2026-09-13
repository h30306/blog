---
title: "LeetCode 2115: Find All Possible Recipes from Given Supplies"
summary: "LeetCode note for Find All Possible Recipes from Given Supplies, rebuilt from the original learning note"
description: "Cleaned LeetCode 2115 article from 2026-04-11 with note repair points and final solution"
date: 2026-04-11
tags: ["medium", "graph", "topological-sort"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-04-11
Source: Day 3 learning note

## Study Context

This article is rebuilt from the exact LeetCode section in the learning note. I kept the note's repair points, comparison points, and common mistakes, while removing unrelated non-LeetCode material from the same day.

## Learning Note Extract

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

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

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

## Complexity

Time O(total ingredients + supplies + recipes), Space O(total ingredients).

## Mistakes To Watch

- Adding unavailable ingredients to the queue.
- Forgetting recipes can become ingredients for later recipes.

## Final Interview Explanation

Start from the state definition, then explain why the transition preserves that state. If there is a loop direction, state compression, or a similar-looking problem with a different answer shape, call that out explicitly because that is where this problem family usually breaks down.
