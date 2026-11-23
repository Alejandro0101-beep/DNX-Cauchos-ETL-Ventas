# Decisiones técnicas y revisión

## Archivos de origen

Los tres SQL nuevos facilitados para la revisión son distintos de los scripts de la raíz, que corresponden al historial inicial del repositorio. Se mantienen ambos conjuntos sin sustituir silenciosamente el contenido anterior.

- `sql/01_origen/crear_esquema.sql`: solo DDL extraído del script transaccional ampliado. Se retira el bloque de `DELETE` previo a crear las tablas. No incluye las inserciones con datos identificables.
- `sql/02_datamart/crear_datamart.sql`: definición de las cinco dimensiones y `hecho_ventas`.
- `sql/03_etl/cargar_datamart.sql`: script ETL entregado con `DBCC CHECKIDENT(..., RESEED, 0)` en lugar de `RESEED, 1`. En tablas con `IDENTITY(1,1)` que fueron vaciadas con `DELETE`, esa corrección permite comenzar las nuevas filas en 1.
- `sql/04_validaciones/validaciones.sql`: consultas adicionales para verificar estados y correspondencias.

## Observaciones pendientes de comprobación

1. El script de origen ampliado incluyó inserciones masivas con datos de personas y campos DNI/teléfono. Antes de publicarlo íntegro hay que revisar que todos los registros sean ficticios o anonimizarlos.
2. Las exportaciones CSV recibidas corresponden a un estado del Data Mart y no prueban que los scripts de la raíz produzcan sus mismos recuentos.
3. La versión del ETL conserva `WHERE V.estado = 'COMPLETADO'`, excluyendo canceladas y pendientes de `hecho_ventas`.
4. El notebook Big Data contiene una reparación de claves entre dimensiones y hechos. Se requiere comprobar que la carga SQL y la exportación CSV asignen claves coherentes.
5. Los scripts de creación no son idempotentes: deben utilizarse en una instancia o bases nuevas. La carga ETL es destructiva respecto del Data Mart.
6. Sin ejecutar SQL Server ni Power BI no se garantiza que todas las medidas DAX o relaciones funcionen en la máquina del lector.

## Criterios de KPI

- Ventas netas: `SUM(hecho_ventas.total_venta)`.
- Unidades: `SUM(hecho_ventas.cantidad)`.
- Costo de fabricación estimado: `SUM(hecho_ventas.costo_total)`.
- Utilidad estimada: `SUM(hecho_ventas.utilidad)`.
- Margen sobre venta neta: `100 * SUM(utilidad) / NULLIF(SUM(total_venta),0)`.
- Pedidos por estado: `COUNT(*)` agrupando `Venta.estado` en el sistema de origen, **no** `hecho_ventas`.

No mezclar ingresos de hechos completados con un conteo de pedidos de todos los estados sin indicar claramente las poblaciones y filtros.
