drop database if exists barberia;
create database barberia;
use barberia;

CREATE TABLE Clientes (
  cliente_id INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(255) NOT NULL,
  apellido VARCHAR(255) NOT NULL,
  telefono VARCHAR(255) UNIQUE,
  correo VARCHAR(255),
  fecha_registro DATE NOT NULL
);

CREATE TABLE Empleados (
  empleado_id INT PRIMARY KEY ,
  nombre VARCHAR(255) NOT NULL,
  apellido VARCHAR(255) NOT NULL,
  especialidad VARCHAR(255),
  telefono VARCHAR(255) UNIQUE,
  correo VARCHAR(255),
  fecha_contratacion DATE NOT NULL
);

CREATE TABLE Horario_empleado (
  id_horario INT PRIMARY KEY AUTO_INCREMENT,
  id_empleado INT,
  dia_semana VARCHAR(255),
  hora_inicio TIME,
  hora_fin TIME
);

create table categoria(
	idcat tinyint primary key auto_increment,
    nombre varchar(30)
    );

CREATE TABLE Servicios (
  servicios_id INT PRIMARY KEY AUTO_INCREMENT,
  NombreServicio VARCHAR(255) NOT NULL UNIQUE,
  Descripcion TEXT,
  Precio DECIMAL(19, 2) NOT NULL,
  DuracionEstimada TIME,
  categoria tinyint
);

CREATE TABLE Citas (
  cita_id INT PRIMARY KEY AUTO_INCREMENT,
  cliente_id INT,
  empleados_id INT,
  Fecha_Hora_Cita DATETIME NOT NULL,
  estadoCita VARCHAR(255)
);

CREATE TABLE Pagos (
  id_pagos INT PRIMARY KEY AUTO_INCREMENT,
  id_cita INT UNIQUE,
  Fecha_Hora_Pago DATETIME NOT NULL,
  monto DECIMAL(19, 2) NOT NULL
);

CREATE TABLE Servicios_Citas (
  servicio_id INT,
  cita_id INT,
  PRIMARY KEY (servicio_id, cita_id)
);

ALTER TABLE Horario_empleado
ADD CONSTRAINT fk_id_empleado FOREIGN KEY (id_empleado) REFERENCES Empleados(empleado_id);

ALTER TABLE Citas
ADD CONSTRAINT fk_cliente_id FOREIGN KEY (cliente_id) REFERENCES Clientes(cliente_id),
ADD CONSTRAINT fk_empleados_id FOREIGN KEY (empleados_id) REFERENCES Empleados(empleado_id);

ALTER TABLE Pagos
ADD CONSTRAINT fk_id_cita FOREIGN KEY (id_cita) REFERENCES Citas(cita_id);

ALTER TABLE Servicios_Citas
ADD CONSTRAINT fk_servicio_id FOREIGN KEY (servicio_id) REFERENCES Servicios(servicios_id),
ADD CONSTRAINT fk_cita_id FOREIGN KEY (cita_id) REFERENCES Citas(cita_id);