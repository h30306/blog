---
title: "LeetCode 2402: Meeting Rooms III"
summary: "LeetCode 2402 解題筆記：空閒房間和忙碌房間各一個 heap，延後的會議要保留原本的長度"
description: "2025-07-17 的 LeetCode 2402 解題紀錄"
date: 2025-07-17
tags: ["hard", "heap", "sorting", "simulation", "intervals"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2025-07-17
- 提交紀錄：Wrong Answer ×3 → Runtime Error → Accepted

## 解題思路

規則：

1. 會議依開始時間處理（開始時間互不相同）。
2. 有空房間時，用**編號最小**的房間。
3. 沒有空房間時，等**最早空出來**的房間，會議延後，但**長度不變**。

這兩個「最小」的依據不一樣，所以要兩個 heap：

- `free`：空閒房間的編號。
- `busy`：`(結束時間, 房間編號)`。結束時間相同時，編號小的先出來。

每場會議開始前，先把 `busy` 裡結束時間 `<= start` 的房間移到 `free`。

## 我的嘗試

### 第一版：只有一個 heap

```python
free_times = [(0, room) for room in range(n)]
for start, end in meetings:
    free_time, room = heapq.heappop(free_times)
    meeting_end = max(end + free_time, end)
```

只用 `(空出時間, 房間)` 一個 heap，取出的是「最早空出來」的房間，不是「已經空出來的房間裡編號最小的」。例如房間 1 在時間 0 空出、房間 0 在時間 3 空出，時間 5 的會議應該用房間 0，這版卻會選房間 1。

另外，延後的結束時間寫成 `end + free_time` 也不對。

### 第二版：兩個 heap，但延後的結束時間算錯

```python
free_time, room = heapq.heappop(free_times)
meeting_end = max(free_time + end, end)
```

延後的會議要從房間空出來的時間開始，**持續原本的長度** `end - start`，所以結束時間是 `free_time + (end - start)`。

### Runtime Error：打錯變數名稱

改公式時把 `free_time` 打成 `ree_time`。

## 正確解法

```python
import heapq

class Solution:
    def mostBooked(self, n: int, meetings: List[List[int]]) -> int:
        meetings.sort()
        free = list(range(n))            # 空閒房間編號
        busy = []                        # (結束時間, 房間編號)
        count = [0] * n

        for start, end in meetings:
            while busy and busy[0][0] <= start:
                _, room = heapq.heappop(busy)
                heapq.heappush(free, room)

            if free:
                room = heapq.heappop(free)
                heapq.heappush(busy, (end, room))
            else:
                free_time, room = heapq.heappop(busy)
                heapq.heappush(busy, (free_time + end - start, room))
            count[room] += 1

        return count.index(max(count))   # 平手時 index 回傳編號最小的
```

## 複雜度

時間 `O(m log m + m log n)`，`m` 是會議數。空間 `O(n)`。

## 要特別避免的錯誤

- 用一個 heap 同時處理「空閒時選最小編號」和「全忙時選最早空出」。
- 延後的會議沒有保留原本長度。
- 結束時間可能超過 32-bit：Java/C++ 要用 `long`。

## 面試口說整理

我用兩個 heap：空閒房間依編號排，忙碌房間依結束時間和編號排。每場會議開始前，先把已經結束的房間移回空閒 heap。有空房就用編號最小的；全部都忙，就取最早空出的房間，會議從那時開始並保留原本的長度。最後回傳使用次數最多、編號最小的房間。時間 `O(m log m)`。
