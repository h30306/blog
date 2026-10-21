---
title: "LeetCode 1410: HTML Entity Parser"
summary: "LeetCode 1410 解題筆記：由左到右在每個位置嘗試比對六個 entity，比對到就整段跳過；不能用連續的 replace"
description: "2025-07-15 的 LeetCode 1410 解題紀錄"
date: 2025-07-15
tags: ["medium", "hash-table", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2025-07-15
- 提交紀錄：Wrong Answer → Runtime Error ×2 → Accepted

## 解題思路

由左到右掃，每個位置用 `startswith` 試六個 entity（[String]({{< relref "/algorithm/String" >}}) 模板二）：

- 比對到就輸出對應的字元，`i` 跳過整個 entity。
- 都沒比對到就輸出原字元，`i += 1`。

因為輸出的字元不會再被掃描，替換結果不會跟後面的字組成新的 entity。

## 我的嘗試

1. **第一版**用一連串的 `replace`。`"&amp;gt;"` 應該變成 `"&gt;"`，但 `&amp;` 換成 `&` 之後，跟後面的 `gt;` 組成新的 `&gt;`，又被換成 `>`。
2. **第二、三版**改成雙指標往後找 `;`，但沒檢查邊界：`&` 在字串最後時 `text[right]` 超出範圍，例如 `"&"` 直接 IndexError。
3. 加上 `right < len(text)` 就 AC 了。

## 正確解法

```python
class Solution:
    def entityParser(self, text: str) -> str:
        table = {"&quot;": '"', "&apos;": "'", "&amp;": "&",
                 "&gt;": ">", "&lt;": "<", "&frasl;": "/"}
        out, i = [], 0
        while i < len(text):
            for pattern, ch in table.items():
                if text.startswith(pattern, i):
                    out.append(ch)
                    i += len(pattern)
                    break
            else:
                out.append(text[i])
                i += 1
        return "".join(out)
```

## 複雜度

時間 `O(n · E)`，`E` 是 entity 總長（常數），空間 `O(n)`。

## 要特別避免的錯誤

- 不要連續 `replace`，替換出來的字會被下一次替換看到。
- 往後看之前要檢查邊界；`startswith` 自己會處理。

## 面試口說整理

我由左到右掃，每個位置試著比對六個 entity，比對到就輸出對應字元並跳過整段，沒有就輸出原字元。輸出的東西不會再被掃描，所以不會有連續 `replace` 那種「換出來的 `&` 又組成新 entity」的問題。時間 `O(n)`。
