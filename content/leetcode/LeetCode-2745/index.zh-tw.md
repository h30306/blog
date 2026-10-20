---
title: "LeetCode 2745: Construct the Longest New String"
summary: "LeetCode 2745 解題筆記：AA 和 BB 必須交替出現，最多用 min(x, y) 對，多的那種還能再多放一個；AB 全部都能接上"
description: "2025-07-22 的 LeetCode 2745 解題紀錄"
date: 2025-07-22
tags: ["medium", "dynamic-programming", "math", "greedy", "brainteaser"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2025-07-22
- 提交紀錄：Accepted（一次通過）

## 解題思路

不能出現 `AAA` 或 `BBB`：

- `AA` 後面不能接 `AA` 或 `AB`（會變成 `AAA`），只能接 `BB`。
- `BB` 後面不能接 `BB`，可以接 `AA` 或 `AB`。
- `AB` 後面可以接 `AA` 或 `AB`，不能接 `BB`。

所以 `AA` 和 `BB` 一定要交替：`AABBAABB...`，最多用 `min(x, y)` 對；如果有一種比較多，可以在頭或尾再多放一個。`AB` 全部可以串在一起，接在 `BB` 後面、`AA` 前面（`...BB ABAB AA...`），所以全部都用得上。

```text
x == y：(2x + z) × 2
x != y：(2 × min(x, y) + 1 + z) × 2
```

## 我的解法

```python
class Solution:
    def longestString(self, x: int, y: int, z: int) -> int:
        pairs = min(x, y)
        pieces = 2 * pairs + (1 if x != y else 0) + z     # 用了幾個字串
        return pieces * 2                                 # 每個字串長度 2
```

LeetCode 的標籤是 DP（可以用 `dp[x][y][z][上一個是什麼]` 做），但找出規律之後是 `O(1)`。

## 複雜度

時間 `O(1)`，空間 `O(1)`。

## 要特別避免的錯誤

- 以為 `AB` 有限制：`ABAB` 不會產生 `AAA` 或 `BBB`，全部都能用。

## 面試口說整理

`AA` 後面只能接 `BB`，所以 `AA` 和 `BB` 一定交替，最多用比較少的那種的兩倍，多的那種再多一個；`AB` 可以全部串在一起，放在 `BB` 和 `AA` 之間。算出用了幾個字串再乘 2。時間 `O(1)`。
