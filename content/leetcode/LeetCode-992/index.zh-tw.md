---
title: "LeetCode 992: Subarrays with K Different Integers"
summary: "LeetCode 992 解題筆記：「剛好 k 種」=「最多 k 種」−「最多 k - 1 種」，「最多」型的計數視窗每個右端加 right - left + 1"
description: "2026-01-21 的 LeetCode 992 解題紀錄"
date: 2026-01-21
tags: ["hard", "sliding-window", "hash-table", "counting", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-01-21
- 提交紀錄：Accepted（一次通過）

## 解題思路

「剛好 `k` 種」不單調，「最多 `k` 種」是單調的：

```text
剛好 k 種 = 最多 k 種 − 最多 k - 1 種
```

「最多」型的計數：種類超過上限就縮左邊，以 `right` 結尾的合法子陣列有 `right - left + 1` 個。

## 我的解法

我 AC 的寫法用了跟 [LeetCode 3306]({{< relref "/leetcode/LeetCode-3306" >}}) 一樣的 `extra` 技巧：剛好 `k` 種時，把左邊多餘的重複值縮掉並記在 `extra`，每個右端加 `1 + extra`；種類超過 `k` 被迫縮掉一種時 `extra` 歸零。這裡寫成比較通用的「最多」相減：

```python
class Solution:
    def subarraysWithKDistinct(self, nums: List[int], k: int) -> int:
        def at_most(limit: int) -> int:
            cnt = Counter()
            left = count = 0
            for right, x in enumerate(nums):
                cnt[x] += 1
                while len(cnt) > limit:
                    y = nums[left]
                    cnt[y] -= 1
                    if cnt[y] == 0:
                        del cnt[y]
                    left += 1
                count += right - left + 1
            return count

        return at_most(k) - at_most(k - 1)
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 計數歸零時要刪 key，`len(cnt)` 才是種類數。

## 面試口說整理

「剛好 `k` 種」不單調，所以我算「最多 `k` 種」減「最多 `k - 1` 種」。「最多」型用滑動視窗，種類超過上限就縮左邊，以右端結尾的合法子陣列有 `right - left + 1` 個。兩次都是 `O(n)`。
