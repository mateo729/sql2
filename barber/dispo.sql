-- Function
USE `barberia`;
DROP function IF EXISTS `verificar_disponibilidad`;

DELIMITER $$
USE `barberia`$$
CREATE FUNCTION verificar_disponibilidad(empleado_id INT, fecha DATETIME)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
  DECLARE disponibilidad BOOLEAN;
  SET disponibilidad = NOT EXISTS (
    SELECT 1 FROM Citas
    WHERE empleados_id = empleado_id AND Fecha_Hora_Cita = fecha
  );
  RETURN disponibilidad;
END;$$

DELIMITER ;

-- Procedure

USE `barberia`;
DROP procedure IF EXISTS `agendar_cita`;

DELIMITER $$
USE `barberia`$$
CREATE PROCEDURE agendar_cita (
  IN p_cliente_id INT,
  IN p_empleado_id INT,
  IN p_fecha DATETIME,
  IN p_estado VARCHAR(255)
)
BEGIN
  IF verificar_disponibilidad(p_empleado_id, p_fecha) THEN
    INSERT INTO Citas (cliente_id, empleados_id, Fecha_Hora_Cita, estadoCita)
    VALUES (p_cliente_id, p_empleado_id, p_fecha, p_estado);
  ELSE
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'El empleado no está disponible en esa fecha y hora';
  END IF;
END;$$

DELIMITER ;

-- Trigger


DROP TRIGGER IF EXISTS `barberia`.`citas_AFTER_INSERT`;

DELIMITER $$
USE `barberia`$$
CREATE TABLE Log_Citas (
  log_id INT AUTO_INCREMENT PRIMARY KEY,
  cita_id INT,
  mensaje TEXT,
  fecha_log DATETIME DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //
CREATE TRIGGER after_insert_cita
AFTER INSERT ON Citas
FOR EACH ROW
BEGIN
  INSERT INTO Log_Citas (cita_id, mensaje)
  VALUES (NEW.cita_id, CONCAT('Cita agendada para el cliente ', NEW.cliente_id));
END;
//
DELIMITER ;$$
DELIMITER ;}

SELECT verificar_disponibilidad(2, '2024-06-01 12:00:00') AS disponible;
CALL agendar_cita(2, 2, '2024-05-27 11:00:00', 'Agendada');
CALL agendar_cita(1, 2, '2024-06-01 12:00:00', 'Agendada');
SELECT * FROM Citas;
SELECT * FROM Log_Citas;




