---
title: "LeetCode 834: Sum of Distances in Tree"
summary: "LeetCode 834 解題筆記：換根 DP：先以 0 為根算子樹大小和 ans[0]，再用 ans[child] = ans[parent] - size + (n - size) 推到每個節點"
description: "2026-10-31 的 LeetCode 834 解題紀錄"
date: 2026-10-31
tags: ["hard", "dynamic-programming", "tree", "depth-first-search", "graph", "dp-on-trees"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-10-31
- 提交紀錄：Wrong Answer → Accepted ×3

## 解題思路

對每個節點都跑一次 BFS 是 `O(n^2)`，`n` 到 `3 * 10^4` 會超時。用換根 DP，兩次走訪就好：

1. **以 0 為根**，由下往上算：
   - `count[v]`：`v` 的子樹有幾個節點。
   - `ans[v]`：`v` 到它子樹裡所有節點的距離和。`ans[p] += ans[v] + count[v]`，因為 `v` 子樹裡每個節點到 `p` 都比到 `v` 多 1。
   - 做完之後 `ans[0]` 就是正確答案。
2. **由上往下換根**：根從 `p` 移到小孩 `v` 時，`v` 子樹裡的 `count[v]` 個節點各近 1，其他 `n - count[v]` 個節點各遠 1：

   `ans[v] = ans[p] - count[v] + (n - count[v])`

用 BFS 得到的順序 `order`：反著走就是由下往上，正著走就是由上往下，不用遞迴（樹可能是一條長鏈）。

## 我的嘗試

1. 兩個迴圈裡應該用 `node` 的地方寫成了 `u`。`u` 是前面建圖迴圈留下來的變數，Python 不會報錯，只會一直用最後一條邊的端點，答案全錯：`n = 2, edges = [[0,1]]` 回傳 `[0,0]`，答案是 `[1,1]`。同一份還有 `p != 1`（應該是 `-1`）的筆誤，`order` 也漏了根。
2. 修好就過了。之後同一天又從頭寫了兩次，都一次通過。

## 正確解法

```python
class Solution:
    def sumOfDistancesInTree(self, n: int, edges: List[List[int]]) -> List[int]:
        graph = defaultdict(list)
        for u, v in edges:
            graph[u].append(v)
            graph[v].append(u)

        parent = [-1] * n
        seen = [False] * n
        seen[0] = True
        order = []
        queue = deque([0])
        while queue:
            node = queue.popleft()
            order.append(node)
            for nei in graph[node]:
                if not seen[nei]:
                    seen[nei] = True
                    parent[nei] = node
                    queue.append(nei)

        count = [1] * n
        ans = [0] * n
        for node in reversed(order):          # 由下往上
            p = parent[node]
            if p != -1:
                count[p] += count[node]
                ans[p] += ans[node] + count[node]

        for node in order:                    # 由上往下換根
            p = parent[node]
            if p != -1:
                ans[node] = ans[p] - count[node] + (n - count[node])
        return ans
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 換根時要用 `ans[p]` 的**最終值**，所以第二次要由上往下走（BFS 順序），不能反著走。
- 第一次走完只有 `ans[0]` 是完整答案，其他 `ans[v]` 只是子樹內的距離和。
- 迴圈變數不要和外面的變數同名或打錯，Python 的迴圈變數離開迴圈後還在。

## 面試口說整理

我用換根 DP。先以 0 為根，由下往上算每個子樹的大小，和節點到子樹內所有點的距離和，這樣 `ans[0]` 就對了。根從父節點移到小孩時，小孩子樹裡的點各近 1，其他點各遠 1，所以 `ans[v] = ans[p] - count[v] + n - count[v]`，由上往下推一次。兩次走訪，時間 `O(n)`。
