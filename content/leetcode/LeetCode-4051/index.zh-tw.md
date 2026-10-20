---
title: "LeetCode 4051: Count Subarrays with Distant Sums"
summary: "LeetCode 4051 解題筆記：前綴和 + 補集 + 區間計數，以及 k = 0 的邊界"
description: "2026-10-19 merge sort 練習梯子的 LeetCode 4051 紀錄"
date: 2026-10-19
tags: ["hard", "merge-sort", "prefix-sum", "binary-indexed-tree", "biweekly-contest"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard（Biweekly Contest 191 Q4）
第一次嘗試：2026-10-19
來源：Merge sort 練習梯子，第 6 階

## 解題思路

子陣列和 `sum` 滿足 `|sum - goal| >= k` 就是 distant，要數 distant 子陣列的個數。`n <= 10^5`，`nums` 有負數。

1. **子陣列和換成前綴和**：`sum = prefix[R] - prefix[L]`，`L < R`。
2. **有負數，不能用 sliding window**：前綴和不單調。改成「對每個 `R`，數前面有多少個 `prefix[L]` 落在某個值域」，這是 merge sort 計數或 BIT 的題型。
3. **用補集**：直接數 distant 要分兩個區間，`k = 0` 時兩個區間會重疊、重複計數。改數「不是 distant」的：

```text
|sum - goal| < k  ⟺  goal - k < sum < goal + k
```

這只是一個連續區間。答案 = `n(n+1)/2 - bad`。

這題就是 LC 327 Count of Range Sum 加上補集。

## 我的嘗試

### 第一版

```python
# count of sum >= k + goal or sum <= k + goal          ← 下界寫錯
...
j1 = mid
j2 = high - 1
for i in range(low, mid):
    while j1 < high and (prefix[i] - prefix[j1]) <= k + goal:   # 方向反了
        j1 += 1
    while j2 > mid and (prefix[i] - prefix[j2]) >= k + goal:
        j2 -= 1                                                  # 指針往左
    count += ((high - low) * (high - low + 1) // 2) - (j2 - j1 + 1)
```

問題：

1. 子陣列和是**右邊減左邊**：`i` 在左半、`j` 在右半，要寫 `prefix[j] - prefix[i]`。
2. 下界是 `goal - k`，不是 `goal + k`。
3. **補集要在最外層減一次**。merge 每層只負責數「`i` 在左、`j` 在右」的 bad pair。
4. `i` 往右時區間上下界都變大，**兩個指針都只往右走**。

### 第二版

```python
l = r = mid
for i in range(low, mid):
    lo = goal - k
    hi = goal + k
    while l < high and prefix[l] - prefix[i] <= lo:
        l += 1
    while r < high and prefix[r] - prefix[i] < hi:
        r += 1
    bad = r - l          # 應該是 +=
```

上面的問題都修好了，直接比較子陣列和的寫法也很直觀。剩兩個 bug：

1. **`bad = r - l` 少了 `+`**：會蓋掉遞迴結果和前面每個 `i` 的計數。範例 1 會回傳 6，正確答案是 5。
2. **少了 `k = 0` 的特判**：`lo == hi` 時 `l` 停在第一個 `> goal`、`r` 停在第一個 `>= goal`，`r - l` 變負數。`nums = [1]`、`goal = 1`、`k = 0` 會回傳 2，正確答案是 1。

## 正確解法

```python
class Solution:
    def distantSubarrays(self, nums: list[int], goal: int, k: int) -> int:
        # distant: sum >= goal + k or sum <= goal - k
        n = len(nums)
        total = n * (n + 1) // 2
        if k == 0:
            return total                       # |x| >= 0 永遠成立

        prefix = [0] * (n + 1)
        for i in range(n):
            prefix[i + 1] = prefix[i] + nums[i]

        lo, hi = goal - k, goal + k            # bad: lo < sum < hi

        def mergeAndSort(low: int, high: int) -> int:
            if high - low <= 1:
                return 0

            mid = (low + high) // 2
            bad = mergeAndSort(low, mid) + mergeAndSort(mid, high)

            l = r = mid
            for i in range(low, mid):
                while l < high and prefix[l] - prefix[i] <= lo:
                    l += 1                     # l: 第一個 sum > lo
                while r < high and prefix[r] - prefix[i] < hi:
                    r += 1                     # r: 第一個 sum >= hi
                bad += r - l

            prefix[low:high] = sorted(prefix[low:high])
            return bad

        return total - mergeAndSort(0, n + 1)
```

### BIT 解法

對每個 `prefix[R]`，bad 的 `prefix[L]` 落在 `[prefix[R] - goal - k + 1, prefix[R] - goal + k - 1]`。前綴和最大到 `10^14`，要先離散化：

```python
from bisect import bisect_left, bisect_right

class Solution:
    def distantSubarrays(self, nums: list[int], goal: int, k: int) -> int:
        n = len(nums)
        pre = [0]
        for x in nums:
            pre.append(pre[-1] + x)
        vals = sorted(set(pre))
        m = len(vals)
        bit = [0] * (m + 1)

        def add(i):
            i += 1
            while i <= m:
                bit[i] += 1
                i += i & -i

        def query(i):                          # rank 在 [0, i) 的個數
            r = 0
            while i > 0:
                r += bit[i]
                i -= i & -i
            return r

        bad = 0
        for s in pre:
            lo, hi = s - goal - k + 1, s - goal + k - 1
            if lo <= hi:                       # k = 0 時區間為空
                bad += query(bisect_right(vals, hi)) - query(bisect_left(vals, lo))
            add(bisect_left(vals, s))          # 先查再插入，保證 L < R
        return n * (n + 1) // 2 - bad
```

## 複雜度

兩種解法都是時間 `O(n log n)`、空間 `O(n)`。

## 要特別避免的錯誤

- 推導還沒寫清楚就開始寫 code：先在註解寫出 bad 區間 `(lo, hi)`。
- 累加變數寫成 `=`。
- 沒有代入極端參數：`k = 0`、只有一個元素。
- Java/C++ 的前綴和要用 `long`。

## 面試口說整理

子陣列和換成前綴和差，因為有負數不能用 sliding window。直接數 distant 要處理兩個區間，`k = 0` 時會重複計數，所以我數補集：`goal - k < sum < goal + k` 只是一個連續區間。用 merge sort 計數，對左半每個 `prefix[i]`，右半的 bad 範圍是中間一段，用兩個只往右走的指針卡左右邊界。答案是總子陣列數減掉 bad，`k = 0` 時直接回傳總數。時間 `O(n log n)`。
