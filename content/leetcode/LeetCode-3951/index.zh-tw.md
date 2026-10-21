---
title: "LeetCode 3951: Minimum Energy to Maintain Brightness"
summary: "LeetCode 3951 解題筆記：一盞燈最多照亮 3 個位置，每個時間單位至少要 ceil(brightness / 3) 盞；合併區間算出需要的總時間再相乘"
description: "2026-06-11 的 LeetCode 3951 解題紀錄"
date: 2026-06-11
tags: ["medium", "array", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-06-11
- 提交紀錄：Accepted（一次通過）

## 解題思路

拆成兩件互不影響的事：

1. **每個時間單位要開幾盞**：一盞燈照亮自己和左右兩格，最多 3 個位置，所以至少要 `ceil(brightness / 3)` 盞。這個數量也一定做得到：把燈放在 1、4、7…，每盞照 3 格不重疊，最後一盞如果超出範圍就放在 `n - 1`，總共照到 `min(3k, n) >= brightness` 格（題目保證 `brightness <= n`）。
2. **哪些時間單位要開**：被至少一個區間覆蓋的時間。區間可能重疊，排序後合併再算總長度（[Array]({{< relref "/algorithm/Array" >}}) 模板五）。

答案是兩者相乘。

## 我的解法

```python
class Solution:
    def minEnergy(self, n: int, brightness: int, intervals: List[List[int]]) -> int:
        bulbs = (brightness + 2) // 3                  # ceil(brightness / 3)
        total = 0
        cur_s, cur_e = None, None
        for s, e in sorted(intervals):
            if cur_e is not None and s <= cur_e:       # 重疊（包含共用端點）就合併
                cur_e = max(cur_e, e)
            else:
                if cur_e is not None:
                    total += cur_e - cur_s + 1
                cur_s, cur_e = s, e
        total += cur_e - cur_s + 1
        return total * bulbs
```

## 複雜度

時間 `O(m log m)`，`m` 是區間數，空間 `O(m)`（排序）。

## 要特別避免的錯誤

- 區間是包含兩端的整數時間，長度是 `e - s + 1`，合併時共用端點也算重疊。
- `ceil(b / 3)` 用整數寫成 `(b + 2) // 3`。

## 面試口說整理

每盞燈最多照亮 3 個位置，所以每個時間單位需要 `ceil(brightness / 3)` 盞，而且一定排得出來。需要開燈的時間是區間的聯集，我排序後合併算出總長度，再乘上每單位的燈數。時間 `O(m log m)`。
