---
title: "Bit Manipulation 位元運算"
summary: "常用的位元操作、AND 只會減少位元而 OR 只會增加位元、用 n & (n >> 1) 找相鄰的 1，以及全部是 1 的數 2^k - 1"
description: "演算法學習"
date: 2026-10-21
tags: ["bit-manipulation"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 介紹

位元題的關鍵通常是一個性質，想到之後程式只有幾行：

| 性質 | 用在哪裡 |
|---|---|
| AND 越多位元越少、OR 越多位元越多 | 一群數的共同位元、所有位元的聯集 |
| `n & (n >> 1)` 留下「左邊也是 1」的位元 | 相鄰的兩個 1 |
| `x & (x - 1)` 清掉最低的 1 | 判斷是不是只有一個 1、數 1 的個數 |
| 全部是 1 的數是 `2^k - 1` | 每一位都一樣的數 |

狀態壓縮 DP 見 [Linear DP]({{< relref "/algorithm/Linear-DP" >}})。

## 常用操作

```python
x & 1              # 最低位（奇偶）
(x >> k) & 1       # 第 k 位
x | (1 << k)       # 把第 k 位設成 1
x & ~(1 << k)      # 把第 k 位清成 0
x & (x - 1)        # 清掉最低的 1；結果是 0 代表 x 只有一個 1（或 x 是 0）
x & -x             # 只留下最低的 1
x.bit_length()     # 最高位的位置 + 1
bin(x).count("1")  # 1 的個數
```

## 模板一：累積 AND / OR

```python
acc_or = 0
for x in nums:
    acc_or |= x                          # 任何一個數有的位元

acc_and = -1                             # -1 的每一位都是 1，是 AND 的單位元素
for x in nums:
    acc_and &= x                         # 每一個數都有的位元
```

- **偶數的 OR**（LC 3688）：只對偶數做 OR；沒有偶數時 OR 的初始值 0 剛好就是答案。
- **能讓排列排好的最大 `k`**（LC 3644）：每個不在正確位置的數都一定要被交換，而交換的兩個數 AND 起來要等於 `k`，所以 `k` 的每一位，每個要移動的數都要有。答案就是所有要移動的數的 AND（已經排好就是 0）。

## 模板二：相鄰的位元

`n & (n >> 1)` 的第 `i` 位是 1，代表 `n` 的第 `i` 位和第 `i + 1` 位都是 1：

```python
pairs = n & (n >> 1)                     # 每個 1 代表一對相鄰的 1
exactly_one = pairs != 0 and pairs & (pairs - 1) == 0
```

- **剛好一對相鄰的 1**（LC 3950）：`111` 有兩對（重疊也算），`pairs` 是 `11`，不只一個 1。

## 模板三：全部是 1 的數

每一位都是 1 的數是 `1, 3, 7, 15, ...`，也就是 `2^k - 1`。`2^k - 1 <= n` 等於 `2^k <= n + 1`，所以 `k` 最多到 `(n + 1).bit_length() - 1`：

```python
count = (n + 1).bit_length()             # 1, 3, 7, ... 的個數，再加上 0
```

- **每一位都一樣的數**（LC 3827）：全部是 0 的只有 0 本身，全部是 1 的是 `2^k - 1`。

## 模板四：XOR 抵消與逐位元統計

```python
res = 0
for x in nums:
    res ^= x                         # 出現兩次的抵消，剩下出現一次的
```

- **只出現一次的數**（LC 136、389）：全部 XOR；字元用 `ord` 再 `chr` 回來。
- **其他數出現三次**（LC 137）：逐位元數 1 的個數取 `% 3`；Python 整數沒有固定位數，第 31 位是 1 時減掉 `2^32`。
- **次方判斷**（LC 231、342）：`n > 0 and n & (n - 1) == 0`；4 的次方再加上 `n & 0x55555555`（或 `n % 3 == 1`）。
- **固定長度的遮罩**（LC 476）：`(1 << n.bit_length()) - 1`，`~n` 會變負數。
- **前綴的餘數**（LC 1018）：讀一位就是 `x = (2x + b) % m`。
- **負數轉十六進位**（LC 405）：`num & 0xffffffff` 得到 32 位元補數，再每次取 4 位。

## 主要參數說明

- Python 的整數沒有位數上限，`~x` 等於 `-x - 1`；需要固定位數時要自己 `& mask`。
- `>>` 和 `&` 的優先順序比比較運算子高、比加減低，不確定時加括號。

## 複雜度

大多是 `O(n)` 或 `O(log x)`。

## 常見錯誤

這些都是我練習時實際寫錯過的：

- **以為可以一個一個交換到位**：對每個位置取 `i & nums[i]` 的最大值。但 `k` 要讓**所有**要移動的數都能交換，應該取 AND（LC 3644）。
- **`&` 比 `==` 先算**：`(n > 0) & (n & (n - 1)) == 0` 不是你想的意思，用 `and`（LC 231）。
- **判斷條件寫反**：`n & (n - 1)` 是 0 才是 2 的次方（LC 231）；交錯位元是「沒有 00 而且沒有 11」（LC 693）。
- **用範例的值寫死**：`bin(5)` 而不是 `bin(num)`（LC 476）。
- **補 0 補在右邊**：二進位加法要在左邊補（LC 67）。
- **`while num > 15` 少了最後一位**、**負數沒有轉補數**（LC 405）。
- **每個前綴都重新轉成整數**：`O(n²)`，只要保留餘數（LC 1018）。
- **間隔把結尾的 0 也算進去**（LC 868）。

## 相關 LeetCode

- `LC 3644` Maximum K to Sort a Permutation
- `LC 3688` Bitwise OR of Even Numbers in an Array
- `LC 3950` Exactly One Consecutive Set Bits Pair
- `LC 3827` Count Monobit Integers
- `LC 136` Single Number
- `LC 137` Single Number II
- `LC 231` Power of Two
- `LC 342` Power of Four
- `LC 476` Number Complement
- `LC 461` Hamming Distance
- `LC 693` Binary Number with Alternating Bits
- `LC 868` Binary Gap
- `LC 762` Prime Number of Set Bits in Binary Representation
- `LC 2859` Sum of Values at Indices With K Set Bits
- `LC 1018` Binary Prefix Divisible By 5
- `LC 67` Add Binary
- `LC 405` Convert a Number to Hexadecimal
- `LC 645` Set Mismatch
- `LC 389` Find the Difference
