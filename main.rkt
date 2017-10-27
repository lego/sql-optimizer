#lang racket

(require
  "./tokenizer.rkt")
 (require racket/date)


(define my_logger (make-logger 'my-log))

(define logger_thread #f)

(define (log level fmt . content)
  (log-message my_logger level "" (string-append (format-time (now)) " " (apply format (cons fmt content)))))

(define (now)
  (current-date))

(define (format-time the_date)
  (format "~a:~a:~a" 
          (~a (date-hour the_date) #:min-width 2 #:pad-string "0" #:align 'right)
          (~a (date-minute the_date) #:min-width 2 #:pad-string "0" #:align 'right)
          (~a (date-second the_date) #:min-width 2 #:pad-string "0" #:align 'right)))

(define (start-logger level)
  (let ([r (make-log-receiver my_logger level)]
        [time (format-time (now))])
    (set! logger_thread
          (thread
           (lambda ()
              (lambda ()
                (let loop ()
                  (match (sync r)
                    [(vector l m v v1)
                    (printf "~a\n" v)
                    (flush-output)])
                  (loop))))))))

(define (restart-logger level)
  (kill-thread logger_thread)
  (start-logger level))

(define (set-log-level! level)
  (start-logger level))

(module+ main
  (require racket/cmdline)
  (define filename (command-line
    #:program "sql-optimizer"
    #:once-any
    [("-w" "--warnings") "show warning logs" (set-log-level! 'warning)]
    [("-i" "--info") "show info logs" (set-log-level! 'info)]
    [("-v" "--verbose") "show verbose (debug) logs" (set-log-level! 'debug)]
    #:args (filename) ; expect one command-line argument: <filename>
    ; return the argument as a filename to compile
    filename))
  (log 'info "Info")
  (log 'warning "Warning")
  (log 'fatal "fatal")
  (log 'fatal "File to read is ~s" filename))