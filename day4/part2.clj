;; My approach consumes quite a lot of memory
;; To run it properly, you might have to increase
;; the jvm stack size. I've done it running
;; `clj -J-Xss515m ...`

(ns part2
  (:require [clojure.string :as str])
  (:use clojure.set)
  )

(defn ReadLines []
  (def fileString (slurp "in.txt"))
  (def lines (str/split-lines fileString))
  lines
  )

(defn TransformStringIntoSet [s] 
  (clojure.edn/read-string (str "#{" s "}")))

(defn score [n] (if (= n 0) 0 (bit-shift-left 1 (- n 1))))

(defn value [s]
  (let [[a b] s] 
    (count (clojure.set/intersection a b))
    )
  )

(defn SplitLineIntoSets [s] 
  (map TransformStringIntoSet
       (map str/trim 
            (str/split 
              (get
                (str/split
                  s
                  #":")
                1)
              #"\|")
            )
       )
  )

(def dp 
  (memoize 
    (fn
      ([] [0])
      ([n & xs] (conj (apply dp xs) (+ 1 (reduce + (take-last n (apply dp xs))))))
      )
    )
  )

(def lines (ReadLines))
(def sets (map SplitLineIntoSets lines))
(def values (map value sets))
(reduce + (apply dp values))
