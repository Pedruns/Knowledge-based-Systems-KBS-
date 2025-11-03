;; kb-main.clp - Archivo principal para cargar y ejecutar el sistema

;; Cargar archivos del sistema
(clear)
(load "templates.clp")
(load "facts.clp")
(load "rules.clp")
(load "run.clp")
(reset)
(execute-all)