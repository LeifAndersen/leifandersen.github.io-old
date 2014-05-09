    Title: How to Write Interpreters: Prelude - Racket and Pattern Matching
    Date: 2014-05-06T17:06:04
    Tags: Interpreters, Racket, Pattern Matching, DRAFT

Many people seem interested in the concept of writing compilers and interpreters. However, few know how to do it. Writing interpreters can be both fun and rewarding. This series of posts will take you through the steps to write interpreters for real world programming languages.

This first post will discusses the tools we will use to build the interpreter. It includes a brief introduction to Racket, followed by a discussion on pattern matching. The contents here are by no means an exhaustive look at Racket, but merely enough to create interpreters and compilers.

Subsequent blog posts will use these tools to make increasingly more powerful interpreters. A future series of posts will take the knowledge from here and use it to create compilers.

<!-- more -->

## Racket

For this tutorial, we will be using [Rakcet][Racket] for it's pattern matching features.

To get started, download Racket from [the Racket webstie][RacketDownload].

The first time you will start up DrRacket, you will see the following window:

![](/img/drracket_fresh.png)

The top text area is the definitions window, where you put your code, and the bottom half is a [REPL][REPL], an interactive prompt where you can experiment with new expressions.

By default, DrRacket needs to be configured to use the Racket language. The easiest way to do this is to type `#lang racket` into the top window and click `Run`.

All Racket files require `#lang` at the top. For now, just use `#lang racket` at the top of each file, as shown below:

![](/img/drracket_empty.png)

Racket is more than just a single programming language. Built into Racket are many languages. Adding `#lang racket` tells Racket to use the racket dialect.

Try adding the following code to the top window and clicking `Run`:

```racket
(+ 3 5)
(* 8 2)
```

DrRacket will print out the results from each of these expressions in the bottom window, shown below:

![](/img/drracket_math.png)

Notice that in Racket, the `+` comes before the numbers we are adding together. This is because Racket uses [Prefix Notation][PrefixNotation]. This means that that the operator comes before the operands.

In order to say `3 + 5`, write `(+ 3 5)`.

Unlike high school algebra where the parentheses are optional, and adding additional parentheses does no harm, the number of parentheses in Racket is significant. For example, `(+ 3 2)` is different from `(+ (3) (2))`.

Once the program has run, you can execute additional expressions. Try executing `(- 9 4)` in the bottom window. The output should look something like this:

![](/img/drracket_repl.png)

You can have expressions as expressions. For example:

```racket
> (+ 3 8 (* 4 2) 9)
28
```

### Define

We can do more than just add mathematical expressions with racket. For example, we can use `define` to define variables.

Try typing this into DrRacket:

```racket
#lang racket

(define x 5)
(define y 7)
(+ 3 (* x y))
```

This code binds the variable `x` to the value of `3`. Then it binds `y` to `7`. Finally, it multiplies `x` and `y`, and adds the result to `3`. The result of running this program is:

```racket
38
```

You can also use `define` to bind functions. Type the following code into DrRacket and click `Run`:

```racket
#lang racket

(define (add2 x)
  (+ x 2))
```

You should not see anything on the bottom half of the window. This is because `define` only creates the function. However, we can still call the function. In the REPL, type:

```racket
> (add2 8)
10
```

The output should look like this:

![](/img/drracket_define.png)

Functions in Racket act the same way as functions in your high school algebra class. The only difference is the left parenthesis is moved to the left of the function.

In other words, `f(x)` would become `(f x)`.

Once defined, you can also use functions in your source code:

```racket
#lang racket

(define (add2 x)
  (+ x 2))

(add2 8)
```

Functions can have multiple expressions, however the result of the last expression will be returned. So for example, type the following in the REPL:

```racket
> (define (f x)
    x
    3) ; Returns the 3

> (f 4)
3
```

You can even define functions in other functions, and return them. Try this code in Racket:

```racket
#lang racket

(define (define-addn n)

  ; Defining an inner function
  (define (addn x)
    (+ n x))

  ; Returning the inner function
  addn)

; add3 becomes a function that adds 3 to a number
(define add3 (define-addn 3))

(add3 5) ; => 8
```

This code can be further simplified using a lambda (λ) function. Lambda is normally used to declare an [anonymous function][AnonymousFunction]. The syntax for a lambda function is:

```racket
(lambda (<variable> ...) <body>)
```

The variable is the list of arguments that the function takes, and the body is what the function does.

