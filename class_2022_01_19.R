## Exercise 1

z = 1
f = function(x, y, z) {
  z = x+y
  g = function(m = x, n = y) {
    m/z + n/z
  }
  z * g()
}

# What is the result of
f(1, 2, x = 3)

## Global Scope
# z = 1

## f() scope
# x = 3 # From args
# y = 1
# z = 2

# z = 3+1  # z = x+y

## g() scope
# m = x = 3 # from args
# n = y = 1

# return m/z + n/z  = 3/4 + 1/4 = 1

## f() scope

# g() returns 1
# return 4* 1 =4


## Exercise 2

primes = c( 2,  3,  5,  7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 
           43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97)

x = c(3,4,12,19,23,51,61,63,78)

# Loop version
res = c()
for(val in x) {
  is_prime = FALSE
  for(p in primes) {
    if (val == p) {
      is_prime = TRUE
      break
    }
  }
  
  if (!is_prime) {
    res = c(res, val)
  }
}

res

# Vectorized version (more on subsetting next week)
x[!x %in% primes]





