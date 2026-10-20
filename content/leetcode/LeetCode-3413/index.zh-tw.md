---
title: "LeetCode 3413: Maximum Coins From K Consecutive Bags"
summary: "LeetCode 3413 解題筆記：最佳的 k 個袋子，一定有一端對齊某段的端點；分別算「左端對齊段的起點」和「右端對齊段的終點」（鏡像後重用同一個函式）"
description: "2026-01-16 的 LeetCode 3413 解題紀錄"
date: 2026-01-16
tags: ["medium", "sliding-window", "greedy", "sorting", "prefix-sum", "binary-search", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-16
- 提交紀錄：Wrong Answer → Accepted

## 解題思路

跟 [LeetCode 2271]({{< relref "/leetcode/LeetCode-2271" >}}) 很像，但每段的權重 `c` 不一樣。

把長度 `k` 的視窗往右推一格，總和的變化是「右邊進來的那格 − 左邊出去的那格」。在兩個段落端點之間，這個變化是固定的，所以總和是線性變化，**最大值一定出現在某個端點**：視窗的左端剛好是某段的起點，或右端剛好是某段的終點。

2271 的權重都是 1，只看左端對齊就夠；這題兩種都要看：

- 左端對齊：跟 2271 一樣的雙指針，完整蓋住的段累加，下一段只算部分。
- 右端對齊：把座標鏡像（`[l, r]` 變成 `[-r, -l]`），右端對齊就變成左端對齊，重用同一個函式。

## 我的嘗試

第一版少了一個情況：如果某段比 `k` 還長，地毯連這段都蓋不完，`right` 會停在 `left`。下一輪 `left` 前進，但 `right` 還指著上一段，結果**上一段被完整加進總和**。例如 `coins = [[2, 3, 5], [7, 8, 5]]`、`k = 1`：答案是 5，這版回傳 15。

補上 `right == left` 時把 `right` 設成 `left + 1` 就 AC 了。

## 正確解法

```python
class Solution:
    def maximumCoins(self, coins: List[List[int]], k: int) -> int:
        def best_left_aligned(segs: List[List[int]]) -> int:   # 視窗左端對齊某段起點
            segs.sort()
            n = len(segs)
            right = full = best = 0
            for left in range(n):
                end = segs[left][0] + k - 1
                while right < n and segs[right][1] <= end:
                    l, r, c = segs[right]
                    full += (r - l + 1) * c
                    right += 1
                partial = 0
                if right < n and segs[right][0] <= end:
                    partial = (end - segs[right][0] + 1) * segs[right][2]
                best = max(best, full + partial)
                if right > left:
                    l, r, c = segs[left]
                    full -= (r - l + 1) * c
                else:
                    right = left + 1               # 這段比 k 長，沒有被完整蓋住
            return best

        mirrored = [[-r, -l, c] for l, r, c in coins]   # 右端對齊 = 鏡像後左端對齊
        return max(best_left_aligned([s[:] for s in coins]), best_left_aligned(mirrored))
```

## 複雜度

時間 `O(n log n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 只看左端對齊：權重不同時，最佳解可能是右端對齊。
- 某段比 `k` 長時，`right` 停在 `left`，下一輪要跳過這段。

## 面試口說整理

視窗往右推一格時，總和的變化在段落端點之間是固定的，所以最大值一定出現在視窗某一端對齊段落端點的時候。我用雙指針算「左端對齊段起點」的最大值，完整蓋住的段累加、下一段算部分；右端對齊的情況把座標鏡像後重用同一個函式。時間 `O(n log n)`。
