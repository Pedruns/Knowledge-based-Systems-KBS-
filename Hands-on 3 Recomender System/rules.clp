;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; REGLAS DE NEGOCIO - SISTEMA RECOMENDADOR DE CONSUMO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; 1. PROMOCIONES BANCARIAS
(defrule promo-iphone16-banamex
    ?o <- (OrdenCompra (marca apple) (modelo iPhone16) (metodoPago banamex) (procesado FALSE))
=>
    (printout t "PROMOCIÓN: iPhone 16 con tarjeta Banamex - 24 meses sin intereses." crlf)
    (modify ?o (procesado TRUE)))

(defrule promo-note21-liverpool
    ?o <- (OrdenCompra (marca samsung) (modelo note21) (metodoPago liverpool-visa) (procesado FALSE))
=>
    (printout t "PROMOCIÓN: Samsung Note 21 con tarjeta Liverpool VISA - 12 meses sin intereses." crlf)
    (modify ?o (procesado TRUE)))


;; 2. COMPRAS AL CONTADO
(defrule combo-macbookair-iphone16
    ?o <- (OrdenCompra (modelo "macbookair+iphone16") (metodoPago contado) (total ?total) (procesado FALSE))
    (test (>= ?total 1000))
=>
    (bind ?vales (* (div ?total 1000) 100))
    (printout t "PROMOCIÓN: Compra al contado MacBook Air + iPhone16. Vale por $" ?vales crlf)
    (modify ?o (procesado TRUE)))


;; 3. DESCUENTOS POR CANTIDAD SEGÚN CLIENTE
(defrule descuento-mayorista
    ?o <- (OrdenCompra (id_cliente ?id) (cantidad ?c) (total ?t) (procesado FALSE))
    (Cliente (id_cliente ?id) (tipoCliente mayorista))
    (test (> ?c 5))
=>
    (bind ?desc (* ?t 0.15))
    (printout t "DESCUENTO MAYORISTA: Cliente #" ?id " obtiene 15% de descuento. Ahorra $" ?desc crlf)
    (modify ?o (descuentoAplicado ?desc) (procesado TRUE)))

(defrule descuento-menudista
    ?o <- (OrdenCompra (id_cliente ?id) (cantidad ?c) (total ?t) (procesado FALSE))
    (Cliente (id_cliente ?id) (tipoCliente menudista))
    (test (> ?c 3))
=>
    (bind ?desc (* ?t 0.05))
    (printout t "DESCUENTO MENUDISTA: Cliente #" ?id " obtiene 5% de descuento. Ahorra $" ?desc crlf)
    (modify ?o (descuentoAplicado ?desc) (procesado TRUE)))


;; 4. DESCUENTOS POR BANCO Y TARJETA
(defrule descuento-bbva
    ?o <- (OrdenCompra (id_cliente ?id) (metodoPago bbva) (total ?t) (procesado FALSE))
=>
    (bind ?desc (* ?t 0.10))
    (printout t "DESCUENTO BANCARIO: Cliente #" ?id " paga con BBVA. 10% de descuento ($" ?desc ")." crlf)
    (modify ?o (descuentoAplicado ?desc) (procesado TRUE)))

(defrule descuento-liverpool
    ?o <- (OrdenCompra (metodoPago liverpool-visa) (total ?t) (procesado FALSE))
=>
    (bind ?desc (* ?t 0.07))
    (printout t "BONO LIVERPOOL: Descuento del 7% adicional ($" ?desc ")." crlf)
    (modify ?o (descuentoAplicado ?desc) (procesado TRUE)))


;; 5. OFERTAS EN ACCESORIOS
(defrule accesorio-descuento-smartphone
    ?o <- (OrdenCompra (tipoProducto smartphone) (procesado FALSE))
=>
    (printout t "OFERTA: 15% de descuento en funda y mica por comprar un smartphone." crlf)
    (modify ?o (procesado TRUE)))

