---
title: "LeetCode 1497: Check If Array Pairs Are Divisible by k"
summary: "餘數配對與雜湊表；特別處理 0 與 k/2 的餘數。"
description: "利用取模與互補關係檢查是否能將陣列完全成對；包含複雜度與常見陷阱。"
date: 2025-08-09
tags: ["daily", "medium", "array", "hash-map", "complement", "counting", "math", "modulo"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false

draft: false
---

## 基本資料

難易度: medium
第一次嘗試： 2025-08-09
- 總花費時間：00:00.00

## 解題思路

以 `num % k` 的餘數作為分類，使用雜湊表統計每個餘數的出現次數。餘數 r 應與其互補餘數 k − r 成對。需特別處理兩個情況：r = 0，以及（當 k 為偶數時）r = k/2，這兩者都必須是偶數次才能完全成對。

## 解法

- 對每個元素計算 `num % k`，並在雜湊表中記錄餘數計數。
- 對於每個餘數 r，檢查 `count[r] == count[k - r]`。
- 特殊情況：
  - 餘數 0 的計數必須為偶數。
  - 若 k 為偶數，餘數 k/2 的計數也必須為偶數。

```python
class Solution:
    def canArrange(self, arr: List[int], k: int) -> bool:
        remains = defaultdict(int)

        for num in arr:
            if num % k:
                remains[num % k] += 1

        for remain_num, count in remains.items():
            if k - remain_num == remain_num and remains[k - remain_num] % 2:
                return False

            elif remains[k - remain_num] != remains[remain_num]:
                return False

        return True
```

### 複雜度

- 時間：O(n)
- 空間：O(k)

## 收穫

- 關鍵概念是餘數與互補餘數的成對關係：r 對 k − r。
- Python 的 `%` 回傳非負餘數，負數也能被自然處理。
- 常見錯誤：忽略處理餘數 0 與（當 k 為偶數時）餘數 k/2。

## 遇到的問題

- 邊界情況需明確處理：
  - 能被 k 整除的數（餘數 0）必須成雙出現，才能互相配對。
  - 當 k 為偶數時，餘數 k/2 也必須成雙；否則僅檢查 `count[k/2] == count[k - k/2]` 可能誤判（例如 k = 4 且有三個 2）。