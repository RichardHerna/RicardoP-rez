CREATE DATABASE if exists coffeeshops_RicardoP;
 
USE coffeeshops_RicardoPerez;
 
/*Funcion guia 2*/
DELIMITER //
CREATE FUNCTION CalcularTotalPedido(_id_pedido INT) RETURNS DECIMAL(10,2)
BEGIN
    DECLARE total DECIMAL(10,2);
    SELECT SUM(precio_producto * cantidad_producto) INTO total
    FROM detalle_pedido
    WHERE id_pedido = _id_pedido;
    RETURN total;
END; 
DELIMITER //`
 
/*Trigger guia 2*/
DELIMITER //
CREATE TRIGGER activar_cliente_despues_de_primer_pedido
AFTER INSERT ON pedido
FOR EACH ROW
BEGIN
  UPDATE cliente
  SET estado_cliente = 1
  WHERE id_cliente = NEW.id_cliente;
END; //
DELIMITER ;
/*Procedimiento almacenado guia 2*/
DELIMITER //
CREATE PROCEDURE InsertarProducto(
    IN _nombre_producto VARCHAR(50),
    IN _descripcion_producto VARCHAR(250),
    IN _precio_producto DECIMAL(5,2),
    IN _existencias_producto INT,
    IN _imagen_producto VARCHAR(25),
    IN _id_categoria INT,
    IN _estado_producto TINYINT(1),
    IN _id_administrador INT
)
BEGIN
    INSERT INTO producto(nombre_producto, descripcion_producto, precio_producto, existencias_producto, imagen_producto, id_categoria, estado_producto, id_administrador, fecha_registro)
    VALUES (_nombre_producto, _descripcion_producto, _precio_producto, _existencias_producto, _imagen_producto, _id_categoria, _estado_producto, _id_administrador, CURRENT_DATE());
END; //
DELIMITER ;

 
/*Ejercicio 1 guia 2*/
SELECT nombre_cliente, estado_pedido FROM pedido
INNER JOIN cliente ON cliente.id_cliente = pedido.id_cliente;


/*Ejercicio 2 guia 2*/
SELECT * FROM pedido
WHERE fecha_registro BETWEEN '2024-02-01' AND '2024-02-29';
/*Ejercicio 3*/
SELECT * FROM cliente
ORDER BY nacimiento_cliente DESC;

/*Ejercicio 4*/
SELECT dp.id_detalle, dp.id_producto, p.nombre_producto, p.descripcion_producto, dp.cantidad_producto, dp.precio_producto
FROM detalle_pedido dp
INNER JOIN producto p ON dp.id_producto = p.id_producto;

/*Ejercicio 5*/
SELECT * FROM producto
WHERE precio_producto = (SELECT MAX(precio_producto) FROM producto);
/*Ejercicio 6*/
SELECT AVG(precio_producto) AS promedio_precios
FROM producto;
 
/*Ejercicio 7*/
SELECT estado_pedido, COUNT(*) AS 'Total de pedidos'
FROM pedido
GROUP BY estado_pedido;
 
/*ejercicio 8*/
SELECT nombre_cliente FROM cliente
WHERE nombre_cliente LIKE 'D%';
 
 
/*ejercicio 9*/
SELECT pedido.id_pedido, COUNT(pedido.id_cliente) AS 'Cantidad de ordenes', nombre_cliente FROM pedido
INNER JOIN cliente ON cliente.id_cliente = pedido.id_cliente
GROUP BY pedido.id_cliente;
 
 
/*ejercicio 10*/
SELECT  SUM(cantidad_producto) AS 'total vendido', nombre_producto
FROM detalle_pedido
INNER JOIN producto ON producto.id_producto = detalle_pedido.id_producto
GROUP BY detalle_pedido.id_producto
ORDER BY 'total vendido' DESC
LIMIT 3;
 
/*Ejercicio 11*/
SELECT cl.nombre_cliente,COUNT(p.id_cliente), p.id_pedido FROM cliente cl
INNER JOIN pedido p ON cl.id_cliente = p.id_cliente
GROUP BY p.id_cliente
ORDER BY p.id_cliente asc
LIMIT 1;
 
/*ejercicio 12*/
 
SELECT p.id_pedido, c.id_cliente, c.nombre_cliente, p.direccion_pedido, p.estado_pedido, p.fecha_registro, dp.id_detalle, pr.nombre_producto, dp.cantidad_producto, dp.precio_producto 
FROM cliente c
INNER JOIN pedido p ON c.id_cliente = p.id_cliente
INNER JOIN detalle_pedido dp ON p.id_pedido = dp.id_pedido
INNER JOIN producto pr ON dp.id_producto = pr.id_producto;