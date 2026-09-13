---
title: "LeetCode 2115: Find All Possible Recipes from Given Supplies"
summary: "LeetCode Problem Solving - Topological Sort / Dependency unlocking Key insight: Supplies are initially available nodes. A recipe becomes available when all its required ingredients are available. Approach: Build graph from ingredient reci"
description: "LeetCode study note from 2026-04-11"
date: 2026-04-11
tags: ["leetcode", "medium", "graph", "topological-sort"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-04-11
Source Note: `notes/day3-topological-sort-tcp-sockets-load-balancer.md`

## Intuition

Pattern: Topological Sort / Dependency unlocking Key insight: Supplies are initially available nodes. A recipe becomes available when all its required ingredients are available. Approach: Build graph from ingredient reci

Pattern: Topological Sort / Dependency unlocking

## Approach

- **Pattern:** Topological Sort / Dependency unlocking
- **Key insight:** Supplies are initially available nodes. A recipe becomes available when all its required ingredients are available.
- **Approach:** Build graph from `ingredient -> recipes depending on it`. Track each recipe's in-degree as number of missing ingredients. Start BFS queue with all supplies. When an available ingredient unlocks a recipe, decrement that recipe's in-degree. If it becomes 0, add recipe to answer and queue because it can become an ingredient for other recipes.
- **Mental model:** This is like Course Schedule, but starting nodes are supplies instead of zero in-degree recipes only.
- **Cycle behavior:** Recipes in cycles or recipes depending on unavailable ingredients never reach in-degree 0.
- **Complexity:** Time O(total ingredients + recipes), Space O(total ingredients + recipes)
- **Common bugs:** Building edge direction as `recipe -> ingredient`, not adding newly created recipes back into the queue, treating unavailable ingredients as immediate failure instead of simply never unlocking.

## Findings

- Keep the state meaning explicit before writing the transition.
- Check base cases and return value before trusting the recurrence.
- Explain why the iteration order or traversal order preserves the intended invariant.

## Encountered Problems

Captured from the learning note; no separate failure note was recorded.
