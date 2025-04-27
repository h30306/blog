---
title: "LeetCode 3522: Calculate Score After Performing Instructions"
summary: "LeetCode 解題紀錄"
description: "LeetCode Weekly"
date: 2025-04-20
series: ["LeetCode Weekly Contest 446"]
series_order: 1
tags: ["LeetCode", "blog", "weekly", "medium"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試： 2025-04-20
- 總花費時間：11:48.00

## 解題思路

採用暴力法：直接遍歷 `instructions` 陣列，根據指令進行對應動作（`add` 或 `jump`）。  
當 `step` 的位置超出邊界（小於 0 或大於等於陣列長度）時，立即停止迴圈並回傳當前的累積分數。  
同時，需要用 `seen` 集合記錄已經拜訪過的位置，避免無限迴圈的發生。

## 解法

```python
class Solution:
    def calculateScore(self, instructions: List[str], values: List[int]) -> int:
        score = 0
        step = 0
        seen = set()
        n = len(instructions)
        
        while True:
            seen.add(step)
            if instructions[step] == "add":
                score += values[step]
                step += 1
                if step in seen:
                    break
            
            elif instructions[step] == "jump":
                step += values[step]
                if step in seen:
                    break
                    
            if step < 0 or step >= n:
                break
                
        return score
```

## 收穫

NA

## 遇到的問題

NA