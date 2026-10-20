---
title: "LeetCode 1354: Construct Target Array With Multiple Sums"
summary: "LeetCode 1354 解題筆記：反著做，最大值一定是最後被設定的；差距大時用取餘數一次跳完"
description: "2026-09-07 的 LeetCode 1354 解題紀錄"
date: 2026-09-07
tags: ["hard", "heap", "math", "greedy"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-09-07
- 提交紀錄：Time Limit Exceeded → Accepted

## 解題思路

正著做選擇太多，**反著做**：

每次操作會把某個位置設成「當時的總和」，而總和一定比其他任何元素都大，所以**目前陣列的最大值，一定是最後一次被設定的那個位置**。

反推一步：設最大值是 `mx`、其他元素的和是 `rest`，上一步這個位置的值是 `mx - rest`。

用 max-heap 反覆取出最大值、還原上一步，直到全部變成 1 就成功；如果還原出來的值小於 1，就失敗。

## 我的第一版：一次只還原一步

```python
preNum = preSum - (currSum - preSum)
```

例如 `[1, 1000000000]`：每次只減 1，要跑 `10^9` 次，TLE。

## 改進：用取餘數一次跳完

如果 `mx` 比 `rest` 大很多，同一個位置會被連續還原很多次，每次減 `rest`，直到小於 `rest` 為止，這就是 `mx % rest`。

需要注意的邊界：

- `rest == 1`：例如 `[1, x]`，一直減 1 一定能減到 1，直接回傳 `True`。要先處理，因為 `x % 1 == 0` 會被誤判。
- `rest == 0`（只有一個元素，而且不是 1），或 `mx <= rest`：沒辦法再往回推，回傳 `False`。
- `mx % rest == 0`：還原出來是 0，不合法，回傳 `False`。

## 正確解法

```python
import heapq

class Solution:
    def isPossible(self, target: List[int]) -> bool:
        total = sum(target)
        heap = [-x for x in target]
        heapq.heapify(heap)

        while True:
            mx = -heapq.heappop(heap)
            if mx == 1:
                return True                    # 最大值是 1，全部都是 1
            rest = total - mx
            if rest == 1:
                return True
            if rest == 0 or mx <= rest:
                return False
            prev = mx % rest
            if prev == 0:
                return False
            total = rest + prev
            heapq.heappush(heap, -prev)
```

## 複雜度

時間 `O(n + log(S) · log n)`，`S` 是總和：最大值至少佔總和的一半，而取餘數後它會變成不到原本的一半，所以每輪總和至少縮小到 `3/4`，迴圈只會跑 `O(log S)` 次。空間 `O(n)`。

## 要特別避免的錯誤

- 一次只還原一步：差距大時 TLE。
- 沒有先處理 `rest == 1`：`x % 1 == 0` 會被當成失敗。
- 單一元素的陣列：`rest == 0`，只有 `[1]` 是 `True`。

## 面試口說整理

我反著做：每次設定的值都是當時的總和，所以目前的最大值一定是最後被設定的，上一步的值是最大值減掉其他元素的和。用 max-heap 反覆取最大值還原；差距很大時同一個位置會被連續還原，所以用取餘數一次跳完。其他元素和是 1 時一定可以，是 0 或不小於最大值時不行，取餘數得到 0 也不行。全部變成 1 就成功。
