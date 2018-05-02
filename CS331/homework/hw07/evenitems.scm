#lang scheme
;Thatcher Lane
;CS 331
;Assignment 7

; evenitems
(define (evenitems a)
  (if (null? a)
    '()
    (if (= (length a) 1)
      (list(car a))
      (cons (car a) (evenitems (cdr(cdr  a)))))))
