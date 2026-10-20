---
title: "LeetCode 3829: Design Ride Sharing System"
summary: "LeetCode 3829 解題筆記：乘客和司機各一個 queue，取消只記在 set 裡，配對前再把隊頭已取消的乘客丟掉"
description: "2026-02-01 的 LeetCode 3829 解題紀錄"
date: 2026-02-01
tags: ["medium", "queue", "design", "hash-map", "lazy-deletion"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-02-01
- 提交紀錄：Accepted（一次通過）

## 解題思路

乘客和司機都依照到達順序配對，所以各用一個 queue。配對時兩邊各拿最早的一個。

麻煩的是 `cancelRider`：要把一個還在等的乘客從 queue **中間**拿掉。做法是 lazy deletion：

- 取消時不動 queue，只把乘客從「還在等的乘客」集合移除。
- 配對前，先把隊頭不在集合裡的乘客丟掉，直到隊頭是還在等的乘客。

## 我的解法

```python
from collections import deque

class RideSharingSystem:

    def __init__(self):
        self.riders = deque()
        self.drivers = deque()
        self.waiting = set()                  # 還在等的乘客

    def addRider(self, riderId: int) -> None:
        self.riders.append(riderId)
        self.waiting.add(riderId)

    def addDriver(self, driverId: int) -> None:
        self.drivers.append(driverId)

    def matchDriverWithRider(self) -> List[int]:
        while self.riders and self.riders[0] not in self.waiting:
            self.riders.popleft()             # 丟掉已取消的
        if not self.riders or not self.drivers:
            return [-1, -1]
        rider = self.riders.popleft()
        self.waiting.discard(rider)
        return [self.drivers.popleft(), rider]

    def cancelRider(self, riderId: int) -> None:
        self.waiting.discard(riderId)
```

原本的版本用一個 `cancel` 集合記錄被取消的乘客，取消時先用 `riderId in self.rider` 檢查乘客還在不在 queue 裡。對 deque 用 `in` 是 `O(n)`，乘客很多時會變慢。改成維護「還在等的乘客」集合，取消和檢查都是 `O(1)`。

## 複雜度

每個操作均攤 `O(1)`：每個乘客最多被丟掉一次。空間 `O(n)`。

## 要特別避免的錯誤

- 對 deque 用 `in` 檢查存在：`O(n)`。
- 先判斷「兩邊都不空」才清理已取消的乘客：清理後乘客可能變空，要在清理之後再判斷。
- 已經配對過的乘客被取消：要確保配對時也把乘客從集合移除，取消才不會影響到別人。

## 面試口說整理

乘客和司機各用一個 queue 依照到達順序配對。取消乘客要從 queue 中間刪除，所以我用 lazy deletion：用一個集合記錄還在等的乘客，取消時只從集合移除，配對前把隊頭已經不在集合裡的乘客丟掉。每個乘客最多被丟一次，所以每個操作均攤 `O(1)`。
