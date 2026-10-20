---
title: "LeetCode 135: Candy"
summary: "LeetCode 135 解題筆記：左往右掃一次滿足左鄰居、右往左掃一次滿足右鄰居，每個人取兩者較大值"
description: "2025-08-05 的 LeetCode 135 解題紀錄"
date: 2025-08-05
tags: ["hard", "greedy", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2025-08-05
- 提交紀錄：Runtime Error ×3 → Accepted ×2 → Time Limit Exceeded → Accepted

## 解題思路

每個人的條件同時跟左右鄰居有關，分開處理（[Greedy]({{< relref "/algorithm/Greedy" >}}) 模板三）：

- `left[i]`：只看左邊。分數比左邊高就是 `left[i - 1] + 1`，否則 1。
- `right[i]`：只看右邊，從右往左算。
- 每個人拿 `max(left[i], right[i])`。

兩個值都是必要的下界：往左一路遞增的長度決定了至少要幾顆，往右也一樣，所以取較大值就是最少的。

## 我的嘗試

我一開始用分治：找區間內分數最高的人，先遞迴處理左右兩半，再讓他比較低的鄰居多 1 顆。

| 版本 | 問題 |
|---|---|
| 前兩次 RE | 用 `ratings.index(max(ratings[left:right]))` 在**整個陣列**找最大值的位置，找到的可能在區間外。`[2, 2]` 給了 3 顆（答案 2），`[4, 1, 2]` 無限遞迴 |
| 第三次 RE | 改成在切片裡找，但右半邊的條件寫成 `max_index < n - 1`，最大值在區間最右邊時會遞迴到空區間，`max()` 對空序列報錯，例如 `[0, 2, 4]` |
| 兩次 AC | 條件改成 `max_index < right - 1`，但跑了 6.5 秒：分數遞增時每層只少一個，`O(n²)` |
| TLE | 把內建的 `max` / `index` 換成自己的 for 迴圈，演算法一樣是 `O(n²)`，Python 迴圈更慢 |

## 正確解法

```python
class Solution:
    def candy(self, ratings: List[int]) -> int:
        n = len(ratings)
        left = [1] * n
        for i in range(1, n):
            if ratings[i] > ratings[i - 1]:
                left[i] = left[i - 1] + 1
        right = [1] * n
        for i in range(n - 2, -1, -1):
            if ratings[i] > ratings[i + 1]:
                right[i] = right[i + 1] + 1
        return sum(max(a, b) for a, b in zip(left, right))
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 遞迴處理子區間時，位置要在子區間裡找，不是整個陣列。
- 遞迴的邊界要用子區間的右端，不是整個陣列的右端。
- 每層找最大值再分治，遇到單調的輸入會退化成 `O(n²)`。

## 面試口說整理

條件跟左右兩邊都有關，所以我分兩次掃：左往右時，比左邊高就比左邊多 1；右往左時，比右邊高就比右邊多 1。每個人取兩者較大值，因為兩個都是必要的下界。時間 `O(n)`。
