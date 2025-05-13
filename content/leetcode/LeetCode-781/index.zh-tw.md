---
title: "LeetCode 781: Rabbits in Forest"
summary: "LeetCode 解題紀錄"
description: "LeetCode Daily"
date: 2025-04-20
tags: ["LeetCode", "daily", "medium"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試： 2025-04-20
- 總花費時間：00:00.00

## 解題思路

我們可以根據每隻兔子的回答，將牠們分為三種情況：  
第一種是給出相同非零答案的兔子，代表牠們屬於同一種顏色。  
第二種是只有自己給出某個數字的兔子，也就是沒有其他兔子給出相同答案的，代表牠屬於獨立的一組。  
第三種是回答 `0` 的兔子，代表牠是森林中唯一一隻該顏色的兔子。

我們可以先建立一個對應回答次數的 hash map，然後遍歷這個 map 並針對這三種情況做處理，來計算森林中兔子的最小數量。  
特別要注意的是當回答數超過 group size 的情況，例如某組兔子回答 1（代表有 2 隻同色），但 hash map 中統計到 7 隻，這就代表最少要有 4 組（`ceil(7 / 2)`）這樣的兔子才能容納這些回答。

## 解法

### 初版解法

```python
class Solution:
    def numRabbits(self, answers: List[int]) -> int:
        count = {}

        for answer in answers:
            count[answer] = count.get(answer, 0) + 1

        res = 0
        for key, value in count.items():
            if key == 0:
                res += value
            
            elif value == 1:
                res += key + 1

            else:
                group = value // (key + 1)
                group += 1 if value % (key + 1) else 0

                res += group * (key + 1)

        return res
```

### 精簡後的第二版解法

我一開始將三種情況分開處理，但後來發現前兩種可以合併：無論是只有一隻還是多隻兔子回答一樣的數字，都代表牠們看到另外 `k` 隻一樣顏色的兔子，即每組總共有 `k+1` 隻，因此可以統一處理：

```python
class Solution:
    def numRabbits(self, answers: List[int]) -> str:
        count = defaultdict(int)

        for answer in answers:
            count[answer + 1] += 1  # +1 是因為包含回答的這隻兔子

        res = 0
        for key, value in count.items():
            group = value // key
            group += 1 if value % key else 0

            res += group * key

        return res
```

## 收穫

## 遇到的問題