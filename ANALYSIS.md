# Vector and Scalar Evaluation

### Input

- scores <- c(test1 = 8, test2 = NA, test3 = 12, test4 = 4)


### Tracing for clean_scores_vector

| Step | Expression | Result |
|---|---|---|
| start | `scores` | test1 = 8, test2 = NA, test3 = 12, test4 = 4 |
| double | `2 * scores` | 16, NA, 24, 8 |
| cap | `pmin(..., 20)` | 16, NA, 20, 8 *(NA remains NA)* |
| check if is NAs | `is.na(out)` | FALSE, TRUE, FALSE, FALSE |
| replace na | `out[is.na(out)] <- 0` | 16, 0, 20, 8 |


### Tracing for clean_scores_scalar

| Step | Expression | Result |
|------|------------|--------|
| start | `out <- setNames(as.double(scores), names(scores))` | test1 = 8, test2 = NA, test3 = 12, test4 = 4 |
| i = 1 | not NA, `min(2 * 8, 20)` | 16 |
| i = 2 | NA, `out[[2]] <- 0` | 0 |
| i = 3 | not NA, `min(2 * 12, 20)` | 20 |
| i = 4 | not NA, `min(2 * 4, 20)` | 8 |
| end | `out` | 16, 0, 20, 8 |


### Comparison
- Vectorized: each step applies to every element, no conditional, and the mask `is.na(out)` picks what to overwrite
- Scalar: each pass changes only `out[[i]]`, `if (is.na(out[[i]]))` chooses between 0 and `min(2 * out[[i]], 20)`, and the index `i` picks what to overwrite


### Evaluation Order
- Within one pass, `is.na(out[[i]])` is checked first. If TRUE, `out[[i]] <- 0` runs and the arithmetic is skipped, so test2 is never doubled or capped
- `i` goes 1 to 4, so test1 finishes before test2 is touched
- The vector version runs `pmin()` with the NA in place and repairs it afterward


### Recycling
- Recycling repeats the shorter vector to match the longer one
- Harmless: in `2 * scores` and `pmin(..., 20)`, 2 and 20 are repeated to length 4
- Harmful: `pmin(c(test1 = 16, test2 = 30, test3 = 24, test4 = 18), c(20, 10))`
  - caps become 20, 10, 20, 10, giving 16, 10, 20, 10 instead of 16, 20, 20, 18
  - R gives no warning, since 4 is a multiple of 2


### Which one to keep
- Keep the vectorized version because it is shorter, more idiomatic, and faster: it hands the whole vector to R's compiled C code, while the scalar version loops in the R interpreter and repeats the full call every pass. The trade-off is memory, since the vector version builds temporary vectors.
