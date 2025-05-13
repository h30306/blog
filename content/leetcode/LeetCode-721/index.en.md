---
title: "LeetCode 721: Accounts Merge"
summary: "LeetCode Problem Solving"
description: "LeetCode Daily"
date: 2025-05-12
tags: ["LeetCode", "Union Find", "medium"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-05-12
- Total time: 20:00.00

## Intuition

This is a Union Find problem without explicitly given relationships.  
At first, I tried a brute-force approach: iterating over every pair of accounts and comparing their email sets.  
If they share more than one item (i.e., same name and at least one common email), then I union them.  
However, this method has time complexity O(n²), and requires additional logic to track owner names and avoid duplicate emails — leading to a messy and inefficient solution.

The better and more optimal approach is to build an email-to-index mapping.  
Every time an email is found in a new account, we check whether it's already in the map:  
- If it is, union the current account with the one mapped by that email.  
- Otherwise, store this email with the current index.  

This way, we only union accounts that share at least one email, and we don't have to repeatedly compare account lists.  
Later, we can iterate over the email map and collect all emails grouped by root index, and finally attach the account name using `accounts[idx][0]`.

Key Insight:  
- Leverage email-to-account index mapping.  
- Use Union Find on indices only (not email strings).  
- Group by root index after union operations.

### Time Complexity:
- First approach: O(n² * m), where m is average number of emails per account.
- Second approach: O(n·α(n)) amortized, where n is total emails.

### Space Complexity:
- O(n + m), due to mappings and Union Find structures.

## Approach

### Compare all email account
I think in this approach, I got stuck on the common item problem.  
I never thought I could simply use all emails as keys, and when an email is already used by another person (linked through the index), I could apply Union Find to connect these two accounts.

```python
class Solution:
    def accountsMerge(self, accounts: List[List[str]]) -> List[List[str]]:
        n = len(accounts)
        uf = UF(n)

        for i in range(n):
            for j in range(i+1, n):
                if len(set(accounts[i]) & set(accounts[j]))>1:
                    uf.union(i, j)

        result = defaultdict(set)
        account = []
        for i in range(n):
            group = uf.find(i)
            if result[group] == set():
                account.append(accounts[i][0])
            result[group].update(accounts[i][1:])
        
        return [[acc, *sorted(value)] for acc, value in zip(account, result.values())]
        
class UF:
    def __init__(self, n):
        self.parent = [i for i in range(n)]

    def find(self, x):
        if self.parent[x] != x:
            self.parent[x] = self.find(self.parent[x])
        return self.parent[x]

    def union(self, x, y):
        root_x = self.find(x)
        root_y = self.find(y)

        if root_x == root_y:
            return

        self.parent[root_y] = root_x
```
### iterate through email account
```python
class UF:
    def __init__(self,n):
        self.root = list(range(n))

    def find(self,x):
        if x == self.root[x]:
            return x
        self.root[x] = self.find(self.root[x])
        return self.root[x]

    def union(self,x,y):
        rootX = self.find(x)
        rootY = self.find(y)
        if rootX != rootY:
            self.root[rootX] = rootY

class Solution:
    def accountsMerge(self, accounts: List[List[str]]) -> List[List[str]]:
        n = len(accounts)
        uf = UF(n)

        owner = {}
        for idx,(_,*emails) in enumerate(accounts):
            for e in emails:
                if e in owner:
                    uf.union(idx,owner[e])    
                else:            
                    owner[e] = idx

        result = defaultdict(list)
        for email,num in owner.items():
            root = uf.find(num) 
            result[root].append(email)

        return [[accounts[idx][0]] + sorted(email) for idx,email in result.items()]
```

## Findings

## Encountered Problems 