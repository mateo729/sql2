-- CLIENTES
INSERT INTO Clientes (nombre, apellido, telefono, correo, fecha_registro) VALUES
('Laura', 'Gómez', '5551234567', 'laura@mail.com', '2025-05-27'),
('Pedro', 'Mora', '5552345678', 'pedro@mail.com', '2025-05-26');

-- HABITACIONES
INSERT INTO Habitaciones (numero, capacidad, precio_noche) VALUES
('101', 1, 80000.00),
('102', 2, 150000.00),
('103', 3, 200000.00),
('104', 4, 250000.00);

-- PRUEBA: CREAR RESERVA CON DESCUENTO (más de 15 días antes)
CALL crear_reserva(1, 1, '2025-06-20', '2025-06-25', '2025-05-27');

-- PRUEBA: VERIFICAR RESERVA
SELECT * FROM Reservas;

-- PRUEBA: CANCELAR Y LIBERAR HABITACIÓN
DELETE FROM Reservas WHERE reserva_id = 2 ;

-- VERIFICAR DISPONIBILIDAD RESTAURADA
SELECT * from habitaciones