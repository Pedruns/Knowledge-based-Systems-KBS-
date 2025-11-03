(defrule objetivo-alcanzado
  (declare (salience 100))
  ?e <- (estado (mono-tiene banana))
  ?o <- (objetivo (mono-tiene banana))
  ?p <- (plan (acciones $?pasos))
  =>
  (printout t "--- ¡ÉXITO! PLAN ENCONTRADO ---" crlf)
  (foreach ?paso $?pasos
    (printout t "  -> " ?paso crlf))
  (printout t "-------------------------------" crlf)
  (retract ?e ?o ?p)
  (halt)
)

(defrule caminar-hacia-caja
  (declare (salience 10))
  ?e <- (estado (mono-en ?loc) (mono-sobre en-suelo) (caja-en ?caja-loc) (mono-tiene ?mt))
  (test (neq ?loc ?caja-loc)) ; El mono no está ya donde la caja
  ?p <- (plan (acciones $?pasos))
  (not (estado-visitado (mono-en ?caja-loc) (mono-sobre en-suelo) (caja-en ?caja-loc) (mono-tiene ?mt)))
  =>
  (retract ?e ?p)
  (assert (estado (mono-en ?caja-loc) (mono-sobre en-suelo) (caja-en ?caja-loc) (mono-tiene ?mt)))
  (assert (plan (acciones $?pasos (str-cat "Caminar de " ?loc " a " ?caja-loc))))
  (assert (estado-visitado (mono-en ?caja-loc) (mono-sobre en-suelo) (caja-en ?caja-loc) (mono-tiene ?mt)))
)

(defrule empujar-caja-al-centro
  (declare (salience 10))
  ?e <- (estado (mono-en ?loc) (mono-sobre en-suelo) (caja-en ?loc) (mono-tiene ?mt))
  (test (neq ?loc en-centro)) ; La caja (y el mono) no están en el centro
  ?p <- (plan (acciones $?pasos))
  (not (estado-visitado (mono-en en-centro) (mono-sobre en-suelo) (caja-en en-centro) (mono-tiene ?mt)))
  =>
  (retract ?e ?p)
  (assert (estado (mono-en en-centro) (mono-sobre en-suelo) (caja-en en-centro) (mono-tiene ?mt)))
  (assert (plan (acciones $?pasos (str-cat "Empujar caja de " ?loc " a " en-centro))))
  (assert (estado-visitado (mono-en en-centro) (mono-sobre en-suelo) (caja-en en-centro) (mono-tiene ?mt)))
)

(defrule subir-a-caja
  (declare (salience 10))
  ?e <- (estado (mono-en en-centro) (mono-sobre en-suelo) (caja-en en-centro) (mono-tiene ?mt))
  ?p <- (plan (acciones $?pasos))
  (not (estado-visitado (mono-en en-centro) (mono-sobre en-caja) (caja-en en-centro) (mono-tiene ?mt)))
  =>
  (retract ?e ?p)
  (assert (estado (mono-en en-centro) (mono-sobre en-caja) (caja-en en-centro) (mono-tiene ?mt)))
  (assert (plan (acciones $?pasos "Subir a la caja")))
  (assert (estado-visitado (mono-en en-centro) (mono-sobre en-caja) (caja-en en-centro) (mono-tiene ?mt)))
)

(defrule agarrar-banana
  (declare (salience 10))
  ?e <- (estado (mono-en en-centro) (mono-sobre en-caja) (caja-en en-centro) (mono-tiene nada))
  ?p <- (plan (acciones $?pasos))
  (not (estado-visitado (mono-en en-centro) (mono-sobre en-caja) (caja-en en-centro) (mono-tiene banana)))
  =>
  (retract ?e ?p)
  (assert (estado (mono-en en-centro) (mono-sobre en-caja) (caja-en en-centro) (mono-tiene banana)))
  (assert (plan (acciones $?pasos "Agarrar la banana")))
  (assert (estado-visitado (mono-en en-centro) (mono-sobre en-caja) (caja-en en-centro) (mono-tiene banana)))
)

(defrule no-se-encontro-plan
  (declare (salience -100))
  ?e <- (estado (mono-tiene ~banana))
  ?o <- (objetivo)
  ?p <- (plan)
  =>
  (printout t "--- NO SE PUDO ENCONTRAR UN PLAN ---" crlf)
  (retract ?e ?o ?p)
  (halt)
)