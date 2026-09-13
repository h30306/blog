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


## Organized Notes

This is dependency unlocking rather than ordinary course scheduling. Supplies are already available, and recipes become available only after every missing ingredient has been seen. The important repair point from the note is not to fail immediately when an ingredient is not initially available; it may be produced by another recipe later. That is why each newly unlocked recipe is pushed back into the queue as a future ingredient.

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

I would treat supplies and completed recipes as available ingredients. Each recipe tracks how many ingredients are still missing. When an available item reduces a recipe's missing count to zero, that recipe becomes both an answer and a new available ingredient.
