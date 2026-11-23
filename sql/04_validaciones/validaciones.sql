USE dbo_DNX_Cauchos_SRL;
GO
-- Estados de las cabeceras (incluye completadas, canceladas y pendientes).
SELECT UPPER(LTRIM(RTRIM(estado))) AS estado,
       COUNT(*) AS total_pedidos
FROM dbo.Venta
GROUP BY UPPER(LTRIM(RTRIM(estado)))
ORDER BY total_pedidos DESC;
GO

-- Esperado: una fila en hechos por detalle de venta completada.
SELECT COUNT(*) AS detalles_completados_origen
FROM dbo.Venta AS V
JOIN dbo.DetalleVenta AS D ON D.id_venta = V.id_venta
WHERE UPPER(LTRIM(RTRIM(V.estado))) = 'COMPLETADO';
GO

USE dm_DNX_Cauchos_SRL;
GO
SELECT COUNT(*) AS lineas_datamart,
       COUNT(DISTINCT pk_venta) AS ventas_completadas,
       COUNT(DISTINCT pk_detalle) AS detalles_distintos
FROM dbo.hecho_ventas;
GO

SELECT SUM(total_venta) AS ventas_netas,
       SUM(descuento) AS descuentos,
       SUM(costo_total) AS costos_fabricacion,
       SUM(utilidad) AS utilidad_estimada,
       CAST(100.0 * SUM(utilidad) / NULLIF(SUM(total_venta), 0) AS DECIMAL(10,2)) AS margen_pct
FROM dbo.hecho_ventas;
GO

-- Detectar códigos de detalle repetidos (esperado: sin filas).
SELECT pk_detalle, COUNT(*) AS repeticiones
FROM dbo.hecho_ventas
GROUP BY pk_detalle
HAVING COUNT(*) > 1;
GO

-- Validar que las claves sustitutas tienen dimensiones asociadas.
SELECT COUNT(*) AS hechos_sin_dimension
FROM dbo.hecho_ventas h
LEFT JOIN dbo.dim_cliente c ON c.id_cliente=h.id_cliente
LEFT JOIN dbo.dim_producto p ON p.id_producto=h.id_producto
LEFT JOIN dbo.dim_vendedor v ON v.id_vendedor=h.id_vendedor
LEFT JOIN dbo.dim_metodoPago m ON m.id_metodoP=h.id_metodoP
LEFT JOIN dbo.dim_tiempo t ON t.id_tiempo=h.id_tiempo
WHERE c.id_cliente IS NULL OR p.id_producto IS NULL
   OR v.id_vendedor IS NULL OR m.id_metodoP IS NULL OR t.id_tiempo IS NULL;
GO
