---
title: "Backtracking"
summary: "The choose, recurse, undo template for subsets, permutations, constrained placement, grid search, and pruning"
description: "Algorithm Learning"
date: 2026-10-20
tags: ["backtracking", "recursion", "dfs", "pruning"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Introduction

Backtracking **tries every possibility systematically**: make one choice, recurse, undo the choice on the way back, and try the next one.

Signals:

- The problem asks for "all" combinations, permutations, subsets, or placements.
- The input is small, e.g. `n <= 15`, a board up to `9 × 9`, or up to 20 grid cells, so exponential time is acceptable.
- There are constraints such as "use each element once" or "visit each cell once".

## Template: Choose → Recurse → Undo

```python
def backtrack(state):
    if reached_the_end(state):
        record the answer
        return
    for choice in available_choices(state):
        if invalid(choice):
            continue
        make(choice)            # modify state
        backtrack(state)
        undo(choice)            # restore state
```

### Key Parameters:

- **Undo must mirror the choice exactly**: remove what was added to a set, restore the original character after marking `#`.
- **Copy when recording**: `res.append(path[:])`, or later undos will change answers already stored.
- **Prune as early as possible**: reject invalid choices before recursing, not only at the end.

## Variation 1: Subsets (take or skip each element)

```python
def backtrack(i, current):
    if i == n:
        record(current)
        return
    backtrack(i + 1, current | nums[i])   # take
    backtrack(i + 1, current)             # skip
```

There are `2^n` subsets. LC 2044 prunes: once the current OR already equals the maximum, the remaining elements do not matter, so return `2^(remaining count)` directly.

With `n <= 16`, a bitmask loop over `range(1 << n)` also works.

## Variation 2: Placement with sets of occupied resources

N-Queens (LC 51) places one queen per row and tracks occupied columns and both diagonals with three sets:

```python
cols, diag1, diag2 = set(), set(), set()

def backtrack(row):
    if row == n:
        record the board
        return
    for col in range(n):
        if col in cols or row + col in diag1 or row - col in diag2:
            continue
        cols.add(col); diag1.add(row + col); diag2.add(row - col)
        backtrack(row + 1)
        cols.remove(col); diag1.remove(row + col); diag2.remove(row - col)
```

Cells on the same "/" diagonal share `row + col`; cells on the same "\" diagonal share `row - col`.

## Variation 3: Grid search, marking visited cells in place

```python
def dfs(r, c):
    original = grid[r][c]
    grid[r][c] = "#"                       # mark visited
    for dr, dc in ((1, 0), (-1, 0), (0, 1), (0, -1)):
        nr, nc = r + dr, c + dc
        if in_bounds and grid[nr][nc] != "#" and ...:
            dfs(nr, nc)
    grid[r][c] = original                  # undo
```

- LC 980: every empty cell must be visited exactly once; on reaching the end, check that the step count matches.
- LC 212: combined with a Trie, only move in directions that can still form a word.

## Pruning Techniques

| Technique | Example |
|---|---|
| Compute the required amount first and stop when exceeded | LC 301: count the minimum `(` and `)` deletions first; no more deletions once the budget is used |
| Compute the rest directly | LC 2044: once the OR is maximal, return `2^k` for the rest |
| Reject early with the constraints | LC 3799: compare first letters before going one level deeper |
| Remove found items from the structure | LC 212: remove found words from the Trie and delete empty nodes |

## When BFS Beats Backtracking

When the problem asks for all results with the **minimum** number of operations, BFS expands level by level and stops at the first level containing a valid result, which is often simpler than backtracking. The BFS version of LC 301 deletes one parenthesis at a time per level; the first level with a valid string is the answer.

## Complexity

Backtracking usually costs "number of solutions × cost per solution", e.g. `O(2^n)` for subsets and `O(n!)` for permutations. Pruning does not change the worst case, but saves a lot in practice.

## Common Mistakes

These are all mistakes I actually made while practicing:

- **Trying everything without computing the required deletions**: the first LC 301 attempt tried keeping or deleting every character and timed out.
- **Leaving a `print` in accepted code**: LC 3799; heavy output slows things down.
- **Reusing an outer variable name inside a comprehension**: LC 51 used `row` inside `for row in board`. Python 3 comprehensions have their own scope, so it worked, but it is easy to misread.
- **Not stopping at the end cell when the step count is wrong**: LC 980 keeps walking out of the end cell. It does not miscount, but wastes time.

## Related LeetCode

- `LC 2044` Count Number of Maximum Bitwise-OR Subsets
- `LC 3799` Word Squares II
- `LC 51` N-Queens
- `LC 980` Unique Paths III
- `LC 301` Remove Invalid Parentheses
- `LC 212` Word Search II
