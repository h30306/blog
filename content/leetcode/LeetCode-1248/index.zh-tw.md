---
title: "LeetCode 1248: Count Number of Nice Subarrays"
summary: "LeetCode 1248 解題筆記：「剛好 k 個奇數」不單調，改成「最多 k 個」減「最多 k - 1 個」；或用前綴和 + 雜湊表"
description: "2025-07-22 的 LeetCode 1248 解題紀錄"
date: 2025-07-22
tags: ["medium", "sliding-window", "prefix-sum", "hash-table", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2025-07-22
- 提交紀錄：Accepted（滑動視窗）→ Time Limit Exceeded → Accepted（前綴和）

## 解題思路

### 滑動視窗：最多 k 減最多 k - 1

「剛好 `k` 個奇數」沒辦法直接用視窗：視窗變大時奇數個數可能不變，左邊界不知道該不該縮。但「**最多 `k` 個奇數**」是單調的：

- 右邊界每加入一個數，奇數超過 `k` 就縮左邊界。
- 以 `right` 結尾、合法的子陣列有 `right - left + 1` 個。

剛好 `k` 個 = 最多 `k` 個 − 最多 `k - 1` 個。

### 前綴和 + 雜湊表

把奇數看成 1、偶數看成 0，子陣列 `(i, j]` 有 `k` 個奇數 ⇔ `prefix[j] - prefix[i] == k`。掃過陣列時，用雜湊表記錄每個前綴值出現幾次，每個 `j` 加上 `count[prefix[j] - k]`。

## 我的嘗試

第一次用滑動視窗 AC。半年後重寫，想改用前綴和，第一版對所有前綴配對做雙層迴圈，`O(n^2)`，`n = 50000` 時 TLE。改成雜湊表記錄前綴值出現的次數就 AC 了。

## 正確解法

```python
class Solution:
    def numberOfSubarrays(self, nums: List[int], k: int) -> int:
        def at_most(limit: int) -> int:
            left = odd = count = 0
            for right, x in enumerate(nums):
                odd += x % 2
                while odd > limit:
                    odd -= nums[left] % 2
                    left += 1
                count += right - left + 1          # 以 right 結尾的合法子陣列
            return count

        return at_most(k) - at_most(k - 1)
```

前綴和版本：

```python
class Solution:
    def numberOfSubarrays(self, nums: List[int], k: int) -> int:
        seen = Counter({0: 1})                     # 前綴值 -> 出現次數
        prefix = ans = 0
        for x in nums:
            prefix += x % 2
            ans += seen[prefix - k]
            seen[prefix] += 1
        return ans
```

## 複雜度

兩種都是時間 `O(n)`。滑動視窗空間 `O(1)`，前綴和空間 `O(n)`。

## 要特別避免的錯誤

- 直接對「剛好 `k`」用滑動視窗：不單調。
- 前綴和用雙層迴圈找配對：`O(n^2)`。
- 前綴和的雜湊表要先放 `{0: 1}`，代表從開頭開始的子陣列。

## 面試口說整理

「剛好 `k` 個奇數」不單調，所以我改算「最多 `k` 個」減「最多 `k - 1` 個」。「最多」可以用滑動視窗：奇數超過上限就縮左邊，以右邊界結尾的合法子陣列有 `right - left + 1` 個。另一種做法是把奇數當 1 做前綴和，用雜湊表數 `prefix - k` 出現過幾次。兩種都是 `O(n)`。
