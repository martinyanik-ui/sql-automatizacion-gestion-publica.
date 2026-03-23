# 🏛️ Monitoreo de Expedientes - Gestión Universitaria

## 📊 Resumen del Proyecto
Este proyecto resuelve un problema real de la administración pública: la detección de expedientes paralizados. Utilicé **SQL** para crear una lógica de auditoría automática y **Power BI** para visualizar los cuellos de botella por área.

## 🛠️ Herramientas Utilizadas
- **SQL (SQLite):** Diseño de base de datos, lógica de fechas (`julianday`) y creación de `VIEWS`.
- **Power BI:** Visualización de datos y storytelling.
- **VS Code:** Entorno de desarrollo.

## 🚀 Cómo funciona
1. El script analiza la tabla de movimientos.
2. Si un expediente no tiene actividad por **más de 30 días**, se genera una alerta automática en una tabla de auditoría.
3. El reporte final agrupa estas alertas por sector para la toma de decisiones.

## 📈 Visualización Final
![Dashboard de Gestión](./dashboard_gestion.png)

*Hallazgo clave: El sector de Administración presenta la mayor criticidad, concentrando el 50% de las alertas actuales.*
