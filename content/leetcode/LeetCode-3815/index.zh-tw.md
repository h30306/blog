---
title: "LeetCode 3815: Design Auction System"
summary: "LeetCode 3815 解題筆記：每個商品一個 max-heap，出價改變就推新的一筆，查詢時丟掉過期的"
description: "2026-01-18 的 LeetCode 3815 解題紀錄"
date: 2026-01-18
tags: ["medium", "heap", "design", "hash-map", "lazy-deletion"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-18
- 提交紀錄：Wrong Answer → Time Limit Exceeded → Wrong Answer → Accepted

## 解題思路

需要支援新增、修改、刪除出價，並查詢某商品「出價最高、平手時 userId 最大」的使用者。

- `bids[itemId][userId] = amount`：目前有效的出價。
- `heaps[itemId]`：存 `(-amount, -userId)` 的 min-heap，堆頂就是「金額最大、平手時 userId 最大」。

修改和刪除都不動 heap，只改 `bids`。查詢時檢查堆頂和 `bids` 裡的目前出價是否一致，不一致就是過期資料，彈掉（lazy deletion）。

## 我的嘗試

### Wrong Answer：平手時取錯 user

```python
return sorted(candidate)[0]       # 題目要 userId 最大，這裡取了最小
```

### Time Limit Exceeded：每次查詢都掃過整個商品的出價

改成 `[-1]` 之後結果對了，但 `getHighestBidder` 每次都 `max(...)` 再掃一遍找候選人，是 `O(出價數)`，查詢多時就 TLE。

### Wrong Answer：heap 空了沒有回傳

改用 heap + lazy deletion 後，`while heap:` 迴圈結束時沒有 `return -1`，函式回傳 `None`。

## 正確解法

```python
import heapq
from collections import defaultdict

class AuctionSystem:

    def __init__(self):
        self.bids = defaultdict(dict)          # itemId -> {userId: amount}
        self.heaps = defaultdict(list)         # itemId -> [(-amount, -userId)]

    def addBid(self, userId: int, itemId: int, bidAmount: int) -> None:
        self.bids[itemId][userId] = bidAmount
        heapq.heappush(self.heaps[itemId], (-bidAmount, -userId))

    def updateBid(self, userId: int, itemId: int, newAmount: int) -> None:
        self.addBid(userId, itemId, newAmount)

    def removeBid(self, userId: int, itemId: int) -> None:
        del self.bids[itemId][userId]

    def getHighestBidder(self, itemId: int) -> int:
        heap = self.heaps[itemId]
        current = self.bids[itemId]
        while heap:
            neg_amount, neg_user = heap[0]
            if current.get(-neg_user) == -neg_amount:
                return -neg_user
            heapq.heappop(heap)                # 過期：已刪除或已改價
        return -1
```

`updateBid` 和 `addBid` 的行為一樣，直接共用。

## 複雜度

每個操作均攤 `O(log n)`，`n` 是推入 heap 的總筆數。空間 `O(n)`。

## 要特別避免的錯誤

- 平手規則看錯方向：這題要 userId **最大**。
- lazy deletion 的迴圈結束後沒有回傳預設值。
- 驗證過期時只檢查 user 存不存在，沒有比對金額：改價後舊的那筆也會被當成有效。

## 面試口說整理

我用 dict 存每個商品目前有效的出價，另外每個商品一個 heap，存 `(-金額, -userId)`，堆頂就是金額最高、平手時 userId 最大的那筆。新增和修改都推一筆新的進 heap，刪除只改 dict。查詢時，如果堆頂和 dict 裡的出價不一致，就是過期資料，彈掉；heap 空了就回傳 `-1`。每個操作均攤 `O(log n)`。
