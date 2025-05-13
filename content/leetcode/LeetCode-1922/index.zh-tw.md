---
title: "LeetCode 1922: Count Good Numbers"
summary: "LeetCode 解題紀錄"
description: "LeetCode Daily"
date: 2025-04-13
tags: ["LeetCode", "daily", "medium"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試： 2025-04-13
- 總花費時間：00:00.00

## 解題思路

這是一道數學題，目的是要計算滿足以下條件的所有組合數：

1. 偶數索引（從 0 開始）的數字必須是偶數。
2. 奇數索引的數字必須是質數（prime number）。

如果一組數字滿足這些條件，我們稱它為 **good number（好數字）**。

我最初的解法是使用暴力計算（exhaustive calculation）。首先，我會判斷整個數字中有多少個奇數與偶數索引位置。接著，使用 `pow` 來計算每個位置的合法選擇組合數，然後將它們相乘以取得總組合數。

最後，根據題目的要求，因為結果可能非常大，所以要對 `10^9 + 7` 取模後回傳答案。


## 解法
```python
class Solution:
    def countGoodNumbers(self, n: int) -> int:
        odd_count = n//2
        even_count = n//2
        
        if n%2: even_count+=1
        mod = 10**9+7

        return (pow(5, even_count, mod)*pow(4, odd_count, mod)) % mod
```

## 收穫
1. 一開始我是用比較笨的方法來計算奇數與偶數索引的數量，
但其實可以簡化成以下這段程式碼：

```python
even = (n + 1) // 2
odd = n // 2
```
範例說明：
如果長度是奇數（例如 123, n = 3）：
→ (3 + 1) // 2 = 2 個偶數索引位置

如果長度是偶數（例如 12, n = 2）：
→ (2 + 1) // 2 = 1 個偶數索引位置

這是因為 Python 的索引是從 0 開始，因此 0、2、4... 都是偶數索引。

## 遇到的問題

1. 回傳
```python
return (pow(5, even_count)*pow(4, odd_count)) % mod
```
後我遇到了 TLE（Time Limit Exceeded）問題。 
 
為了避免在處理巨大數字時才取模導致的運算瓶頸，我們可以在每次乘法運算前就先取模，  
這樣可以確保中間結果不會過大，有助於提升效能並避免溢位。
```python
return (pow(5, even_count, mod)*pow(4, odd_count, mod)) % mod
```