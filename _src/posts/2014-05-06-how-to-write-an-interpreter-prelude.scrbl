#lang scribble/manual

Title: How to write Interpreters: Prelude - Racket and Pattern Matching
Date: 2014-05-06T17:06:04
Tags: interpreters

<!-- more -->

```racket
;; Finds Racket sources in all subdirs
(for ([path (in-directory)])
  (when (regexp-match? #rx"[.]rkt$" path)
    (printf "source file: ~a\n" path)))
(define (foo #:bar bar)
  #t)
```
