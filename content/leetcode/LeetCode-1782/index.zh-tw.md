---
title: "LeetCode 1782: Count Pairs Of Nodes"
summary: "LeetCode 1782 解題筆記：先用排序後的度數 + 對撞指針數 deg[a] + deg[b] > q 的配對，再對有共用邊的配對修正多算的部分"
description: "2026-01-24 的 LeetCode 1782 解題紀錄"
date: 2026-01-24
tags: ["hard", "two-pointers", "graph", "sorting", "hash-table", "counting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-01-24
- 提交紀錄：Wrong Answer → Runtime Error ×2 → Accepted

## 解題思路

`incident(a, b) = deg[a] + deg[b] - shared(a, b)`，`shared(a, b)` 是 `a`、`b` 之間的邊數（可能有重邊）。

直接枚舉所有點對是 `O(n^2)`，太慢。拆成兩步：

1. **先忽略 `shared`**：數 `deg[a] + deg[b] > q` 的配對數。把度數排序後，用對撞指針：
   - `deg[left] + deg[right] > q`：`left..right - 1` 每一個跟 `right` 配都成立，加上 `right - left`，`right` 往左。
   - 否則 `left` 往右。
2. **修正**：只有真的相連的點對，`shared > 0`。對每一對相連的 `(u, v)`，如果 `deg[u] + deg[v] > q` 但 `deg[u] + deg[v] - shared <= q`，代表第一步多算了，減 1。

相連的點對最多 `E` 對，所以每個查詢是 `O(n + E)`。

## 我的嘗試

1. **第一版 WA**：`shared` 的 key 直接用 `(u, v)`，沒有把小的放前面，所以 `[1, 2]` 和 `[2, 1]` 這兩條重邊被當成兩組不同的點對，各自只有 1 條共用邊，修正量算錯。例如 `n = 2`、`edges = [[1, 2], [2, 1]]`、`queries = [2]`：`incident(1, 2) = 2`，不大於 2，答案是 `[0]`，這版回傳 `[1]`。
2. **兩次 RE**：補上交換時打錯變數名稱，一次寫成 `u, v`（還沒定義），一次寫成 `i, j = j, v`。

## 正確解法

```python
class Solution:
    def countPairs(self, n: int, edges: List[List[int]], queries: List[int]) -> List[int]:
        deg = [0] * (n + 1)
        shared = Counter()
        for u, v in edges:
            deg[u] += 1
            deg[v] += 1
            shared[(min(u, v), max(u, v))] += 1   # 重邊要合併到同一個 key

        sorted_deg = sorted(deg[1:])
        ans = []
        for q in queries:
            count = 0
            left, right = 0, n - 1
            while left < right:
                if sorted_deg[left] + sorted_deg[right] > q:
                    count += right - left
                    right -= 1
                else:
                    left += 1
            for (u, v), c in shared.items():
                if deg[u] + deg[v] > q >= deg[u] + deg[v] - c:
                    count -= 1                     # 扣掉共用邊後就不成立
            ans.append(count)
        return ans
```

## 複雜度

時間 `O(n log n + Q · (n + E))`，空間 `O(n + E)`。

## 要特別避免的錯誤

- 無向邊的 key 沒有正規化，重邊被拆成兩組。
- 直接 `O(n^2)` 枚舉點對。

## 面試口說整理

`incident(a, b)` 等於兩點度數相加減掉它們之間的邊數。我先忽略共用邊，把度數排序後用對撞指針數度數和大於 `q` 的配對；再對每一對真的相連的點檢查，如果度數和大於 `q`、扣掉共用邊後卻不大於 `q`，就減一。每個查詢 `O(n + E)`。
