---
title: "LeetCode 716: Max Stack"
summary: "LeetCode 716 解題筆記：stack 和 heap 都存唯一 id，刪除只記 id，查詢時再丟掉已刪除的；用值記錄會分不清重複的元素"
description: "2026-09-14 的 LeetCode 716 解題紀錄"
date: 2026-09-14
tags: ["hard", "stack", "heap", "design", "lazy-deletion"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-09-14
- 提交紀錄：Wrong Answer ×2 → Time Limit Exceeded → Accepted ×2

## 解題思路

要支援一般的 stack 操作，加上 `peekMax` 和 `popMax`。`popMax` 會刪掉**中間**的元素，stack 和 heap 都沒辦法直接做到。

做法是 **lazy deletion**，跟 Heap 那篇一樣：

- 每個元素 push 時給一個遞增的 **id**，同時放進 stack（`(值, id)`）和 max-heap（`(-值, -id)`）。
- `pop` 或 `popMax` 刪除元素時，只把 id 加進 `deleted` 集合。
- `top`、`pop` 前先把 stack 頂端已刪除的彈掉；`peekMax`、`popMax` 前先把 heap 頂端已刪除的彈掉。

heap 用 `(-值, -id)`：值相同時 id 比較大的（比較晚 push 的、在 stack 比較上面的）先出來，符合「最大值有好幾個時，刪最上面那個」。

## 我的嘗試

### Wrong Answer ×2：用「值」記錄刪除

```python
self.deleted[val] += 1          # heap 這邊刪了一個 val
self.stack_deleted[val] += 1    # stack 這邊刪了一個 val
```

同一個值可能出現好幾次，只記「刪了幾個 2」，**分不清楚刪的是哪一個 2**。反例：

```text
push 1, push 2, popMax, push 3, push 2, top
```

`popMax` 刪掉第一個 2，但它還留在 stack 裡，被後來的 3 壓在下面。新 push 的 2 在頂端，`top` 檢查到「有一個 2 被刪過」，就把這個**有效的** 2 丟掉，回傳 3。正確答案是 2。

### Time Limit Exceeded：改用 id，但條件寫反

改成用 id 之後，`pop` 和 `top` 寫成：

```python
remove_idx = self.count - 1
while remove_idx not in self.delete:      # 應該是 in
    remove_idx -= 1
```

條件寫反了，而且是逐個 index 往回找，所以超時。改成「stack 存 `(值, id)`，頂端的 id 已刪除就彈掉」就 AC 了。

## 正確解法

```python
import heapq

class MaxStack:

    def __init__(self):
        self.stack = []          # (值, id)
        self.heap = []           # (-值, -id)
        self.deleted = set()
        self.next_id = 0

    def push(self, x: int) -> None:
        self.stack.append((x, self.next_id))
        heapq.heappush(self.heap, (-x, -self.next_id))
        self.next_id += 1

    def _clean_stack(self) -> None:
        while self.stack[-1][1] in self.deleted:
            self.stack.pop()

    def _clean_heap(self) -> None:
        while -self.heap[0][1] in self.deleted:
            heapq.heappop(self.heap)

    def pop(self) -> int:
        self._clean_stack()
        x, i = self.stack.pop()
        self.deleted.add(i)
        return x

    def top(self) -> int:
        self._clean_stack()
        return self.stack[-1][0]

    def peekMax(self) -> int:
        self._clean_heap()
        return -self.heap[0][0]

    def popMax(self) -> int:
        self._clean_heap()
        neg_x, neg_i = heapq.heappop(self.heap)
        self.deleted.add(-neg_i)
        return -neg_x
```

題目保證呼叫 `pop`、`top`、`peekMax`、`popMax` 時 stack 不是空的，所以清理時不用檢查空的情況：只要還有元素沒被刪，清理一定會停在它上面。

原本 AC 的版本在 `peekMax` 的迴圈裡還留著 `print(self.heap)`，最後一版才拿掉。

## 複雜度

`push`、`pop`、`peekMax`、`popMax` 均攤 `O(log n)`；`top` 均攤 `O(1)`。空間 `O(n)`。

## 要特別避免的錯誤

- 用值記錄刪除：重複的值分不清楚是哪一個。
- 最大值相同時刪錯：heap 要用 `-id` 讓比較晚 push 的先出來。
- 清理過期資料的條件寫反。

## 面試口說整理

`popMax` 要刪中間的元素，所以我用 lazy deletion：每個元素給一個唯一的 id，同時放進 stack 和 max-heap，heap 依 `(-值, -id)` 排序，這樣最大值相同時最上面那個先出來。刪除只把 id 加進集合，查詢前先把兩邊頂端已刪除的丟掉。一定要記 id 而不是值，因為值會重複。每個操作均攤 `O(log n)`。
