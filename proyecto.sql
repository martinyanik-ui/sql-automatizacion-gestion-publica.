-- 1. Limpieza total para recargar
DROP VIEW IF EXISTS reporte_critico;
DROP TABLE IF EXISTS alertas_gestion;
DROP TABLE IF EXISTS historial_pasos;
DROP TABLE IF EXISTS tramite_expediente;

-- 2. Creación de Tablas
CREATE TABLE tramite_expediente (
    id_expediente INTEGER PRIMARY KEY,
    tipo_tramite TEXT,
    area_responsable TEXT,
    fecha_inicio DATE,
    estado_actual TEXT
);

CREATE TABLE historial_pasos (
    id_paso INTEGER PRIMARY KEY AUTOINCREMENT,
    id_expediente INTEGER,
    fecha_movimiento DATE,
    accion_realizada TEXT,
    FOREIGN KEY (id_expediente) REFERENCES tramite_expediente(id_expediente)
);

CREATE TABLE alertas_gestion (
    id_alerta INTEGER PRIMARY KEY AUTOINCREMENT,
    id_expediente INTEGER,
    tipo_alerta TEXT,
    nivel_prioridad TEXT,
    fecha_deteccion DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 3. Carga de Datos Masiva (Varios sectores)
INSERT INTO tramite_expediente VALUES 
(301, 'Beca Apunte', 'Bienestar', '2026-03-10', 'Abierto'),
(302, 'Título Posgrado', 'Títulos', '2026-01-05', 'Abierto'),
(303, 'Alta Docente', 'RRHH', '2026-02-10', 'Abierto'),
(304, 'Certificado Alumno', 'Alumnos', '2026-03-22', 'Abierto'),
(305, 'Expediente Compras', 'Administración', '2025-12-01', 'Abierto'),
(306, 'Validación DNI', 'Alumnos', '2026-03-20', 'Abierto'),
(307, 'Baja Patrimonial', 'Administración', '2026-01-15', 'Abierto');

-- 4. Movimientos (Simulamos que algunos están trabados)
INSERT INTO historial_pasos (id_expediente, fecha_movimiento, accion_realizada) VALUES 
(301, '2026-03-21', 'Movimiento Reciente'),
(302, '2026-01-10', 'Recibido en Títulos'),    -- TRABADO (>30 días)
(303, '2026-02-11', 'Pendiente Firma'),       -- TRABADO (>30 días)
(304, '2026-03-23', 'Iniciado'),
(305, '2025-12-05', 'Enviado a Contaduría'), -- TRABADO (>30 días)
(306, '2026-03-22', 'Documento ok'),
(307, '2026-01-20', 'Para Firma Decano');     -- TRABADO (>30 días)

-- 5. Ejecutar la lógica de Alertas Automáticas
INSERT INTO alertas_gestion (id_expediente, tipo_alerta, nivel_prioridad)
SELECT id_expediente, 'EXPEDIENTE PARALIZADO', 'ALTA'
FROM historial_pasos
WHERE (julianday('now') - julianday(fecha_movimiento)) > 30;

-- 6. Crear la Vista para el Gráfico
CREATE VIEW reporte_critico AS
SELECT area_responsable, COUNT(id_expediente) AS cantidad_alertas
FROM tramite_expediente
WHERE id_expediente IN (SELECT id_expediente FROM alertas_gestion)
GROUP BY area_responsable;

-- 7. Ver resultado
SELECT * FROM reporte_critico;
