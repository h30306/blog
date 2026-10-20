---
title: "LeetCode 3508: Implement Router"
summary: "LeetCode 3508 解題筆記：queue 管 FIFO、set 判重複、每個目的地一個遞增的時間陣列，查詢用 bisect"
description: "2025-04-06 的 LeetCode 3508 解題紀錄"
date: 2025-04-06
tags: ["medium", "design", "binary-search", "queue", "hash-map"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2025-04-06
- 提交紀錄：Runtime Error → Time Limit Exceeded（2025-04-06）→ Wrong Answer → Accepted（2025-08-01）

## 解題思路

三個操作各自需要不同的結構：

| 操作 | 需求 | 結構 |
|---|---|---|
| `addPacket` | 判斷重複 | `set` 存 `(source, destination, timestamp)` |
| `forwardPacket`、記憶體滿時丟最舊的 | FIFO | `deque` |
| `getCount` | 某目的地、某時間區間內的封包數 | 每個目的地一個時間陣列，加上 bisect |

關鍵觀察：題目保證 `addPacket` 的時間**不遞減**，而移除永遠是移除最舊的。所以**每個目的地的時間陣列天生就是排好序的**，而且只會從前面移除。

## 我的嘗試

### 四月：Runtime Error 和 TLE

第一版全部塞在一個 list：

- `packet in self.packets` 判重複是 `O(n)`。
- `pop(0)` 是 `O(n)`。
- `getCount` 掃過所有封包，也是 `O(n)`。
- `forwardPacket` 沒有處理空的情況，對空 list `pop(0)` 就 Runtime Error。

修掉空的情況之後，就是 TLE。

### 八月：WA，二分搜尋的 `hi` 少了 1

重寫成 set + deque + 每個目的地的時間 deque 之後，手寫的二分搜尋設了 `right = len(packets) - 1`，搭配左閉右開的 `while left < right`。所有時間都比 `startTime` 小時，正確答案是 `len`，但這個寫法最多只能回傳 `len - 1`。改成 `right = len(packets)` 就 AC 了。

## 正確解法

AC 版在 `deque` 上做二分搜尋。`deque` 用 index 存取中間的元素不是 `O(1)`，所以這裡改成 list 加上一個「起點指標」，從前面移除時只把指標往後移：

```python
import bisect
from collections import defaultdict, deque

class Router:

    def __init__(self, memoryLimit: int):
        self.limit = memoryLimit
        self.queue = deque()
        self.seen = set()
        self.times = defaultdict(list)       # destination -> 遞增的時間
        self.start = defaultdict(int)        # destination -> 第一個還在的 index

    def addPacket(self, source: int, destination: int, timestamp: int) -> bool:
        packet = (source, destination, timestamp)
        if packet in self.seen:
            return False
        if len(self.queue) == self.limit:
            self.forwardPacket()
        self.queue.append(packet)
        self.seen.add(packet)
        self.times[destination].append(timestamp)
        return True

    def forwardPacket(self) -> List[int]:
        if not self.queue:
            return []
        packet = self.queue.popleft()
        self.seen.remove(packet)
        self.start[packet[1]] += 1           # 最舊的一定在最前面
        return list(packet)

    def getCount(self, destination: int, startTime: int, endTime: int) -> int:
        arr = self.times[destination]
        lo = self.start[destination]
        return bisect.bisect_right(arr, endTime, lo) - bisect.bisect_left(arr, startTime, lo)
```

`bisect` 的第三個參數 `lo` 讓搜尋從還沒被移除的位置開始。

## 複雜度

`addPacket`、`forwardPacket` 是 `O(1)`，`getCount` 是 `O(log n)`。空間 `O(n)`。

## 要特別避免的錯誤

- 判重複、移除、計數都用 list 線性操作。
- `forwardPacket` 沒處理空的情況。
- 左閉右開的二分搜尋把 `hi` 設成 `len - 1`。
- 記憶體滿時先丟最舊的，再判重複：重複的封包不應該導致任何封包被丟掉，所以要**先判重複**。

## 面試口說整理

我用 deque 處理 FIFO，set 判斷重複。因為新增的時間不會遞減、移除永遠移除最舊的，每個目的地的時間陣列天生有序，而且只會從前面移除，所以我用 list 加上起點指標代表它。查詢時用 `bisect_right` 和 `bisect_left` 相減，就是區間內的封包數。新增和轉發 `O(1)`，查詢 `O(log n)`。
