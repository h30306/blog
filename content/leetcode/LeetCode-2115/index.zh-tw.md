---
title: "LeetCode 2115: Find All Possible Recipes from Given Supplies"
summary: "LeetCode 2115 解題筆記，依照原始 learning note 重新整理"
description: "2026-04-11 的 LeetCode 2115 學習紀錄，包含筆記修正點與正確解法"
date: 2026-04-11
tags: ["medium", "graph", "topological-sort"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-04-11
來源：Day 3 learning note

## 學習脈絡

這篇是從 learning note 裡該 LeetCode 題目的段落重新整理出來的版本。我保留當天筆記中的修正點、比較點、容易犯錯的地方，並移除同一天其他非 LeetCode 主題，避免文章內容混題。

## 當天筆記摘錄

#### LC 2115 - Find All Possible Recipes from Given Supplies
- **Pattern:** Topological Sort / Dependency unlocking
- **Key insight:** Supplies 是一開始就 available 的節點。當某個 recipe 的所有 ingredients 都 available，它才會變成 available。
- **Approach:** 建 `ingredient -> recipes depending on it` 的 graph。每個 recipe 的 in-degree 代表還缺幾個 ingredient。BFS queue 從 supplies 開始。當一個 available ingredient unlock 某個 recipe，就把該 recipe 的 missing count 減 1；如果變成 0，加入答案並放回 queue，因為 recipe 之後也可以當別人的 ingredient。
- **Mental model:** 這像 Course Schedule，但起點是 supplies，不只是 zero in-degree recipes。
- **Cycle behavior:** 在 cycle 裡、或依賴 unavailable ingredient 的 recipes，永遠不會到 in-degree 0。
- **Complexity:** Time O(total ingredients + recipes), Space O(total ingredients + recipes)
- **Common bugs:** 把 edge 建成 `recipe -> ingredient`、忘記把新做出的 recipe 放回 queue、看到 unavailable ingredient 就立刻失敗。


## 整理補充

這題比較像 dependency unlocking，不是一般課程排程。Supplies 是一開始就 available 的材料；每個 recipe 記錄還缺幾個 ingredient。當某個 available item 讓 recipe 的 missing count 歸零，那個 recipe 不只加入答案，也要放回 queue，因為做出的 recipe 之後也能當其他 recipe 的 ingredient。note 裡最重要的修正點是：看到某個 ingredient 一開始 unavailable 不代表立刻失敗，它可能晚一點被做出來。

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
from collections import defaultdict, deque
from typing import List

class Solution:
    def findAllRecipes(self, recipes: List[str], ingredients: List[List[str]], supplies: List[str]) -> List[str]:
        graph = defaultdict(list)
        need = {}

        for recipe, ing_list in zip(recipes, ingredients):
            need[recipe] = len(ing_list)
            for ing in ing_list:
                graph[ing].append(recipe)

        q = deque(supplies)
        ans = []
        while q:
            item = q.popleft()
            for recipe in graph[item]:
                need[recipe] -= 1
                if need[recipe] == 0:
                    ans.append(recipe)
                    q.append(recipe)

        return ans
```

## 複雜度

Time O(total ingredients + supplies + recipes), Space O(total ingredients).

## 要特別避免的錯誤

- Adding unavailable ingredients to the queue.
- Forgetting recipes can become ingredients for later recipes.

## 面試口說整理

我會把 supplies 和已完成 recipes 都當成 available ingredients。每個 recipe 記錄還缺幾個 ingredient；當 missing count 歸零，它就是答案，也會變成新的 available ingredient 去解鎖後面的 recipes。
