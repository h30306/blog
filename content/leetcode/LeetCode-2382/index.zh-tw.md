---
title: "LeetCode 2382: Maximum Segment Sum After Removals"
summary: "LeetCode 2382 解題筆記：倒著做，把刪除變成加回去；Union-Find 的根記區段總和，最大值只會變大"
description: "2026-07-26 的 LeetCode 2382 解題紀錄"
date: 2026-07-26
tags: ["hard", "union-find", "prefix-sum", "ordered-set", "array"]
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
- 提交紀錄：Time Limit Exceeded ×2 → Accepted → Wrong Answer → Accepted

## 解題思路

一個一個刪除會把區段切開，但 Union-Find 只能合併。**倒著做**（[Union-Find]({{< relref "/algorithm/Union-Find" >}}) 的「倒著做」）：從全部刪光開始，依相反順序把元素加回去，跟左右已經存在的區段合併。

- 每個根記它的區段總和 `total[root]`。
- 倒著加回去時區段只會變長、總和只會變大（數字都是正的），所以目前最大值用一個變數維護就好。
- 第 `i` 次刪除後的答案，就是倒著加回 `removeQueries[i]` **之前**的最大值。

## 我的嘗試

| 版本 | 問題 |
|---|---|
| 兩次 TLE | 想法對，但每一步都用 `max(group_sum.values())` 重算所有區段的最大值，整體 `O(n²)`；第一版的 `find` 也沒有路徑壓縮 |
| AC | 改用陣列，最大值用一個變數維護 |
| WA | 換一個做法：排序好的刪除位置 + 前綴和 + 堆積延遲刪除。但從堆積拿掉時**沒有把刪除計數減 1**，一個區段被刪，所有同樣總和的區段都跟著被丟掉。例如 `nums = [3, 1, 3]`、`removeQueries = [1, 2, 0]`：答案是 `[3, 3, 0]`，這版回傳 `[3, 0, 0]` |
| AC | 補上計數減 1（但 `list.insert` 是 `O(n)`，跑了 1.3 秒） |

## 正確解法

```python
class Solution:
    def maximumSegmentSum(self, nums: List[int], removeQueries: List[int]) -> List[int]:
        n = len(nums)
        parent = list(range(n))
        total = [0] * n
        alive = [False] * n

        def find(x):
            while parent[x] != x:
                parent[x] = parent[parent[x]]
                x = parent[x]
            return x

        res, best = [], 0
        for i in reversed(removeQueries):
            res.append(best)                       # 加回 i 之前的答案
            alive[i] = True
            total[i] = nums[i]
            for j in (i - 1, i + 1):
                if 0 <= j < n and alive[j]:
                    rj, ri = find(j), find(i)
                    parent[rj] = ri
                    total[ri] += total[rj]
            best = max(best, total[find(i)])
        return res[::-1]
```

## 複雜度

時間 `O(n · α(n))`，空間 `O(n)`。

## 要特別避免的錯誤

- 不要每一步都重算所有集合的最大值。
- 延遲刪除時，從堆積拿掉一個就要把對應的計數減 1。
- 記錄答案要在加回之前，而且最後要反轉。

## 面試口說整理

刪除會切開區段，Union-Find 不能拆，所以我倒著把元素加回去，跟左右存在的區段合併，根上記總和。數字都是正的，加回去最大值只會變大，用一個變數維護。每次加回之前的最大值就是那次刪除後的答案，最後反轉。時間 `O(n α(n))`。
