; Vlad Khitev 26.04.2017

(setf adjacency-list '(
    (0 (1))
    (1 (0 2))
    (2 (1 3))
    (3 (2 4))
    (4 (3 5))
    (5 (4 6 19))
    (6 (5 7))
    (7 (6 8))
    (8 (7 9))
    (9 (8 10))
    (10 (9 11))
    (11 (10 12 27 28))
    (12 (11 13))
    (13 (12 14))
    (14 (13 15))
    (15 (14 16))
    (16 (15 17))
    (17 (16 18))
    (18 (17))
    (19 (5 20))
    (20 (19 21))
    (21 (20 22))
    (22 (21))
    (23 (24))
    (24 (23 25))
    (25 (24 26 37))
    (26 (25 27))
    (27 (26 11))
    (28 (11 29))
    (29 (28 30))
    (30 (29 31))
    (31 (30 32))
    (32 (31 33))
    (33 (32 34))
    (34 (33 35))
    (35 (34 36))
    (36 (35))
    (37 (25))             
))

; Creates hashtable from adjacency list
(defun create-graph (adjacency-list)
    (defun init-node (hash-table list-value)
        (setf (gethash (car list-value) hash-table) (cadr list-value))
        hash-table)
    (reduce #'init-node adjacency-list
            :initial-value (make-hash-table)))

; Creates closure that expandes node of graph
(defun create-expander (graph)
    (lambda (node)
        (gethash node graph)))

; Recursive version of BFS to build a search-tree
; MUTATES GRAPH (?!?!)
; bfs-tree :: a → (a → Set a) → [a]
(defun bfs-tree (initial expand)
    (defun bfsi (pending tree)       
        (if (null pending)
            tree                                       ; Return tree when traverse is done
            (progn
                (setf new-pending                      ; Expand all pending nodes and subtract visited
                      (remove-duplicates
                          (set-difference
                               (mapcan expand pending) ; Why the fuck does it mutate graph?
                               tree)))
                (setf new-tree                         ; Add new nodes to current tree
                      (remove-duplicates
                          (union tree new-pending)))
                (bfsi new-pending new-tree))))         ; Call bfsi with new values
    (bfsi (list initial) (list initial)))

(defun qpush (value queue)
    (nconc queue (list value)))

(defun qpop (queue)
    (cdr queue))

(defun backtrace (back-path goal)
    (setf path (list goal))
    (loop while (not (null (gethash goal back-path))) do
          (setf goal (gethash goal back-path))
          (setf path (qpush goal path)))
    (reverse path))

; Non-recursive version of BFS to find a path between two nodes
; bfs-path :: a → a → (a → Set a) → [a]
(defun bfs-path (initial goal expand)
    (setf queue (list initial))
    (setf visited (list initial))
    (setf path (make-hash-table))
    (loop while (not (null queue)) do
          (setf current (car queue))                      ; Get top element
          (setf queue (qpop queue))                       ; Pop top element
          (when (= current goal)
              (return-from bfs-path
                           (backtrace path
                                      goal)))             ; Return tree if path is found
          
          (setf expanded (funcall expand current))        ; Get adjacent nodes
          (loop for node in expanded do                   ; Iterate through siblings
              (when (not (find node visited))             ; If node not visited
                  (setf (gethash node path) current)      ; Add it to path
                  (setf queue (qpush node queue))         ; Add it to queue
                  (setf visited (qpush node visited)))))  ; Add it to visited
    nil)

(defun spush (value stack)
    (nconc stack (list value)))

(defun spop (stack)
    (reverse (cdr (reverse stack))))

; Non-recursive version of DFS to build a search-tree
; dfs-tree :: a → a → (a → Set a) → [a]
(defun dfs-tree (initial expand)
    (setf stack (list initial))
    (setf visited (list initial))
    (setf path (make-hash-table))
    (setf tree (list initial))
    (loop while (not (null stack)) do
          (setf current (car (last stack)))                ; Get top element
          (setf stack (spop stack))                        ; Pop top element
          (setf last-added current)
          
          (setf expanded (funcall expand current))        ; Get adjacent nodes
          (loop for node in expanded do                   ; Iterate through siblings
              (when (not (find node visited))             ; If node not visited
                  (setf (gethash node path) current)      ; Add it to path
                  (setf stack (spush node stack))         ; Add it to stack
                  (setf tree (spush node tree))
                  (setf visited (spush node visited)))))  ; Add it to visited
    tree)

; Non-recursive version of DFS to find a path between two nodes
; dfs-path :: a → a → (a → Set a) → [a]
(defun dfs-path (initial goal expand)
    (setf stack (list initial))
    (setf visited (list initial))
    (setf path (make-hash-table))
    (setf last-added initial)
    (loop while (not (null stack)) do
          (setf current (car (last stack)))                ; Get top element
          (setf stack (spop stack))                        ; Pop top element
          (setf last-added current)
          
          (when (= current goal)
              (return-from dfs-path
                           (backtrace path
                                      goal)))             ; Return tree if path is found
          
          (setf expanded (funcall expand current))        ; Get adjacent nodes
          (loop for node in expanded do                   ; Iterate through siblings
              (when (not (find node visited))             ; If node not visited
                  (setf (gethash node path) current)      ; Add it to path
                  (setf stack (spush node stack))         ; Add it to stack
                  (setf visited (spush node visited)))))  ; Add it to visited
    nil)

(setf graph (create-graph adjacency-list))
(setf expand (create-expander graph))

(print (dfs-path 0 22 expand))
(print (dfs-tree 0 expand))

(print (bfs-path 0 22 expand))
(print (bfs-tree 0 expand))




    
    

