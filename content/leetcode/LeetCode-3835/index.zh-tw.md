---
title: "LeetCode 3835: Count Subarrays With Cost Less Than or Equal to K"
summary: "LeetCode 3835 解題筆記：花費 = (最大 - 最小) × 長度，視窗變大只會變貴，所以可以滑動視窗數子陣列；視窗最大、最小值用兩個單調佇列維護"
description: "2026-02-08 的 LeetCode 3835 解題紀錄"
date: 2026-02-08
tags: ["medium", "sliding-window", "monotonic-queue", "queue", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-02-08
- 提交紀錄：Wrong Answer → Accepted

## 解題思路

`cost = (max - min) × 長度`。視窗變大時，`max - min` 不會變小、長度變大，**花費只會增加**，所以條件是單調的：

- 右邊界加入元素，花費 `> k` 就縮左邊界。
- 以 `right` 結尾的合法子陣列有 `right - left + 1` 個。

視窗的最大、最小值用**兩個單調佇列**（存 index）：

- 最大值佇列值遞減：新元素進來前，把尾端 `<=` 它的都丟掉。
- 最小值佇列值遞增：把尾端 `>=` 它的都丟掉。
- 左邊界移動後，頭端的 index `< left` 就丟掉（過期）。

## 我的嘗試

第一版用 list 當佇列，把「過期」的條件也混進從**尾端**丟元素的迴圈裡（`max_stack[0] < left`），最小值那邊還寫成 `min_stack[0] > left`。過期的元素應該從**頭端**丟，跟從尾端丟掉被支配的元素是兩件事。例如 `nums = [6, 2, 3]`、`k = 9`：答案是 5，這版回傳 6。

改成兩個 `deque`、尾端只處理被支配的、頭端只處理過期的，就 AC 了。

## 正確解法

```python
from collections import deque

class Solution:
    def countSubarrays(self, nums: List[int], k: int) -> int:
        max_q, min_q = deque(), deque()            # 存 index
        left = count = 0
        for right, x in enumerate(nums):
            while max_q and nums[max_q[-1]] <= x:
                max_q.pop()
            max_q.append(right)
            while min_q and nums[min_q[-1]] >= x:
                min_q.pop()
            min_q.append(right)

            while (nums[max_q[0]] - nums[min_q[0]]) * (right - left + 1) > k:
                left += 1
                if max_q[0] < left:
                    max_q.popleft()                # 過期
                if min_q[0] < left:
                    min_q.popleft()
            count += right - left + 1
        return count
```

`left == right` 時花費是 0，`k >= 0` 一定合法，所以縮視窗的迴圈不會讓佇列變空。

## 複雜度

時間 `O(n)`：每個 index 進出每個佇列各一次。空間 `O(n)`。

## 要特別避免的錯誤

- 把「過期」和「被支配」混在同一個條件：一個從頭端丟、一個從尾端丟。
- 用 `list.pop(0)` 當佇列：每次 `O(n)`。

## 面試口說整理

花費是最大減最小乘長度，視窗越大花費越大，所以可以用滑動視窗：花費超過 `k` 就縮左邊，以右邊界結尾的合法子陣列有 `right - left + 1` 個。視窗的最大、最小值用兩個單調佇列，尾端丟掉被新元素支配的，頭端丟掉已經在視窗外的。每個 index 進出一次，時間 `O(n)`。
