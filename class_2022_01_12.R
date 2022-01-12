## Exercise 1

### Part 1
typeof(c(1, NA+1L, "C")) # -> character vector

typeof(c(1L / 0, NA)) # -> double vector

typeof(c(1:3, 5)) # -> double vector

typeof(c(3L, NaN+1L)) # -> double vector

typeof(c(NA, TRUE)) #-> logical vector

### Part 2

# logical < integer < double < character



### Exercise 2

f = function(x) {
  # Check small prime
  if (x > 10 || x < -10) {
    stop("Input too big")
  } else if (x %in% c(2, 3, 5, 7)) {
    cat("Input is prime!\n")
  } else if (x %% 2 == 0) {
    cat("Input is even!\n")
  } else if (x %% 2 == 1) {
    cat("Input is odd!\n")
  }
}

f(1) # is odd
f(3) # is prime
f(8) # is even
f(-1) # is odd
f(-3) # is odd
f(11) # is too big
f(1:2) # warnings. + is off
f(2:1) # 1 warning. + is prime
f("0") # error for %%
f("3") # error to big (incorrect)
f("zero") # error to big (incorrect)



