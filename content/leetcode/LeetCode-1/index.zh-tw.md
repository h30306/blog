---
title: "LeetCode 1: Two Sum"
summary: "LeetCode 1 解題筆記：一邊掃一邊把看過的數存進雜湊表，查 target - x 有沒有出現過；先查再存，同一個元素才不會用兩次"
description: "2019-09-14 的 LeetCode 1 解題紀錄"
date: 2019-09-14
tags: ["easy", "array", "hash-table"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2019-09-14
- 提交紀錄：Runtime Error → Accepted ×2 → Wrong Answer → Accepted ×2 → Runtime Error → Wrong Answer ×2 → Runtime Error → Accepted → Wrong Answer ×2 → Accepted → Output Limit Exceeded → Accepted ×2 → Runtime Error ×2 → Accepted ×4 → Compile Error

## 解題思路

掃到 `x` 時，需要的另一半是 `target - x`。用雜湊表存「值 → index」（[Hash Table]({{< relref "/algorithm/Hash-Table" >}})），**先查再存**：查到就回傳兩個 index，查不到才把 `x` 存進去。先查再存保證不會配到自己，也能正確處理 `[3, 3]` 這種相同的值。

## 我的嘗試

這題從 2019 年到 2026 年寫了 24 次，錯誤大多是同一類：

- 兩層迴圈配上 `nums.index(i)` 找 index，**相同的值會拿到同一個 index**：`[1, 1]`、`target = 2` 回傳 `[0, 0]`。加上 `i != l` 比較的是值，一樣沒用。
- 改成兩層迴圈從 `i + 1` 開始就對了，但是 `O(n²)`。
- 雜湊表版本的錯誤都是小地方：變數打錯（`taregt`、把 `temp[num]` 寫成 `target[num]`）、留下 `print` 造成 Output Limit Exceeded。

## 正確解法

```python
class Solution:
    def twoSum(self, nums: List[int], target: int) -> List[int]:
        seen = {}
        for i, x in enumerate(nums):
            if target - x in seen:
                return [seen[target - x], i]
            seen[x] = i
        return []
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 回傳的是 index，不是值；`nums.index(x)` 遇到相同的值會拿到同一個 index。
- 先查再存，不然 `x` 會配到自己。
- 兩層迴圈是 `O(n²)`。

## 面試口說整理

我一邊掃一邊用雜湊表存看過的值和它的 index，每個數先查 target 減掉它有沒有出現過，有就回傳兩個 index，沒有才把自己存進去，這樣不會配到自己。時間 `O(n)`、空間 `O(n)`。
