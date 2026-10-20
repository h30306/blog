---
title: "LeetCode 632: Smallest Range Covering Elements from K Lists"
summary: "LeetCode 632 解題筆記：heap 放每條 list 的目前元素，同時記錄最大值，每次推進最小的那條"
description: "2026-01-18 的 LeetCode 632 解題紀錄"
date: 2026-01-18
tags: ["hard", "heap", "k-way-merge", "sliding-window"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-01-18
- 提交紀錄：Time Limit Exceeded → Wrong Answer → Accepted → Wrong Answer → Accepted（同一天重寫一次）

## 解題思路

要找一個最小的區間 `[a, b]`，讓每條 list 都至少有一個數在裡面。

讓每條 list 各出一個「目前的元素」，這 k 個數的最小值和最大值就構成一個合法區間。要讓區間變小，**只能推進最小值那條 list**：推進最大值那條只會讓區間更大。

做法跟 K 路合併一樣：

1. heap 放每條 list 的第一個元素，同時記錄目前的最大值。
2. 每次彈出最小值，用 `[最小值, 最大值]` 更新答案。
3. 把那條 list 的下一個元素推進 heap，更新最大值。
4. 某條 list 用完就停止：之後再也湊不出包含每條 list 的區間。

## 我的嘗試

### TLE：全部推進 heap，每次重算 min 和 max

把所有元素都推進 heap，依序彈出時記錄每條 list 最後看到的值，湊滿 k 條後每次都對 dict 取 `min` 和 `max`。每次是 `O(k)`，總共 `O(N k)`。

### Wrong Answer：最大值初始化成 0

```python
current_max = 0
```

數值可能是負的。全部都是負數時，最大值永遠是 0，區間就錯了。要初始化成 `float("-inf")`。

### 一個奇怪的地方

第一個 AC 版回傳的是 `[min_end, min_start]`，其中 `min_end` 存的是最大值、`min_start` 存的是最小值，看起來順序是反的，但還是被判 AC。同一天重寫時改成了 `[best_min, best_max]`。之後寫的時候，還是用正確的順序。

## 正確解法

```python
import heapq

class Solution:
    def smallestRange(self, nums: List[List[int]]) -> List[int]:
        heap = [(lst[0], i, 0) for i, lst in enumerate(nums)]
        heapq.heapify(heap)
        current_max = max(lst[0] for lst in nums)
        best_min, best_max = float("-inf"), float("inf")

        while True:
            current_min, i, j = heapq.heappop(heap)
            if current_max - current_min < best_max - best_min:
                best_min, best_max = current_min, current_max

            if j + 1 == len(nums[i]):
                break                                   # 這條 list 用完了
            nxt = nums[i][j + 1]
            heapq.heappush(heap, (nxt, i, j + 1))
            current_max = max(current_max, nxt)

        return [best_min, best_max]
```

用 `<` 更新答案：最小值是遞增彈出的，寬度相同時先遇到的區間起點比較小，剛好符合題目「寬度相同取 `a` 比較小」的規則。

## 複雜度

時間 `O(N log k)`，`N` 是所有元素數量。空間 `O(k)`。

## 要特別避免的錯誤

- 最大值初始化成 0。
- 推進最大值那條 list：只有推進最小值才可能讓區間變小。
- 某條 list 用完還繼續：之後的區間不可能包含這條 list。

## 面試口說整理

每條 list 各取一個目前的元素，它們的最小值和最大值就是一個合法區間。要縮小區間，只能推進最小值所在的 list。所以我用 heap 放每條 list 的目前元素，並記錄目前的最大值：每次彈出最小值更新答案，再推入同一條 list 的下一個元素，某條 list 用完就停。時間 `O(N log k)`。
