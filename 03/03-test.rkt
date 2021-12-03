#lang racket/base

(require rackunit
         "03.rkt")

(check-equal? (blist->number '(1 0 1 1 0)) 22 "Conver byte list to number")
