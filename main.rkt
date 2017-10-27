#lang racket

(require
  "./tokenizer.rkt"
  "./logger.rkt")

(require racket/date)

(define log (create-logger 'main))

(module+ main
  (require racket/cmdline)
  (define filename (command-line
    #:program "sql-optimizer"
    #:once-any
    [("-w" "--warnings") "show warning logs" (set-logger-level! 'warn)]
    [("-i" "--info") "show info logs" (set-logger-level! 'info)]
    [("-v" "--verbose") "show verbose (debug) logs" (set-logger-level! 'debug)]
    #:args (filename) ; expect one command-line argument: <filename>
    ; return the argument as a filename to compile
    (run-tokenizer))))