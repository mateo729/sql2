-- Function

USE `barberia`;
DROP function IF EXISTS `total_servicios_cita`;

DELIMITER $$
USE `barberia`$$
CREATE FUNCTION total_servicios_cita(cita INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
  DECLARE total DECIMAL(10,2);
  SELECT SUM(s.Precio)
  INTO total
  FROM Servicios_Citas sc
  JOIN Servicios s ON sc.servicio_id = s.servicios_id
  WHERE sc.cita_id = cita;
  RETURN IFNULL(total, 0);
END;$$

DELIMITER ;

-- Procedure

USE `barberia`;
DROP procedure IF EXISTS `registrar_pago`;

DELIMITER $$
USE `barberia`$$
CREATE PROCEDURE registrar_pago (
  IN p_cita_id INT,
  IN p_fecha DATETIME,
  IN p_monto DECIMAL(10,2)
)
BEGIN
  DECLARE monto_esperado DECIMAL(10,2);
  SET monto_esperado = total_servicios_cita(p_cita_id);

  IF p_monto >= monto_esperado THEN
    INSERT INTO Pagos (id_cita, Fecha_Hora_Pago, monto)
    VALUES (p_cita_id, p_fecha, p_monto);
  ELSE
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'El monto ingresado es menor al valor total de los servicios';
  END IF;
END;$$

DELIMITER ;

-- trigger

DROP TRIGGER IF EXISTS `barberia`.`after_pago_insert`;

DELIMITER $$
USE `barberia`$$
CREATE TRIGGER after_pago_insert
AFTER INSERT ON Pagos
FOR EACH ROW
BEGIN
  UPDATE Citas
  SET estadoCita = 'Pagada'
  WHERE cita_id = NEW.id_cita;
END;$$
DELIMITER ;

call registrar_pago(2,40000.00);
