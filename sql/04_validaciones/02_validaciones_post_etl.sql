-- Validaciones posteriores a la carga del ETL (separadas de 01_cargar_datamart.sql).
-- Ejecutar con ambas bases en la misma instancia.

USE dm_DNX_Cauchos_SRL;
GO

-- ====================================
-- Validacion de Data Mart
-- ====================================
    
SELECT 'dim_cliente' AS tabla, COUNT(*) AS registros FROM dim_cliente
UNION ALL
SELECT 'dim_producto', COUNT(*) FROM dim_producto
UNION ALL
SELECT 'dim_vendedor', COUNT(*) FROM dim_vendedor
UNION ALL
SELECT 'dim_metodoPago', COUNT(*) FROM dim_metodoPago
UNION ALL
SELECT 'dim_tiempo', COUNT(*) FROM dim_tiempo
UNION ALL
SELECT 'hecho_ventas', COUNT(*) FROM hecho_ventas;
GO

-- ====================================
-- Validación de linea origen con Data Mart
-- ====================================

SELECT COUNT(*) AS lineasOLTP FROM dbo_DNX_Cauchos_SRL.dbo.Venta V
INNER JOIN dbo_DNX_Cauchos_SRL.dbo.DetalleVenta D ON V.id_venta = D.id_venta
WHERE V.estado = 'COMPLETADO';

-- ====================================
-- Registros cargados en el Data Mart

SELECT COUNT(*) AS lineasDataMart FROM dm_DNX_Cauchos_SRL.dbo.hecho_ventas;
GO

-- ====================================
-- Resultado de la tabla de hechos
-- ====================================

SELECT * FROM dbo.dim_cliente
SELECT * FROM dbo.dim_metodoPago
SELECT * FROM dbo.dim_producto
SELECT * FROM dbo.dim_tiempo
SELECT * FROM dbo.dim_vendedor
SELECT * FROM dbo.hecho_ventas
GO

-- ====================================
-- Validación de KPIs
-- ====================================

SELECT
    SUM(total_venta) AS ventas_totales,
    SUM(cantidad) AS unidades_vendidas,
    SUM(descuento) AS descuento_total,
    SUM(costo_total) AS costo_total,
    SUM(utilidad) AS utilidad_total
FROM hecho_ventas;
GO

SELECT 
    SUM(total_venta) AS ventasTotales,
    SUM(costo_total) AS costoTotal,
    SUM(utilidad) AS utilidadTotal,
    CAST((SUM(utilidad) * 100.0 / NULLIF(SUM(total_venta), 0)) AS DECIMAL(10,2)) AS margenGananciaPorcentaje
FROM hecho_ventas;
GO