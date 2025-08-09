---
title: "LeetCode 30: Substring with Concatenation of All Words"
summary: "三種作法：暴力、計數優化、偏移量滑動視窗。"
description: "從暴力到以 word_len 為步長的滑動視窗，透過頻率控制維持有效視窗；包含複雜度與心得。"
date: 2025-08-09
tags: ["LeetCode", "daily", "hard", "string", "sliding-window", "two-pointers", "hash-map", "frequency-counter", "brute-force"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度：困難
第一次嘗試：2025-08-09
- 總花費時間：00:00.00

## 解題思路

先從暴力法出發：針對每個起點逐一消耗單字，若全部吻合就記錄起點，但容易 TLE。
接著做計數優化，減少重複切片與狀態重建，雖有改善但本質仍是暴力。
最後利用所有單字長度相同的特性，將字串視為長度 `word_len` 的區塊，對 `offset ∈ [0, word_len)` 做滑動視窗，搭配頻率表在失衡時從左邊彈出回復有效視窗。

## 解法

### 作法一 — 暴力

```python
class Solution:
    def findSubstring(self, s: str, words: List[str]) -> List[int]:
        if not s or not words:
            return []

        m = len(s)
        n = len(words[0])
        total_words = len(words)
        total_len = n * total_words
        if m < total_len:
            return []

        target = Counter(words)
        res: List[int] = []

        for i in range(m - total_len + 1):
            left = i
            remaining = total_words
            need = target.copy()

            while remaining > 0:
                word = s[left:left + n]
                if need[word] > 0:
                    need[word] -= 1
                    left += n
                    remaining -= 1
                else:
                    break

            if remaining == 0:
                res.append(i)

        return res
```

### 作法二 — 計數優化（每個起點及早終止）

```python
class Solution:
    def findSubstring(self, s: str, words: List[str]) -> List[int]:
        if not s or not words:
            return []

        m = len(s)
        n = len(words[0])
        total_words = len(words)
        total_len = n * total_words
        if m < total_len:
            return []

        target = Counter(words)
        res: List[int] = []

        for i in range(m - total_len + 1):
            left = i
            seen = defaultdict(int)
            matched = 0

            for right in range(left, m - n + 1, n):
                word = s[right:right + n]
                if word in target and seen[word] < target[word]:
                    seen[word] += 1
                    matched += 1
                else:
                    break

            if matched == total_words:
                res.append(left)

        return res
```

### 作法三 — 偏移量滑動視窗（最優）

```python
class Solution:
    def findSubstring(self, s: str, words: List[str]) -> List[int]:
        res = []
        word_len = len(words[0])
        n = len(words)
        word_count = Counter(words)

        for i in range(word_len):
            word_freq = defaultdict(int)
            count = 0
            start = i

            for j in range(i, len(s) - word_len + 1, word_len):
                word = s[j: j + word_len]

                if word not in word_count:
                    count = 0
                    start = j + word_len
                    word_freq = defaultdict(int)
                    continue

                count += 1
                word_freq[word] += 1

                while word_freq[word] > word_count[word]:
                    word_freq[s[start: start + word_len]] -= 1
                    count -= 1
                    start += word_len

                if count == n:
                    res.append(start)

        return res
```

### 複雜度

- 作法一（暴力）：O((|s| - total_len + 1) × num_words) 時間，O(k) 空間
- 作法二（計數優化）：O((|s| - total_len + 1) × num_words) 時間（常數較佳），O(k) 空間
- 作法三（滑動視窗）：O(|s|) 時間，O(k) 空間；k 為 `words` 中不同單字個數

## 收穫

- 單字長度一致可用 `word_len` 為步長做偏移量滑動視窗，涵蓋所有起點。
- 無效單字時重置視窗，有效避免二次方級別回溯。
- 以頻率控制的滑動視窗避免從頭重檢，實務上最穩定。 

## 遇到的問題