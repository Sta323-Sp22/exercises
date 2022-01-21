## Exercise 1

json = '{
  "firstName": "John",
  "lastName": "Smith",
  "age": 25,
  "address": 
  {
    "streetAddress": "21 2nd Street",
    "city": "New York",
    "state": "NY",
    "postalCode": 10021
  },
  "phoneNumber": 
  [
    {
      "type": "home",
      "number": "212 555-1239"
    },
    {
      "type": "fax",
      "number": "646 555-4567"
    }
  ]
}'

str(jsonlite::fromJSON(json, simplifyVector = FALSE))

str(list(
  "firstName" = "John",
  "lastName" = "Smith",
  "age" = 25,
  "address" = list(
    "streetAddress" = "21 2nd Street",
    "city" = "New York",
    "state" = "NY",
    "postalCode" = 10021
  ),
  "phoneNumber" = list(
    list(
      "type" = "home",
      "number" = "212 555-1239"
    ),
    list(
      "type" = "fax",
      "number" = "646 555-4567"
    )
  )
))

## Exercise 2

report = function(x) {
  UseMethod("report")
}
report.default = function(x) {
  "This class does not have a method defined."
}
report.integer = function(x) {
  "I'm an integer!"
}
report.double = function(x) {
  "I'm a double!"
}
report.numeric = function(x) {
  "I'm a numeric!"
}

class(1); mode(1); typeof(1)

class(1L); mode(1L); typeof(1L)

## Part 1

report(1)  # => Double
report(1L) # => Integer

## Part 2

rm("report.integer")
report(1)  # => Double
report(1L) # => Numeric (mode since class method doesnt exist)

## Part 3

rm("report.double")
report(1)  # => Numeric
report(1L) # => Numeric






