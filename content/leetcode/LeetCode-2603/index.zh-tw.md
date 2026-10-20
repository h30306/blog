---
title: "LeetCode 2603: Collect Coins in a Tree"
summary: "LeetCode 2603 解題筆記：先剪掉沒有硬幣的葉子，再固定剪兩層，剩下的邊走兩次"
description: "2026-06-26 的 LeetCode 2603 解題紀錄"
date: 2026-06-26
tags: ["hard", "tree", "graph", "topological-sort"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-06-26
- 提交紀錄：Wrong Answer ×2 → Accepted → Wrong Answer（重交舊版）→ Accepted

## 解題思路

可以從任意點出發，每到一個點就能收集距離 2 以內的硬幣，最後要回到起點。

關鍵是：**最後走過的路徑會是一棵子樹，而走完一棵子樹再回到起點，每條邊剛好走兩次。** 所以答案是「必須走的邊數 × 2」。

哪些邊必須走？用兩次剪葉子找出來：

1. **剪掉沒有硬幣的葉子**，而且要連鎖：剪掉之後，鄰居如果也變成沒有硬幣的葉子，就繼續剪。剪完之後，剩下的每片葉子都有硬幣。
2. **再固定剪兩層葉子**：站在距離葉子 2 步的位置，就能收到那片葉子的硬幣，所以最外面兩層不用真的走過去。

剩下的邊數乘以 2 就是答案。

## 我的嘗試

### 第一版：continue 讓連鎖剪枝失效

```python
while leaves:
    leaf = leaves.popleft()
    coins[leaf] = -1
    if coins[leaf]:          # 剛設成 -1，永遠是 True
        continue
    ...
```

先把 `coins[leaf]` 設成 `-1`，下一行又檢查它，`-1` 是 truthy，所以每片葉子都直接 `continue`，**鄰居的 degree 從來沒被扣**，只剪掉了第一層。

另外還留了一行 `print(neighbor, degree)` 除錯輸出。

### 第二版：把有硬幣的鄰居也剪掉

拿掉 `continue` 之後：

```python
if degree[neighbor] == 1:
    leaves.append(neighbor)      # 沒有檢查鄰居有沒有硬幣
```

鄰居變成葉子時，不管它有沒有硬幣都被放進 queue 剪掉，**有硬幣的節點被誤刪**。條件要改成 `degree[neighbor] == 1 and coins[neighbor] == 0`。

後來又不小心重交了一次舊版，所以中間多了一次 WA。

## 正確解法

```python
from collections import deque

class Solution:
    def collectTheCoins(self, coins: List[int], edges: List[List[int]]) -> int:
        n = len(coins)
        degree = [0] * n
        adj = [[] for _ in range(n)]
        for u, v in edges:
            adj[u].append(v)
            adj[v].append(u)
            degree[u] += 1
            degree[v] += 1

        # 第一階段：連鎖剪掉沒有硬幣的葉子
        leaves = deque(i for i in range(n) if degree[i] == 1 and coins[i] == 0)
        while leaves:
            leaf = leaves.popleft()
            coins[leaf] = -1                     # 標記為已刪除
            for nei in adj[leaf]:
                degree[nei] -= 1
                if degree[nei] == 1 and coins[nei] == 0:
                    leaves.append(nei)

        # 第二階段：在剩下的樹上固定剪兩層葉子
        degree = [0] * n
        adj = [[] for _ in range(n)]
        for u, v in edges:
            if coins[u] == -1 or coins[v] == -1:
                continue
            adj[u].append(v)
            adj[v].append(u)
            degree[u] += 1
            degree[v] += 1

        leaves = deque(i for i in range(n) if degree[i] == 1)
        while leaves:
            leaf = leaves.popleft()
            coins[leaf] = -1                     # 第一層
            for nei in adj[leaf]:
                degree[nei] -= 1
                if degree[nei] == 1:
                    coins[nei] = -1              # 變成葉子的就是第二層，不再往內

        # 第三階段：數剩下的邊
        remaining = sum(1 for u, v in edges if coins[u] != -1 and coins[v] != -1)
        return remaining * 2
```

第二階段不把第二層放回 queue，所以剛好只剪兩層。

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 標記之後馬上檢查同一個值，讓整段邏輯失效。
- 連鎖剪枝時忘記檢查鄰居有沒有硬幣。
- 第二層剪完還繼續往內剪：只能剪兩層。
- 提交前沒有確認編輯器裡是不是最新版本。

## 面試口說整理

收集完所有硬幣再回到起點，走過的路徑是一棵子樹，每條邊剛好走兩次，所以答案是必須走的邊數乘以 2。我先用類似拓撲排序的方式連鎖剪掉沒有硬幣的葉子，讓剩下的葉子都有硬幣；因為能收集距離 2 以內的硬幣，再固定剪兩層葉子。剩下的邊數乘以 2 就是答案，時間 `O(n)`。
