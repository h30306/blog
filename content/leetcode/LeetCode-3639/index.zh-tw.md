---
title: "LeetCode 3639: Minimum Time to Activate String"
summary: "LeetCode 3639 解題筆記：每個新星號貢獻 (左距離) × (右距離) 個新子字串；或對時間二分"
description: "2025-08-03 的 LeetCode 3639 解題紀錄"
date: 2025-08-03
tags: ["medium", "binary-search", "counting", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2025-08-03
- 提交紀錄：Accepted（一次通過）

## 解題思路

每個時間點把一個位置換成 `*`，問「至少包含一個 `*` 的子字串數量」第一次 `>= k` 是什麼時候。

### 我的做法：每個新星號帶來多少新的合法子字串

在位置 `idx` 放上星號時，找到它左邊最近的星號 `left` 和右邊最近的星號 `right`（沒有就用 `-1` 和 `n`）。

**新增的合法子字串**，就是「包含 `idx`、但不包含任何其他星號」的子字串：起點在 `(left, idx]`、終點在 `[idx, right)`，共 `(idx - left) * (right - idx)` 個。

累加起來第一次 `>= k` 的時間就是答案。

## 我的解法

```python
import bisect

class Solution:
    def minTime(self, s: str, order: List[int], k: int) -> int:
        n = len(s)
        stars = [-1, n]                       # 排序好的星號位置，加上兩個哨兵
        total = 0
        for t, idx in enumerate(order):
            i = bisect.bisect_left(stars, idx)
            left, right = stars[i - 1], stars[i]
            total += (idx - left) * (right - idx)
            if total >= k:
                return t
            stars.insert(i, idx)
        return -1
```

原本是手寫 lower bound，這裡換成 `bisect`。

這個寫法有個隱憂：`list.insert` 是 `O(n)`，最壞是 `O(n^2)`。實際上 `insert` 是很快的記憶體搬移，所以 `n = 10^5` 也能過，但面試時最好提出更穩的做法。

## 更穩的做法：對時間二分

「時間越晚，星號越多，合法子字串越多」，所以 `check(t) = 前 t+1 個星號放下後，合法子字串數是否 >= k` 是單調的，可以對 `t` 二分。

`check` 用補集算：全部子字串 `n(n+1)/2`，減掉不含星號的子字串。不含星號的子字串，就是每一段連續沒有星號的區間，長度 `L` 的區間有 `L(L+1)/2` 個。

```python
class Solution:
    def minTime(self, s: str, order: List[int], k: int) -> int:
        n = len(s)
        total = n * (n + 1) // 2
        if total < k:
            return -1

        def count(t: int) -> int:
            star = [False] * n
            for idx in order[:t + 1]:
                star[idx] = True
            bad = run = 0
            for is_star in star:
                run = 0 if is_star else run + 1
                bad += run                    # 以這格結尾、不含星號的子字串數
            return total - bad

        lo, hi = 0, n - 1
        while lo < hi:
            mid = (lo + hi) // 2
            if count(mid) >= k:
                hi = mid
            else:
                lo = mid + 1
        return lo
```

`bad += run` 是「以目前位置結尾的無星號子字串有 `run` 個」，累加起來就是所有無星號子字串的數量。

## 複雜度

| 解法 | 時間 |
|---|---|
| 逐一插入星號 | 最壞 `O(n^2)`（`list.insert`） |
| 對時間二分 | `O(n log n)` |

## 要特別避免的錯誤

- 每加一個星號就重新數全部子字串：`O(n^2)` 以上。
- 沒有先檢查 `k` 是否超過子字串總數：所有位置都變成星號也達不到時要回傳 `-1`。
- 貢獻公式寫成 `(idx - left + 1) * (right - idx + 1)`：左右邊界的星號本身不能包含進去。

## 面試口說整理

每放下一個星號，新增的合法子字串就是包含它、但不包含其他星號的子字串，個數是它到左右最近星號的距離相乘，所以我用一個有序的星號列表加 bisect 找左右鄰居，邊加邊累計。因為插入是 `O(n)`，更穩的做法是對時間二分：星號越多合法子字串越多，`check` 用總數減掉無星號區間的子字串數，`O(n)` 算完，總共 `O(n log n)`。
