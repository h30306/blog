---
title: "Segment Tree 與 Fenwick Tree"
summary: "單點更新、區間查詢：Fenwick Tree（樹狀陣列）用 i & -i 跳，線段樹用遞迴把區間切兩半；兩者都是每次操作 O(log n)"
description: "演算法學習"
date: 2026-10-21
tags: ["segment-tree", "binary-indexed-tree", "design"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 介紹

[Prefix Sum]({{< relref "/algorithm/Prefix-Sum" >}}) 查詢區間和是 `O(1)`，但只要改一個值，整個前綴陣列都要重算，`O(n)`。陣列會被修改時，要用能「部分更新」的結構：

| 結構 | 更新 | 查詢 | 適合 |
|---|---|---|---|
| 前綴和 | `O(n)` | `O(1)` | 不會修改 |
| Fenwick Tree | `O(log n)` | `O(log n)` | 單點更新 + 前綴和（可以相減得到區間和） |
| 線段樹 | `O(log n)` | `O(log n)` | 任何可以合併的區間運算（和、最大值、最小值），也能延伸到區間更新 |

## 模板一：Fenwick Tree（樹狀陣列）

`tree[i]` 管理一段長度是 `i & -i`（`i` 最低的 1）的區間。index 從 1 開始：

```python
class Fenwick:
    def __init__(self, n):
        self.tree = [0] * (n + 1)

    def add(self, i, delta):             # nums[i] += delta，i 從 1 開始
        while i < len(self.tree):
            self.tree[i] += delta
            i += i & -i                  # 往上：負責範圍包含 i 的下一格

    def prefix(self, i):                 # nums[1..i] 的和
        s = 0
        while i > 0:
            s += self.tree[i]
            i -= i & -i                  # 往左：去掉這格負責的範圍
        return s
```

區間和是 `prefix(r) - prefix(l - 1)`。題目給的是「改成 `val`」時，要先算出差值 `val - nums[i]` 再 `add`，所以要另外存一份原陣列。

## 模板二：線段樹

節點 `node` 管理 `[start, end]`，左右小孩是 `2 * node + 1`、`2 * node + 2`，陣列開 `4n`：

```python
def build(node, start, end):
    if start == end:
        tree[node] = nums[start]
        return
    mid = (start + end) // 2
    build(2 * node + 1, start, mid)
    build(2 * node + 2, mid + 1, end)
    tree[node] = tree[2 * node + 1] + tree[2 * node + 2]

def query(node, start, end, l, r):
    if r < start or end < l:             # 完全不重疊
        return 0
    if l <= start and end <= r:          # 完全被包含
        return tree[node]
    mid = (start + end) // 2
    return query(2 * node + 1, start, mid, l, r) + query(2 * node + 2, mid + 1, end, l, r)
```

更新跟建樹一樣往下找到葉子，改完再一路把父節點重算。

- **可修改的區間和**（LC 307）：兩種都可以；Fenwick 程式短，線段樹比較好延伸。

## 主要參數說明

- Fenwick 的 index 從 1 開始，`i & -i` 是 `i` 最低位的 1。
- 線段樹的區間是包含兩端的 `[start, end]`；`mid` 屬於左半邊。

## 複雜度

建樹 `O(n)`（Fenwick 一個一個 `add` 是 `O(n log n)`），每次更新和查詢 `O(log n)`，空間 `O(n)`。

## 常見錯誤

這些都是我練習時實際寫錯過的：

- **左右小孩算成同一個**：右小孩寫成 `2 * node + 1`，跟左小孩一樣（LC 307）。
- **遞迴算完沒有 `return`**：左右兩邊都查了，最後忘了回傳相加的結果，得到 `None`（LC 307）。

## 相關 LeetCode

- `LC 307` Range Sum Query - Mutable
