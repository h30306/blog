---
title: "LeetCode 23: Merge k Sorted Lists"
summary: "LeetCode 23 解題筆記：heap 只放 k 個開頭，以及分治兩兩合併"
description: "2026-10-20 merge sort 練習梯子的 LeetCode 23 紀錄"
date: 2026-10-20
tags: ["hard", "linked-list", "heap", "merge-sort", "divide-and-conquer"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-10-20
來源：Merge sort 練習梯子的延伸題（高頻）

## 解題思路

設 `N` 是所有節點總數、`k` 是 list 條數。目標是 `O(N log k)`。

- **Heap**：每條 list 已排序，目前最小的節點一定是某條 list 的開頭，所以 heap 只要放 `k` 個開頭。
- **分治**：把每條 list 當成一個元素做 merge sort，merge 就是 LC 21。

## 我的嘗試

### 第一版：全部倒進 heap

```python
pq = []
dummy = tail = ListNode()
for node in lists:
    while node:
        heapq.heappush(pq, node.val)
        node = node.next

while pq:
    node = heapq.heappop(pq)
    tail.next = ListNode(node)
    tail = tail.next

return dummy.next
```

會 AC，但時間是 `O(N log N)`、空間 `O(N)`。這等於「把所有值倒出來排序再串回去」，沒用到每條 list 已排序的條件。另外建了 `N` 個新節點，而且 `node = heappop(...)` 拿到的其實是值，名稱容易誤導。

### 第二版：分治

```python
def mergeAndSort(low: int, high: int):
    if high - low == 0:
        return None
    if high - low == 1:
        return list[low]          # 應該是 lists[low]

    mid = (low + high) // 2
    return merge(mergeAndSort(low, mid), mergeAndSort(mid, high))
```

結構全對，只有一個筆誤：`list` 是 Python 內建型別，`list[low]` 是合法的型別提示語法，**不會馬上報錯**，要到 `merge` 讀 `.val` 才出現 `AttributeError`。報錯的位置跟出錯的位置不一樣，這種 bug 最難找。

拼錯成不存在的名字會立刻 `NameError`；拼錯成剛好存在的名字（`list`、`dict`、`sum`、`max`、`id`）就會悄悄跑下去。

## 正確解法

### 分治（merge sort）

```python
class Solution:
    def mergeKLists(self, lists: list[ListNode | None]) -> ListNode | None:

        def merge(a: ListNode | None, b: ListNode | None) -> ListNode | None:   # LC 21
            dummy = tail = ListNode()
            while a and b:
                if a.val <= b.val:
                    tail.next = a
                    a = a.next
                else:
                    tail.next = b
                    b = b.next
                tail = tail.next
            tail.next = a or b
            return dummy.next

        def mergeAndSort(low: int, high: int) -> ListNode | None:
            if high - low == 0:
                return None                    # 空輸入，避免無限遞迴
            if high - low == 1:
                return lists[low]
            mid = (low + high) // 2
            return merge(mergeAndSort(low, mid), mergeAndSort(mid, high))

        return mergeAndSort(0, len(lists))
```

### Heap 只放 k 個開頭

```python
import heapq

class Solution:
    def mergeKLists(self, lists: list[ListNode | None]) -> ListNode | None:
        pq = []
        for i, node in enumerate(lists):
            if node:
                heapq.heappush(pq, (node.val, i, node))

        dummy = tail = ListNode()
        while pq:
            _, i, node = heapq.heappop(pq)
            tail.next = node                   # 重用原本的節點
            tail = tail.next
            if node.next:
                heapq.heappush(pq, (node.next.val, i, node.next))
        return dummy.next
```

tuple 中間放 `i`，是因為值相同時 Python 會接著比第二個欄位。ListNode 沒有定義比較，直接比會 `TypeError`。每條 list 同時最多一個節點在 heap 裡，所以 `i` 不會重複。

### Bottom-up 迭代（空間 O(1)）

```python
k = len(lists)
if k == 0:
    return None
step = 1
while step < k:
    for i in range(0, k - step, step * 2):
        lists[i] = merge(lists[i], lists[i + step])
    step *= 2
return lists[0]
```

會修改輸入的 `lists`，面試時要主動說明。

## 複雜度

| 解法 | 時間 | 空間 |
|---|---|---|
| 全部倒進 heap | `O(N log N)` | `O(N)` |
| Heap 只放 k 個開頭 | `O(N log k)` | `O(k)` |
| 分治遞迴 | `O(N log k)` | `O(log k)` |
| 分治 bottom-up | `O(N log k)` | `O(1)` |
| 依序一條一條合併 | `O(N k)` | `O(1)` |

分治共 `log k` 層，每層所有節點各被合併一次，是 `O(N)`。依序合併時，第一條 list 的節點會在之後每次 merge 都被重掃，總共約 `N k / 2`。

## 要特別避免的錯誤

- 只寫 `high - low == 1` 的終止條件：`lists = []` 時 `mergeAndSort(0, 0)` 會無限遞迴。
- heap 的 tuple 沒放 tie-breaker。
- 變數名稱撞到內建名稱。

## 面試口說整理

每條 list 都已排序，所以有兩種 `O(N log k)` 的做法。第一種是 heap 只放每條 list 目前的開頭，每次取最小的接到結果，再把它的下一個補進 heap。第二種是分治，把 k 條 list 當成 merge sort 的元素兩兩合併，merge 就是 LC 21，總共 `log k` 層、每層 `O(N)`。如果資料是串流、沒辦法一次拿到全部 list，我會選 heap，因為它只需要每條 list 目前的開頭。
