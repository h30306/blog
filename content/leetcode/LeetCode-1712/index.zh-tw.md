---
title: "LeetCode 1712: Ways to Split Array Into Three Subarrays"
summary: "LeetCode 1712 解題筆記：固定第一刀，第二刀的合法範圍用兩次 bisect 或兩個單調指針找出來"
description: "2026-01-22 的 LeetCode 1712 解題紀錄"
date: 2026-01-22
tags: ["medium", "binary-search", "prefix-sum", "two-pointers"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-22
- 提交紀錄：TLE → WA（01-22）→ TLE → AC → TLE → AC → AC（bisect 版，01-24）

## 解題思路

切兩刀，把陣列分成 `left`、`mid`、`right`，要滿足 `sum(left) <= sum(mid) <= sum(right)`。數字都非負。

用前綴和 `P[j] = nums[0] + ... + nums[j]`。固定第一刀在 `i`（`left = nums[0..i]`），第二刀在 `j`（`mid = nums[i+1..j]`）：

```text
sum(left) <= sum(mid)   ⟺  P[i] <= P[j] - P[i]         ⟺  P[j] >= 2 * P[i]
sum(mid)  <= sum(right) ⟺  P[j] - P[i] <= P[-1] - P[j]  ⟺  P[j] <= (P[-1] + P[i]) / 2
```

數字非負，所以 `P` 是遞增的，**合法的 `j` 是一段連續的區間**，可以用 bisect 找左右邊界。另外 `j` 的範圍是 `[i + 1, n - 2]`，因為三段都不能是空的。

## 我的嘗試

### 第一天：滑動窗口的思路不對

一開始想用一個窗口同時推三段，邏輯沒有對應到「固定第一刀、數第二刀的合法範圍」，TLE 和 WA。

### 第二天：兩個指針，但其中一個會往回走

改成固定 `i`，用 `j_low`、`j_high` 兩個指針找第二刀的範圍：

```python
j_low = min(i + 1, j_low)          # 應該是 max
```

`i` 往右時，兩個邊界都只會往右移，所以指針應該只往前。寫成 `min` 會把 `j_low` 拉回 `i + 1`，每一輪都從頭掃，變成 `O(n^2)`，TLE。改成 `max` 就 AC 了。

中間有一次 TLE 是不小心交回了 `min` 的舊版。

## 正確解法

### 解法一：兩次 bisect

```python
import bisect
from itertools import accumulate

class Solution:
    def waysToSplit(self, nums: List[int]) -> int:
        P = list(accumulate(nums))
        n, total = len(nums), P[-1]
        ans = 0
        for i in range(n - 2):
            lo = bisect.bisect_left(P, 2 * P[i], i + 1, n - 1)
            hi = bisect.bisect_right(P, (total + P[i]) // 2, i + 1, n - 1)
            if hi > lo:
                ans += hi - lo
        return ans % (10 ** 9 + 7)
```

`bisect` 的 `lo`、`hi` 參數把搜尋範圍限制在 `[i + 1, n - 1)`，剛好是第二刀的合法位置。

`P[j] <= (total + P[i]) / 2` 寫成整數的 `// 2` 也對：`P[j]` 是整數，小於等於某個數就等於小於等於它的 floor。

### 解法二：兩個只往前的指針

```python
class Solution:
    def waysToSplit(self, nums: List[int]) -> int:
        n = len(nums)
        prefix = [0] * (n + 1)
        for i in range(n):
            prefix[i + 1] = prefix[i] + nums[i]

        ans = 0
        j_low = j_high = 1
        for i in range(n - 2):
            j_low = max(j_low, i + 1)
            while j_low < n - 1 and prefix[j_low + 1] < 2 * prefix[i + 1]:
                j_low += 1
            j_high = max(j_high, j_low)
            while j_high < n - 1 and 2 * prefix[j_high + 1] <= prefix[n] + prefix[i + 1]:
                j_high += 1
            ans += j_high - j_low
        return ans % (10 ** 9 + 7)
```

## 複雜度

| 解法 | 時間 |
|---|---|
| 兩次 bisect | `O(n log n)` |
| 兩個單調指針 | `O(n)` |

空間都是 `O(n)`。

## 要特別避免的錯誤

- 單調指針寫成 `min`，讓它往回走。
- 第二刀的範圍沒有限制在 `[i + 1, n - 2]`：三段都不能是空的。
- 合法範圍是空的時候（`hi <= lo`）要跳過，不能把負數加進答案。

## 面試口說整理

我先建前綴和，固定第一刀 `i`，把兩個不等式改寫成第二刀前綴和的上下界：`P[j] >= 2 P[i]` 和 `P[j] <= (total + P[i]) / 2`。數字非負所以前綴和遞增，合法的第二刀是一段連續區間，用兩次 bisect 找邊界，並限制 `j` 在 `[i+1, n-2]`。也可以用兩個只往右移的指針做到 `O(n)`。
