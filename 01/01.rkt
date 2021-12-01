#lang racket

(require racket/file)

;; Read all the depth reading from the input
(define readings (map string->number (file->lines "01/input")))

;; Calculate the amount of times the previous increased
(define (count-increasing data)
  (let-values ([(prev counter)
                (for/fold ([prev #f]
                           [counter 0])
                          ([current data])
                  (if (and prev (> current prev))
                      (values current (add1 counter))
                      (values current counter)))])
    counter))

;; Solution to part one is the count of increasing depth
(printf "Part 1: ~a\n" (count-increasing readings))

;; For the second part, we need to accumulate the readings into a set of size 3
(define (sliding-window data [results empty])
  (with-handlers
      ([exn:fail:contract?
        (lambda (exn) (flatten results))])
    (sliding-window
     (rest data)
     (list results (apply + (take data 3))))))

;; To solve part 2 we simply run the result of the sliding-window to the previous function
(printf "Part 2: ~a\n" (count-increasing (sliding-window readings)))
