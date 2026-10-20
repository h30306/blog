---
title: "LeetCode 2105: Watering Plants II"
summary: "LeetCode 2105 解題筆記：Alice 從左、Bob 從右，對撞指針模擬澆水；相遇在同一株時由水比較多的人澆"
description: "2026-01-24 的 LeetCode 2105 解題紀錄"
date: 2026-01-24
tags: ["medium", "two-pointers", "simulation", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-24
- 提交紀錄：Accepted（一次通過）

## 解題思路

兩個人同時開始、每株花的時間一樣，所以第 `t` 步 Alice 在 `t`、Bob 在 `n - 1 - t`，就是對撞指針。

每一步：

- 水夠就直接澆，不夠就先補滿（次數 +1）再澆。
- `left == right`（奇數長度的中間那株）：由水比較多的人澆，一樣多由 Alice 澆。只要「比較多的那個」水夠，就不用補水；否則補一次。

## 我的解法

```python
class Solution:
    def minimumRefill(self, plants: List[int], capacityA: int, capacityB: int) -> int:
        a, b = capacityA, capacityB
        left, right = 0, len(plants) - 1
        refills = 0
        while left < right:
            if a < plants[left]:
                a = capacityA
                refills += 1
            a -= plants[left]
            if b < plants[right]:
                b = capacityB
                refills += 1
            b -= plants[right]
            left += 1
            right -= 1
        if left == right and max(a, b) < plants[left]:
            refills += 1                       # 中間那株：水多的人也不夠才補
        return refills
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 補水時寫成 `a = capacityA` 之後忘了扣掉這株的水量。
- 中間那株讓兩個人都澆，或固定讓 Alice 澆。

## 面試口說整理

兩個人速度一樣，所以 Alice 從左、Bob 從右就是對撞指針。每一步水不夠就先補滿再澆，補水次數加一。奇數長度時兩人會在中間相遇，由水多的人澆，只有水多的人也不夠時才補一次。時間 `O(n)`。
