#lang racket

; Tokens:
;  - (CREATE_TABLE table columns)
;  - (SELECT projection_list FROM from_cause WHERE where_clause ORDER_BY order_clause GROUP_BY group_clause)
;  - (INSERT_INTO table VALUES values...)
;  - (DELETE_FROM table WHERE where_clause)