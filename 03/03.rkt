#lang racket

(require racket/file)

;; Parse sequence of numbers in the line into list of numbers
(define (parse-line line)
  (map string->number (map string (string->list line))))

;; Parse the file as input
(define (parse-input file-path)
  (map parse-line (file->lines file-path)))

;; Sum the columns toghether
(define (sum-cols input)
  (for/fold ([sum (map (lambda (x) 0) (car input))])
            ([sequence input])
    (for/list ([s sum]
               [v sequence])
      (+ s v))))

;; Compute the most common value for each column.
;; If we sum all values and the result is greater
;; than half the length of the array, then the most
;; common value will be a 1. Otherwhise it's a 0.
(define (calc-gamma input)
  (let ([half (/ (length input) 2)])
    (for/list ([sum (sum-cols input)])
      (if (> sum half)
          1
          0))))

;; Inverts the sequence
(define (invert sequence)
  (for/list ([v sequence])
    (if (= v 1)
        0
        1)))

;; Converts a list containing bytes initigers into a number
(define (blist->number blist)
  (string->number (string-join (map number->string blist) "") 2))

(provide
 blist->number)

;; Obtain the answer to part 1
(define (part-1 file-path)
  (let* ([gamma (calc-gamma (parse-input file-path))]
         [epsilon (invert gamma)])
    (* (blist->number gamma) (blist->number epsilon))))

;; Print the part 1 solutions
(printf "[TEST] Part 1: ~a\n" (part-1 "03/test"))
(printf "[REAL] Part 1: ~a\n" (part-1 "03/input"))
