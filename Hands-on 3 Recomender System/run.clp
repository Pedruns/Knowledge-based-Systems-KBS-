;; Función para mostrar todos los hechos
(deffunction show-all-facts ()
   (printout t crlf)
   (printout t "==================================================" crlf)
   (printout t "             MOSTRANDO TODOS LOS HECHOS           " crlf)
   (printout t "==================================================" crlf)
   (facts)
   (printout t crlf))

;; Función para ejecutar reglas sobre órdenes no procesadas
(deffunction run-system ()
   (printout t crlf)
   (printout t "==================================================" crlf)
   (printout t "          INICIANDO SISTEMA RECOMENDADOR          " crlf)
   (printout t "==================================================" crlf
             "Ejecutando reglas sobre órdenes..." crlf crlf)
   (run)
   (printout t crlf)
   (printout t "==================================================" crlf)
   (printout t "              EJECUCIÓN COMPLETADA                " crlf)
   (printout t "==================================================" crlf crlf))

;; Función para probar escenarios específicos
(deffunction test-scenarios ()
   (printout t crlf)
   (printout t "==================================================" crlf)
   (printout t "          PROBANDO ESCENARIOS ESPECÍFICOS         " crlf)
   (printout t "==================================================" crlf crlf)
   
   ;; Escenario 1: Cliente nuevo compra un iPhone16
   (printout t "ESCENARIO 1: Cliente nuevo compra iPhone16" crlf)
   (assert (Cliente (id_cliente 4) (nombre "Laura") (apellido "Gómez") 
                    (edad 25) (telefono "3312345678") (correo "laura@mail.com") (ultimoMesCompra 10)
                    (direccion "Calle Nueva 123") (tipoCliente menudista) ))
   (assert (OrdenCompra (numeroOrden 2001) (id_cliente 4) (tipoProducto smartphone)
                        (marca apple) (modelo iPhone16) (metodoPago contado)
                        (cantidad 2) (total 54000) (procesado FALSE)))
   (run)
   (printout t crlf)

   ;; Escenario 2: Compra de MacBook Air + iPhone16 al contado
   (printout t "ESCENARIO 2: Combo MacBook Air + iPhone16 al contado" crlf)
   (assert (OrdenCompra (numeroOrden 2002) (id_cliente 1) (tipoProducto combo)
                        (marca apple) (modelo "macbookair+iphone16") 
                        (metodoPago contado) (cantidad 1) (total 74000) (procesado FALSE)))
   (run)
   (printout t crlf)

   ;; Escenario 3: Cliente mayorista con descuento y vale
   (printout t "ESCENARIO 3: Cliente mayorista con vale" crlf)
   (assert (OrdenCompra (numeroOrden 2003) (id_cliente 3) (tipoProducto computadora)
                        (marca dell) (modelo inspiron14) (metodoPago contado)
                        (cantidad 6) (total 168000) (procesado FALSE)))
   (assert (Vale (id_vale 3) (id_cliente 3) (fecha_vencimiento "31-12-2025") (monto 500)))
   (run)
   (printout t crlf)

   ;; Escenario 4: Stock bajo para smartphone
   (printout t "ESCENARIO 4: Stock bajo de Xiaomi Mi13" crlf)
   (assert (Smartphone (id_producto 3) (marca xiaomi) (modelo mi13) 
                       (color azul) (precio 15000) (num_camaras 3) (stock 3)))
   (run)
   (printout t crlf)

   ;; Escenario 5: Cliente menudista compra más de 3 unidades
   (printout t "ESCENARIO 5: Cliente menudista compra >3 unidades" crlf)
   (assert (OrdenCompra (numeroOrden 2004) (id_cliente 2) (tipoProducto smartphone)
                        (marca samsung) (modelo note21) (metodoPago liverpool-visa)
                        (cantidad 4) (total 88000) (procesado FALSE)))
   (run)
   (printout t crlf)

   ;; Escenario 6: Cumpleaños del cliente
   (printout t "ESCENARIO 6: Cliente cumpleañero" crlf)
   (assert (Cliente (id_cliente 5) (nombre "Jose") (apellido "Alvarez") (edad 22)
                  (telefono "55555555") (correo "pedro@example.com") (direccion "Guadalajara")
                  (tipoCliente menudista) (cumpleMes 11) (ultimoMesCompra 10) (procesado FALSE)))

   (assert (Fecha (dia 3) (mes 11) (anio 2025)))
   (run)
   (printout t crlf)

)

;; Función para ejecutar todo el flujo
(deffunction execute-all ()
   (reset)
   (show-all-facts)
   (run-system)
   (test-scenarios)
)