(defrule accesorio-descuento-mayorista
    ?o <- (OrdenCompra (id_cliente ?id) (procesado FALSE))
    (Cliente (id_cliente ?id) (tipoCliente mayorista))
=>
    (printout t "BONO: Cliente mayorista recibe envío gratuito y 10% extra en accesorios." crlf)
    (modify ?o (procesado TRUE)))


;; 6. ALERTAS DE STOCK
(defrule alerta-stock-bajo
    (Smartphone (marca ?m) (modelo ?mod) (stock ?s))
    (test (< ?s 5))
=>
    (printout t "ALERTA: Stock bajo de " ?m " " ?mod " (" ?s " unidades restantes)." crlf))

(defrule reabastecer-computadora
    (Computadora (marca ?m) (modelo ?mod) (stock ?s))
    (test (< ?s 5))
=>
    (printout t "REABASTECER: Computadora " ?m " " ?mod " tiene menos de 5 en inventario." crlf))


;; 7. ACTUALIZAR STOCK TRAS COMPRA
(defrule actualizar-stock-smartphone
    ?o <- (OrdenCompra (marca ?m) (modelo ?mod) (tipoProducto smartphone) (cantidad ?c) (procesado FALSE))
    ?p <- (Smartphone (marca ?m) (modelo ?mod) (stock ?s))
=>
    (bind ?nuevoStock (- ?s ?c))
    (modify ?p (stock ?nuevoStock))
    (printout t "STOCK ACTUALIZADO: " ?m " " ?mod " ahora con " ?nuevoStock " unidades." crlf)
    (modify ?o (procesado TRUE)))

(defrule actualizar-stock-computadora
    ?o <- (OrdenCompra (marca ?m) (modelo ?mod) (tipoProducto computadora) (cantidad ?c) (procesado FALSE))
    ?p <- (Computadora (marca ?m) (modelo ?mod) (stock ?s))
=>
    (bind ?nuevoStock (- ?s ?c))
    (modify ?p (stock ?nuevoStock))
    (printout t "STOCK ACTUALIZADO: " ?m " " ?mod " ahora con " ?nuevoStock " unidades." crlf)
    (modify ?o (procesado TRUE)))


;; 8. RECOMPENSAS Y LEALTAD
(defrule cliente-premium
    ?o <- (OrdenCompra (id_cliente ?id) (total ?t) (procesado FALSE))
    (test (> ?t 50000))
=>
    (printout t "CLIENTE PREMIUM: Cliente #" ?id " obtiene envío gratis y acceso a preventas exclusivas." crlf)
    (modify ?o (procesado TRUE)))

(defrule puntos-fidelidad
    ?o <- (OrdenCompra (id_cliente ?id) (total ?t) (procesado FALSE))
=>
    (bind ?puntos (div ?t 100))
    (printout t "FIDELIDAD: Cliente #" ?id " acumula " ?puntos " puntos de recompensa." crlf)
    (modify ?o (procesado TRUE)))


;; 9. RECOMENDACIONES
(defrule recomendacion-apple
    ?o <- (OrdenCompra (marca apple) (procesado FALSE))
=>
    (printout t "RECOMENDACIÓN: Cliente fanboy de Apple - se sugiere comprar Apple Watch o AirPods." crlf)
    (modify ?o (procesado TRUE)))

(defrule recomendacion-samsung
    ?o <- (OrdenCompra (marca samsung) (procesado FALSE))
=>
    (printout t "RECOMENDACIÓN: Cliente Samsung - se sugiere Galaxy Buds y protector de pantalla." crlf)
    (modify ?o (procesado TRUE)))

(defrule recomendacion-xiaomi
    ?o <- (OrdenCompra (marca xiaomi) (procesado FALSE))
=>
    (printout t "RECOMENDACIÓN: Cliente Xiaomi - pruebe MiBand 8 y audífonos inalámbricos Xiaomi." crlf)
    (modify ?o (procesado TRUE)))


