(deftemplate estado
  (slot mono-en (type SYMBOL))     ; Ubicación horizontal del mono (en-puerta, en-ventana, en-centro)
  (slot mono-sobre (type SYMBOL)) ; Ubicación vertical del mono (en-suelo, en-caja)
  (slot caja-en (type SYMBOL))      ; Ubicación de la caja
  (slot mono-tiene (type SYMBOL))  ; Lo que tiene el mono (nada, banana)
)

(deftemplate objetivo
  (slot mono-tiene (type SYMBOL))
)

(deftemplate plan
  (multislot acciones) ; Guardará una lista de strings
)

(deftemplate estado-visitado
  (slot mono-en (type SYMBOL))
  (slot mono-sobre (type SYMBOL))
  (slot caja-en (type SYMBOL))
  (slot mono-tiene (type SYMBOL))
)