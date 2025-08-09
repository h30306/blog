---
title: "LeetCode 30: Substring with Concatenation of All Words (Brute Force → Counting → Sliding Window)"
summary: "Three approaches: brute force, counting optimization, and sliding window over word-length offsets."
description: "Progression from brute force to a frequency-controlled sliding window using word-length stepping; includes complexity and key insights."
date: 2025-08-09
tags: ["LeetCode", "daily", "hard", "string", "sliding-window", "two-pointers", "hash-map", "frequency-counter", "brute-force"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: Hard
First Attempt: 2025-08-09
- Total time: 00:00.00

## Intuition

The first idea is brute force: iterate each starting index and try to consume words one by one. If every word is matched exactly once, record the start. This approach tends to TLE.
Next, an improvement is to reduce repeated slicing and reuse state where possible, which helps but remains fundamentally brute force.
Finally, because all words share the same length, we can view the string in chunks of `word_len` and run a sliding window per offset in `[0, word_len)`, expanding and shrinking the window while maintaining word frequencies.

## Approach

### Approach 1 — Brute Force

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

### Approach 2 — Counting Optimization (early break per window)

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

### Approach 3 — Sliding Window with Offsets (optimal)

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

### Complexity

- Approach 1 (Brute Force): O((|s| - total_len + 1) × num_words) time, O(k) space
- Approach 2 (Counting Optimization): O((|s| - total_len + 1) × num_words) time with better constants, O(k) space
- Approach 3 (Sliding Window): O(|s|) time, O(k) space, where k is the number of distinct words

## Findings

- Equal word length enables stepping the window by `word_len` and scanning per offset.
- Early breaking on invalid words prunes work even in the simpler approaches.
- Frequency-controlled sliding window avoids re-checking from scratch and is optimal here.

## Encountered Problems 