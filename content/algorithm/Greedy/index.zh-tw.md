---
title: "Greedy 貪心"
summary: "排序後掃描、區間按右端點排序、左右兩次掃描、配對與奇偶不變量、相鄰差值，以及「比平均大的先拿掉」；每一種都附上為什麼貪心是對的"
description: "演算法學習"
date: 2026-10-20
tags: ["greedy", "sorting", "intervals"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 介紹

貪心是每一步都做「現在看起來最好」的選擇，而且不回頭。寫起來通常很短，難的是**確定它是對的**。常用的證明方式有兩種：

- **交換論證**：假設最佳解在某一步跟貪心不一樣，把它換成貪心的選擇，答案不會變差。
- **不變量 / 下界**：找出一個不管怎麼操作都不會變的量（例如負數個數的奇偶），或一個任何解都至少要付的代價，再證明貪心剛好達到。

| 形式 | 做法 | 例子 |
|---|---|---|
| 排序後掃描 | 由小到大（或由大到小）決定要不要拿 | 分組、買最多個、前 `k` 大 |
| 區間 | 按右端點排序，點盡量放右邊 | 每個區間至少放兩個點 |
| 左右兩次掃描 | 左鄰居的限制掃一次、右鄰居的限制再掃一次 | 發糖果、上界傳遞 |
| 配對與奇偶 | 先數各種類型的個數，再決定怎麼配 | 回文配對、翻號、交換成本 |
| 相鄰差值 | 答案只跟相鄰兩個的差有關 | 讓陣列不遞減的最小加總 |
| 平均值 | 比平均大的資源只能給一個人用 | 電池分給電腦 |

如果選擇之間會互相影響、拿了這個會讓後面的選擇變差，通常就要用 DP，見 [Linear DP]({{< relref "/algorithm/Linear-DP" >}})。

## 模板一：排序後掃描

```python
nums.sort()
groups = 1
start = nums[0]                          # 目前這組的最小值
for x in nums[1:]:
    if x - start > k:                    # 放不進這組，開新的一組
        groups += 1
        start = x
```

- **分組，每組最大減最小 `<= k`**（LC 2294）：排序後每組盡量往右延伸。
- **錢有限，買最多個**（LC 1833）：從便宜的開始買；題目要求計數排序，值域只有 `10^5`。
- **最多 `k` 個不同的數，總和最大**（LC 3684）：去重、由大到小取前 `k` 個。
- **最少刪幾個字元，讓種類 `<= k`**（LC 3545）：整種刪掉，從出現次數最少的開始刪。
- **可以任意刪除，再選不重複的子陣列**（LC 3487）：等於選不重複的值，非負的全拿；全是負數時只拿最大的一個。
- **欄可以任意排列的最大全 1 子矩陣**（LC 1727）：每列算出往上連續 1 的高度，排序由大到小，第 `j` 高乘上 `j + 1` 欄。

## 模板二：區間，按右端點排序

```python
intervals.sort(key=lambda x: (x[1], -x[0]))    # 右端點小的先，同右端點時區間短的先
p1 = p2 = float("-inf")                  # 目前放的最右邊兩個點，p1 < p2
res = 0
for s, e in intervals:
    if s > p2:                           # 一個點都沒蓋到
        res += 2
        p1, p2 = e - 1, e
    elif s > p1:                         # 只蓋到 p2
        res += 1
        p1, p2 = p2, e
```

點要盡量放在**右端點**，因為後面的區間右端點只會更大，放右邊最有機會被共用（LC 757）。同一個右端點時，短的區間（左端點大）先處理，否則長的先處理會以為已經蓋到兩個點。

- **插入區間**（LC 57）：區間已經排好，分成完全在左、完全在右、重疊三組，重疊的跟新區間合併；合併範圍從新區間本身開始。
- **摘要區間**（LC 228）：接得上就延長最後一個區間，否則開新的。

## 模板三：左右兩次掃描

條件同時跟左右鄰居有關時，一次只處理一邊：

```python
left = [1] * n
for i in range(1, n):
    if ratings[i] > ratings[i - 1]:
        left[i] = left[i - 1] + 1
right = [1] * n
for i in range(n - 2, -1, -1):
    if ratings[i] > ratings[i + 1]:
        right[i] = right[i + 1] + 1
res = sum(max(a, b) for a, b in zip(left, right))
```

- **發糖果**（LC 135）：`left` 滿足左邊的條件、`right` 滿足右邊的條件，取兩者較大值就同時滿足，而且每一個都是必要的下界。
- **上界傳遞**（LC 3796）：每個位置的上界 = 自己的限制、左邊上界 + 差值、右邊上界 + 差值，三者取最小。左往右一次、右往左一次就收斂。

## 模板四：配對與奇偶

先把每個位置分類、數個數，答案只跟各類的個數有關：

```python
cnt = Counter(words)
res, mid = 0, False
for w, c in cnt.items():
    r = w[::-1]
    if w == r:                           # 自己就是回文：兩兩配對放兩邊
        res += c // 2 * 4
        mid |= c % 2 == 1                # 剩一個可以放正中間
    elif w < r:                          # 跟反轉配對，每對只算一次
        res += min(c, cnt[r]) * 4
res += 2 if mid else 0
```

- **回文配對**（LC 2131）：上面的程式。
- **負號可以兩兩移動**（LC 1975）：相鄰兩個一起乘 -1，負號可以搬到任何位置，但負數個數的**奇偶不變**。偶數個全變正；奇數個留一個在絕對值最小的位置。
- **兩種不一樣的位置**（LC 3800）：`s = 0, t = 1` 和 `s = 1, t = 0` 各有幾個。不同類的兩兩用一次 swap，同類的兩兩用 cross + swap，剩一個只能 flip，每種都跟「兩次 flip」比較。
- **多出來的水果**（LC 2561）：每種值總數要是偶數，多出來的排序後，便宜的一半各跟一個貴的交換；也可以借全域最小值當中介，花 `2 × 最小值`。
- **每種值只要一次操作**（LC 3810）：答案是不相等的位置上有幾種不同的值。
- **設備的最小值**（LC 3961）：除了一台以外，每台把最小的那個單位捐給同一台，剩下的那台挑第二小值最小的。

## 模板五：相鄰差值

一次操作只影響區間的兩個邊界，所以答案常常只跟相鄰差值有關：

```python
res = 0
for i in range(1, n):
    res += max(0, nums[i - 1] - nums[i])   # 每個下降都要補
```

- **讓陣列不遞減，加的總量最小**（LC 3914）：對區間 `[l, r]` 加 `x`，只會讓 `l - 1 → l` 的差值變大 `x`。每個下降至少要補那麼多，而對後綴加剛好做到。
- **只能走鄰近位置的移動成本**（LC 3919）：一步一步走，每一步的成本是 1（對方是 closest）或差值；直接跳的成本是差值總和，不會更便宜。用前綴和回答每個查詢。
- **最大減最小**（LC 3689）：整個陣列的最大值和最小值，可以重複選 `k` 次。

## 模板六：比平均大的先拿掉

```python
batteries.sort()
total = sum(batteries)
while batteries[-1] > total // n:        # 比平均大的電池只能給一台用
    total -= batteries.pop()
    n -= 1
return total // n
```

一顆比平均時間還大的電池，最多只能讓一台電腦一直用它，多出來的部分浪費掉；把它和那台電腦一起拿掉，剩下的再算平均（LC 2141）。要用嚴格的 `>`：等於平均的電池拿掉後，剩下的平均可能比它還大，那台電腦撐不到那麼久。

## 主要參數說明

- 排序的 key 決定掃描順序；區間題常用 `(右端點, -左端點)`。
- 計數類的題目，先想清楚「有幾種類型」，再分別算每種類型的成本。
- 兩次掃描時，第二次要拿第一次的結果取 `max` / `min`，不是覆蓋。

## 複雜度

大多是排序 `O(n log n)` 加上一次掃描 `O(n)`。計數類 `O(n)`。

## 常見錯誤

這些都是我練習時實際寫錯過的：

- **全是負數時回傳 0**：只收集正數，結果集合是空的（LC 3487）。
- **在整個陣列找最大值的位置**：遞迴處理子區間時用 `ratings.index(...)`，找到的是區間外的位置，結果錯或無限遞迴（LC 135）。
- **自己就是回文的字全部丟到中間**：`["cc", "cc"]` 可以一左一右，長度 4（LC 2131）。
- **只檢查交叉點的前一格**：兩段斜坡的最高點可能就在交叉的那一格（LC 3796）。
- **寫死只拿前 3 大**，沒有用 `k`（LC 3684）。
- **以為每一列已經排序**，直接拿 `unit[0]` 當最小值（LC 3961）。
- **拿掉電池時沒有從總和扣掉**，以及用 `<=` 把等於平均的電池也拿掉（LC 2141）。
- **`while` 條件用迴圈外取出的計數**：那個值不會變，計數一直減到變成負的（LC 2561）。
- **種花沒有把新種的花標記上去**：相鄰的兩個空格都會被算成能種（LC 605）。
- **找零只記總金額**：要記每種面額的張數（LC 860）。
- **切成三段時要求剛好 3 段**：和為 0 的段可以切得更多，要用 `>= 3`（LC 1013）。
- **遞增三元組用嚴格的 `>` 更新 `first`**：相等的數會被當成 `second`（LC 334）。
- **合併區間從 `inf` 開始、右端點取 `min`**（LC 57）。
- **合併區間時跟原本的前一個區間比**：要跟合併好的最後一個比，終點取 `max`（LC 56）。
- **更新第二大時用 `if` 而不是 `elif`**：最大值會變成自己的第二名（LC 747）。
- **交錯排列沒有反轉兩半**：重複的中位數會相鄰（LC 324）。

## 相關 LeetCode

- `LC 3487` Maximum Unique Subarray Sum After Deletion
- `LC 3545` Minimum Deletions for At Most K Distinct Characters
- `LC 135` Candy
- `LC 2131` Longest Palindrome by Concatenating Two Letter Words
- `LC 2294` Partition Array Such That Maximum Difference Is K
- `LC 3689` Maximum Total Subarray Value I
- `LC 3796` Find Maximum Value in a Constrained Sequence
- `LC 3800` Minimum Cost to Make Two Binary Strings Equal
- `LC 1975` Maximum Matrix Sum
- `LC 3810` Minimum Operations to Reach Target Array
- `LC 3684` Maximize Sum of At Most K Distinct Elements
- `LC 3914` Minimum Operations to Make Array Non Decreasing
- `LC 3919` Minimum Cost to Move Between Indices
- `LC 3961` Maximize Sum of Device Ratings
- `LC 1833` Maximum Ice Cream Bars
- `LC 1727` Largest Submatrix With Rearrangements
- `LC 757` Set Intersection Size At Least Two
- `LC 2141` Maximum Running Time of N Computers
- `LC 2561` Rearranging Fruits
- `LC 605` Can Place Flowers
- `LC 860` Lemonade Change
- `LC 1013` Partition Array Into Three Parts With Equal Sum
- `LC 334` Increasing Triplet Subsequence
- `LC 134` Gas Station
- `LC 228` Summary Ranges
- `LC 57` Insert Interval
- `LC 435` Non-overlapping Intervals
- `LC 56` Merge Intervals
- `LC 747` Largest Number At Least Twice of Others
- `LC 414` Third Maximum Number
- `LC 561` Array Partition
- `LC 324` Wiggle Sort II
- `LC 1005` Maximize Sum Of Array After K Negations
- `LC 3074` Apple Redistribution into Boxes
- `LC 3075` Maximize Happiness of Selected Children
