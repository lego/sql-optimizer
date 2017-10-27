#lang racket

(provide
    run-tokenizer)

(struct token (kind))

; Select
; projection: (ListOf expr-token)
; from: (OneOf Relation)
; Where: (ListOf expr-token)
; Order: ...
; Group: ...
(struct select-token (projection from where order group)
    #:super struct:token
    #:guard (λ (kind projection from where order group type-name)
                (unless (symbol=? kind 'select)
                    (error "select: expected kind='select"))
                (unless (and (list? projection) (andmap expr-token? projection))
                    (error "select: projection was not a (ListOf expr-token"))
                (values kind projection from where order group)))
(define (select-token-ctor . v)
    (apply select-token (cons 'select v)))

(struct create-table-token (table columns)
    #:super struct:token)
(struct insert-into-token (table values)
    #:super struct:token)
(struct delete-from-token (table where)
    #:super struct:token)

(struct table-token (database table)
    #:super struct:token)
(define (table-token-ctor . v)
    (apply table-token (cons 'table v)))


(struct expr-token (op operands)
    #:super struct:token
    #:guard (λ (kind op operands type-name)
                (unless (member op operands)
                    (error (format "expr: ~a is not a valid operand" op)))
                (unless (list? operands)
                    (error "expr: expected operands to be a List"))
                (values kind op operands)))
(define (expr-token-ctor . v)
    (apply expr-token (cons 'expr v)))


(struct node (kind props data))

(struct scan-node ()
    #:super struct:node)

; Node struct
; (kind props data)
;
; Props
; Carry properties about the node. For example, column dependancies
;
; Node kinds
; == Relational operators:
; - scanOp
; - renameOp
;
; - unionOp
; - intersectOp
; - exceptOp
;
; - innerJoinOp
; - leftJoinOp
; - rightJoinOp
; - fullJoinOp
; - semiJoinOp
; - antiJoinOp
;
; - projectOp
;
; - groupByOp
; - orderByOp
; == Scalar operators:
; - variableOp
; - constOp
;
; - existsOp
;
; - andOp
; - orOp
; - notOp
;
; - eqOp
; - ltOp
; - gtOp
; - leOp
; - geOp
; - neOp
; - inOp
; - notInOp
; - likeOp
; - notLikeOp
; - iLikeOp
; - notILikeOp
; - similarToOp
; - notSimilarToOp
; - regMatchOp
; - notRegMatchOp
; - regIMatchOp
; - notRegIMatchOp
; - isDistinctFromOp
; - isNotDistinctFromOp
; - isOp
; - isNotOp
; - anyOp
; - someOp
; - allOp
;
; - bitandOp
; - bitorOp
; - bitxorOp
; - plusOp
; - minusOp
; - multOp
; - divOp
; - floorDivOp
; - modOp
; - powOp
; - concatOp
; - lShiftOp
; - rShiftOp
;
; - unaryPlusOp
; - unaryMinusOp
; - unaryComplementOp
;
; - functionOp

;;; (define test-select
;;;     (select-token ))

(define (run-tokenizer)
    (void))