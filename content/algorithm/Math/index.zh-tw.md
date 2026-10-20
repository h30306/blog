---
title: "Math 數學技巧"
summary: "組合計數（配對數、切分方式）、第 k 個排列逐位決定、幾何（最近點、餘弦定理、三角不等式），以及排序或觀察之後變成公式的題目"
description: "演算法學習"
date: 2026-10-20
tags: ["math", "combinatorics", "geometry", "brainteaser"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 介紹

數學題的套路比較分散，但常見的幾種想法是固定的：

| 想法 | 例子 |
|---|---|
| 不枚舉，直接數 | 相同的數有幾對、能切成幾種 |
| 逐位決定 | 第 `k` 個排列 |
| 幾何公式 | 最近點、餘弦定理、三角不等式 |
| 先觀察結構 | 排序後取固定位置、答案只跟頭尾有關 |

質數、GCD、篩法見 [Number Theory]({{< relref "/algorithm/Number-Theory" >}})。

## 模板一：組合計數

**相同的東西兩兩配對**：每種有 `c` 個，配對數是 `c × (c - 1) / 2`。邊掃邊數更簡單：

```python
cnt = Counter()
pairs = 0
for x in items:
    pairs += cnt[x]                      # 跟前面每個相同的配一對
    cnt[x] += 1
```

- **相同數字的配對**（LC 1512）。
- **凱薩密碼等價的字串**（LC 3805）：先把每個字串**正規化**（整串平移到第一個字母是 `a`），等價的字串就變成一樣的，再數配對。

**切成幾段**：如果陣列必須切成 `b` 個不可再分的區塊，每個相鄰區塊之間可以切或不切，共 `2^(b - 1)` 種（LC 2963）。區塊用「每個數最後出現的位置」找，跟 [LeetCode 2584]({{< relref "/leetcode/LeetCode-2584" >}}) 一樣。

## 模板二：第 k 個排列（逐位決定）

從左到右決定每一位：試每個可以放的字元，算「這一位放它之後，剩下的有幾種排法」，`k` 比這個數大就跳過（`k` 減掉它），否則就放它。

```python
k -= 1                                   # 改成 0-indexed
digits = list(range(1, n + 1))
res = []
for i in range(n - 1, -1, -1):
    block = factorial(i)                 # 剩下 i 個數的排法
    idx, k = divmod(k, block)
    res.append(digits.pop(idx))
```

- **`1..n` 的第 `k` 個排列**（LC 60）。
- **第 `k` 個回文排列**（LC 3518）：回文由左半邊決定，變成「多重集合的第 `k` 個排列」。剩下的排法數是 `total! / Π cnt!`；放了字元 `c` 之後，排法數變成 `目前排法數 × cnt[c] / 剩下的長度`，可以 `O(1)` 更新。

## 模板三：幾何

- **圓和矩形有沒有重疊**（LC 1401）：矩形裡離圓心最近的點，是把圓心座標 **clamp** 到矩形範圍內，再比較距離和半徑：

```python
nx = min(max(xc, x1), x2)
ny = min(max(yc, y1), y2)
overlap = (nx - xc) ** 2 + (ny - yc) ** 2 <= r * r
```

- **三角形的內角**（LC 3899）：先用三角不等式判斷能不能組成，再用餘弦定理 `cos A = (b² + c² - a²) / 2bc`。
- **最大周長的三角形**（LC 976）：排序後，三條邊 `a <= b <= c` 能組成三角形 ⇔ `a + b > c`。從最大的開始看連續三個，第一個成立的就是答案。

## 模板四：先觀察結構

- **三等分的二進位值**（LC 927）：三段的 1 的個數一定一樣，所以先數 1。第三段的結尾固定在陣列尾端（尾端的 0 都屬於它），由第三段決定每段的長度。
- **選三個數取中位數**（LC 3627）：排序後，每次拿最大的兩個和最小的一個，中位數是第二大的；答案是從尾端往前每隔一個取。
- **最後剩下的數**（LC 3828）：Alice 第一步就能刪掉除了頭或尾以外的全部，Bob 也一樣，答案是 `max(頭, 尾)`。
- **感測器覆蓋**（LC 3648）：每個感測器蓋 `2k + 1` 的寬度，兩個方向各自做**無條件進位的除法**再相乘。

## 模板五：位數與簡單公式

**取出每一位**：轉成字串最簡單；用 `% 10`、`// 10` 也可以，而且是從個位數開始：

```python
digits = [int(c) for c in str(n)]        # 從最高位開始

while n:                                 # 從個位數開始
    d = n % 10
    n //= 10
```

- **位數和 / 積**（LC 3550、1281、3622）、**位數平方和**（LC 3959：每一位的 `d² - d >= 0`，總和只會變大，達標就能提早回傳）。
- **兩個最大的位數相乘**（LC 3536）、**某個數字出現幾次**（LC 3895、3908）。
- **拆成 `d × 10^k` 的和**（LC 3697）：每個非 0 的位數就是一項。

**直接套公式**：`min(n², maxWeight // w)`（LC 3492）、攝氏轉換（LC 2469）、`n` 個和為 0 的不同整數（LC 1304：`1..n/2` 和它們的相反數，`n` 是奇數再加 0）、等差數列的 XOR（LC 1486）。

## 主要參數說明

- 無條件進位的除法：`-(-a // b)` 或 `(a + b - 1) // b`，不要用浮點數。
- 排列計數用整數運算；Python 大整數沒問題，其他語言要注意溢位或取模。

## 複雜度

大多是 `O(n)` 或排序的 `O(n log n)`；第 `k` 個多重集合排列是 `O(n · 字元種類)`。

## 常見錯誤

這些都是我練習時實際寫錯過的：

- **全部都是 0 的特例**：三等分時沒有 1，任何切法都合法（LC 927）。
- **回文的中間字元算錯**：出現 3 次的字元也是奇數，中間要放它（LC 3518）。
- **第 `k` 個排列沒有把用過的數字拿掉**（LC 60）。
- **無條件進位寫成 `a // b + 1`**：整除時多了 1（LC 3648）。
- **幾何的比較方向寫反**：圓心在矩形上方時要比較上邊，條件寫成了 `<`（LC 1401）。
- **忘了排序輸出**（LC 3899）。
- **從頭 `pop(0)`**：每次 `O(n)`，TLE（LC 3627）。
- **用 `/` 得到浮點數**：答案要整數，用 `//`（LC 3492）。
- **字串和整數混著比較**、**找到新的最大值時沒把舊的最大值移到第二名**（LC 3536）。
- **取模的方向寫反**：`(sum + prod) % n` 應該是 `n % (sum + prod)`（LC 3622）。
- **偶數個時多放了 0**（LC 1304）。

## 相關 LeetCode

- `LC 1512` Number of Good Pairs
- `LC 3805` Count Caesar Cipher Pairs
- `LC 2963` Count the Number of Good Partitions
- `LC 60` Permutation Sequence
- `LC 3518` Smallest Palindromic Rearrangement II
- `LC 1401` Circle and Rectangle Overlapping
- `LC 3899` Angles of a Triangle
- `LC 976` Largest Perimeter Triangle
- `LC 927` Three Equal Parts
- `LC 3627` Maximum Median Sum of Subsequences of Size 3
- `LC 3828` Final Element After Subarray Deletions
- `LC 3648` Minimum Sensors to Cover Grid
- `LC 3492` Maximum Containers on a Ship
- `LC 3536` Maximum Product of Two Digits
- `LC 3550` Smallest Index With Digit Sum Equal to Index
- `LC 3622` Check Divisibility by Digit Sum and Product
- `LC 1304` Find N Unique Integers Sum up to Zero
- `LC 3697` Compute Decimal Representation
- `LC 2469` Convert the Temperature
- `LC 2235` Add Two Integers
- `LC 1486` XOR Operation in an Array
- `LC 1281` Subtract the Product and Sum of Digits of an Integer
- `LC 3908` Valid Digit Number
- `LC 3959` Check Good Integer
- `LC 3895` Count Digit Appearances
