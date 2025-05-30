-- FUNCIÓN: CALCULAR DESCUENTO
DELIMITER //
CREATE FUNCTION calcular_descuento(f_ingreso DATE, f_reserva DATE, subtotal DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
  DECLARE dias_anticipacion INT;
  SET dias_anticipacion = DATEDIFF(f_ingreso, f_reserva);

  IF dias_anticipacion >= 15 THEN
    RETURN subtotal * 0.9; -- 10% de descuento
  ELSE
    RETURN subtotal;
  END IF;
END;
//
DELIMITER ;

-- PROCEDIMIENTO: CREAR RESERVA
DELIMITER //
CREATE PROCEDURE crear_reserva (
  IN p_cliente_id INT,
  IN p_habitacion_id INT,
  IN p_fecha_ingreso DATE,
  IN p_fecha_salida DATE,
  IN p_fecha_reserva DATE
)
BEGIN
  DECLARE noches INT;
  DECLARE subtotal DECIMAL(10,2);
  DECLARE precio DECIMAL(10,2);
  DECLARE total_final DECIMAL(10,2);

  SELECT precio_noche INTO precio
  FROM Habitaciones 
  WHERE habitacion_id = p_habitacion_id AND disponible = 'Sí';

  IF precio IS NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Habitación no disponible o inexistente';
  END IF;

  SET noches = DATEDIFF(p_fecha_salida, p_fecha_ingreso);
  SET subtotal = noches * precio;

  SET total_final = calcular_descuento(p_fecha_ingreso, p_fecha_reserva, subtotal);

  INSERT INTO Reservas (cliente_id, habitacion_id, fecha_reserva, fecha_ingreso, fecha_salida, total)
  VALUES (p_cliente_id, p_habitacion_id, p_fecha_reserva, p_fecha_ingreso, p_fecha_salida, total_final);

  UPDATE Habitaciones SET disponible = 'No' WHERE habitacion_id = p_habitacion_id;
END;
//
DELIMITER ;

-- TRIGGER: LIBERAR HABITACIÓN AL CANCELAR RESERVA
DELIMITER //
CREATE TRIGGER liberar_habitacion
AFTER DELETE ON Reservas
FOR EACH ROW
BEGIN
  UPDATE Habitaciones
  SET disponible = 'Sí'
  WHERE habitacion_id = OLD.habitacion_id;
END;
//
DELIMITER ;

CALL crear_reserva(1, 2, '2025-06-02', '2025-06-04', '2025-06-01');  -- Solo 1 día de anticipación
SELECT calcular_descuento('2025-06-20', '2025-05-27', 400000.00);
