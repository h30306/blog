---
title: "LeetCode 3885: Design Event Manager"
summary: "LeetCode 3885 解題筆記：dict 存目前優先度，max-heap 加 lazy deletion，彈出時再驗證"
description: "2026-03-29 的 LeetCode 3885 解題紀錄"
date: 2026-03-29
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
第一次嘗試：2026-03-29
- 提交紀錄：Wrong Answer → Time Limit Exceeded → Accepted

## 解題思路

這題跟 LC 3815 Design Auction System 幾乎一樣，是 lazy deletion 的標準題：

- `priority[eventId]`：目前有效的優先度，被彈出的活動就從 dict 刪除。
- max-heap 存 `(-priority, eventId)`：優先度最高、平手時 id 最小的在堆頂。
- 修改優先度時直接推一筆新的，舊的留在 heap 裡。
- 彈出時，如果堆頂的優先度和 dict 裡的不一致，或活動已經不在 dict 裡，就是過期資料，丟掉繼續找。

## 我的嘗試

### Wrong Answer：dict 裡留著空集合

第一版用 `priority -> set(eventId)` 的 dict，修改優先度時從舊集合移除，但**集合空了之後沒有刪掉這個 key**。之後 `max(dict)` 可能選到一個空集合，就回傳了 `-1`。

### Time Limit Exceeded：`max(dict)` 是 O(不同優先度的數量)

把空集合刪掉之後結果對了，但每次 `pollHighest` 都要 `max(dict)` 掃過所有優先度，還要 `min(set)`，查詢多時就 TLE。

## 正確解法

```python
import heapq

class EventManager:

    def __init__(self, events: List[List[int]]):
        self.priority = {}
        self.heap = []
        for event_id, p in events:
            self.priority[event_id] = p
            self.heap.append((-p, event_id))
        heapq.heapify(self.heap)

    def updatePriority(self, eventId: int, newPriority: int) -> None:
        self.priority[eventId] = newPriority
        heapq.heappush(self.heap, (-newPriority, eventId))

    def pollHighest(self) -> int:
        while self.heap:
            neg_p, event_id = heapq.heappop(self.heap)
            if self.priority.get(event_id) == -neg_p:
                del self.priority[event_id]        # 已經被取走
                return event_id
        return -1
```

初始化時用 `heapify` 是 `O(n)`，比一筆一筆 `heappush` 的 `O(n log n)` 快。

## 複雜度

每個操作均攤 `O(log n)`，空間 `O(n + 更新次數)`。

## 要特別避免的錯誤

- 用 dict 存「優先度 → 集合」卻沒刪掉空集合。
- 每次查詢都 `max(dict)`。
- 彈出後忘記從 `priority` 刪除：同一個活動的另一筆舊資料可能被當成有效的再彈出一次。

## 面試口說整理

我用 dict 存每個活動目前的優先度，另外用 heap 存 `(-優先度, id)`，堆頂就是優先度最高、id 最小的活動。修改優先度時推一筆新的，舊的不動。彈出時，如果堆頂的優先度和 dict 不一致，或活動已經被取走，就丟掉繼續找；找到有效的就從 dict 刪除並回傳。每個操作均攤 `O(log n)`。
