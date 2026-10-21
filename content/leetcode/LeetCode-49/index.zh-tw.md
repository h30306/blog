---
title: "LeetCode 49: Group Anagrams"
summary: "LeetCode 49 解題筆記：把每個字串排序後當成 key，同一個 key 的字串就是同一組 anagram"
description: "2022-10-22 的 LeetCode 49 解題紀錄"
date: 2022-10-22
tags: ["medium", "array", "hash-table", "string", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-10-22
- 提交紀錄：Runtime Error → Wrong Answer ×2 → Time Limit Exceeded ×3 → Accepted → Runtime Error → Accepted ×3

## 解題思路

互為 anagram 的字串排序之後一模一樣，所以用 `"".join(sorted(s))`（或 `tuple(sorted(s))`）當 key（[Hash Table]({{< relref "/algorithm/Hash-Table" >}}) 模板五），丟進 `defaultdict(list)`，最後回傳所有的 value。也可以用長度 26 的次數 tuple 當 key，省掉排序。

## 我的嘗試

這題提交了 11 次：

- 第一版變數打錯（`rse`，NameError）；第二版只在既有的組別裡找，**找不到時沒有新增一組**，所以永遠回傳空的。
- 第三版補上新增，但用 `set` 判斷是不是同一組：`["bb", "b"]` 被分在同一組。
- 改成用 `Counter` 比較之後答案對了，但每個字串都要跟每一組比，**TLE 了三次**。
- 最後改成「排序後當 key」才 AC。2022-10-27 重寫時把 `values()` 寫成 `values` 又 RE 一次。

## 正確解法

```python
class Solution:
    def groupAnagrams(self, strs: List[str]) -> List[List[str]]:
        groups = defaultdict(list)
        for s in strs:
            groups["".join(sorted(s))].append(s)
        return list(groups.values())
```

## 複雜度

時間 `O(n · k log k)`（`k` 是字串長度），空間 `O(nk)`。

## 要特別避免的錯誤

- 不能用 `set` 比：`"bb"` 和 `"b"` 的字元集合相同，但不是 anagram。
- 每個字串都跟現有的每一組比是 `O(n²)`，會 TLE；用 key 一次就能找到組別。
- `dict.values` 是方法，要加括號。

## 面試口說整理

我把每個字串排序後當成雜湊表的 key，互為 anagram 的字串會得到同一個 key，最後回傳所有組別。時間 `O(n · k log k)`；如果字串很長，可以改用 26 個字母的次數當 key。
