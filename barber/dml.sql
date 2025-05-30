INSERT INTO Clientes (nombre, apellido, telefono, correo, fecha_registro) VALUES
('Juan', 'Pérez', '5551234567', 'juan.perez@mail.com', '2024-05-01'),
('Ana', 'García', '5559876543', 'ana.garcia@mail.com', '2024-05-02'),
('Carlos', 'López', '5557654321', 'carlos.lopez@mail.com', '2024-05-03');

INSERT INTO Empleados (empleado_id, nombre, apellido, especialidad, telefono, correo, fecha_contratacion) VALUES
(1, 'María', 'Torres', 'Corte de cabello', '5550001111', 'maria.torres@mail.com', '2023-01-15'),
(2, 'José', 'Martínez', 'Barba', '5550002222', 'jose.martinez@mail.com', '2023-02-20');

INSERT INTO Horario_empleado (id_empleado, dia_semana, hora_inicio, hora_fin) VALUES
(1, 'Lunes', '09:00:00', '17:00:00'),
(1, 'Miércoles', '10:00:00', '18:00:00'),
(2, 'Martes', '11:00:00', '19:00:00'),
(2, 'Jueves', '12:00:00', '20:00:00');

INSERT INTO categoria (nombre) VALUES
('Cabello'),
('Barba'),
('Tratamientos');

INSERT INTO Servicios (NombreServicio, Descripcion, Precio, DuracionEstimada, categoria) VALUES
('Corte Básico', 'Corte de cabello clásico', 150.00, '00:30:00', 1),
('Arreglo de Barba', 'Perfilado y rebajado de barba', 100.00, '00:20:00', 2),
('Tratamiento Capilar', 'Tratamiento intensivo para el cabello', 200.00, '00:45:00', 3);

INSERT INTO Citas (cliente_id, empleados_id, Fecha_Hora_Cita, estadoCita) VALUES
(1, 1, '2024-05-27 10:00:00', 'Agendada'),
(2, 2, '2024-05-27 11:00:00', 'Completada'),
(3, 1, '2024-05-28 14:00:00', 'Cancelada');

INSERT INTO Pagos (id_cita, Fecha_Hora_Pago, monto) VALUES
(1, '2024-05-27 10:30:00', 150.00),
(2, '2024-05-27 11:30:00', 100.00);

INSERT INTO Servicios_Citas (servicio_id, cita_id) VALUES
(1, 1),  -- Corte Básico para cita 1
(2, 2),  -- Arreglo de Barba para cita 2
(3, 3);  -- Tratamiento Capilar para cita 3