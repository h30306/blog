---
title: "LeetCode 2355: Maximum Number of Books You Can Take"
summary: "LeetCode 2355 解題筆記：以 i 結尾時往左每格少拿 1 本，直到碰到書比較少的瓶頸書架 j；用單調堆疊找 j，dp[i] = dp[j] + 等差數列和"
description: "2026-07-26 的 LeetCode 2355 解題紀錄"
date: 2026-07-26
tags: ["hard", "dynamic-programming", "monotonic-stack", "stack", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-07-26
- 提交紀錄：Accepted ×2

## 解題思路

`dp[i]` = 拿到第 `i` 個書架為止（`i` 是最右邊）最多拿幾本。

以 `i` 結尾時，第 `i` 格拿 `books[i]` 本最好，往左每一格要嚴格少 1 本：第 `k` 格最多拿 `books[i] - (i - k)` 本。往左走，直到碰到某一格 `j` 的書**不夠**這個數量：`books[j] < books[i] - (i - j)`，也就是 **`books[j] - j < books[i] - i`**。

- `j` 右邊的 `j + 1..i` 這段可以照等差數列拿：從 `books[i]` 往下數，最多 `i - j` 格，而且不能少於 1，所以拿 `length = min(i - j, books[i])` 格。
- 到 `j` 時，`j` 自己能拿的上限是 `books[j]`，比等差數列給的還少，所以從 `j` 往左就是 `dp[j]`。

```text
dp[i] = dp[j] + (books[i] + (books[i] - length + 1)) × length / 2
```

找「左邊第一個 `books[j] - j < books[i] - i` 的 `j`」就是**單調堆疊**：維護 `books[k] - k` 遞增的堆疊，`>=` 的都彈掉。

## 我的解法

```python
class Solution:
    def maximumBooks(self, books: List[int]) -> int:
        n = len(books)
        dp = [0] * n
        stack = []                                 # books[k] - k 遞增
        for i in range(n):
            while stack and books[stack[-1]] - stack[-1] >= books[i] - i:
                stack.pop()
            j = stack[-1] if stack else -1         # 左邊第一個瓶頸
            length = min(i - j, books[i])
            dp[i] = (books[i] + books[i] - length + 1) * length // 2
            if j >= 0:
                dp[i] += dp[j]
            stack.append(i)
        return max(dp)
```

兩次 AC 的差別只在判斷式的寫法：`books[top] >= books[i] - (i - top)` 和 `books[top] - top >= books[i] - i` 是同一件事，後者比較容易看出單調性。

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 等差數列的長度不能超過 `books[i]`：最少要拿 1 本，往左最多 `books[i]` 格。
- 瓶頸的條件是嚴格小於：`books[j] - j < books[i] - i`。

## 面試口說整理

以 `i` 結尾時，`i` 拿滿，往左每格少拿一本，直到碰到書不夠的書架 `j`，條件整理後是 `books[j] - j < books[i] - i`。`j` 右邊照等差數列拿，`j` 往左就是 `dp[j]`。找左邊第一個這樣的 `j` 用單調堆疊，時間 `O(n)`。
