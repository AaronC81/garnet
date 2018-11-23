# Garnet
Garnet is a **stack-based language running on Ruby.** It doesn't introduce
a new set of functions and data types; rather, code is evaluated directly
as a Ruby `Module` using `instance_eval`.

It's still really basic, but could be developed into a useful, minimalistic
alternative to Ruby.

## Basic usage
You push things onto a stack, then call functions to reduce the stack. All
functions will push one return value onto the stack, even if it's `nil`.

Example program:

```
8 2 #+ puts$1 #
```

  - `8 2` - Pushes 8 and then 2 onto the stack.
  - `#+` - Calls the instance method `+` on `2`, with one argument `8`. The argument count can be determined automatically because `+` *always* takes one argument.
  - `puts$1` - Calls `puts`. The argument count must be specified explicitly because `puts` takes `*args`, hence the `$1` for 1 argument.
  - `#` - Discard the top element of the stack, which will be `nil` because `puts` returns `nil`.