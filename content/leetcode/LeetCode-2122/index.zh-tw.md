---
title: "LeetCode 2122: Recover the Original Array"
summary: "LeetCode 2122 解題筆記：最小的數一定在 lower，枚舉它的配對決定 k；排序後用兩個指針把每個最小的未配對數配給 +2k 的數"
description: "2026-01-26 的 LeetCode 2122 解題紀錄"
date: 2026-01-26
tags: ["hard", "two-pointers", "sorting", "hash-table", "enumeration", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-01-26
- 提交紀錄：Wrong Answer → Accepted（計數版）→ Accepted（雙指針版）

## 解題思路

每個原始的 `arr[i]` 產生一對 `arr[i] - k` 和 `arr[i] + k`，差是 `2k`。

1. **決定 `k`**：排序後，最小的 `nums[0]` 一定是某個 `lower`，它的配對是某個 `nums[i]`。枚舉 `i`，`diff = nums[i] - nums[0]` 必須是正的偶數，`k = diff / 2`。
2. **檢查這個 `k`**：從小到大，每個還沒配對的最小數一定是 `lower`（比它小的都配完了），它的配對是 `x + 2k`。用兩個指針：`lo` 找下一個未配對的數，`hi` 找下一個未使用、`>= x + 2k` 的數，相等就配成一對。
3. 配滿 `n / 2` 對就回傳 `[x + k for 每一對]`。

`x + 2k` 隨著 `lo` 遞增，所以 `hi` 只會往右走；被 `hi` 跳過、比目標小的數，之後的目標更大，不會再被當成 `higher`。

## 我的嘗試

先寫了用 `Counter` 的版本：對每個 `k` 掃過排序後的數，`freq` 記錄每個值被用了幾次。

第一版遇到「這個數已經被當成 `higher` 用掉了」時寫成 `break`，應該是 `continue` 跳過它。例如 `nums = [1, 3, 4, 6]`（原陣列 `[2, 5]`、`k = 1`）：配完 `1, 3` 後遇到已被用掉的 `3` 就停了，什麼都沒回傳。

改成 `continue` 後 AC，之後又用雙指針重寫一次。

## 正確解法

```python
class Solution:
    def recoverArray(self, nums: List[int]) -> List[int]:
        nums.sort()
        n = len(nums)
        for i in range(1, n):
            diff = nums[i] - nums[0]
            if diff == 0 or diff % 2:
                continue                           # k 必須是正整數
            k = diff // 2
            used = [False] * n
            res = []
            hi = 0
            for lo in range(n):
                if used[lo]:
                    continue                       # 已經被當成 higher 用掉
                hi = max(hi, lo + 1)
                while hi < n and (used[hi] or nums[hi] < nums[lo] + 2 * k):
                    hi += 1
                if hi == n or nums[hi] != nums[lo] + 2 * k:
                    break                          # 這個 k 不行
                used[lo] = used[hi] = True
                res.append(nums[lo] + k)
            if len(res) == n // 2:
                return res
        return []
```

## 複雜度

時間 `O(n^2)`：最多枚舉 `n` 個 `k`，每個用雙指針 `O(n)` 檢查。空間 `O(n)`。

## 要特別避免的錯誤

- `k` 必須是正整數：`diff` 是 0 或奇數都要跳過。
- 已經被配對用掉的數要 `continue`，不是 `break`。

## 面試口說整理

排序後最小的數一定是 `lower`，所以我枚舉它的配對來決定 `k`，差要是正的偶數。對每個 `k`，從小到大，每個還沒配對的最小數一定是 `lower`，用另一個只往右走的指針找它的 `x + 2k`，找不到就換下一個 `k`。配滿就回傳每對的中點。總共 `O(n^2)`。
