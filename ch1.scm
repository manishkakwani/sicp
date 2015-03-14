; 1.1
10
12
8
3
6
;Value: a
;Value: b
19
;Value: #f
4
16
6
16

;1.2
(/ (* 3
      (- 6 2)
      (- 2 7))
   (+ 5
      4
      (- 2
         (- 3
            (+ 6
               (/ 4 5))))))

;1.3
(define (sum_of_squrares_two_larger x y z)
  (if (>= x y)
      (if (>= y z)
          (+ (* x x) (* y y))
          (+ (* x x) (* z z)))
      (if (>= x z)
          (+ (* y y) (* x x))
          (+ (* y y) (* z z)))))

;1.4
Compound expression: expressions representing primitives may be combined with expressions representing a primitve procedure to form compound expresssion that represents the application of the procedure to the primitives.
Replace formal parameters 'a' and 'b' with args 'a' and 'b'. Evaluate if b is greater than 0 and return either the '+' or '-' primitive procedure. Including a space after the closing parens of the if expression ensures the procedure application of - or + as opposed to the positive or negative sign for an integer.

;1.5
(define (p) (p))

(define (test x y)
  (if (= x 0)
      0
      y))

(test 0 (p))

Under applicative-order, it will be an infinite loop because the arguments will be evaluated after replacing the formal parameters, and the procedure application of p will just keep returning the procedure p. Under normal-order, the args will not be evaluated until everything is expanded, and so the predicate will be evaluated first and the function will return 0.

;1.6
;The key issue is applicative order. Under applicative order, for a procedure, the interpreter first evaluates the operator and operands and then applies the resulting procedure to the resulting arguments.  Thus as new-if is defined as a procedure, all of its arguments are evaluated before execution can continue. Since one of the arguments (the else-clause) is actually a recursive call to sqrt-iter, using new-if creates an infinite recursive stack and never returns. The standard if is a special form that evaluates the predicate first and then evaluates either only the consequent or the alternative.

;;;;;;;;;;;;;;;;; using original code
(define (square x) (* x x))

(define (sqrt-iter guess x)
  (if (good-enough? guess x)
       guess
       (sqrt-iter (improve guess x)
                  x)))

(define (improve guess x)
  (average guess (/ x guess)))

(define (average x y)
  (/ (+ x y) 2))

(define (good-enough? guess x)
  (< (abs (- (square guess) x)) 0.001))

(define (sqrt x)
  (sqrt-iter 1.0 x))

;;;;;;;;;;;;;;;;;;;;; using new-if
(define (new-if predicate then-clause else-clause)
  (cond (predicate then-clause)
        (else else-clause)))

(define (sqrt-iter2 guess x)
  (new-if (good-enough? guess x)
          guess
          (sqrt-iter2 (improve guess x)
                      x)))
(define (sqrt2 x)
  (sqrt-iter2 1.0 x))

;;;;;;;;;;;;;;;;;;;;; using standard cond expression instead of if or new-if
(define (sqrt-iter3 guess x)
  (cond ((good-enough? guess x) guess)
        (else (sqrt-iter3 (improve guess x) x))))

(define (sqrt3 x)
  (sqrt-iter3 1.0 x))

;;;;;;;;;;;;;;;;;;;;;; expanding new-if
;Does it not work because the condition is always nested underneath the if clause?
(sqrt2 2)

(sqrt-iter2 1.0 2)

(new-if (good-enough? 1.0 2)
        1.0
        (sqrt-iter2 (improve 1.0 2) 2))

(new-if #f
        1.0
        (sqrt-iter2 1.5 2))

