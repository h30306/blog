---
title: "DVA-BERT: Sentiment-Based Masked Language Modeling for Valence–Arousal Prediction"
summary: "Applied Intelligence 2022: masking sentiment words by their intensity instead of random tokens, as an auxiliary task that improves sentence-level valence–arousal prediction"
description: "A multi-task BERT model that replaces random masking with sentiment-word masking and combines VA intensity estimation with masked sentiment word prediction; compares 11 masking setups, loss weights, masking rates, and a public dataset"
date: 2022-03-22
tags: ["paper", "nlp", "sentiment-analysis", "bert", "masked-language-model", "valence-arousal"]
categories: ["paper"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Paper Info

| Item | Details |
|---|---|
| Venue | Applied Intelligence 52 (14), 16353–16369 (2022) |
| Title | Sentiment-based masked language modeling for improving sentence-level valence–arousal prediction |
| Authors | Jheng-Long Wu, **Wei-Yi Chung** |
| DOI | [10.1007/s10489-022-03384-9](https://doi.org/10.1007/s10489-022-03384-9) |
| Code | [h30306/Sentiment-Based-Masked-Language-Modeling-for-Improving-Sentence-Level-Valence-Arousal-Prediction](https://github.com/h30306/Sentiment-Based-Masked-Language-Modeling-for-Improving-Sentence-Level-Valence-Arousal-Prediction) |
| Funding | MOST 107-2218-E-031-002-MY2, 109-2221-E-031-003, 110-2221-E-031-004 |

This was one of the first research topics I started in the NLP Lab. In early 2020 I wrote the first version in the IJCAI-PRICAI 2020 format (*A Novel Dimensional Valence-Arousal Prediction Model Using Masked Sentiment Words Approach*), then extended it into a journal paper for Applied Intelligence. Per the paper's CRediT statement, I was responsible for conceptualization, methodology, experiments, and writing.

## Motivation

### Why valence–arousal

Most sentiment analysis stops at positive versus negative, which says nothing about how strong a feeling is. **Dimensional valence–arousal (DVA)** uses two continuous values instead:

- **Valence**: the direction of the emotion, positive or negative.
- **Arousal**: how excited the emotion is, calm or agitated.

This matters for mental-health text. Comments that are negative and highly aroused, for example, show up in depression-related posts and may signal unstable emotions or negative behavior; a binary label cannot capture that.

### BERT's random masking ignores sentiment

BERT is pre-trained with masked language modeling (MLM): mask random tokens, then predict them back. That teaches the model to read context, but **every token has the same chance of being masked**, no matter how much it matters to the sentiment.

Earlier work that applied BERT to sentiment analysis mostly swapped in new input data and a new output layer and fine-tuned, without treating the domain's sentiment words specially. This paper's idea: since masking forces the model to understand the context around the masked position, **mask the sentiment words specifically**, and the model will focus on them and how they are used.

## Model Architecture: DVA-BERT

![DVA-BERT architecture (figure from the paper)](model.jpg)

DVA-BERT has two learning tasks:

- **VAIE** (valence–arousal intensity estimation, the main task): predict the sentence's valence and arousal.
- **RMSWP** (random masked sentiment word prediction, the auxiliary task): replace BERT's random masking with intensity-based masking of sentiment words, then predict which sentiment word was masked.

In the figure, "hate" in "I hate you very much" is a sentiment word and becomes `[MASK]`. The pipeline has five steps.

### 1. Word segmentation

The CKIP tagger splits sentence `s_i` into words `X = {x1, …, xN}`.

### 2. Sentiment intensity → masking probability

The sentiment lexicon is **CVAW**, where every word has a valence and an arousal score on a 1–9 scale.

For **valence**, first take the distance from the midpoint:

```text
TI_V(sw) = | I_V(sw) − mid(I_V) |
```

The more positive or negative a word, the larger `TI_V`. Then min–max normalize and **reverse** with `|norm − 1|`:

```text
P_V(sw) = | (TI_V(sw) − min(TI_V)) / (max(TI_V) − min(TI_V)) − 1 |
```

After reversing, **the weaker the sentiment, the higher the masking probability**. The paper's reasoning: low-intensity sentiment words are the ones most likely to confuse the model about how strong an emotion they carry, so the model should be pushed to learn them.

For **arousal**, min–max normalize directly and reverse the same way:

```text
P_A(sw) = | (I_A(sw) − min(I_A)) / (max(I_A) − min(I_A)) − 1 |
```

### 3. Building the masked sequence

Only sentiment words can be masked; every other word has probability 0. Each sentiment word gets one Bernoulli draw for valence and one for arousal, and **is masked only if both hit**:

```text
P_mask(x_n) = Bernoulli(β · P_V(x_n)) × Bernoulli(β · P_A(x_n))
```

β is the initial masking probability, a hyperparameter that stops too many sentiment words in a sentence from being masked, which would leave the model unable to learn the original meaning. The final input is:

```text
X' = [<CLS>, mn_1, …, mn_N, <EOS>]
```

### 4. Output layers for the two tasks

`X'` goes through BERT to produce hidden states `H = [h_CLS, h_1, …, h_N, h_EOS]`.

| Task | Output used | Head | Loss |
|---|---|---|---|
| VAIE | `h_CLS` | Two linear layers for valence and arousal | MSE |
| RMSWP | `h_i` at each word | Linear → GELU → LayerNorm → Linear, output size equal to the lexicon | Cross-entropy |

### 5. Training

The two losses are combined with a weight:

```text
L = α · l_VAI + (1 − α) · l_RMSW
```

α controls how much the model leans toward the main task. With α = 1 the auxiliary loss is ignored, but the input is still the masked sentence. All BERT parameters are fine-tuned with Adam.

## Data

### PsychPark depression corpus

The data come from PsychPark, an online psychiatric clinic run by volunteer psychiatrists, psychologists, and social workers. **2,300 sentences** from depression-related posts fall into six categories:

| Category | Sentences | Share | Mean valence | Mean arousal |
|---|---|---|---|---|
| Depressed mood | 641 | 27.8% | 3.23 | 4.66 |
| Suicide | 224 | 9.7% | 1.97 | 5.77 |
| Insomnia | 233 | 10.1% | 3.86 | 3.90 |
| Work and activity | 110 | 4.8% | 3.81 | 3.32 |
| Anxiety | 738 | 32.0% | 3.38 | 5.19 |
| Physical symptoms | 354 | 16.1% | 3.48 | 4.70 |

**Annotation**: at least 10 annotators scored each sentence's valence and arousal on a 1–9 scale independently. Scores beyond ±1.5 standard deviations from the mean were dropped as outliers before averaging.

Depression-related sentences are generally calm: arousal never goes above 6. Among the six categories, "suicide" has the lowest mean valence (1.97) and the highest mean arousal (5.77).

### Sentiment word coverage

If a sentence has no lexicon word, there is nothing to mask. The paper counts how many sentences contain at least one CVAW sentiment word:

| Category | Sentences | With a sentiment word | Coverage |
|---|---|---|---|
| Depressed mood | 641 | 589 | 91.9% |
| Suicide | 224 | 169 | 75.4% |
| Insomnia | 233 | 181 | 77.7% |
| Work and activity | 110 | 78 | 70.9% |
| Anxiety | 738 | 658 | 89.2% |
| Physical symptoms | 354 | 255 | 72.0% |

Coverage ranges from 70.9% to 91.9%, so each Bernoulli draw has plenty of different sentiment words to choose from and the model sees many different masks.

## Experimental Setup

**Splits**: 7:1:2 train/validation/test with five-fold cross-validation; reported numbers are averages over the five test folds.

**Hyperparameters**:

| Parameter | Value | Note |
|---|---|---|
| α | 0.6, 0.8, 1.0 | Weight of the VAIE loss |
| β | 0.1 to 0.5 in steps of 0.05 | Initial masking probability |
| Learning rate | 5e-5 | |

Every model starts from Google's pre-trained Chinese BERT. The best model is chosen by the best α–β combination.

**Metrics**: RMSE, MAE, MdAE (median absolute error), and R².

### The 11 masking setups

| Model | Masking |
|---|---|
| **DVA-BERT** | Proposed: V and A both reversed, the two draws multiplied (intersection) |
| DVA-BERT-VAI | Same but not reversed; higher intensity means more masking |
| DVA-BERT-NM | No masking, VAIE only |
| DVA-BERT-RM | Original BERT random masking |
| DVA-BERT-MS | Masks sentiment words without intensity-based probability |
| DVA-BERT-MV / MRV | Valence only, not reversed / reversed |
| DVA-BERT-MA / MRA | Arousal only, not reversed / reversed |
| DVA-BERT-VAU / RVAU | V and A probabilities added (union), not reversed / reversed |

## Results

### Comparing the 11 setups

- **DVA-BERT has the lowest RMSE** and the best standardized sum over the four metrics.
- **Reversed setups win**: MRV, MRA, and RVAU beat the unreversed MV, MA, and VAU. Low-intensity sentiment words are more frequent and used in more ways, so masking them teaches finer distinctions in sentiment.
- **DVA-BERT-MS is the worst**: it treats every sentiment word as a candidate regardless of intensity, masks too many words, and breaks the meaning of short sentences.
- DVA-BERT-VAI and RVAU also do well, so choosing masks from both dimensions beats choosing from one.
- The valence-only MRV is strong too, which suggests valence words carry much of a sentence's sentiment.

### Sentences with and without sentiment words

Test sentences split into those with and without a sentiment word (excerpt):

| Model | With: RMSE | MAE | R² | Without: RMSE | MAE | R² |
|---|---|---|---|---|---|---|
| DVA-BERT-RM | 1.36 | 1.06 | 0.81 | 1.49 | 1.14 | 0.59 |
| DVA-BERT-NM | 1.35 | 1.04 | 0.82 | 1.51 | 1.14 | 0.51 |
| DVA-BERT-MS | 1.41 | 1.08 | 0.73 | 1.54 | 1.18 | 0.45 |
| DVA-BERT-VAI | 1.33 | 1.02 | 0.86 | 1.48 | 1.14 | 0.58 |
| DVA-BERT-RVAU | 1.35 | 1.04 | 0.84 | 1.50 | 1.17 | 0.53 |
| **DVA-BERT** | **1.32** | **1.02** | **0.88** | **1.46** | **1.13** | **0.60** |

- Every model is more accurate on sentences with sentiment words, so those words drive sentence sentiment.
- On those sentences DVA-BERT clearly beats the unmasked NM on all four metrics, so learning to guess sentiment words helps.
- Interestingly, DVA-BERT also has the best RMSE, MAE, and R² on sentences **without** sentiment words: what it learns from masking transfers.

### Loss weight α

- DVA-BERT reaches its lowest MAE at **α = 0.8**, i.e. 80% main task and 20% auxiliary task.
- MS, MA, and VAU, which mask many words, improve as α grows (leaning toward the main task); RM and VAI go the other way; the rest show no stable trend.
- The paper's inference: **when few words are masked, guessing them helps the main task; when too many are masked, guessing becomes a burden.**
- Even at α = 1, with the auxiliary loss ignored, different masking setups still give different results, so which words are masked in the input already shapes what the model learns.

### Initial masking probability β

The paper plots the average number of masked words during training against β:

- Models that **already mask many words** (RM, MS, VAU, MRA) do best with low β, which cuts the mask count.
- Models that **start with few masked words** (MV, RVAU, DVA-BERT) can afford a high β, choose where to mask more flexibly, and end up best.

### Effect of pre-trained weights

| Model | RMSE | MAE | MdAE | R² |
|---|---|---|---|---|
| DVA-BERT-INIT (random init) | 1.79 | 1.38 | 0.55 | 0.52 |
| DVA-BERT (pre-trained) | **1.33** | **1.03** | **0.41** | **0.70** |

Without pre-trained weights RMSE falls back from 1.33 to 1.79. Sentiment-word masking builds on BERT's existing language ability.

### Against sequence models

| Model | RMSE | MAE | MdAE | R² |
|---|---|---|---|---|
| **DVA-BERT** | **1.33** | **1.03** | **0.41** | **0.70** |
| DVA-BERT-NM | 1.42 | 1.12 | 0.44 | 0.68 |
| Bi-RNN | 1.68 | 1.30 | 0.48 | 0.63 |
| Bi-LSTM | 1.75 | 1.35 | 0.57 | 0.59 |
| Bi-GRU | 1.71 | 1.32 | 0.51 | 0.51 |

The three bidirectional sequence models use the same 768 hidden and embedding size as BERT, with the same learning rate and epochs. The BERT models are clearly better; among the sequence models the simplest, Bi-RNN, beats Bi-LSTM and Bi-GRU because the sentences are short and need no long-range memory.

### Public dataset

To check that the method is not tied to depression text, the paper also tests on the Chinese sentence VA dataset of Yu et al., built from forum comments where most sentences contain sentiment words:

| Model | RMSE | MAE | MdAE | R² |
|---|---|---|---|---|
| **DVA-BERT** | **1.03** | **0.81** | **0.38** | **0.72** |
| DVA-BERT-RM | 1.27 | 0.93 | 0.43 | 0.62 |
| DVA-BERT-NM | 1.26 | 0.91 | 0.44 | 0.64 |

DVA-BERT beats random masking and no masking on all four metrics, so the masking scheme carries over to other domains.

## Discussion and Limitations

- DVA-BERT works because it **uses both V and A intensity** to decide which sentiment words to mask, which focuses the model on the context around them.
- The union setups (VAU, RVAU) bring no clear gain: they mask so many sentiment words that the auxiliary task becomes too hard.
- **Limitation**: the training data are single sentences, so masking even one word can change the meaning and keep the model from learning the original sentiment. Future work could use multi-sentence text for more and more varied mask candidates, and apply the scheme to other attention-based models.

## Code and Resources

Each `Models/VA_BERT_*` folder in the repo is one experiment. The README has a table mapping each folder and training script to the paper's model names (for example, DVA-BERT is `VA_BERT_mask_sentiment_prob_Intersection_reverse`, trained with `run_train_MSPRIN_kfold*.sh`).

The repo also has `sense_data/` (positive and negative sentiment words; add your own), `data/` (five-fold splits and masking-coverage statistics), `result_statistic/` (collects metrics into CSV), `notebooks/` (plotting code for the paper figures), and `Graph/` (the figures).
