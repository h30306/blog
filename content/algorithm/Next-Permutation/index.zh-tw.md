---
title: "Next Permutation"
summary: "Next Permutation 介紹"
description: "演算法學習"
date: 2025-04-13
tags: ["algorithm", "next permutation"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 介紹

**Next Permutation**（下一個排列）是一種用來產生某個序列在字典序中「下一個更大排列」的演算法。  
如果該序列已經是字典序中最大的排列，則會將它重排成字典序中最小的形式（也就是升序排列）。

這個演算法常用於處理與排列生成、字串處理，或是在狀態空間中尋找下一個組合的相關問題中。

## 核心概念

這個演算法的目的是：**在字典序下找出序列的下一個排列**。其主要步驟如下：

1. **從右往左掃描**，找到第一個滿足 `nums[i] < nums[i + 1]` 的位置 `i`，這是所謂的「轉折點」。
2. 在 `i` 右邊的區域中，找到最小的 `j > i` 且 `nums[j] > nums[i]`。
3. **交換** `nums[i]` 和 `nums[j]`。
4. **反轉** `nums[i + 1:]` 區段，使其變成最小的組合。

如果整個陣列是遞減的，表示目前是字典序中最大排列，只需要將整個陣列反轉為升序，得到最小排列。

## 時間複雜度

**Next Permutation**（下一個排列）演算法具有以下時間複雜度特性：

- **步驟 1（尋找 pivot）**：  
  從右向左掃描，找到第一個不滿足遞減趨勢的元素，最壞情況下需遍歷整個陣列 — **O(n)**。

- **步驟 2（尋找交換對象）**：  
  再次從右側掃描，找到第一個比 pivot 大的元素 — 最壞情況也是 **O(n)**。

- **步驟 3（交換）**：  
  一次常數時間的交換操作 — **O(1)**。

- **步驟 4（反轉尾部）**：  
  將 `i + 1` 到陣列尾部的部分反轉 — 最壞情況下是 **O(n)**。

---

### 總體時間複雜度：

```
O(n)
```

其中 `n` 為輸入陣列的長度。

---

### 空間複雜度：

```
O(1)
```

所有操作都在原地（in-place）進行，不需要額外空間。


## 模板

```python
def next_permutation(nums: List[int]) -> None:
    n = len(nums)
    i = n - 2

    # Step 1: Find first decreasing element from the right
    while i >= 0 and nums[i] >= nums[i + 1]:
        i -= 1

    if i >= 0:
        # Step 2: Find element just greater than nums[i]
        j = n - 1
        while nums[j] <= nums[i]:
            j -= 1
        # Step 3: Swap
        nums[i], nums[j] = nums[j], nums[i]

    # Step 4: Reverse the tail
    nums[i + 1:] = reversed(nums[i + 1:])
```

### 主要參數說明：

- `i`: 轉折點的索引，從右邊找到第一個打破遞減趨勢的元素。

- `j`: 右側最小但大於 `nums[i]` 的元素，用來與 `nums[i]` 交換。

- `nums[i + 1:]`: 陣列的尾部，需反轉成遞增排序以獲得最小後綴。

## 範例

## LeetCode