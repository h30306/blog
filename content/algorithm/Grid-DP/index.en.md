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
