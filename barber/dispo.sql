-- Function
USE `barberia`;
DROP function IF EXISTS `calcular_hora_fin`;

DELIMITER $$
USE `barberia`$$
CREATE FUNCTION calcular_hora_fin(p_cita_id INT)
RETURNS TIME
DETERMINISTIC
BEGIN
  DECLARE hora_inicio TIME;
  DECLARE total_duracion INT; -- en segundos

  -- Obtener la hora de inicio de la cita
  SELECT TIME(Fecha_Hora_Cita) INTO hora_inicio
  FROM Citas WHERE cita_id = p_cita_id;

  -- Calcular la duración total de todos los servicios asociados a la cita
  SELECT SUM(TIME_TO_SEC(DuracionEstimada)) INTO total_duracion
  FROM Servicios
  WHERE servicios_id IN (
    SELECT servicio_id FROM Servicios_Citas WHERE cita_id = p_cita_id
  );

  -- Retornar hora final sumando duración
  RETURN ADDTIME(hora_inicio, SEC_TO_TIME(total_duracion));
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

DROP TRIGGER IF EXISTS `barberia`.`verificar_disponibilidad`;

DELIMITER $$
USE `barberia`$$
CREATE TRIGGER verificar_disponibilidad
BEFORE INSERT ON Citas
FOR EACH ROW
BEGIN
  DECLARE conteo INT;

  SELECT COUNT(*) INTO conteo
  FROM Citas
  WHERE empleados_id = NEW.empleados_id
    AND DATE(Fecha_Hora_Cita) = DATE(NEW.Fecha_Hora_Cita)
    AND TIME(Fecha_Hora_Cita) = TIME(NEW.Fecha_Hora_Cita);

  IF conteo > 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'El barbero ya tiene una cita en ese horario.';
  END IF;
END;$$
DELIMITER ;

SELECT calcular_hora_fin(3) AS hora_fin;