(new-if #f
        1.0
        (new-if (good-enough? 1.5 2)
                1.5
                (sqrt-iter2 (improve 1.5 2) 2))

(new-if #f
        1.0
        (new-if #f
                1.5
                (sqrt-iter2 1.416666 2)))

(new-if #f
        1.0
        (new-if #f
                1.5
                (new-if (good-enough? 1.416666 2)
                        1.416666
                        (sqrt-iter2 (improve 1.416666 2) 2))

(new-if #f
        1.0
        (new-if #f
                1.5
                (new-if #f
                        1.416666
                        (sqrt2 1.4142156851212637 2))))

(new-if #f
        1.0
        (new-if #f
                1.5
                (new-if #f
                        1.416666
                        (new-if (good-enough? 1.4142156851212637 2)
                                1.4142156851212637
                                (sqrt-iter2 (improve 1.4142156851212637 2) 2))

(new-if #f
        1.0
        (new-if #f
                1.5
                (new-if #f
                        1.416666
                        (new-if #t
                                1.4142156851212637))))


;1.7

;1.8

;1.9
(define (+ a b)
    (if (= a 0)
      b
      (inc (+ (dec a) b))))

(define (+ a b)
    (if (= a 0)
      b
      (+ (dec a) (inc b))))

The first one is recursive and the second is iterative. The first is recursive because it builds up a chain of defeerred incrementations. The second is iterative because it can be summarized with the state variables of a and b, and the fixed rule of incrementing and decrementing as the process progresses from state to state.

(+ 4 5)
(inc (+ 3 5))
(inc (inc (+ 2 5)))
(inc (inc (inc (+ 1 5))))
(inc (inc (inc (inc (+ 0 5)))))
(inc (inc (inc (inc 5))))
(inc (inc (inc 6)))
(inc (inc 7))
(inc 8)
9

(+ 4 5)
(+ (dec 4) (inc 5))
(+ 3 6)
(+ (dec 3) (inc 6))
(+ 2 7)
(+ (dec 2) (inc 7))
(+ 1 8)
(+ (dec 1) (inc 8))
(+ 0 9)
9

;1.10
(A 1 10)
(A 0 (A 1 9))
(A 0 (A 0 (A 1 8)))
(A 0 (A 0 (A 0 (A 1 7))))
(A 0 (A 0 (A 0 (A 0 (A 1 6)))))
(A 0 (A 0 (A 0 (A 0 (A 0 (A 1 5))))))
(A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 1 4)))))))
(A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 1 3))))))))
(A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 1 2)))))))))
(A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 1 1))))))))))
(A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 2)))))))))
(A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 4))))))))
(A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 8)))))))
(A 0 (A 0 (A 0 (A 0 (A 0 (A 0 16))))))
(A 0 (A 0 (A 0 (A 0 (A 0 32)))))
(A 0 (A 0 (A 0 (A 0 64))))
(A 0 (A 0 (A 0 128)))
(A 0 (A 0 256))
(A 0 512)
1024 ; 2 ^ 10

(A 2 4)
(A 1 (A 2 3))
(A 1 (A 1 (A 2 2)))
(A 1 (A 1 (A 1 (A 2 1))))
(A 1 (A 1 (A 1 2)))
(A 1 (A 1 (A 0 (A 1 1))))
(A 1 (A 1 (A 0 2)))
(A 1 (A 1 4))
(A 1 (A 0 (A 1 3)))
(A 1 (A 0 (A 0 (A 1 2))))
(A 1 (A 0 (A 0 (A 0 (A 1 1)))))
(A 1 (A 0 (A 0 (A 0 2))))
(A 1 (A 0 (A 0 4)))
(A 1 (A 0 8))
(A 1 16)
(A 0 (A 1 15))
(A 0 (A 0 (A 1 14)))
(A 0 (A 0 (A 0 (A 1 13))))
(A 0 (A 0 (A 0 (A 0 (A 1 12)))))
(A 0 (A 0 (A 0 (A 0 (A 0 (A 1 11))))))
(A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 1 10))))))) ; (A 1 10) already determined above
(A 0 (A 0 (A 0 (A 0 (A 0 (A 0 1024))))))
(A 0 (A 0 (A 0 (A 0 (A 0 2048)))))
(A 0 (A 0 (A 0 (A 0 4096))))
(A 0 (A 0 (A 0 8192)))
(A 0 (A 0 16384))
(A 0 32768)
65536

(A 3 3)
(A 2 (A 3 2))
(A 2 (A 2 (A 3 1)))
(A 2 (A 2 2))
(A 2 (A 1 (A 2 1)))
(A 2 (A 1 2))
(A 2 (A 0 (A 1 1)))
(A 2 (A 0 2))
(A 2 4) ;already determined above
65536


;(f n) => 2n ;determined from the definition
;(g n) => 2 ^ n
(A 1 n)
(A 0 (A 1 (- n 1))) ; x is 0
(* 2 (A 1 (- n 1)))
(* 2 (A 0 (A 1 (- n 2))))
(* 2 (* 2 (A 1 (- n 2)))) ; execute multiplying by 2 n times, from n until n decrements to 1, inclusive.

;(h n) =>
(A 2 n)
(A 1 (A 2 (- n 1)))
(^ 2 (A 2 (- n 1)))
(^ 2 (A 1 (A 2 (- n 2))))
(^ 2 (^ 2 (A 2 (- n 2)))) ; execute taking the power of 2 n times, from n until n decrements to 1, inclusive.


;1.10
; f(n) = n if n < 3 and f(n) = f(n - 1) + 2f(n - 2) + 3f(n - 3) if n >= 3
; f(2) = 2, f(4) = f(3) + 2f(2) + 3f(1) = f(2) + 2f(1) + 3f(0) + 4 + 3 = 2 + 2 + 0 + 7 = 11

;recursive procedure
(define (f n)
  (if (< n 3)
      n
      (+ (f (- n 1))
         (* 2 (f (- n 2)))
         (* 3 (f (- n 3))))))

;iterative procedure
;state can be summarized by a fixed number of state variables, together with a fixed rule that describes how the state variables should be updated as the process moves from state to state and an (optional) end test that specifies conditions under which the process should terminate.
;count up until you reach n?
(define (f2 n)
  ; call other function that needs a counter, a total, and n
  (if (> counter n)
    total
