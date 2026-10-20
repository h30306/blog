---
title: "Grid DP"
summary: "Counting, cost optimization, reverse resource DP, and local geometry"
description: "Algorithm Learning"
date: 2026-09-13
tags: ["dynamic-programming", "grid-dp"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Introduction

Grid DP is used when movement rules create local dependencies between cells. The most important step is defining exactly what each cell means:

- number of ways to reach this cell
- minimum cost to reach this cell
- minimum health required when entering this cell
- largest square ending at this cell

Changing that state changes the recurrence.

## Counting Paths

For right/down movement without obstacles:

```text
dp[r][c] = number of paths from start to (r, c)
dp[r][c] = dp[r - 1][c] + dp[r][c - 1]
```

With obstacles, blocked cells contribute `0` paths.

## Minimum Cost Paths

For minimum path sum:

```text
dp[r][c] = minimum cost to reach (r, c)
dp[r][c] = grid[r][c] + min(up, left)
```

This is not the same recurrence as counting paths. Counting adds both predecessors; optimization chooses the cheaper predecessor.

## Reverse DP

Some grid problems are easier backward. In Dungeon Game:

```text
dp[r][c] = minimum health required upon entering (r, c)
```

The recurrence looks forward to the cheaper required next state, then clamps health to at least `1`.

## Local Geometry DP

For square problems:

```text
dp[r][c] = side length of the largest all-1 square ending at (r, c)
```

If the current cell is `1`:

```text
dp[r][c] = 1 + min(top, left, diagonal)
```

The diagonal is required because a larger square needs a valid inner square.

## Grid DP + Extra State

When grid coordinates are not enough to describe the state, add a dimension:

- **At most k teleports** (LC 3651): compute layer by layer, where layer `t` has used `t` teleports. Teleporting into a cell costs the previous layer's minimum over all cells with value `>=` it, so sort cells by value descending, keep a running minimum, then run the usual right / down DP.
- **Parentheses paths** (LC 2267): the state is `(r, c, open-bracket balance)`. The balance can never be negative or exceed the remaining steps (or it could never close).
- **Strictly increasing paths** (LC 2328): moves go in four directions, but values strictly increase, so there are no cycles. Process cells from largest to smallest value with `dp[cell] = 1 + Σ dp[larger neighbors]`, or memoize a DFS.

## Common Mistakes

- Writing a recurrence before saying what `dp[r][c]` means.
- Returning bottom-right when the path can end anywhere in the last row.
- Using count-path addition for min-cost problems.
- Forgetting first row and first column boundary behavior.
- Using forward DP when the state really needs future survival constraints.

## Related LeetCode

- `LC 62` Unique Paths
- `LC 63` Unique Paths II
- `LC 64` Minimum Path Sum
- `LC 120` Triangle
- `LC 174` Dungeon Game
- `LC 221` Maximal Square
- `LC 576` Out of Boundary Paths
- `LC 931` Minimum Falling Path Sum
- `LC 1277` Count Square Submatrices With All Ones
- `LC 1289` Minimum Falling Path Sum II
- `LC 3651` Minimum Cost Path with Teleportations
- `LC 2267` Check if There Is a Valid Parentheses String Path
- `LC 2328` Number of Increasing Paths in a Grid
