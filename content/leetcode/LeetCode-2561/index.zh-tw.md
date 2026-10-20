---
title: "LeetCode 2561: Rearranging Fruits"
summary: "LeetCode 2561 解題筆記：每種值總數要是偶數；多出來的排序後，便宜的一半各自跟貴的交換，成本取 min(便宜的值, 2 × 全域最小值)"
description: "2026-09-15 的 LeetCode 2561 解題紀錄"
date: 2026-09-15
tags: ["hard", "greedy", "hash-table", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-09-15
- 提交紀錄：Wrong Answer → Accepted ×2

## 解題思路

1. **可不可能**：兩籃最後要一樣，所以每種值的總數要是偶數，每籃各一半。有一種是奇數就回傳 -1。
2. **要換哪些**：每種值在籃子 1 裡多出或少了 `|count1 - total / 2|` 個。把兩邊多出來的都列出來（`need`），長度是 `2 × 交換次數`，每次交換把一邊多的一個和另一邊多的一個對調。
3. **怎麼配最便宜**：一次交換的成本是兩者較小的值。把 `need` 排序，讓便宜的前一半各配一個貴的，每次付便宜那個的值。
4. **借最小值當中介**：全域最小的水果 `m` 可以來回換兩次，把一對對調，成本 `2m`。所以每次的成本是 `min(need[i], 2m)`。

這是 [Greedy]({{< relref "/algorithm/Greedy" >}}) 模板四的配對想法。

## 我的嘗試

第一版想用兩個 deque 從兩邊配對，但抵銷共同部分的 `while` 條件用的是 `for k, v in ...items()` 取出的 `v`，**`v` 在迴圈裡不會變**，所以會一直減到另一邊歸零，計數變成負的。例如 `basket1 = [3, 3, 1]`、`basket2 = [1, 1, 1]`：答案是 1（拿一個 3 換一個 1），這版把 1 的計數減成 -2，最後回傳 0。這版也沒有考慮用最小值當中介。

改成上面的做法，就 AC 了。

## 正確解法

```python
class Solution:
    def minCost(self, basket1: List[int], basket2: List[int]) -> int:
        c1, total = Counter(basket1), Counter(basket1) + Counter(basket2)
        need = []
        for v, c in total.items():
            if c % 2:
                return -1
            need += [v] * abs(c // 2 - c1[v])
        need.sort()
        m = min(total)
        return sum(min(x, 2 * m) for x in need[:len(need) // 2])
```

## 複雜度

時間 `O(n log n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 迴圈條件不要用迴圈外取出、之後不會更新的值。
- 別忘了用全域最小值當中介，有時比直接換便宜。

## 面試口說整理

每種值總數要是偶數才可能。我把兩籃多出來的水果列出來排序，便宜的一半各跟貴的一個交換，成本是便宜的那個；也可以用全域最小值來回換兩次，成本是兩倍最小值，所以每次取兩者較小的。時間 `O(n log n)`。
