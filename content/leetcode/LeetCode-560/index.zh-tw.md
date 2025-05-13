---
title: "LeetCode 560: Subarray Sum Equals K"
summary: "LeetCode 解題紀錄"
description: "LeetCode Daily"
date: 2025-04-19
tags: ["LeetCode", "daily", "medium"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試： 2025-04-19
- 總花費時間：15:00.00 (TLE)

## 解題思路

這是一題 prefix sum（前綴和）問題，但由於題目限制 `1 <= nums.length <= 2 * 10^4`，如果使用暴力解法會很容易遇到 TLE（Time Limit Exceeded）。

一開始我嘗試使用 prefix sum 並搭配雙層迴圈，列舉所有的 `(i, j)` 來計算所有子陣列的總和。然而因為陣列過大，`O(n^2)` 的時間複雜度是無法接受的。

後來我從討論區學到一種更好的做法，利用 **Hash Map** 來記錄 prefix sum 出現的次數。

核心思路如下：

- 遍歷陣列的同時，計算目前累積的 prefix sum（記為 `count`）。
- 每遇到一個元素，就檢查 `count - k` 是否存在於 Hash Map 中：
    - 如果存在，代表從某個 prefix sum 到當前位置之間的子陣列總和為 `k`，就可以把 `count - k` 出現的次數加到結果中。
- 最後，記得將目前的 `count` 次數更新進 Hash Map。

這個做法將時間複雜度降為 `O(n)`，可以有效解決原本暴力法會超時的問題。


## 解法
### TLE解法
```python
class Solution:
    def subarraySum(self, nums: List[int], k: int) -> int:
        n = len(nums)

        ps = [0]* (n+1)

        for i in range(n):
            ps[i+1] = nums[i] + ps[i]

        res = 0
        for i in range(n):
            for j in range(i, n):
                if ps[j+1]-ps[i] == k:
                    res+=1

        return res
```

```python
class Solution:
    def subarraySum(self, nums: List[int], k: int) -> int:
        sub_num = {0:1}

        count = res = 0
        for num in nums:
            count += num
            
            if (count - k) in sub_num:
                res += sub_num[count - k]

            sub_num[count] = sub_num.get(count, 0) + 1

        return res

```

## 收穫

一開始我被使用 prefix sum 解題的思維所限制。

但後來我意識到，如果我們的目的是要統計某個特定數值出現的次數，將其儲存到 Hash Map 並在需要時查詢，會是更好的做法。

這樣不僅能簡化邏輯，也能大幅降低時間複雜度。



## 遇到的問題