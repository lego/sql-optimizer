; Generates a predicate to check a character
; ... probably easier to use curry
(define (chartest ch)
  (curry char=? ch))
