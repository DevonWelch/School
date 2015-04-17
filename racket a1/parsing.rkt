#| Assignment 1 - Parsing (due Oct 11, noon)

***Write the names and CDF accounts for each of your group members below.***
Devon Welch, c1welchd
|#
#lang racket
(provide parse-html-tag make-text-parser
         parse-non-special-char parse-plain-char
         either both star
         parse-html
         parse-attr find-one-attr
         get-to-no-space
         get-tag get-inner check-close)

#|
(parse-html-tag str)
  If str starts with "<html>", returns a pair (list "<html>" rest), where
  rest is the part of str after "<html>".
  Otherwise, returns (list 'error "hi"), signifying an error.

> (parse-html-tag "<html></html>")
'("<html>" "</html>")
> (parse-html-tag "<hey><html>")
'(error "<hey><html>")
|#
(define (parse-html-tag str) 
  (if (equal? str "")
      (list 'error str)
      (if (equal? (substring str 0 6) "<html>")
          (list "<html>" (substring str 6))
          (list 'error str))))


#|
(make-text-parser t)
  Return a parser that tries to read *one* occurrence of t at the
  start of its input.

> (define parse-hi (make-text-parser "hi"))
> (parse-hi "hiya!")
'("hi" "ya!")
> (parse-hi "goodbye hi")
'(error "goodbye hi")
|#
(define (make-text-parser t) 
  (lambda (str)
    (if (equal? str "")
        (if (equal? t "")
            (list "" str)
            (list 'error str))
        (if (equal? (substring str 0 (string-length t)) t)
            (list t (substring str (string-length t)))
            (list 'error str)))))


#|
(parse-non-special-char str)
  Try to parse *one* non-special character at the start of str.

> (parse-non-special-char "hi")
'(#\h "i")
> (parse-non-special-char "<html>")
'(error "<html>")
|#
(define (parse-non-special-char str) 
  (if (equal? str "")
      (list 'error str)
      (if (or (equal? (string-ref str 0) #\<) (equal? (string-ref str 0) #\>) (equal? (string-ref str 0) #\=) 
              (equal? (string-ref str 0) #\") (equal? (string-ref str 0) #\/))
          (list 'error str)
          (list (string-ref str 0) (substring str 1)))))


#|
(parse-plain-char str)
  Try to parse *one* non-special, non-white character at the start of str.

> (parse-plain-char "hi")
'(#\h "i")
> (parse-plain-char " hello!")
'(error " hello!")
|#
(define (parse-plain-char str) 
  (if (equal? str "")
      (list 'error str)
      (if (or (equal? (string-ref str 0) #\<) (equal? (string-ref str 0) #\>) (equal? (string-ref str 0) #\=) 
              (equal? (string-ref str 0) #\") (equal? (string-ref str 0) #\/) (equal? (string-ref str 0) #\space))
          (list 'error str)
          (list (string-ref str 0) (substring str 1)))))


#| Parsing Combinators |#

#|
(either parser1 parser2)

  Return a new parser that does the following:
    - Try to apply parser 1; if success, return that result
    - Otherwise, return the result of applying parser 2

> ((either parse-plain-char parse-html-tag) "hello")
'(#\h "ello")
> ((either parse-plain-char parse-html-tag) "<html>hello")
'("<html>" "hello")
> ((either parse-plain-char parse-html-tag) "<xml>hello")
'(error "<xml>hello")
|#
(define (either parser1 parser2) 
  (lambda (str) 
    (if (equal? (parser1 str) (list 'error str))
      (parser2 str)
      (parser1 str))))


#|
(both parser1 parser2)

  Return a new parser that does the following:
    - Apply parser1; if failure, return failure
    - Otherwise, apply parser2 to the rest of the string
      not parsed by parser1
    - If failure, emit failure, together with *original* string
    - If success, return (list data rest), where data is a *LIST*
      containing the data parsed by parser1 and parser2, in that order,
      and rest is the part of the string not parsed by either
      parser1 or parser2.

> ((both parse-html-tag parse-plain-char) "<html>hello")
'(("<html>" #\h) "ello")
> ((both parse-html-tag parse-plain-char) "<xml>hello")
'(error "<xml>hello")
> ((both parse-html-tag parse-plain-char) "<html> hello")
'(error "<html> hello")
|#
(define (both parser1 parser2) 
  (lambda (str) 
    (let ([parsed-rest (second (parser1 str))] [parsed-str (first (parser1 str))])
    (if (or (equal? (parser2 parsed-rest) (list 'error parsed-rest)) (equal? (parser1 str) (list 'error str)))
        (list 'error str)
        (list (list parsed-str (first (parser2 parsed-rest))) (second (parser2 parsed-rest)))))))

#|
(star parser)

  Return a new parser that tries to parse using parser
  0 or more times, returning as its data a list of *all*
  parsed values. This new parser should be *greedy*: it
  always uses the input parser as many times as it can,
  until it reaches the end of the string or gets an error.

  Note that the new parser never returns an error; even if
  the first attempt at parsing fails, the data returned
  is simply '().

> ((star parse-plain-char) "hi")
'((#\h #\i) "")
> ((star parse-plain-char) "hi there")
'((#\h #\i) " there")
> ((star parse-plain-char) "<html>hi")
'(() "<html>hi")
|#
(define (star parser) 
  (lambda (str) (star-helper '() str parser)))
        

(define (star-helper acc str parser)
    (if (or (equal? str "") (equal? (parser str) (list 'error str)))
        (list acc str)
        (star-helper (append acc (list (first (parser str)))) (second (parser str)) parser)))

#| HTML Parsing |#

#|
(parse-html str)

  Parse HTML content at the beginning of str, returning (list data rest),
  where data is the tree representation of the parsed HTML specified in the
  assignment handout, and rest is the rest of str that has not been parsed.

  If the string does not start with a valid html string, return
  (list 'error str) instead.

> (parse-html "<html><body class=\"hello\" >Hello, world!</body></html> Other")
'(("html"
   ()
   ("body"
    (("class" "hello"))
    "Hello, world!"))
  " Other")
> (parse-html "<blAh></blAh>")
'(("blAh"
   ()
   "")
  "")
> (parse-html "<body><p>Not good</body></p>")
'(error "<body><p>Not good</body></p>")
|#
(define (parse-html str)
  (if (equal? (get-tag str) (list 'error str))
      (list 'error str)
      (let ([tag (first(get-tag str))] [attr (second (get-tag str))] [rest-str (third (get-tag str))])
        (if (equal? (get-inner rest-str) (list 'error rest-str))
                    (list 'error str)
                    (let ([inner (first (get-inner rest-str))] [rest-str (second (get-inner rest-str))])
                      (if (equal? (check-close (get-to-no-space rest-str) tag) (list 'error (get-to-no-space rest-str)))
                          (list 'error str)
                          (if (and (list? inner) (equal? (length inner) 1))
                              (list (list tag attr (first inner)) (check-close (get-to-no-space rest-str) tag))
                              (list (list tag attr inner) (check-close (get-to-no-space rest-str) tag)))))))))

#|
(parse-attr str)

  Parses all of the attributes after the initial tag name of an HTML element. 
  Returns (list attributes str) where str is a list of lists, where each sublist
  is the name and value pair of one of the attributes and str is the remainder of the
  string after the tag is closed. If there is an error (one tag is not in proper 
  format, tag is not closed, no tags present) (list 'error str) is returned. 

|#

(define (parse-attr str) 
  (if (equal? (find-one-attr str) (list 'error str))
              (list 'error str)
              (let ([attr (first (find-one-attr str))] [rest-str (second (find-one-attr str))])
                (if (equal? (string-ref (get-to-no-space rest-str) 0) #\>)
                    (list attr (substring (get-to-no-space rest-str) 1))
                    (if (equal? (parse-attr rest-str) (list 'error rest-str))
                        (list 'error str)
                        (list (append attr (first (parse-attr rest-str))) (second (parse-attr rest-str))))))))

#|
(find-one-attr str)

  Parses one attribute from a string. Attribute must be in the form name="value". 
  The name and value are returned as a nested list in the from ((name value)). 
  The remaining string is also returned, making the returned value (((name value)) rest-str).
  If there is an error (no attribute, format error), (list "error "error") is returned. 

|#

(define (find-one-attr str) 
  (let* ([rest-str (get-to-no-space str)] [key (list->string (first ((star parse-plain-char) rest-str)))] [rest-str-2 (second ((star parse-plain-char) rest-str))])
    (if (and (equal? (string-ref (get-to-no-space rest-str-2) 0) #\=) (equal? (string-ref (get-to-no-space (substring (get-to-no-space rest-str-2) 1)) 0) #\"))
        (let* ([rest-str-3 (substring (get-to-no-space (substring (get-to-no-space rest-str-2) 1)) 1)] [val (list->string (first ((star parse-non-special-char) rest-str-3)))] [rest-str-4 (second ((star parse-non-special-char) rest-str-3))])
          (if (equal? (string-ref rest-str-4 0) #\")
              (list (list (list key val)) (substring rest-str-4 1))
              (list 'error str)))
        (list 'error str))))

#|
(get-to-no-space str)

  Removes all leading whitespace from a string, and returns the new string.  
  This could have been implemented using star and anotehr custom parser,
  but I believe that this was slightly less complicated.

|#

(define (get-to-no-space str) 
  (if (equal? str "")
      ""
      (if (equal? (string-ref str 0) #\space)
          (get-to-no-space (substring str 1))
          str)))

#|
(get-tag str)

  Gets the name stored in the tag as well as any attributes, if present. 
  Returns in the form (name (attributes) rest-str), where rest-str is
  the remainder of str after the tag is closed. If there are no attributes,
  (attributes) is an empty list. If there is an error (no tag opening, 
  error parsing attributes [see parse-attr for more information], 
  improper characters in name), (list 'error str) is returneed. 

|#

(define (get-tag str) 
  (if (equal? (string-ref str 0) #\<)
      (if (< (length ((star parse-plain-char) (substring str 1))) 1)
          (list 'error str)
          (let ([rest-str (second ((star parse-plain-char) (substring str 1)))] [tag (first ((star parse-plain-char) (substring str 1)))])
            (if (equal? (string-ref rest-str 0) #\>)
                (list (list->string tag) '() (substring rest-str 1))
                (if (equal? (parse-attr rest-str) (list 'error rest-str))
                    (list 'error str)
                    (list (list->string tag) (first (parse-attr rest-str)) (second (parse-attr rest-str)))))))
      (list 'error str)))

#|
(get-inner str)

  Gets the inner value of the HTML element and returns it. If the element 
  has no children, but there is text, the text is returned as a string; 
  if there is no text, the empty string is returned. If there are children,
  a list of all the children is returned. In addition to the inner value
  being returned, the remainder of the string after the inner is returned 
  (in other words, the first closing tag that is not a closing tag of
  any of the element's children is the first part of the returned string).
  The returned value is in the form (inner rest-str). If there is an error
  getting the children, (list 'error str) is returned. 

|#

(define (get-inner str) 
  (if (equal? (string-ref (get-to-no-space str) 0) #\<)
      (if (equal? (string-ref (get-to-no-space str) 1) #\/)
          (list "" str)
          (if (equal? (length (first ((star parse-html) (get-to-no-space str)))) 0)
              (list 'error str)
              ((star parse-html) (get-to-no-space str))))
      (list (list->string (first ((star parse-non-special-char) str))) (second ((star parse-non-special-char) str)))))

#|
(check-close str tag)

  Checks to make sure that the closing tag at the beginning of the string 
  matches the name passed in by the function. If it matches, the remainder 
  of the string after the end of the close tag is returned. If it does not match 
  or the close tag is malformed, (list 'error str) is returned.

|#

(define (check-close str tag) 
  (if (and (equal? (string-ref str 0) #\<) (equal? (string-ref str 1) #\/))
      (if (equal? ((make-text-parser tag) (substring str 2)) (list 'error str))
          (list 'error str)
          (if (equal? (string-ref (second ((make-text-parser tag) (substring str 2))) 0) #\>)
              (substring (second ((make-text-parser tag) (substring str 2))) 1)
              (list 'error str)))
      (list 'error str)))
