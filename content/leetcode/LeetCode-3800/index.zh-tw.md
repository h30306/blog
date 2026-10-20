---
title: "LeetCode 3800: Minimum Cost to Make Two Binary Strings Equal"
summary: "LeetCode 3800 解題筆記：不相等的位置分兩類；不同類的兩兩用 swap，同類的兩兩用 cross + swap，剩一個只能 flip，每種都跟兩次 flip 比"
description: "2026-01-04 的 LeetCode 3800 解題紀錄"
date: 2026-01-04
tags: ["medium", "greedy", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-04
- 提交紀錄：Accepted（一次通過）

## 解題思路

只有 `s[i] != t[i]` 的位置要處理，分成兩類：

- `c0`：`s[i] = 0, t[i] = 1`。
- `c1`：`s[i] = 1, t[i] = 0`。

修法（[Greedy]({{< relref "/algorithm/Greedy" >}}) 模板四「配對與奇偶」）：

| 情況 | 做法 | 成本 |
|---|---|---|
| 一個 `c0` 配一個 `c1` | 在 `s` 裡把這兩格交換 | `min(swap, 2 × flip)` |
| 兩個同類 | 先 cross 其中一格，它就變成另一類，再 swap | `min(cross + swap, 2 × flip)` |
| 剩一個 | 只能 flip | `flip` |

不同類的配對越多越好（`min(c0, c1)` 對），剩下的 `|c0 - c1|` 個同類兩兩配，奇數個時剩一個 flip。

## 我的解法

我當時列了三種整體方案取最小：全部 flip；不同類 swap、其餘 flip；不同類 swap、同類 cross + swap、剩一個 flip。這裡整理成每一種配對各自取最便宜：

```python
class Solution:
    def minimumCost(self, s: str, t: str, flipCost: int, swapCost: int, crossCost: int) -> int:
        c = [0, 0]
        for a, b in zip(s, t):
            if a != b:
                c[int(a)] += 1
        pairs = min(c)                 # 不同類配對
        rest = abs(c[0] - c[1])        # 剩下的都是同一類
        return (pairs * min(swapCost, 2 * flipCost)
                + rest // 2 * min(crossCost + swapCost, 2 * flipCost)
                + rest % 2 * flipCost)
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 同類的兩格不能直接 swap（交換兩個一樣的值沒用），要先 cross 變成不同類。
- 每一種配對都要跟「兩次 flip」比較，flip 可能比較便宜。

## 面試口說整理

我把不相等的位置分成 `s` 是 0 和 `s` 是 1 兩類。不同類的兩格用一次 swap 修好，同類的兩格先 cross 一格再 swap，剩一個只能 flip；每種都跟兩次 flip 比較取便宜的。時間 `O(n)`。
