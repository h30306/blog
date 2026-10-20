---
title: "LeetCode 88: Merge Sorted Array"
summary: "LeetCode 88 解題筆記：從後往前合併，O(1) 額外空間"
description: "2026-10-18 merge sort 練習梯子的 LeetCode 88 紀錄"
date: 2026-10-18
tags: ["easy", "two-pointers", "merge-sort"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2026-10-18
來源：Merge sort 練習梯子，第 0 階

## 解題思路

`nums1` 的長度是 `m + n`，後面 `n` 格是空位。兩個陣列都已排序，所以只需要 merge sort 裡的 merge 這一步。

如果從前面填，會蓋掉 `nums1` 還沒讀的元素。從後面填就不會：寫入位置 `k` 永遠不會超過還沒讀的位置 `i`。

## 我的第一版

```python
i = m - 1
j = n - 1
k = m + n - 1

while i >= 0 or j >= 0:
    if j == -1 or (nums1[i] > nums2[j] and i >= 0):
        nums1[k] = nums1[i]
        i -= 1
    else:
        nums1[k] = nums2[j]
        j -= 1
    k -= 1
```

結果正確，但有兩個可以改的地方：

- **判斷順序**：`i == -1` 時會先讀 `nums1[-1]` 才檢查 `i >= 0`。Python 的負索引剛好讓它不出錯，但在 Java/C++ 會越界。邊界檢查要放前面，利用 short-circuit 保護後面的存取。
- **迴圈跑太久**：`nums2` 用完以後，`nums1` 剩下的元素已經在正確位置，這時 `k == i`，等於把元素複製到自己身上。迴圈條件改成 `while j >= 0` 就夠了。

## 正確解法

```python
class Solution:
    def merge(self, nums1: list[int], m: int, nums2: list[int], n: int) -> None:
        i, j, k = m - 1, n - 1, m + n - 1
        while j >= 0:
            if i >= 0 and nums1[i] > nums2[j]:
                nums1[k] = nums1[i]
                i -= 1
            else:
                nums1[k] = nums2[j]
                j -= 1
            k -= 1
```

### 另一種寫法：從前往後 + 暫存陣列

這就是 merge sort 標準的 merge，LC 912 會直接用到：

```python
a = nums1[:m]
i = j = 0
for k in range(m + n):
    if j >= n or (i < m and a[i] <= nums2[j]):
        nums1[k] = a[i]
        i += 1
    else:
        nums1[k] = nums2[j]
        j += 1
```

## 複雜度

| 寫法 | 時間 | 額外空間 |
|---|---|---|
| 從後往前 | `O(m + n)` | `O(1)` |
| 從前往後 + 暫存 | `O(m + n)` | `O(m)` |
| 合併後整個重排 | `O((m + n) log(m + n))` | 不建議 |

## 要特別避免的錯誤

- 先讀陣列才檢查邊界。
- 從前面填卻沒有暫存，蓋掉還沒讀的元素。

## 面試口說整理

兩個陣列都已排序，所以只需要 merge 這一步。`nums1` 的空位在尾巴，我從後往前填，每次放兩邊目前最大的值，這樣不會蓋掉還沒讀的元素，可以做到 `O(m + n)` 時間、`O(1)` 額外空間。`nums2` 用完就可以停，因為 `nums1` 剩下的部分已經在正確位置。
