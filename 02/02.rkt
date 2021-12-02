#lang racket

(require racket/file)
(require megaparsack megaparsack/text)
(require data/monad)
(require data/applicative)

;; Parse the forward instruction
(define forward/p
  (do (string/p "forward")
    (pure 'forward)))

;; parse the down instruction
(define down/p
  (do (string/p "down")
    (pure 'down)))

;; Parse the up instruction
(define up/p
  (do (string/p "up")
    (pure 'up)))

;; Parser for the instructions
(define instruction/p
  (or/p forward/p
        down/p
        up/p))

;; Parser for the commands, which are defined as "<instruction> <amount>"
(define command/p
  (do [instruction <- instruction/p]
    space/p
    [amount <- integer/p]
    (pure (cons instruction amount))))

;; Parse a command line into a (x y) movement instruction
(define (parse-command line)
  (match (parse-result! (parse-string command/p line))
    [(cons 'up val) (cons (- val) 0)]
    [(cons 'down val) (cons val 0)]
    [(cons 'forward val) (cons 0 val)]))

;; Parse the instructions files and returns a list of movements
(define movements
  (map parse-command (file->lines "02/input")))

;; Calculates the final position by applying the movements to a starting position of (0 0)
(define (calculate-position movements)
  (for/fold ([position (cons 0 0)])
            ([movement movements])
    (cons
     (+ (car movement) (car position))
     (+ (cdr movement) (cdr position)))))

;; Calcualte the position of applying the movements
(define end-location (calculate-position movements))

;; Calculate the solution to part 1
(printf "Part 1: ~a\n" (* (car end-location) (cdr end-location)))
