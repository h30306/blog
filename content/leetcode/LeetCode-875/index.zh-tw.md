---
title: "LeetCode 875: Koko Eating Bananas"
summary: "LeetCode 875 解題筆記：對速度二分，找最小的 k 讓總時數 <= h；時數剛好等於 h 時還要繼續往左找"
description: "2022-10-28 的 LeetCode 875 解題紀錄"
date: 2022-10-28
tags: ["medium", "array", "binary-search"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-10-28
- 提交紀錄：Wrong Answer ×9 → Runtime Error → Wrong Answer ×3 → Accepted ×2 → Wrong Answer → Accepted ×3

## 解題思路

速度越快、花的時數越少，有單調性，對答案二分（[Binary Search]({{< relref "/algorithm/Binary-Search" >}}) 模板二）。找**最小**的 `k` 讓 `sum(ceil(p / k)) <= h`：

- 時數 `<= h`：`k` 可行，但可能還有更小的，`r = mid`。
- 時數 `> h`：太慢，`l = mid + 1`。

速度範圍是 `[1, max(piles)]`。

## 我的嘗試

這題提交了 19 次，問題都在二分的方向和停止條件：

- 時數剛好等於 `h` 就直接回傳，但可能還有更小的速度也行。例如 `[4]`、`h = 5`：速度 1 就夠，回傳了 4。
- 改了幾次之後方向反了：寫成 `times < h` 時往左、其他（包括相等）往右，相等時把可行的答案丟掉了。例如 `[7]`、`h = 2`：答案 4，回傳 7。

## 正確解法

```python
class Solution:
    def minEatingSpeed(self, piles: List[int], h: int) -> int:
        l, r = 1, max(piles)
        while l < r:
            mid = (l + r) // 2
            hours = sum((p + mid - 1) // mid for p in piles)
            if hours <= h:
                r = mid
            else:
                l = mid + 1
        return l
```

## 複雜度

時間 `O(n log M)`，`M` 是最大的一堆，空間 `O(1)`。

## 要特別避免的錯誤

- 時數剛好等於 `h` 不代表是最小的速度，還要往左找。
- 向上取整用整數 `(p + k - 1) // k`。

## 面試口說整理

速度越快時數越少，所以我對速度二分：時數不超過 `h` 就往左找更小的速度，超過就往右。範圍是 1 到最大的一堆。時間 `O(n log M)`。
