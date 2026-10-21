---
title: "LeetCode 981: Time Based Key-Value Store"
summary: "LeetCode 981 解題筆記：每個 key 存一個 (timestamp, value) 的 list，timestamp 是遞增的；get 時二分找最後一個 timestamp <= 查詢時間的"
description: "2022-10-28 的 LeetCode 981 解題紀錄"
date: 2022-10-28
tags: ["medium", "hash-table", "string", "binary-search", "design"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-10-28
- 提交紀錄：Runtime Error ×4 → Time Limit Exceeded ×2 → Runtime Error → Time Limit Exceeded → Wrong Answer → Time Limit Exceeded ×2 → Runtime Error → Time Limit Exceeded ×2 → Wrong Answer → Time Limit Exceeded ×2 → Output Limit Exceeded → Time Limit Exceeded ×3 → Runtime Error → Output Limit Exceeded → Wrong Answer → Time Limit Exceeded ×2 → Runtime Error → Time Limit Exceeded → Accepted → Wrong Answer → Runtime Error → Accepted ×2

## 解題思路

`set` 的 timestamp 是嚴格遞增的，所以每個 key 的 list 自然是排序好的（[Binary Search]({{< relref "/algorithm/Binary-Search" >}}) 模板一）。`get` 要的是「最後一個 `timestamp <= t`」，等於「第一個 `> t` 的位置減一」，用 `bisect_right` 找。key 不存在或找不到時回傳空字串。

## 我的嘗試

這題提交了 33 次：

- 二分的時候寫成 `l += 1` / `r -= 1`，每次只移一格，等於線性搜尋，一直 TLE。
- `get` 沒出現過的 key 時直接 `self.map[key]`，KeyError。
- tuple 的順序存成 `(timestamp, value)`，取的時候卻當成 `(value, timestamp)`；也有幾次留著 debug 的 `print`，Output Limit Exceeded。

## 正確解法

```python
class TimeMap:
    def __init__(self):
        self.times = defaultdict(list)
        self.values = defaultdict(list)

    def set(self, key: str, value: str, timestamp: int) -> None:
        self.times[key].append(timestamp)
        self.values[key].append(value)

    def get(self, key: str, timestamp: int) -> str:
        i = bisect.bisect_right(self.times[key], timestamp)
        return self.values[key][i - 1] if i else ""
```

## 複雜度

`set` 是 `O(1)`，`get` 是 `O(log n)`，空間 `O(n)`。

## 要特別避免的錯誤

- `get` 一個沒出現過的 key 要回傳空字串，不能 KeyError。
- 二分時要往右縮（`l = mid + 1`），每次只移一格（`l += 1`）就退化成線性，會 TLE。

## 面試口說整理

timestamp 是遞增的，所以我每個 key 存一個 timestamp 的 list 和對應的值，`get` 時用 `bisect_right` 找最後一個不超過查詢時間的位置。`set` 是 `O(1)`，`get` 是 `O(log n)`。
