-- SCRIPT DE CREACIÓN DE BASE DE DATOS: MedAgenda
-- CREACIÓN DE LA BBASE DE DATOS MEDAGENDA
CREATE DATABASE medagenda_db;
-- 1. CREACIÓN DEL TIPO COMPUESTO
CREATE TYPE personanombre AS (
  nombrepila VARCHAR(50),
  paterno VARCHAR(50),
  materno VARCHAR(50)
);
-- 2. TABLA: usuario (Capa de Autenticación)
CREATE TABLE usuario(
  idusuario SERIAL PRIMARY KEY,
  username VARCHAR(50) NOT NULL UNIQUE,
  rol VARCHAR(20) NOT NULL CHECK(rol IN(
    'ADMIN',
    'DOCTOR',
    'ASISTENTE',
    'PACIENTE'
  )),
  estaactivo BOOLEAN DEFAULT TRUE,
  email TEXT NOT NULL UNIQUE,
  password VARCHAR(80),
  telefono VARCHAR(15) NOT NULL CHECK(telefono ~'^[0-9]+$'),
  token_verificacion VARCHAR(255)
);
-- 3. TABLA: especialidad (Catálogo Médico)
CREATE TABLE especialidad(
  idespecialidad SERIAL PRIMARY KEY,
  nombre personanombre,
  descripcion TEXT
);
-- 4. TABLA: paciente (Perfil de Pacientes)
CREATE TABLE paciente(
  idpaciente SERIAL PRIMARY KEY,
  curp VARCHAR(18) UNIQUE,
  nombre personanombre,
  fechanacimiento DATE,
  idusuario INTEGER UNIQUE REFERENCES usuario(idusuario)
);
-- 5. TABLA: doctor (Perfil Profesional)
CREATE TABLE doctor(
  iddoctor SERIAL PRIMARY KEY,
  idusuario INTEGER UNIQUE REFERENCES usuario(idusuario),
  idespecialidad INTEGER REFERENCES especialidad(idespecialidad),
  nombre personanombre,
  cedula VARCHAR(20) NOT NULL UNIQUE,
  direccion VARCHAR(255)
);
-- 6. TABLA: cita (Gestión de Agenda)
CREATE TABLE cita(
  idcita SERIAL PRIMARY KEY,
  idpaciente INTEGER REFERENCES paciente(idpaciente),
  iddoctor INTEGER REFERENCES doctor(iddoctor),
  fechahora TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  motivo VARCHAR(255),
  estado VARCHAR(20) DEFAULT 'PENDIENTE'CHECK(estado IN(
    'PENDIENTE',
    'REALIZADA',
    'CANCELADA',
    'PAGADA'
  ))
);
-- 7. TABLA: horariolaboral (Disponibilidad de Médicos)
CREATE TABLE horariolaboral(
  idhorario SERIAL PRIMARY KEY,
  iddoctor INTEGER REFERENCES doctor(iddoctor),
  diasemana VARCHAR(15) NOT NULL,
  horaentrada TIME WITHOUT TIME ZONE NOT NULL,
  horasalida TIME WITHOUT TIME ZONE NOT NULL
);
-- 8. TABLA: expediente (Notas Clínicas)
CREATE TABLE expediente(
  idexpediente SERIAL PRIMARY KEY,
  idcita INTEGER UNIQUE REFERENCES cita(idcita),
  diagnostico TEXT,
  tratamiento TEXT,
  notasjson JSONB
);
-- 9. TABLA: pago (Módulo Financiero)
CREATE TABLE pago(
  idpago SERIAL PRIMARY KEY,
  idcita INTEGER UNIQUE REFERENCES cita(idcita),
  monto NUMERIC(
    10,
    2
  ) NOT NULL,
  metodopago VARCHAR(50),
  fechapago TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
-- 10. TABLA: sep_cedula (Simulación de Padrón Oficial)
CREATE TABLE sep_cedula(
  num_cedula VARCHAR(10) PRIMARY KEY,
  nombre personanombre,
  especialidad VARCHAR(100),
  institucion VARCHAR(100)
);
