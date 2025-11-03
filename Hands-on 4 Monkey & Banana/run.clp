(printout t "--- Cargando Sistema Mono y Banana (versión en español) ---" crlf)

(clear)

(load "templates.clp")
(printout t "Plantillas cargadas." crlf)

(load "facts.clp")
(printout t "Hechos iniciales cargados." crlf)

(load "rules.clp")
(printout t "Reglas cargadas." crlf)

(printout t crlf "--- Iniciando Simulación ---" crlf)

(watch all)

(reset)

(run)

(printout t "--- Simulación Terminada ---" crlf)