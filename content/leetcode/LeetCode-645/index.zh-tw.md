---
title: "LeetCode 645: Set Mismatch"
summary: "LeetCode 645 解題筆記：用總和算：missing = 1..n 的和 - set 的和，duplicate = 陣列總和 - set 的和"
description: "2022-08-29 的 LeetCode 645 解題紀錄"
date: 2022-08-29
tags: ["easy", "array", "hash-table", "bit-manipulation", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-29
- 提交紀錄：Runtime Error → Wrong Answer ×5 → Runtime Error ×2 → Wrong Answer ×6 → Runtime Error → Accepted ×2

## 解題思路

陣列本來應該是 `1..n`，其中一個數重複、一個數不見。`set(nums)` 去掉重複後少了 `missing`：`missing = n(n + 1) / 2 - sum(set)`；陣列總和比 set 多了 `duplicate`：`duplicate = sum(nums) - sum(set)`。不用排序也不用比較位置（[Hash Table]({{< relref "/algorithm/Hash-Table" >}})）。`O(1)` 空間的作法是把所有數和 `1..n` 一起 XOR，得到 `dup ^ miss`，再用最低的 1 分組（[Bit Manipulation]({{< relref "/algorithm/Bit-Manipulation" >}})）。

## 我的嘗試

這題提交了 17 次，前十幾次都在「比較 `nums[i]` 和 `i + 1`」：

- 陣列**沒有排序**，比較 `nums[i]` 和 `nums[i - 1]`、或 `nums[i]` 和 `i + 1` 都沒有意義：`[2, 2]` 回傳 `[2, 1, 2]` 或 `[1, 2]`，好幾版還忘了 `return`。
- 先排序再找「值和位置不同」的地方，**錯位的不只一個**：`[3, 3, 1]` 排序後是 `[1, 3, 3]`，第 2、3 格都不對，回傳 `[3, 2, 3, 3]` 之類的結果。
- 最後改成排序找重複、用 set 的差集找缺少的數才 AC，之後又改成用總和計算。

## 正確解法

```python
class Solution:
    def findErrorNums(self, nums: List[int]) -> List[int]:
        n = len(nums)
        uniq = sum(set(nums))
        return [sum(nums) - uniq, n * (n + 1) // 2 - uniq]
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 陣列沒有排序，不能直接比較 `nums[i]` 和 `i + 1`。
- 排序後也不是只有一個位置不對：重複和缺少之間的元素都會錯位。
- 回傳的順序是 `[duplicate, missing]`。

## 面試口說整理

set 去掉重複之後少了 missing，陣列總和比 set 多了 duplicate，所以我用 1 到 n 的和減掉 set 的和得到 missing，用陣列總和減掉 set 的和得到 duplicate。時間 `O(n)`。
