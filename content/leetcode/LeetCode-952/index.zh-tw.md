---
title: "LeetCode 952: Largest Component Size by Common Factor"
summary: "LeetCode 952 解題筆記：有共同因數 ⇔ 有共同的質因數；把每個數分解質因數，同一個質因數的 index 用 Union-Find 合併，不用兩兩算 GCD"
description: "2025-05-10 的 LeetCode 952 解題紀錄"
date: 2025-05-10
tags: ["hard", "math", "number-theory", "union-find", "hash-table", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2025-05-10
- 提交紀錄：TLE ×2 → AC（2025-05-17）→ TLE → AC ×2（2026-10-12 重寫）

## 解題思路

兩個數有大於 1 的公因數 ⇔ **有共同的質因數**。

- 兩兩算 GCD 是 `O(n^2 log M)`，`n = 2 × 10^4` 會超時。
- 改成對每個數**分解質因數**（試除到 `√x`），記錄每個質因數第一次出現的 index `owner[p]`。之後再遇到同一個質因數，就跟 `owner[p]` 合併。

最後數每一組的大小，取最大值。

## 我的嘗試

| 時間 | 版本 | 問題 |
|---|---|---|
| 2025-05 | 兩次 TLE | 兩兩算 GCD，`O(n^2)` |
| 2025-05 | AC | 改成依質因數分組，每組相鄰的 index 合併 |
| 2026-10 | TLE | 重寫時又回到兩兩算 GCD |
| 2026-10 | AC（3.9 秒） | 改成 `owner[p]`，但 `find` 寫成 `return find(parent[a])`，**沒有存回 `parent[a]`**，等於沒有路徑壓縮 |
| 2026-10 | AC（1.3 秒） | 補上路徑壓縮 |

## 正確解法

```python
class Solution:
    def largestComponentSize(self, nums: List[int]) -> int:
        n = len(nums)
        parent = list(range(n))

        def find(a: int) -> int:
            if parent[a] != a:
                parent[a] = find(parent[a])        # 路徑壓縮：存回去
            return parent[a]

        def union(a: int, b: int) -> None:
            ra, rb = find(a), find(b)
            if ra != rb:
                parent[ra] = rb

        owner = {}                                 # 質因數 -> 第一個擁有它的 index

        def link(i: int, p: int) -> None:
            if p in owner:
                union(i, owner[p])
            else:
                owner[p] = i

        for i, x in enumerate(nums):
            p = 2
            while p * p <= x:
                if x % p == 0:
                    link(i, p)
                    while x % p == 0:
                        x //= p
                p += 1
            if x > 1:
                link(i, x)                         # 剩下的大質因數

        return max(Counter(find(i) for i in range(n)).values())
```

## 複雜度

時間 `O(n √M)`（試除），`M` 是最大值；用 SPF 篩可以降到 `O(M + n log M)`。空間 `O(n + 質因數數量)`。

## 要特別避免的錯誤

- 兩兩算 GCD：`O(n^2)`。
- `find` 沒有把結果存回去：等於沒有路徑壓縮。
- 試除完剩下的 `x > 1` 也是質因數。

## 面試口說整理

有共同因數就等於有共同的質因數，所以我不兩兩算 GCD，而是把每個數分解質因數，記下每個質因數第一次出現的 index，之後遇到同一個質因數就用 Union-Find 合併。最後數每一組的大小。時間 `O(n √M)`。
