---
title: "Prefix Sum"
summary: "Prefix Sum 介紹"
description: "演算法學習"
date: 2025-04-19
tags: ["prefix-sum"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 介紹

**Prefix Sum（前綴和）** 是一種常見的演算法技巧，用來快速計算子陣列的總和或區間值。

舉例來說，假設有一個陣列 `nums = [2, 4, 5, 7]`，如果我們想要查詢從 `nums[i]` 到 `nums[j]` 的總和，使用暴力解法每次查詢都需要花費 `O(n)` 的時間。

然而，只要先遍歷一次陣列並建立一個 prefix sum 陣列，就能將每次查詢的時間縮短為 `O(1)`。

## 核心概念

這個技巧的核心概念是：建立一個陣列，讓其中的每個元素都代表原陣列中所有前面元素的累加和。

因此，對於索引 `i`，在 `prefix[i + 1]` 中儲存的值就是原始陣列從索引 `0` 到 `i` 的總和。

```python
prefix = [0] * (len(nums) + 1)
for i in range(len(nums)):
    prefix[i + 1] = prefix[i] + nums[i]
```

如果我們要查詢從索引 `i` 到 `j` 的區間總和，只需要這樣寫：

```python
sum_ = prefix[j+1] - prefix[i]
```

`prefix` 陣列的第一個元素代表的是「空區間」（也就是總和為 `0` 的情況），所以我們用 `prefix[j + 1]` 來包含索引 `j` 的值，並用 `prefix[i]` 來排除索引 `i` 之前的總和。


## 模板

```python
prefix = [0] * (len(nums) + 1)
for i in range(len(nums)):
    prefix[i + 1] = prefix[i] + nums[i]

sum_ = prefix[j+1] - prefix[i]
```

### 主要參數說明：

## 範例

經典題
```
class NumArray:

    def __init__(self, nums: List[int]):
        self.ps = [0]
        for num in nums:
            self.ps.append(num+self.ps[-1])

    def sumRange(self, left: int, right: int) -> int:
        return self.ps[right+1] - self.ps[left]
```

### 延伸：前綴積與最小前綴和

- **除了自己以外的乘積**（LC 238）：第一輪存左邊的乘積（不含自己），第二輪用一個變數乘上右邊的乘積，不用除法。
- **起始值**（LC 1413）：`1 - min(前綴和)`，最小值從 0 開始算。
- **中間的 index**（LC 1991）：右邊的和是 `total - left - nums[i]`。

## 模板二：前綴 / 後綴的最大最小值（找分割點）

題目要「左邊一段的某個值」和「右邊一段的某個值」時，先各掃一次存起來，再枚舉分割點：

```python
n = len(nums)
pre_max = nums[:]                        # pre_max[i] = max(nums[0..i])
for i in range(1, n):
    pre_max[i] = max(pre_max[i - 1], nums[i])
suf_min = nums[:]                        # suf_min[i] = min(nums[i..n-1])
for i in range(n - 2, -1, -1):
    suf_min[i] = min(suf_min[i + 1], nums[i])
for i in range(n):
    score = pre_max[i] - suf_min[i]      # 或 prefix_sum[i] - suf_min[i + 1] 等
```

- **最小穩定 index**（LC 3903、3904）：`pre_max[i] - suf_min[i] <= k` 的第一個 `i`。
- **前綴和減後綴最小值**（LC 3788）：分割點 `i` 的分數是 `prefix_sum[i] - suf_min[i + 1]`。
- **`(nums[i] - nums[j]) * nums[k]` 最大**（LC 2874）：枚舉中間的 `j`，左邊取最大、右邊取最大。也可以一次掃描，同時維護「目前最大值」和「目前最大差」。
- **切一刀，兩邊和相等**（LC 3707、3548）：邊掃邊累加左邊，右邊是 `total - left`。3548 還能去掉一格，要另外判斷去掉之後是否還連通。

## 模板三：前綴差值 + 雜湊表

把「0 和 1 一樣多」轉成「前綴的 `ones - zeros` 相同」。記住每個差值**最早**出現的位置，子字串越長越好：

```python
first = {0: -1}
diff = best = 0
for i, ch in enumerate(s):
    diff += 1 if ch == "1" else -1
    if diff in first:
        best = max(best, i - first[diff])
    else:
        first[diff] = i
```

- **允許交換一次**（LC 3900）：差值差 2 的子字串，只要外面還有一個可以換進來的字元，交換後就平衡。最早的位置不合格時，第二早的一定合格，所以每個差值記前兩個位置就好。

## 模板四：只走到最後需要的位置

每種東西只要走到它**最後一次出現**的位置，路程用前綴和算：

```python
last = {}
for i, items in enumerate(houses):
    for t in set(items):
        last[t] = i
prefix = [0]
for d in travel:
    prefix.append(prefix[-1] + d)
total = sum(len(items) for items in houses) + sum(prefix[i] for i in last.values())
```

- **收垃圾**（LC 2391）：三台車各自只開到自己那種垃圾的最後一間。

## 常見錯誤

這些都是我練習時實際寫錯過的：

- **後綴陣列的 index 差一**：反著建的後綴陣列，對應位置寫錯，把 `j` 自己也算進右邊（LC 2874）。
- **分數用 `ord(c)`**：題目的分數是字母順序 1 到 26；兩邊長度不同時，`ord` 會多出不同的 `96 × 長度`（LC 3707）。
- **前綴差值的題目用滑動視窗**：平衡不是單調的條件，縮左邊不一定會變好（LC 3900）。
- **前綴積包含了自己**：`res[i] = res[i - 1] * nums[i - 1]`，不是 `nums[i]`（LC 238）。

## LeetCode

- `LC 303` Range Sum Query - Immutable
- `LC 2874` Maximum Value of an Ordered Triplet II
- `LC 3788` Maximum Score of a Split
- `LC 3903` Smallest Stable Index I
- `LC 3904` Smallest Stable Index II
- `LC 2391` Minimum Amount of Time to Collect Garbage
- `LC 3494` Find the Minimum Amount of Time to Brew Potions
- `LC 3707` Equal Score Substrings
- `LC 3548` Equal Sum Grid Partition II
- `LC 3900` Longest Balanced Substring After One Swap
- `LC 1480` Running Sum of 1d Array
- `LC 1732` Find the Highest Altitude
- `LC 1413` Minimum Value to Get Positive Step by Step Sum
- `LC 1991` Find the Middle Index in Array
- `LC 238` Product of Array Except Self
