(deffacts productos
    ;; SMARTPHONES
    (Smartphone (id_producto 1) (marca apple) (modelo iPhone16) (color rojo) (precio 27000) (num_camaras 3) (stock 30))
    (Smartphone (id_producto 2) (marca samsung) (modelo note21) (color negro) (precio 22000) (num_camaras 4) (stock 25))
    (Smartphone (id_producto 3) (marca xiaomi) (modelo mi13) (color azul) (precio 15000) (num_camaras 3) (stock 40))
    (Smartphone (id_producto 4) (marca motorola) (modelo edge40) (color gris) (precio 13000) (num_camaras 2) (stock 35))

    ;; COMPUTADORAS
    (Computadora (id_producto 10) (marca apple) (modelo macbookair) (color gris) (precio 47000) (almacenamiento 512) (stock 15))
    (Computadora (id_producto 11) (marca apple) (modelo macbookpro) (color plata) (precio 58000) (almacenamiento 1000) (stock 10))
    (Computadora (id_producto 12) (marca hp) (modelo pavilion15) (color negro) (precio 25000) (almacenamiento 512) (stock 20))
    (Computadora (id_producto 13) (marca dell) (modelo inspiron14) (color gris) (precio 28000) (almacenamiento 512) (stock 18))

    ;; ACCESORIOS
    (Accesorio (id_producto 20) (marca apple) (nombre funda) (precio 500) (stock 80))
    (Accesorio (id_producto 21) (marca apple) (nombre mica) (precio 200) (stock 100))
    (Accesorio (id_producto 22) (marca samsung) (nombre audifonos) (precio 1500) (stock 50))
    (Accesorio (id_producto 23) (marca generica) (nombre cargador) (precio 300) (stock 120))
    (Accesorio (id_producto 24) (marca logitech) (nombre mouse) (precio 700) (stock 40))
)

(deffacts clientes
    (Cliente (id_cliente 1) (nombre Pedro) (apellido Reyes) (edad 22) (telefono "333-555-7777")
             (correo "pedro@correo.com") (direccion "Guadalajara, Jal.") (tipoCliente mayorista) (ultimoMesCompra 10))
    (Cliente (id_cliente 2) (nombre Ana) (apellido López) (edad 30) (telefono "331-999-8888")
             (correo "ana@correo.com") (direccion "Zapopan, Jal.") (tipoCliente menudista) (ultimoMesCompra 8))
    (Cliente (id_cliente 3) (nombre Luis) (apellido Martínez) (edad 27) (telefono "332-444-1111")
             (correo "luis@correo.com") (direccion "Tlaquepaque, Jal.") (tipoCliente menudista) (ultimoMesCompra 9))
)

;; TARJETAS DE CRÉDITO
(deffacts tarjetas
    (TarjetaCredito (id_metodoPago 1) (id_cliente 1) (titular "Pedro Reyes") (banco banamex) (grupo oro) (expiracion "12-26"))
    (TarjetaCredito (id_metodoPago 2) (id_cliente 2) (titular "Ana López") (banco liverpool) (grupo visa) (expiracion "11-25"))
    (TarjetaCredito (id_metodoPago 3) (id_cliente 3) (titular "Luis Martínez") (banco bbva) (grupo mastercard) (expiracion "08-27"))
)

;; VALES
(deffacts vales
    (Vale (id_vale 1) (id_cliente 1) (fecha_vencimiento "31-12-2025") (monto 0))
    (Vale (id_vale 2) (id_cliente 2) (fecha_vencimiento "31-12-2025") (monto 0))
)

;; ÓRDENES DE COMPRA (EJEMPLOS PARA DISPARAR REGLAS)
(deffacts ordenes
    ;; Ejemplo 1: iPhone16 con tarjeta Banamex (aplica 24 meses sin intereses)
    (OrdenCompra (numeroOrden 1001) (id_cliente 1) (tipoProducto smartphone)
                 (marca apple) (modelo iPhone16) (metodoPago banamex) (cantidad 1)
                 (total 27000) (procesado FALSE))
    ;; Ejemplo 2: Samsung Note 21 con Liverpool VISA (12 meses sin intereses)
    (OrdenCompra (numeroOrden 1002) (id_cliente 2) (tipoProducto smartphone)
                 (marca samsung) (modelo note21) (metodoPago liverpool-visa)
                 (cantidad 1) (total 22000) (procesado FALSE))


    ;; Ejemplo 3: MacBook Air y iPhone16 al contado (vales)
    (OrdenCompra (numeroOrden 1003) (id_cliente 3) (tipoProducto combo)
                 (marca apple) (modelo "macbookair+iphone16") (metodoPago contado)
                 (cantidad 1) (total 74000) (procesado FALSE))

    ;; Ejemplo 4: Smartphone cualquiera (para oferta de accesorios)
    (OrdenCompra (numeroOrden 1004) (id_cliente 2) (tipoProducto smartphone)
                 (marca xiaomi) (modelo mi13) (metodoPago bbva)
                 (cantidad 2) (total 30000) (procesado FALSE))
)
