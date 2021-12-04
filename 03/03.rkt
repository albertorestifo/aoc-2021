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
      (if (>= sum half)
          1
          0))))

;; Flipts the value of a bit
(define (flip bit)
  (if (= bit 1) 0 1))

;; Inverts the sequence
(define (invert sequence)
  (map flip sequence))

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

;; Return true when this bit should be kept according to the flag
(define (should-keep? bit flag flip?)
  (if (eq? bit flag)
      (if flip? false true)
      (if flip? true false)))

;; Filter list matching the flag at the given position
(define (filter-flag-at input flags pos flip?)
  (filter (lambda (values)
            (should-keep? (list-ref values pos) (list-ref flags pos) flip?))
          input))

;; Keep filtering the list, moving the position at each iteration until
;; we're left with only one element in the list
(define (find-match input flags flip? [pos 0])
  (let ([filtered (filter-flag-at input flags pos flip?)])
    (if (equal? 1 (length filtered))
        (flatten filtered)
        (find-match filtered (calc-gamma filtered) flip? (add1 pos)))))

;; Obtain the answer to part 2
(define (part-2 file-path)
  (let* ([input (parse-input file-path)]
         [gamma (calc-gamma input)]
         [oxigen (find-match input gamma false)]
         [co2 (find-match input gamma true)])
    (* (blist->number oxigen) (blist->number co2))))

;; Print the part 2 solutions
(printf "[TEST] Part 2: ~a\n" (part-2 "03/test"))
(printf "[REAL] Part 2: ~a\n" (part-2 "03/input"))
