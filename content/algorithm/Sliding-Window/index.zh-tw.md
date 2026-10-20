---
title: "Sliding Window 滑動視窗"
summary: "固定長度視窗、可變長度求最長 / 最短、數子陣列個數（at most K 相減）、單調佇列維護視窗最值"
description: "演算法學習"
date: 2025-07-04
tags: ["sliding-window", "two-pointers", "hash-table", "monotonic-queue"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 介紹

滑動視窗處理的是「**連續子陣列 / 子字串**」的問題。暴力枚舉所有區間是 `O(n^2)`，滑動視窗讓左右邊界都只往右走，每個元素只進出視窗各一次，降到 `O(n)`。

關鍵是**視窗移動時，只更新進來和出去的那一個元素**，不要重算整個視窗。

| 形式 | 視窗怎麼動 | 例子 |
|---|---|---|
| 固定長度 | 右邊進一個、左邊出一個 | 長度 `k` 的最大和、每個視窗的統計 |
| 可變長度，求最長 | 右邊一直擴，不合法時左邊縮到合法 | 最多 `k` 個 0 的最長子陣列 |
| 可變長度，求最短 | 右邊一直擴，合法時左邊盡量縮 | 和至少 `k` 的最短子陣列 |
| 數子陣列個數 | 以 `right` 結尾的合法子陣列有 `right - left + 1` 個 | 「剛好 K」用「最多 K」相減 |
| 視窗內的最大 / 最小值 | 單調佇列 | 滑動視窗最大值 |

能用可變長度視窗的前提是**單調性**：視窗變大時條件只會越來越難（或越來越容易）滿足。如果陣列有負數、條件不單調，通常要改用前綴和 + 雜湊表。

## 模板一：固定長度視窗

```python
window = 0
for right, x in enumerate(nums):
    window += x                          # 進來
    if right >= k:
        window -= nums[right - k]        # 出去
    if right >= k - 1:                   # 視窗滿了才更新答案
        res = max(res, window)
```

視窗裡要維護的東西不一定是總和：

- **雜湊表 / 計數陣列**：視窗內有幾種數（LC 2841、2461），第 `x` 小的負數（LC 2653，值域小，用計數陣列）。
- **「刪掉一段」轉成「留下一段」**：從兩端拿 `k` 張牌 = 中間留下長度 `n - k` 的連續一段，求最小和（LC 1423）；刪掉長度 `k` 的子字串 = 剩下的位移 = 總位移減視窗位移（LC 3694）。
- **環狀陣列**：把陣列接兩次，或用 `i % n`（LC 2134、1888）。
- **滾動雜湊**：視窗移動時，乘上 / 除以 `power`，只更新頭尾（LC 2156）。

## 模板二：可變長度，求最長

```python
left = 0
for right, x in enumerate(nums):
    加入(x)
    while 視窗不合法():
        移除(nums[left])
        left += 1
    res = max(res, right - left + 1)     # 縮完之後一定合法
```

- **最多 1 個 0**：刪掉一個元素後全是 1 的最長長度，就是「最多一個 0 的最長視窗」再減 1（LC 1493）。

## 模板三：可變長度，求最短

```python
left = 0
for right, x in enumerate(nums):
    加入(x)
    while 視窗合法():
        res = min(res, right - left + 1) # 合法時更新，再試著縮
        移除(nums[left])
        left += 1
```

- **不同值的和至少 `k`**（LC 3795）：同一個值在視窗裡出現多次只算一次。記錄每個值**最後一次出現的位置**，左邊界移出時，只有它是最後一次出現才扣掉。

## 模板四：數子陣列個數

以 `right` 結尾、左端在 `[left, right]` 的子陣列都合法，共 `right - left + 1` 個：

```python
def at_most(k):
    left = count = 0
    for right, x in enumerate(nums):
        加入(x)
        while 超過(k):
            移除(nums[left])
            left += 1
        count += right - left + 1
    return count

return at_most(k) - at_most(k - 1)       # 剛好 k
```

**「剛好 K」不單調，但「最多 K」單調**，所以用兩次「最多」相減（LC 1248）。如果條件是「花費 `<= k`」本身就單調，直接數就好（LC 3835）。

## 模板五：單調佇列維護視窗最值

```python
from collections import deque

max_q = deque()                          # 存 index，值遞減
for right, x in enumerate(nums):
    while max_q and nums[max_q[-1]] <= x:
        max_q.pop()                      # 被 x 支配，之後不可能是最大值
    max_q.append(right)
    left = right - k + 1                 # 固定長度 k；可變長度時 left 由條件決定
    if max_q[0] < left:
        max_q.popleft()                  # 過期：已經在視窗外
    if left >= 0:
        res.append(nums[max_q[0]])       # 視窗最大值
```

兩個條件要分開：**尾端**丟掉被支配的，**頭端**丟掉過期的。同時要最大和最小值，就開兩個佇列（LC 3835）。

## 主要參數說明

- `left`、`right`：視窗是 `[left, right]`，長度 `right - left + 1`。
- 固定長度時，出去的元素是 `nums[right - k]`，視窗滿的條件是 `right >= k - 1`。
- 計數用的雜湊表：值減到 0 時要刪掉，才能用 `len()` 當作「幾種數」。

## 複雜度

每個元素進出視窗各一次，時間 `O(n)`。視窗內用雜湊表時空間是 `O(視窗內不同值的數量)`。

## 常見錯誤

這些都是我練習時實際寫錯過的：

- **出去的元素用錯變數**：複製貼上後，判斷左邊元素時用的還是右邊的期望值（LC 1888）。
- **被丟掉的元素還留在計數裡**：題目規定要丟掉的到貨，之後離開視窗時不應該再扣一次（LC 3679）。
- **第一個視窗沒算到**：更新答案的條件寫成 `i - k >= 0`，少了 `i == k - 1` 那個視窗（LC 3694）。
- **條件寫成總和，題目要的是不同值的和**（LC 3795）。
- **沒檢查視窗長度剛好等於目標**（LC 2953）。
- **次方沒有取模**：`power ** k` 每次重算大整數，TLE（LC 2156）。
- **單調佇列把「過期」和「被支配」混在同一個條件**（LC 3835）。

## 相關 LeetCode

- `LC 1248` Count Number of Nice Subarrays
- `LC 1493` Longest Subarray of 1's After Deleting One Element
- `LC 2841` Maximum Sum of Almost Unique Subarray
- `LC 2461` Maximum Sum of Distinct Subarrays With Length K
- `LC 3679` Minimum Discards to Balance Inventory
- `LC 1423` Maximum Points You Can Obtain from Cards
- `LC 3694` Distinct Points Reachable After Substring Removal
- `LC 2134` Minimum Swaps to Group All 1's Together II
- `LC 3795` Minimum Subarray Length With Distinct Sum At Least K
- `LC 1888` Minimum Number of Flips to Make the Binary String Alternating
- `LC 2653` Sliding Subarray Beauty
- `LC 2953` Count Complete Substrings
- `LC 2269` Find the K-Beauty of a Number
- `LC 2156` Find Substring With Given Hash Value
- `LC 3835` Count Subarrays With Cost Less Than or Equal to K
- `LC 1016` Binary String With Substrings Representing 1 To N
- `LC 220` Contains Duplicate III
- `LC 2024` Maximize the Confusion of an Exam
- `LC 1208` Get Equal Substrings Within Budget
- `LC 3634` Minimum Removals to Balance Array
- `LC 3090` Maximum Length Substring With Two Occurrences
- `LC 2958` Length of Longest Subarray With at Most K Frequency
- `LC 2831` Find the Longest Equal Subarray
- `LC 2779` Maximum Beauty of an Array After Applying Operation
- `LC 2271` Maximum White Tiles Covered by a Carpet
- `LC 1838` Frequency of the Most Frequent Element
- `LC 2730` Find the Longest Semi-Repetitive Substring
- `LC 2516` Take K of Each Character From Left and Right
- `LC 2106` Maximum Fruits Harvested After at Most K Steps
- `LC 2555` Maximize Win From Two Segments
- `LC 2009` Minimum Number of Operations to Make Array Continuous
- `LC 2781` Length of the Longest Valid Substring
- `LC 3413` Maximum Coins From K Consecutive Bags
- `LC 395` Longest Substring with At Least K Repeating Characters
- `LC 1763` Longest Nice Substring
- `LC 2904` Shortest and Lexicographically Smallest Beautiful String
- `LC 2968` Apply Operations to Maximize Frequency Score
- `LC 3258` Count Substrings That Satisfy K-Constraint I
- `LC 1040` Moving Stones Until Consecutive II
- `LC 2302` Count Subarrays With Score Less Than K
- `LC 2875` Minimum Size Subarray in Infinite Array
- `LC 1234` Replace the Substring for Balanced String
