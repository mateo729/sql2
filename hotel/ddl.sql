-- CREAR BASE DE DATOS
DROP DATABASE IF EXISTS hotel;
CREATE DATABASE hotel;
USE hotel;

-- TABLA CLIENTES
CREATE TABLE Clientes (
  cliente_id INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(100) NOT NULL,
  apellido VARCHAR(100) NOT NULL,
  telefono VARCHAR(20) UNIQUE,
  correo VARCHAR(100),
  fecha_registro DATE NOT NULL
);

-- TABLA HABITACIONES
CREATE TABLE Habitaciones (
  habitacion_id INT PRIMARY KEY AUTO_INCREMENT,
  numero VARCHAR(10) UNIQUE,
  capacidad INT CHECK (capacidad BETWEEN 1 AND 4),
  precio_noche DECIMAL(10,2), -- en pesos colombianos
  disponible ENUM('Sí', 'No') DEFAULT 'Sí'
);

-- TABLA RESERVAS
CREATE TABLE Reservas (
  reserva_id INT PRIMARY KEY AUTO_INCREMENT,
  cliente_id INT,
  habitacion_id INT,
  fecha_reserva DATE,
  fecha_ingreso DATE,
  fecha_salida DATE,
  total DECIMAL(10,2),
  FOREIGN KEY (cliente_id) REFERENCES Clientes(cliente_id),
  FOREIGN KEY (habitacion_id) REFERENCES Habitaciones(habitacion_id)
);
