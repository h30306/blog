---
title: "Heap 優先佇列"
summary: "heapq 基本用法、Top-K、lazy deletion、雙 heap、K 路合併、掃描線與 Dijkstra"
description: "演算法學習"
date: 2026-10-20
tags: ["heap", "priority-queue", "greedy", "dijkstra"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 介紹

Heap（優先佇列）可以在 `O(log n)` 內插入元素、取出最小值，而且隨時能用 `O(1)` 看到最小值。

辨識訊號：

- 要**反覆**取「目前最小 / 最大」的元素，而且集合會一直變動。
- 題目出現「第 k 大」、「最接近的 k 個」、「最早結束的」、「優先處理」。
- 要合併好幾條**已經排好序**的序列。

如果只需要取一次最小值，直接排序或 `min()` 就好，不需要 heap。

## Python heapq 基本用法

```python
import heapq

h = []
heapq.heappush(h, 3)          # O(log n)
smallest = h[0]               # O(1)，只看不取
smallest = heapq.heappop(h)   # O(log n)
heapq.heapify(arr)            # O(n)，原地轉成 heap
```

### 主要參數說明：

- **只有 min-heap**：要 max-heap 就把值取負號，例如 `heappush(h, -x)`。
- **tuple 會依序比較每個欄位**：`(優先度, 次要條件, 資料)`。第一個欄位相同時會比第二個，所以要放能比較的 tie-breaker，例如 index。
- **字串不能取負號**：想要「分數高優先，分數相同時名字小優先」這種混合順序，可以自訂 class 的 `__lt__`（LC 2102）。

## 模板一：Top-K，維持大小為 k 的 heap

要「前 k 大」，就維持一個大小為 k 的 **min-heap**：堆頂是這 k 個裡面最小的，新元素比它大才換進來。

```python
h = []
for x in nums:
    heapq.heappush(h, x)
    if len(h) > k:
        heapq.heappop(h)      # 丟掉 k 個裡最小的
# h[0] 就是第 k 大
```

時間 `O(n log k)`。

## 模板二：Lazy deletion（延遲刪除）

`heapq` 不支援刪除或修改中間的元素。做法是：**修改時直接推一筆新資料進去，舊的留在 heap 裡；取出時再檢查堆頂是不是過期的。**

```python
current = {}                  # key -> 目前有效的值

def update(key, value):
    current[key] = value
    heapq.heappush(h, (-value, key))

def top():
    while h:
        neg_value, key = h[0]
        if current.get(key) == -neg_value:
            return key        # 有效
        heapq.heappop(h)      # 過期，丟掉
    return -1
```

### 主要參數說明：

- 驗證條件要能分辨「過期資料」：通常是比對 dict 裡目前的值（LC 3815、3885），或一個 `online` 陣列（LC 3607）。
- 每筆資料最多被推入、彈出各一次，均攤下來仍是 `O(log n)`。
- **heap 空了要回傳預設值**，不然函式會回傳 `None`。

## 模板三：雙 heap

兩個 heap 分別管理兩種狀態，元素在兩邊移動：

- **空閒 / 忙碌**（LC 2402 Meeting Rooms III）：空閒房間依編號排，忙碌房間依結束時間排。新會議開始前，先把已經結束的房間從「忙碌」移到「空閒」。
- **前 k 名 / 其他**（LC 2102）：前 k 名用 min-heap，堆頂是第 k 名；其他用 max-heap，堆頂是第 k+1 名。
- **中位數**（LC 295）：小的一半放 max-heap，大的一半放 min-heap。

## 模板四：K 路合併

合併 k 條已排序的序列，heap 裡只放每條序列目前的開頭：

```python
h = [(lst[0], i, 0) for i, lst in enumerate(lists) if lst]
heapq.heapify(h)
while h:
    val, i, j = heapq.heappop(h)
    # 處理 val
    if j + 1 < len(lists[i]):
        heapq.heappush(h, (lists[i][j + 1], i, j + 1))
```

時間 `O(N log k)`。LC 632 在合併的同時記錄目前的最大值，LC 759 在合併的同時找空檔。

## 模板五：掃描線 + 結束時間 heap

依開始時間排序，heap 存「進行中的事件的結束時間」：

```python
intervals.sort()
h = []
for start, end in intervals:
    while h and h[0] <= start:    # 半開區間 [start, end)：end == start 時可以重用
        heapq.heappop(h)
    heapq.heappush(h, end)
    best = max(best, len(h))      # LC 253：同時進行的最大數量
```

LC 1353 是變形：每天從 heap 裡挑「最早結束」的活動參加。

## 模板六：Dijkstra

Heap 裡放 `(目前距離, 節點)`，每次取出距離最小的節點往外擴展。

- **最大機率路徑**（LC 1514）：機率介於 0 和 1，相乘只會變小，所以可以把機率取負號放進 min-heap，概念跟「非負邊權」一樣。
- **距離相同時比字典序**（LC 499）：把 `(距離, 路徑字串)` 一起當作 heap 的優先度。

## 複雜度

| 操作 | 時間 |
|---|---|
| `heappush` / `heappop` | `O(log n)` |
| 看堆頂 `h[0]` | `O(1)` |
| `heapify` | `O(n)` |
| Top-K | `O(n log k)` |
| K 路合併 | `O(N log k)` |

## 常見錯誤

這些都是我練習時實際寫錯過的：

- **每次查詢都對整個集合取 `min()`**：查詢多時就 TLE，要改成 heap + lazy deletion（LC 3607，十次 TLE）。
- **lazy deletion 的 heap 空了沒有回傳 `-1`**（LC 3815）。
- **dict 裡留著空集合**：`max(dict)` 會選到已經沒有元素的 key（LC 3885）。
- **延後的會議結束時間算錯**：應該是「房間空出來的時間 + 會議長度」，不是 `max(free_time + end, end)`（LC 2402）。
- **半開區間用 `<` 而不是 `<=`**：結束時間等於開始時間時，房間可以重用（LC 253）。
- **最大值初始化成 0**：遇到負數就錯（LC 632）。
- **排序後取錯邊**：要最大的三個卻取了 `[:3]`（LC 3572）。
- **Dijkstra 用 `<` 剪枝**：相同距離的狀態一直被重複推入，Memory Limit Exceeded（LC 1514）。
- **反向模擬一次只減一步**：差距很大時要用取餘數一次跳完（LC 1354）。
- **Top-K 的 heap 滿了之後沒有處理新的數**：要 `heappushpop`，大小上限是 `k` 不是 `k + 1`（LC 215）。
- **max-heap 存負數時差的正負號弄反**：放回去的也要是負數（LC 1046）。
- **兩顆一樣重全部消掉後讀 `h[0]`**：heap 可能是空的（LC 1046）。
- **選完 Top-K 忘了排回原本的順序**（LC 2099）。

## 相關 LeetCode

- `LC 253` Meeting Rooms II
- `LC 1353` Maximum Number of Events That Can Be Attended
- `LC 2402` Meeting Rooms III
- `LC 632` Smallest Range Covering Elements from K Lists
- `LC 759` Employee Free Time
- `LC 3607` Power Grid Maintenance
- `LC 3815` Design Auction System
- `LC 3885` Design Event Manager
- `LC 2102` Sequentially Ordinal Rank Tracker
- `LC 1514` Path with Maximum Probability
- `LC 499` The Maze III
- `LC 1354` Construct Target Array With Multiple Sums
- `LC 420` Strong Password Checker
- `LC 3507` Minimum Pair Removal to Sort Array I
- `LC 3572` Maximize Y‑Sum by Picking a Triplet of Distinct X‑Values
- `LC 2762` Continuous Subarrays
- `LC 658` Find K Closest Elements
- `LC 1878` Get Biggest Three Rhombus Sums in a Grid
- `LC 215` Kth Largest Element in an Array
- `LC 973` K Closest Points to Origin
- `LC 1046` Last Stone Weight
- `LC 347` Top K Frequent Elements
- `LC 506` Relative Ranks
- `LC 2335` Minimum Amount of Time to Fill Cups
- `LC 1464` Maximum Product of Two Elements in an Array
- `LC 2357` Make Array Zero by Subtracting Equal Amounts
- `LC 2099` Find Subsequence of Length K With the Largest Sum
- `LC 2231` Largest Number After Digit Swaps by Parity
