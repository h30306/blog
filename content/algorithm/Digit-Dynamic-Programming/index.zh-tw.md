---
title: "Digit Dynamic Programming"
summary: "Digit Dynamic Programming 介紹"
description: "演算法學習"
date: 2025-04-11
tags: ["algorithm", "digit DP"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 介紹

Digit Dynamic Programming（Digit DP，數位動態規劃）是一種強大的技巧，常用來解決在某個範圍內**統計符合特定條件的數字個數**的問題。

通常，題目會給你一個數字區間 `start` 到 `finish`，並搭配一組與數字位數相關的限制條件。目標是找出在這個範圍中，有多少個數字滿足這些條件。

舉例來說，假設給定 `start = 10` 與 `finish = 25`，問題可能會要求你回傳這個範圍內，**數位總和為偶數** 或 **不包含重複數字** 的數字數量。

與傳統動態規劃（通常處理陣列或矩陣元素）不同的是，Digit DP 是針對數字的**每一個位數（digit）** 來進行處理，並且從最高位數一路遞迴到最低位數。

---

## 核心概念

Digit DP 本質上是一種 **自頂向下（Top-down）的遞迴 DFS 結合記憶化（Memoization）** 技巧。其核心概念是：**一位一位地構造數字（digit by digit）**，同時在每一層遞迴中維持限制條件。

Digit DP 中最重要的概念之一是 `tight`（或稱 `is_tight`）參數，它表示我們目前是否仍**受到原始目標數字的限制**。

舉例來說，假設我們從左到右構造一個數字，而目標數字是 `125`。只要我們選擇的每一位數字與 `1`、`2`… 這些原始數字相同，那我們就仍處於 *tight* 狀態。但一旦我們在某一位選擇了一個較小的數字（例如選擇 `0` 而非 `1`），就會**不再 tight**，之後的每一位數字都可以自由地選擇從 `0` 到 `9`。

## 時間複雜度

Digit DP 的時間複雜度取決於以下兩個因素：

1. **目標數字的位數**（記為 `d`）  
   例如 `n = 10^18` 則大約有 18 位數。

2. **DP 狀態的總數**（記為 `s`）  
   根據題目需求，可能需要追蹤：
   - 數字總和（digit sum）
   - 奇偶性（parity）
   - 前一位數字（檢查是否重複）
   - 是否出現某個模式（例如包含特定數字）
   - 使用過的數字集合（bitmask）
   - 等等...

---

### 一般情況分析

若：
- `d` = 數字的總位數
- `s` = 狀態空間大小（some_state 可能的值組合數）

則 Digit DP 的總時間複雜度約為：

```
O(d × s)
```

原因如下：
- 每一層遞迴函數會根據 `(pos, tight, state)` 呼叫一次；
- 每個 `pos`（位數位置）最多枚舉 10 個數字（0 到 9）；
- 但由於使用記憶化（例如 `lru_cache` 或 `memo`），  
  所有重複子問題都只計算一次，避免重工。

---

### 空間複雜度（Space Complexity）

空間複雜度也為：

```
O(d × s)
```

這來自於：
- 記憶化儲存中間遞迴結果（避免重算）；
- 遞迴呼叫堆疊深度最多為 `d` 層。

---

---

## 模板

以下是一個通用的 Digit DP 函式模板範例：
```python
def digit_dp(n: int):
    digits = list(map(int, str(n)))

    from functools import lru_cache

    @lru_cache(None)
    def dfs(pos: int, tight: bool, some_state):
        if pos == len(digits):
            return base_case_result

        max_digit = digits[pos] if tight else 9
        res = 0

        for d in range(0, max_digit + 1):
            res += dfs(
                pos + 1,
                tight and d == max_digit,
                update_state(some_state, d)
            )
        return res

    return dfs(0, True, initial_state)
```
### 主要參數說明：

- `pos`：目前處理的數字位數位置（從最左邊第 0 位開始）。

- `tight`：表示目前構造出來的數字前綴是否仍與原始數字 `n` 相符。若 `tight` 為 `True`，代表當前位數不能超過 `digits[pos]`。

- `some_state`：根據題目需求所定義的自訂狀態變數，常見的範例如：
  - 數位總和（digit sum）
  - 出現過幾個 1（number of 1s）
  - 前一個數字（用來檢查是否有連續重複）
  - 是否出現過某個模式
  - 等等

## 範例
### 數位加總

```python
def count_digit_sum(n: int , target: int):
    digits = list(map(int, str(n)))

    from functools import lru_cache

    @lru_cache(None)
    def dfs(position: int, tight: bool, digit_sum: int) -> int:
        if position == len(digits):
            return int(digit_sum == target)
        
        max_digit = digits[position] if tight else 9
        result = 0
        
        for digit in range(0, max_digit+1):
            result += dfs(
                position + 1,
                tight and (digit==max_digit),
                digit_sum + digit
            )
        
        return result
    
    return dfs(0, True, 0)
```
### 不連續重複數位
```python
def non_duplicate_number(number: int):
    digits = list(map(int, str(number)))

    from functools import lru_cache


    @lru_cache(None)
    def dfs(position: int, tight: bool, prev_digit: int, leading_zero: bool):
        if position==len(digits):
            return 1
        
        max_digit = digits[position] if tight else 9
        res = 0

        for d in range(max_digit+1):
            if d == prev_digit and not leading_zero:
                continue
            res += dfs(
                position +1,
                tight and d==max_digit,
                d,
                leading_zero and not d
            )
        
        return res
    
    return dfs(0, True, -1, True)
```

### 偶數位
```python
def even_number(number: int):
    digits = list(map(int, str(number)))

    from functools import lru_cache

    @lru_cache(None)
    def dfs(position: int, tight:bool, parity:int):
        if position==len(digits):
            return int(parity == 0)
        
        max_digit = digits[position] if tight else 9
        res = 0
        for d in range(max_digit+1):
            res += dfs(
                position+1,
                tight and (d==max_digit),
                (parity + d) % 2
            )

        return res
    
    return dfs(0, True, 0)
```
