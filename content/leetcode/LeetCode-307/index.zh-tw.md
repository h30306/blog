---
title: "LeetCode 307: Range Sum Query - Mutable"
summary: "LeetCode 307 解題筆記：單點更新加區間和，前綴和每次更新要 O(n)；用線段樹或 Fenwick Tree，兩種操作都是 O(log n)"
description: "2026-06-19 的 LeetCode 307 解題紀錄"
date: 2026-06-19
tags: ["medium", "segment-tree", "binary-indexed-tree", "design", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-06-19
- 提交紀錄：Wrong Answer → Accepted

## 解題思路

[Prefix Sum]({{< relref "/algorithm/Prefix-Sum" >}}) 查詢 `O(1)`，但每次 `update` 都要重算後面的前綴，`O(n)`。更新和查詢次數都到 `3 × 10^4`，要讓兩種操作都是 `O(log n)`（[Segment Tree]({{< relref "/algorithm/Segment-Tree" >}})）：

- **線段樹**：每個節點存一段區間的和，左右小孩各管一半。更新時往下找到葉子、回來時重算父節點；查詢時完全包含的節點直接回傳，不重疊的回傳 0，部分重疊的往下分。
- **Fenwick Tree**：程式更短，`update` 先算差值再 `add`，區間和是兩個前綴相減。

## 我的嘗試

我用遞迴的線段樹。第一版的 `sumRange` 有兩個錯：右小孩寫成 `2 * node + 1`（跟左小孩一樣），而且左右兩邊都查完之後**忘了 `return left_sum + right_sum`**，部分重疊的節點回傳 `None`。修好就 AC 了。

## 正確解法

```python
class NumArray:
    def __init__(self, nums: List[int]):
        self.n = len(nums)
        self.tree = [0] * (4 * self.n)
        self._build(nums, 0, 0, self.n - 1)

    def _build(self, nums, node, start, end):
        if start == end:
            self.tree[node] = nums[start]
            return
        mid = (start + end) // 2
        self._build(nums, 2 * node + 1, start, mid)
        self._build(nums, 2 * node + 2, mid + 1, end)
        self.tree[node] = self.tree[2 * node + 1] + self.tree[2 * node + 2]

    def update(self, index: int, val: int) -> None:
        def go(node, start, end):
            if start == end:
                self.tree[node] = val
                return
            mid = (start + end) // 2
            if index <= mid:
                go(2 * node + 1, start, mid)
            else:
                go(2 * node + 2, mid + 1, end)
            self.tree[node] = self.tree[2 * node + 1] + self.tree[2 * node + 2]
        go(0, 0, self.n - 1)

    def sumRange(self, left: int, right: int) -> int:
        def go(node, start, end):
            if right < start or end < left:
                return 0
            if left <= start and end <= right:
                return self.tree[node]
            mid = (start + end) // 2
            return go(2 * node + 1, start, mid) + go(2 * node + 2, mid + 1, end)
        return go(0, 0, self.n - 1)
```

## 複雜度

建樹 `O(n)`，`update` 和 `sumRange` 各 `O(log n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 左右小孩是 `2 * node + 1` 和 `2 * node + 2`，複製貼上時特別容易寫成同一個。
- 遞迴函式每一條路徑都要有回傳值。

## 面試口說整理

會修改的區間和不能用前綴和，因為每次更新要 `O(n)`。我用線段樹，每個節點存它那一段的和；更新時找到葉子、回來重算祖先，查詢時完全包含的節點直接用、不重疊的回傳 0、其他的往下分。兩種操作都是 `O(log n)`。Fenwick Tree 也可以，程式更短。
