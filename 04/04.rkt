#lang racket

(require racket/file)
(require math/array)
(require math/matrix)

;; Parse the file, and discard all the empty files
(define (parse-file path)
  (filter non-empty-string? (file->lines path)))

;; Parses the numbers to draw
(define (parse-drawn-numbers line)
  (map
   string->number
   (string-split line ",")))

;; Represents a cell in the Bing board
(struct cell (number drawn?))

;; Parse a single line of the board into cells
(define (parse-board-line line)
  (for/list ([str (map string-trim (string-split line))]
             #:when non-empty-string?)
    (cell (string->number str) false)))

;; Group a list of cells into groups of 25 (each board has 25 numbers)
(define (group-cells cells)
  (if (null? cells)
      '()
      (let ([first-chunk (take cells 25)]
            [others (drop cells 25)])
        (cons first-chunk (group-cells others)))))

;; Parse the lines into 5x5 board matrixes
(define (create-boards lines)
  (map
   (lambda (board-cells)
     (list->matrix 5 5 board-cells))
   (group-cells (flatten (map parse-board-line lines)))))

;; Mark the passed number as drawn in the given board.
(define (mark-in-board board n)
  (matrix-map
   (lambda (c)
     (if (equal? (cell-number c) n)
         (struct-copy cell c [drawn? true])
         c))
   board))

;; Returns true if all the cells in the list are marked as drawn
(define (all-drawn? cells)
  (array-andmap
   (lambda (c) (cell-drawn? c))
   cells))

;; Returns true if the given board has a winnind row or column
(define (won? board)
  (or
   (ormap all-drawn? (matrix-rows board))
   (ormap all-drawn? (matrix-cols board))))

;; Find if any board won
(define (find-winning boards)
  (for/first ([b boards]
              #:when (won? b))
    b))

;; Play the game:  draw a number from the sequence,
;; check if any board won, and return the winning board.
;; Otherwhise recursive call to draw another number.
(define (play-game numbers boards)
  (let* ([n (car numbers)]
         [updated-boards (map
                          (lambda (b) (mark-in-board b n))
                          boards)]
         [winning-board (find-winning updated-boards)])
    (if winning-board
        (values n winning-board)
        (play-game (cdr numbers) updated-boards))))

;; Sums all the unmarked numbers
(define (sum-unmarked board)
  (for/fold ([sum 0])
            ([c (matrix->list board)]
             #:when (not (cell-drawn? c)))
    (+ sum (cell-number c))))

(define (part-1 file-path)
  (let*-values ([(lines) (parse-file file-path)]
                [(drawn-numbers) (parse-drawn-numbers (car lines))]
                [(boards) (create-boards (cdr lines))]
                [(w-number w-board) (play-game drawn-numbers boards)]
                [(u-count) (sum-unmarked w-board)])
    (* u-count w-number)))

;; Print the part 1 solutions
(printf "[TEST] Part 1: ~a\n" (part-1 "04/test"))
(printf "[REAL] Part 1: ~a\n" (part-1 "04/input"))
