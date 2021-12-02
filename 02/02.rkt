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

;; Structure to track the position of the submarine
(struct posn (x y z))

;; Parse a command line into an instruction
(define (parse-command line)
  (parse-result! (parse-string command/p line)))

;; Parse the instructions files and returns a list of movements
(define instructions
  (map parse-command (file->lines "02/input")))

;; Part 1: Calculate position ignoring the z-azis
(define (part-1-calculate-position instructions)
  (for/fold ([position (posn 0 0 0)])
            ([instruction instructions])
    (match instruction
      [(cons 'up val) (struct-copy posn position [x (- (posn-x position) val)])]
      [(cons 'down val) (struct-copy posn position [x (+ (posn-x position) val)])]
      [(cons 'forward val) (struct-copy posn position [y (+ (posn-y position) val)])])))

;; Calcualte the position of applying the movements
(define part-1-end-location (part-1-calculate-position instructions))

;; Calculate the solution to part 1
(printf "Part 1: ~a\n" (* (posn-y part-1-end-location) (posn-x part-1-end-location)))
