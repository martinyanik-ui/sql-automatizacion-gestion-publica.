-- 1. Limpieza inicial (Eliminamos en orden inverso por las Foreign Keys)
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
    fecha_deteccion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_expediente) REFERENCES tramite_expediente(id_expediente)
);

-- 3. Inserción de Datos
INSERT INTO
    tramite_expediente
VALUES
    (
        101,
        'Beca Estudiantil',
        'Secretaría Académica',
        '2026-03-01',
        'Abierto'
    );

INSERT INTO
    tramite_expediente
VALUES
    (
        102,
        'Título de Grado',
        'Títulos',
        '2026-02-15',
        'Abierto'
    );

INSERT INTO
    tramite_expediente
VALUES
    (
        103,
        'Certificado Trabajo',
        'RRHH',
        '2026-03-20',
        'Abierto'
    );

INSERT INTO
    historial_pasos (
        id_expediente,
        fecha_movimiento,
        accion_realizada
    )
VALUES
    (101, '2026-03-21', 'Validación');

INSERT INTO
    historial_pasos (
        id_expediente,
        fecha_movimiento,
        accion_realizada
    )
VALUES
    (102, '2026-02-16', 'Recepción');

INSERT INTO
    historial_pasos (
        id_expediente,
        fecha_movimiento,
        accion_realizada
    )
VALUES
    (103, '2026-03-22', 'Firma');

-- 4. Lógica de Automatización
INSERT INTO
    alertas_gestion (id_expediente, tipo_alerta, nivel_prioridad)
SELECT
    id_expediente,
    'ALERTA: EXPEDIENTE PARALIZADO (>30 DÍAS)',
    'ALTA'
FROM
    historial_pasos
WHERE
    (julianday('now') - julianday(fecha_movimiento)) > 30;

-- 5. Creación de Reporte (VISTA)
CREATE VIEW reporte_critico AS
SELECT
    area_responsable,
    COUNT(id_expediente) AS cantidad_alertas
FROM
    tramite_expediente
WHERE
    id_expediente IN (
        SELECT
            id_expediente
        FROM
            alertas_gestion
    )
GROUP BY
    area_responsable;

-- 6. Verificación Final de Resultados
SELECT
    *
FROM
    reporte_critico;