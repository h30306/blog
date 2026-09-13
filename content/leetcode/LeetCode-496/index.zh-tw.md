---
title: "LeetCode 496: Next Greater Element I"
summary: "單調遞減堆疊處理 nums2，預先建立下一個更大元素對照表，回答 nums1 查詢。"
description: "使用單調堆疊在線性時間內計算下一個更大元素；包含複雜度與常見陷阱。"
date: 2025-08-09
tags: ["leetcode", "daily", "easy", "array", "stack", "monotonic-stack", "hash-map", "next-greater-element"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
  draft: false
---

## 基本資料

難易度: easy
第一次嘗試： 2025-08-09
- 總花費時間：00:00.00

## 解題思路

用單調遞減堆疊遍歷 `nums2`。當前數字大於堆疊頂端時，彈出頂端並將當前數字記為該值的「下一個更大元素」。如此即可預先建立「值 → 下一個更大元素」的映射，回答 `nums1` 中每個值的查詢。

## 解法

- 維持 `nums2` 的遞減堆疊。
- 針對 `nums2` 的每個 `num`：
  - 當堆疊非空且 `stack[-1] < num`，彈出 `top` 並設定 `map_[top] = num`。
  - 將 `num` 推入堆疊。
- 最後對 `nums1` 每個值回傳 `map_.get(value, -1)`。

```python
class Solution:
    def nextGreaterElement(self, nums1: List[int], nums2: List[int]) -> List[int]:

        stack = []
        map_ = {}

        for num in nums2:
            while stack and stack[-1] < num:
                value = stack.pop()
                map_[value] = num

            stack.append(num)

        return [map_.get(num, -1) for num in nums1]
```

### 複雜度

- 時間：O(n + m)，其中 n = len(nums2)，m = len(nums1)
- 空間：O(n)，用於堆疊與映射

## 收穫

- 單調遞減堆疊確保每個元素最多被推入/彈出一次，時間為線性。
- 本題 `nums2` 元素皆唯一，因此可用「值」作為映射鍵，不會產生歧義。
- 對於無更大元素者，透過 `get(..., -1)` 自然回傳 `-1`。

## 遇到的問題

- 構建對照表時混淆「索引」與「值」，容易查不到或查錯。
- 若元素不唯一，使用「值」作為鍵會產生歧義；本題由於唯一性避免了此問題。
- 不需特別清空堆疊：剩餘在堆疊中的值確實沒有更大元素，對應 `-1`。