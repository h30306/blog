---
title: "LeetCode 4098: Minimize the Maximum Value of GCD-Connected Array"
summary: "LeetCode 4098 解題筆記：value 的最小質因數 p 決定一切：後一個最小是 value + p，之後都是偶數每次加 2；左邊可行的條件是 value - p >= 2 * index"
description: "2026-11-02 的 LeetCode 4098 解題紀錄"
date: 2026-11-02
tags: ["medium", "math", "number-theory", "greedy"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-11-02
- 提交紀錄：Wrong Answer ×2 → Accepted

## 解題思路

陣列要嚴格遞增、`nums[index] = value`、相鄰兩個的 gcd 大於 1。要讓最後一個數最小。

關鍵是 `gcd(value, value + d) = gcd(value, d)`。所以和 `value` 有公因數的數，離 `value` 最近的距離是 `value` 的**最小質因數 `p`**（[Number Theory]({{< relref "/algorithm/Number-Theory" >}})）：

- `value + p`、`value - p` 一定是偶數：`p = 2` 時 `value` 是偶數；`p` 是奇數時 `value` 也是奇數，奇數加減奇數是偶數。
- 偶數之後可以一直接下一個偶數（gcd 至少是 2），每次只多 2，不可能更省。

**右邊**：`index` 後面還有 `t = n - 1 - index` 個數。

- `t = 0`：答案就是 `value`。
- 否則：`value + p`，接著每次加 2，最後一個是 `value + p + 2 * (t - 1)`。

**左邊**只要確認可行：前一個最大是 `value - p`，再往前每次減 2，第一個數至少要是 2，所以 `index` 個數要放得下：`value - p - 2 * (index - 1) >= 2`，也就是 `value - p >= 2 * index`。`value = 1` 沒有質因數，一定不可行（除非它不需要任何鄰居，但 `n >= 2` 一定有鄰居）。

`value` 到 `10^9`，用試除法到 `sqrt(value)` 找最小質因數。

## 我的嘗試

比賽中錯了兩次：

1. 第一版想得太複雜：用篩法列出 `value` 的質因數，再用 Euler phi 算「比 `value` 小、和 `value` 有公因數的數」有幾個，拿來和 `index` 比；答案一律回傳 `value + 最小質因數`。兩邊都錯：
   - 左邊只要求**相鄰兩個**有公因數，不需要每個數都和 `value` 有公因數。`n = 4, index = 3, value = 9` 可以是 `[2,4,6,9]`，我回傳 -1。
   - 右邊沒管 `index` 後面還有幾個數：`n = 4, index = 3, value = 12` 答案是 12，我回傳 14；`n = 4, index = 0, value = 8` 答案是 14（`[8,10,12,14]`），我回傳 10。
   - 另外篩法要開長度 `value` 的陣列，`value` 到 `10^9` 本來就不可行。
2. 加了 `value == 1` 的判斷，其他沒改，一樣錯。
3. 換成上面的推導，過了。

## 正確解法

```python
class Solution:
    def minimumMaxValue(self, n: int, index: int, value: int) -> int:
        if value == 1:
            return -1
        p = value
        d = 2
        while d * d <= value:
            if value % d == 0:
                p = d
                break
            d += 1
        if value - p < 2 * index:
            return -1
        t = n - 1 - index
        return value if t == 0 else value + p + 2 * (t - 1)
```

## 複雜度

時間 `O(sqrt(value))`，空間 `O(1)`。

## 要特別避免的錯誤

- 條件是**相鄰**兩數 gcd > 1，不是每個數都要和 `value` 有公因數。
- 答案和 `index` 後面有幾個數有關，`index` 是最後一個時答案就是 `value`。
- `value` 到 `10^9`，不能開長度 `value` 的篩法陣列。

## 面試口說整理

`gcd(value, value + d) = gcd(value, d)`，所以離 `value` 最近、又和它有公因數的數距離是最小質因數 `p`，而且 `value ± p` 一定是偶數，之後就能每次 ±2。右邊有 `t` 個數，答案是 `value + p + 2(t - 1)`，`t = 0` 時是 `value`；左邊要放得下 `index` 個至少是 2 的數，條件是 `value - p >= 2 * index`。試除找最小質因數，時間 `O(sqrt(value))`。