;; 10. ALERTA CLIENTE SIN COMPRAS
(defrule alerta-sin-compra
    (Cliente (id_cliente ?id) (nombre ?n))
    (not (OrdenCompra (id_cliente ?id)))
=>
    (printout t "ALERTA: Cliente " ?n " aún no ha realizado compras. Enviar cupón de bienvenida." crlf))

;; 11. PROMOCIÓN POR PRIMERA COMPRA
;; 11. PROMOCIÓN POR PRIMERA COMPRA (sin crear nuevo template)
(defrule primera-compra
    (Cliente (id_cliente ?id) (nombre ?n))
    (not (OrdenCompra (id_cliente ?id)))
=>
    (printout t "PROMOCIÓN: " ?n " obtiene 10% de descuento en su primera compra." crlf))

;; 12. ALERTA DE COMPRA GRANDE
(defrule compra-grande
    (OrdenCompra (id_cliente ?id) (total ?t))
    (test (> ?t 100000))
=>
    (printout t "ALERTA: Cliente #" ?id " realizó una compra superior a $100,000. Verificar stock y pago." crlf))

;; 13. DESCUENTO POR REFERENCIA
(defrule descuento-referencia
    (Cliente (id_cliente ?id) (referidoPor ?r))
=>
    (printout t "BONO DE REFERENCIA: Cliente #" ?id " recibe 5% de descuento por ser referido por #" ?r "." crlf))

;; 14. RECOMENDACIÓN SEGÚN CANTIDAD COMPRADA
(defrule recomendacion-gran-cantidad
    (OrdenCompra (cantidad ?c))
    (test (> ?c 10))
=>
    (printout t "RECOMENDACIÓN: Por compras grandes, considere adquirir un seguro extendido o garantía premium." crlf))

;; 15. ALERTA DE PRODUCTO POPULAR
(defrule producto-popular
    (Smartphone (marca ?m) (modelo ?mod) (stock ?s))
    (test (< ?s 10))
=>
    (printout t "AVISO: " ?m " " ?mod " está entre los más vendidos, stock bajo (" ?s " unidades restantes)." crlf))

;; 16. PROMOCIÓN ESTACIONAL
(defrule promocion-navidad
    (Fecha (mes diciembre))
=>
    (printout t "PROMOCIÓN NAVIDEÑA: Todos los productos Apple tienen 10% de descuento adicional." crlf))

;; 17. ALERTA DE STOCK SOBRANTE
(defrule stock-sobrante
    (Computadora (marca ?m) (modelo ?mod) (stock ?s))
    (test (> ?s 100))
=>
    (printout t "ALERTA: Exceso de inventario en " ?m " " ?mod ". Considerar liquidación o promoción especial." crlf))

;; 18. DESCUENTO POR COMPRA ONLINE
(defrule compra-online
    (OrdenCompra (id_cliente ?id) (canal online))
=>
    (printout t "DESCUENTO DIGITAL: Cliente #" ?id " obtiene 5% por comprar en línea." crlf))

;; 19. RECOMPENSA POR FECHA ESPECIAL
(defrule cumpleanios-cliente
    (Cliente (id_cliente ?id) (nombre ?n) (cumpleMes ?mes))
    (Fecha (mes ?mes))
=>
    (printout t "¡FELIZ CUMPLEAÑOS, " ?n "! Recibe cupón de $500 en tu próxima compra." crlf))

;; 20. ALERTA DE BAJA ACTIVIDAD
(defrule cliente-inactivo
    (Cliente (id_cliente ?id) (nombre ?n) (ultimoMesCompra ?m))
    (Fecha (mes ?mesActual))
    (test (> (- ?mesActual ?m) 3))
=>
    (printout t "ALERTA: Cliente " ?n " lleva más de 3 meses sin comprar. Enviar correo de reactivación." crlf))
