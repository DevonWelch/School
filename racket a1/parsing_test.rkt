#| Assignment 1 - Parsing TESTS (due Oct 11, noon) 

***Write the names and CDF accounts for each of your group members below.***
Devon Welch, c1welchd
|#
#lang racket
(require "parsing.rkt")
(require test-engine/racket-tests)


; TODO: WRITE TESTS!!

(check-expect (parse-attr " class=\"hello\" >Hello, world!</body></html> Other") '((("class" "hello")) "Hello, world!</body></html> Other"))

(check-expect (parse-attr " class=\"hello\">Hello, world!</body></html> Other") '((("class" "hello")) "Hello, world!</body></html> Other"))

(check-expect (parse-attr " class=\"hello\" class2=\"hello2\">Hello, world!</body></html> Other") '((("class" "hello") ("class2" "hello2")) "Hello, world!</body></html> Other"))

(check-expect (parse-attr " class=\"hello\" Hello, world!</body></html> Other") (list 'error " class=\"hello\" Hello, world!</body></html> Other"))

(check-expect (parse-attr " class\"hello\" >Hello, world!</body></html> Other") (list 'error " class\"hello\" >Hello, world!</body></html> Other"))

(check-expect (parse-attr " class=hello\" >Hello, world!</body></html> Other") (list 'error " class=hello\" >Hello, world!</body></html> Other"))

(check-expect (parse-attr "  >Hello, world!</body></html> Other") (list 'error "  >Hello, world!</body></html> Other"))

(check-expect (find-one-attr " class=\"hello\" >Hello, world!</body></html> Other") '((("class" "hello")) " >Hello, world!</body></html> Other"))

(check-expect (find-one-attr " class= \"hello\" >Hello, world!</body></html> Other") '((("class" "hello")) " >Hello, world!</body></html> Other"))

(check-expect (find-one-attr " class =\"hello\" >Hello, world!</body></html> Other") '((("class" "hello")) " >Hello, world!</body></html> Other"))

(check-expect (find-one-attr " class=hello\" >Hello, world!</body></html> Other") (list 'error " class=hello\" >Hello, world!</body></html> Other"))

(check-expect (get-to-no-space " hi") "hi")

(check-expect (get-to-no-space "hi") "hi")

(check-expect (get-to-no-space "                hi    ") "hi    ")

(check-expect (get-to-no-space "") "")

(check-expect (get-tag "<body class=\"hello\" >Hello, world!</body></html> Other") '("body" (("class" "hello")) "Hello, world!</body></html> Other"))

(check-expect (get-tag "<body>Hello, world!</body></html> Other") '("body" () "Hello, world!</body></html> Other"))

(check-expect (get-tag "<body >Hello, world!</body></html> Other") (list 'error "<body >Hello, world!</body></html> Other"))

(check-expect (get-inner "<body class=\"hello\" >Hello, world!</body></html> Other") '((("body" (("class" "hello")) "Hello, world!")) "</html> Other"))

(check-expect (get-inner "<body class=\"hello\" ><p>Hello, world!</p><q><r>hi</r><s></s></q></body></html> Other") '((("body" (("class" "hello")) (("p" () "Hello, world!") ("q" () (("r" () "hi") ("s" () "")))))) "</html> Other"))

(check-expect (get-inner "<body class=\"hello\" >Hello, >world!</body></html> Other") (list 'error "<body class=\"hello\" >Hello, >world!</body></html> Other"))

(check-expect (check-close "</body></html>" "body") "</html>")

(check-expect (check-close "</bodynot></html>" "body") (list 'error "</bodynot></html>"))

(check-expect (check-close "</body</html>" "body") (list 'error "</body</html>"))

; tests below this point are for the provided functions; most are 
; the tests provided in the comments 

(check-expect (parse-html-tag "<html></html>") '("<html>" "</html>"))

(check-expect (parse-html-tag "") '(error ""))

(check-expect (parse-html-tag "<hey><html>") '(error "<hey><html>"))

(define parse-hi (make-text-parser "hi"))

(check-expect (parse-hi "hiya!") '("hi" "ya!"))

(check-expect (parse-hi "goodbye hi") '(error "goodbye hi"))

(check-expect (parse-hi "") '(error ""))

(define parse-null (make-text-parser ""))

(check-expect (parse-null "abcdefg") '("" "abcdefg"))

(check-expect (parse-non-special-char "hi") '(#\h "i"))

(check-expect (parse-non-special-char "<html>") '(error "<html>"))

(check-expect (parse-non-special-char "") '(error ""))

(check-expect (parse-plain-char "hi") '(#\h "i"))

(check-expect (parse-plain-char " hello!") '(error " hello!"))

(check-expect (parse-non-special-char "") '(error ""))

(check-expect ((either parse-plain-char parse-html-tag) "hello") '(#\h "ello"))

(check-expect ((either parse-plain-char parse-html-tag) "<html>hello") '("<html>" "hello"))

(check-expect ((either parse-plain-char parse-html-tag) "<xml>hello") '(error "<xml>hello"))

(check-expect ((both parse-html-tag parse-plain-char) "<html>hello") '(("<html>" #\h) "ello"))

(check-expect ((both parse-html-tag parse-plain-char) "<xml>hello") '(error "<xml>hello"))

(check-expect ((both parse-html-tag parse-plain-char) "<html> hello") '(error "<html> hello"))

(check-expect ((star parse-plain-char) "hi") '((#\h #\i) ""))

(check-expect ((star parse-plain-char) "hi there") '((#\h #\i) " there"))

(check-expect ((star parse-plain-char) "<html>hi") '(() "<html>hi"))

(check-expect (parse-html "<html><body class=\"hello\" >Hello, world!</body></html> Other") '(("html" () ("body" (("class" "hello")) "Hello, world!")) " Other"))

(check-expect (parse-html "<blAh></blAh>") '(("blAh" () "") ""))

(check-expect (parse-html "<body><p>Not good</body></p>") '(error "<body><p>Not good</body></p>"))

(check-expect (parse-html "<blAh>   hi   </blAh>") '(("blAh" () "   hi   ") ""))

(check-expect (parse-html "<p class =\"main\" id= \"me \" >Hi</p>") '(("p" (("class" "main") ("id" "me ")) "Hi") ""))

(check-expect (parse-html "<html><body class=\"hello\" >Hello, world!</body></html><moretag></moretag> Other") '(("html" () ("body" (("class" "hello")) "Hello, world!")) "<moretag></moretag> Other"))

(check-expect (parse-html "<html>      <body class=\"hello\" >Hello, world!</body>        </html> Other") '(("html" () ("body" (("class" "hello")) "Hello, world!")) " Other"))

(test)

; things i still need to deal with:
; other bugs/tests