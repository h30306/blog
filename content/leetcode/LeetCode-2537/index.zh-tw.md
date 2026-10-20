---
title: "LeetCode 2537: Count the Number of Good Subarrays"
summary: "LeetCode 2537 解題筆記：加入 x 會多出 cnt[x] 對相同的 pair，移出時少 cnt[x] - 1 對；「至少 k 對」的計數視窗，count += left"
description: "2026-01-20 的 LeetCode 2537 解題紀錄"
date: 2026-01-20
tags: ["medium", "sliding-window", "hash-table", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-20
- 提交紀錄：Wrong Answer ×2 → Accepted ×2

## 解題思路

視窗裡相同值的 pair 數：加入一個 `x` 時，它可以跟視窗裡原本的每個 `x` 配對，**pair 數增加 `cnt[x]`**（加入前的數量）。移出時反過來，減少 `cnt[x] - 1`（移出後的數量）。

pair 數只會隨視窗變大而增加，「至少 `k` 對」是單調的，用「至少」型的計數：合法時一直縮左邊，`count += left`。

## 我的嘗試

我一開始用組合數 `C(cnt, 2)` 算：加入時扣掉舊的 `C(cnt - 1, 2)`、加上新的 `C(cnt, 2)`。

| 版本 | 問題 |
|---|---|
| 第一版 | 組合數裡用了 `freq[nums[right - 1]]`（前一個元素的數量），應該是 `freq[nums[right]]`。例如 `nums = [2, 2, 3]`、`k = 1`：答案是 2，回傳 4 |
| 第二版 | 修好 index，但縮左邊時**只更新了 pair 數，沒有把 `freq[nums[left]]` 減一**。例如 `nums = [3, 2, 2, 3]`、`k = 1`：答案是 4，回傳 5 |
| 第三版 AC | 補上 `freq[nums[left]] -= 1` |
| 第四版 AC | 改成「加入時加 `cnt[x]`、移出時減 `cnt[x]`」，簡單很多 |

## 正確解法

```python
class Solution:
    def countGood(self, nums: List[int], k: int) -> int:
        cnt = Counter()
        pairs = left = count = 0
        for x in nums:
            pairs += cnt[x]                        # 跟視窗裡每個 x 配一對
            cnt[x] += 1
            while pairs >= k:
                y = nums[left]
                cnt[y] -= 1
                pairs -= cnt[y]                    # 少了跟剩下的 y 配的那些對
                left += 1
            count += left
        return count
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 縮視窗時只更新統計值，忘了更新計數表。
- 增量更新時用錯元素（`nums[right - 1]` vs `nums[right]`）。

## 面試口說整理

加入一個 `x` 時，它跟視窗裡原本的每個 `x` 都能配成一對，所以 pair 數加上原本的數量；移出時反過來。pair 數隨視窗變大只增不減，所以用「至少」型的滑動視窗：至少 `k` 對時一直縮左邊，左端在 0 到 `left - 1` 都合法，加上 `left`。時間 `O(n)`。
