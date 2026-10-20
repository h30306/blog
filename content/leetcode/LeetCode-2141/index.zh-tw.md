---
title: "LeetCode 2141: Maximum Running Time of N Computers"
summary: "LeetCode 2141 解題筆記：比平均時間還大的電池只能給一台電腦用，連同那台電腦一起拿掉，剩下的取平均；要用嚴格的大於"
description: "2026-07-28 的 LeetCode 2141 解題紀錄"
date: 2026-07-28
tags: ["hard", "greedy", "binary-search", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-07-28
- 提交紀錄：Wrong Answer ×2 → Accepted

## 解題思路

電池可以隨時換，所以只要電量總和夠，時間可以平均分攤：理想上能跑 `total // n` 分鐘。

例外是**特別大的電池**：一顆電池同一時間只能放在一台電腦裡，所以它最多貢獻 `T` 分鐘給一台電腦。如果最大的電池比平均 `total // n` 還大，就讓它專門供一台電腦，多出來的電量浪費掉；把它和那台電腦一起拿掉，剩下的重新算平均。一直做到最大的電池不超過平均為止（[Greedy]({{< relref "/algorithm/Greedy" >}}) 模板六）。

## 我的嘗試

1. **第一版**拿掉電池時**沒有從總和扣掉**。例如 `n = 2`、`[7, 5]`：答案是 5，這版拿掉 7 之後用 `12 // 1` 回傳 12。
2. **第二版**扣掉了，但條件是 `avg <= batteries[-1]`，**等於平均的電池也被拿掉**。例如 `n = 2`、`[4, 1, 4]`：平均 `9 // 2 = 4`，拿掉一顆 4 之後剩 `[1, 4]` 給一台，平均變成 5，但被拿掉的那台只能跑 4 分鐘，答案是 4，這版回傳 5。
3. 改成嚴格的 `<`，就 AC 了。

為什麼嚴格大於才安全：如果 `b > total / n`，拿掉後的平均 `(total - b) / (n - 1)` 一定小於 `total / n`，也就小於 `b`，被拿掉的那台跑得比剩下的久；等於平均時就不一定了。

## 正確解法

```python
class Solution:
    def maxRunTime(self, n: int, batteries: List[int]) -> int:
        batteries.sort()
        total = sum(batteries)
        while batteries[-1] > total // n:
            total -= batteries.pop()
            n -= 1
        return total // n
```

`n = 1` 時平均就是總和，一定不小於最大的電池，迴圈不會把 `n` 減到 0。

也可以二分答案 `T`：檢查 `sum(min(b, T)) >= n * T`，每顆電池最多貢獻 `T`。

## 複雜度

時間 `O(m log m)`，`m` 是電池數，空間 `O(1)`（不算排序）。

## 要特別避免的錯誤

- 拿掉電池時，總和也要扣掉。
- 等於平均的電池不要拿掉，條件要用嚴格大於。

## 面試口說整理

電池可以隨時換，所以理想上能跑總電量除以電腦數。但一顆電池同時只能給一台用，如果它比平均還大，就讓它專門供一台，把兩者一起拿掉重算平均，直到最大的電池不超過平均。要用嚴格大於，因為等於平均的電池拿掉後剩下的平均可能比它大。時間 `O(m log m)`。
