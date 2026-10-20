# Vector and Scalar Evaluation


- For this we can use this input as a tracing example 

### Input

- scores <- c(test1 = 8, test2 = NA, test3 = 12, test4 = 4)


### Tracing for clean_scores_vector
- Table version just like previous 124 lec 

| Step | Expression | Result |
|---|---|---|
| start | `scores` | test1 = 8, test2 = NA, test3 = 12, test4 = 4 |
| double | `2 * scores` | 16, NA, 24, 8 |
| cap | `pmin(..., 20)` | 16, NA, 20, 8 *(NA remains NA)* |
| check if is NAs | `is.na(out)` | FALSE, TRUE, FALSE, FALSE |
| replace na | `out[is.na(out)] <- 0` | 16, 0, 20, 8 |

- vectorized method for cleaning scores wherein there is no if and  decisions are depending on the (is.na(out)) -> picks element to overwrite


### Tracing for clean_scores_scalar

| Step | Expression | Result |
|------|------------|--------|
| start | `out <- setNames(as.double(scores), names(scores))` | test1 = 8, test2 = NA, test3 = 12, test4 = 4 |
| i = 1 | `is.na(out[[1]])` is FALSE, so `out[[1]] <- min(2 * 8, 20)` | 16 |
| i = 2 | `is.na(out[[2]])` is TRUE, so `out[[2]] <- 0` | 0 |
| i = 3 | `is.na(out[[3]])` is FALSE, so `out[[3]] <- min(2 * 12, 20)` | 20 |
| i = 4 | `is.na(out[[4]])` is FALSE, so `out[[4]] <- min(2 * 4, 20)` | 8 |
| end | `out` | 16, 0, 20, 8 |


### Comparison
- For the vectorized
  - one operation per step and is applied to every element
  - no conditional used 
  - logical mask (is.na(out)) is used to pick what element to overwrite


- For the scalar
  - one element per pass, and each pass changes only `out[[i]]`
  - conditional used: `if (is.na(out[[i]]))` decides between writing 0 and `min(2 * out[[i]], 20)`
  - loop index (`i`) is used to pick what element to overwrite


### Evaluation Order
- Within one pass, `is.na(out[[i]])` is checked first. If TRUE, `out[[i]] <- 0` runs and the arithmetic `min(2 * out[[i]], 20)` is skipped, so test2 is never doubled or capped
- Across passes, `i` goes 1 to 4, so test1 is finished before test2 is touched
- In the vector version, `pmin()` runs with the NA still in place and `out[is.na(out)] <- 0` repairs it afterward


### Recycling
- Recycling repeats the shorter vector to match the longer one
- Harmless: in `2 * scores` and `pmin(..., 20)` the single numbers 2 and 20 are repeated to length 4
- Harmful: `pmin(c(test1 = 16, test2 = 30, test3 = 24, test4 = 18), c(20, 10))`
  - caps become 20, 10, 20, 10, so the result is 16, 10, 20, 10
  - intended result is 16, 20, 20, 18
  - R gives no warning, since 4 is a multiple of 2


### Which one to keep
- keep the vectoriezed version because it is shorter and more is a much more idiomatic. It is also much more versatile and faster since it hands the whole vector to R's compiled C code, which loops over the elements with almost no per-element cost while the scalar runs the loop in the R interpreter so each set of passes repeats the full call. As time goes on those call adds up and affects the speed of the program. That is a good trade-off for using more memory for it, we replaced speed with memory