#lang racket

(provide
    (contract-out
        [set-logger-level! (level? . -> . void?)]
        [create-logger (symbol? . -> . ((symbol? string?) #:rest (listof any/c) . ->* . void?))]))

; check if proper level, used for contract
(define (level? level)
    (member level levels))

; parameter for logger level defaults to fatal
(define active-log-level (make-parameter 'fatal))

; Ordered by lowest to highest priority
(define levels '(debug info warn fatal))

; Checks if the log level is within the current active level, given the ordered priorities above
(define (logging-in-priority? log-level)
  (member log-level (member (active-log-level) levels)))

; set global logger level
(define (set-logger-level! level)
    (active-log-level level))

; log to stderr
(define (log topic level msg . v)
    (if (logging-in-priority? level)
        (apply flogger (append (list (current-error-port) level topic msg) v))
        (void)))

; output logs to output-port
(define (flogger output-port level topic format-string . v)
    (define prefix (string-append
                    (~a
                        (format "~a ~a" (~a (format "[~a] " (string-upcase (symbol->string level))) #:min-width 8)
                            topic) #:min-width 12)
                    ": "))
    (define msg (string-append prefix format-string "~n"))
    (apply fprintf (append (list output-port msg)  v)))

; logger creator for
(define (create-logger topic)
    (curry log topic))