You can also replace the literal word `lambda` with just the `λ` character (Use `Ctr` + `\` in DrRacket to get a `λ`).

Rewriting the above code than becomes:

```racket
#lang racket

(define (define-addn n)

  ; Define and return the lambda at the same time
  (λ (addn x)
     (+ n x)))

(define add3 (define-addn 3))

(add3 5) ; => 8
```

### Strings and Symbols

Racket programs can also contain strings. As with many other languages strings are lists of characters, contained in quotes. For example `"This is a string"` is a string.

Strings can be displayed with `display`. Try the following in DrRacket:

```racket
#lang racket

(display "Hello World")
```

Racket also contains the concept of symbols. Symbols are similar to strings, but have a different internal representation. Unlike strings, symbols start with the `'` character, and generally go to the nearest space. The following are all valid symbols:

```racket
'Hello
'hello-world
'+
'λ
```

Strings and symbols are designed to serve different purposes. Many of these differences will become more clear in time. As a general rule of thumb, strings are for interacting with the end user of the program, while symbols are used for data that the end user will not directly see.

### Lists

Racket would not be very useful if it could only handle numbers. One of the basic data structures in Racket is the list. There are [many different ways to make lists][RacketListsς] in Racket. We will only discuss one way here, which is the `quote`, or like symbols, using the character `'`.

Unlike symbols, putting a `'` before an expression changes it from a function call to a literal list. While `(+ 3 2)` evaluates to `5`, the expression `'(+ 3 2)` evaluates to `'(+ 3 2)`. This can be tested in the REPL:

```racket
> (+ 3 2)
5

> '(+ 3 2)
'(+ 3 2)
```

In the above list, `3` and `2` are numbers, and `+` is a symbol. We could get the same result with:

```racket
> (list '+ 3 2)
(+ 3 2)
```

Lists can contain more than just numbers, strings, and symbols, lists can also contain other lists. Some valid lists are:

```racket
'("Hello" "World")
'(1 2 (3 4) 5)
'(2 4 8 + "Hello" blue)
```

Racket Lists are implemented as singly linked lists. And `null`, or `'()` represents the empty list. Traditionally, lists have been manipulated with three functions, `cons`, `car`, `cdr`. However, when building a compiler or interpreter, it is more convenient to use pattern matching to manipulate lists, which will be shown later.

### Quasiquoting

Like quoting, quasingquoting allows us to make quoted lists. Unlike quoting, quasiquoting allows us to put the result of code into the literal string. A quasiquote can be created using the `` ` `` symbol.

By default, everything in the quasiquote will be text, until an expression is preceded with a `,` (called `unquote`) character. When this happens, Racket will evaluate the inner expression and put the result back into the list as a literal.

That was a mouthful, an example will make things more clear. Type the following into the REPL:

```racket
> `(1 + 2 = ,(+ 1 2))
'(1 + 2 = 3)
```

Note that the `1`, `'+`, `2`, and `'=` all remained the same. However, the `,(+ 1 2)` was evaluated to a `3`, and then placed back into the list.

Unquotes in a quasiquote can also evaluate to a quoted list, for example:

```racket
> `(1 2 ,('(3 4 5)) 6)
'(1 2 (3 4 5) 6)
```

Finally, if the unquoted expression evaluates to a list (as it did above), that list can be spliced into the outer list using `,@`, or `unquote-with-splicing`. Modifying the code from above yields:

```racket
> `(1 2 ,@('(3 4 5)) 6)
'(1 2 3 4 5 6)
```

### Booleans and Conditionals

Racket uses `#t` for true and `#f` for false. The `=` function can be used for comparing numbers, and `equal?` can be used for comparing numbers, lists, and other data structures.

Try the following in the REPL:

```racket
> (= 3 4)
#t

> (equal? '(3 8 "blue") '(3 8 blue))
#f

> (equal? '(3 8 blue) '(3 8 blue))
#t
```

The `and` and `or` functions evaluate as regular Boolean algebra. Consider the following functions:

```racket

```

Use `if` to evaluate different expressions based on different conditions.

## Pattern Matching

## Conclusion

That is all. You now know everything you need to write an interpreter using Racket. In the next post we will write a reduction based interpreter.

There still is plenty more to learn about Racket and Pattern Matching, but this is the essence of what you need to begin writing interpreters.

## Resources

A more gentle introduction to racket can be found on [the Racket quick start page][RacketQuickStart].

You can also learn more about programming with a lisp style language by reading [How to Design Programs][HTDP].

The [Racket reference][PatternMatching] contains an exhastive list of the things you can match using pattern matchin.

## Exercises

1. Write a factorial function using Racket. That is, write a function that takes in a number, and returns the factorial of that number.

2. Using the [Racket documentation][RacketLists], figure out how to make the list `'(1 2 (3 4) 5)` using only the `cons` function. Now get the `4` out of the list using only `car` and `cdr`.

3. Again, using the [Racket documentation][RacketLists], figure out why the following is not a valid list `'(1 2 . 3 4)`.

4. What is the difference between the following two pieces of code?

    ``(define (f x) (+ 8 x))``

    ``(define f (λ (x) (+ 8 x)))``

5. Why is the following code invalid?

    `` `(1 2 ,@(+ 3 2) 4)``

6. Foo

[Racket]: http://racket-lang.org
[PrefixNotation]: http://en.wikipedia.org/wiki/Polish_notation
[REPL]: http://en.wikipedia.org/wiki/Read%E2%80%93eval%E2%80%93print_loop
[HTDP]: http://www.ccs.neu.edu/home/matthias/HtDP2e/
[RacketQuickStart]: http://docs.racket-lang.org/quick/
[PatternMatching]: http://docs.racket-lang.org/reference/match.html
[RacketLists]: http://docs.racket-lang.org/reference/pairs.html
[AnonymousFunction]: http://en.wikipedia.org/wiki/Anonymous_function
[RacketDownload]: http://http://racket-lang.org/download/
[BooleanAlgebra]: http://en.wikipedia.org/wiki/Boolean_algebra
