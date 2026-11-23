USE MASTER
GO

USE dm_DNX_Cauchos_SRL;
GO

-- ===================================================================
-- PASO 1: LIMPIEZA PREVIA (En orden inverso a las dependencias)
-- ===================================================================
DELETE FROM hecho_ventas;
DBCC CHECKIDENT ('hecho_ventas', RESEED, 0);

DELETE FROM dim_cliente;
DBCC CHECKIDENT ('dim_cliente', RESEED, 0);

DELETE FROM dim_producto;
DBCC CHECKIDENT ('dim_producto', RESEED, 0);

DELETE FROM dim_vendedor;
DBCC CHECKIDENT ('dim_vendedor', RESEED, 0);

DELETE FROM dim_metodoPago;
DBCC CHECKIDENT ('dim_metodoPago', RESEED, 0);

DELETE FROM dim_tiempo;
DBCC CHECKIDENT ('dim_tiempo', RESEED, 0);
GO

-- ===================================================================
-- PASO 2: CARGA DE DIMENSIÓN CLIENTE
-- ===================================================================
INSERT INTO dim_cliente (pk_cliente, nombre_cliente, tipo_cliente, dni, telefono, distrito)
SELECT
    id_cliente,
    nombre_cliente,
    tipo_cliente,
    dni,
    telefono,
    distrito
FROM dbo_DNX_Cauchos_SRL.dbo.Cliente;
GO

-- ===================================================================
-- PASO 3: CARGA DE DIMENSIÓN PRODUCTO
-- ===================================================================
INSERT INTO dim_producto (pk_producto, nombre_producto, tipo_suela, talla, stock, costo_fabricacion, precio, categoria, material)
SELECT
    id_producto,
    nombre_producto,
    tipo_suela,
    talla,
    stock,
    costo_fabricacion,
    precio,
    categoria,
    material
FROM dbo_DNX_Cauchos_SRL.dbo.Producto;
GO

-- ===================================================================
-- PASO 4: CARGA DE DIMENSIÓN VENDEDOR
-- ===================================================================
INSERT INTO dim_vendedor (pk_vendedor, dni, nombre_vendedor, apellido, usuario, cargo)
SELECT
    id_vendedor,
    dni,
    nombre_vendedor,
    apellido,
    usuario,
    cargo
FROM dbo_DNX_Cauchos_SRL.dbo.Vendedor;
GO

-- ===================================================================
-- PASO 5: CARGA DE DIMENSIÓN MÉTODO DE PAGO
-- ===================================================================
INSERT INTO dim_metodoPago (pk_metodoP, nombre_metodo, tipo_pago)
SELECT
    id_metodo_pago,
    nombre_metodo,
    tipo_pago
FROM dbo_DNX_Cauchos_SRL.dbo.MetodoPago;
GO

-- ===================================================================
-- PASO 6: CARGA DE DIMENSIÓN TIEMPO (Generación dinámica de fechas)
-- ===================================================================
SET LANGUAGE Spanish;
GO

DECLARE @FechaInicio DATE, @FechaFin DATE;

-- Se extrae el rango de fechas real desde las ventas transaccionales
SELECT
    @FechaInicio = MIN(fecha),
    @FechaFin = MAX(fecha)
FROM dbo_DNX_Cauchos_SRL.dbo.Venta;

WHILE @FechaInicio <= @FechaFin
BEGIN
    INSERT INTO dim_tiempo (fecha, dia, mes, nombre_mes, trimestre, anio)
    VALUES (
        @FechaInicio,
        DAY(@FechaInicio),
        MONTH(@FechaInicio),
        DATENAME(MONTH, @FechaInicio),
        DATEPART(QUARTER, @FechaInicio),
        YEAR(@FechaInicio)
    );
   
    SET @FechaInicio = DATEADD(DAY, 1, @FechaInicio);
END;
GO

-- ===================================================================
-- PASO 7: CARGA DE LA TABLA DE HECHOS (hecho_ventas)
-- ===================================================================
INSERT INTO hecho_ventas (
    id_cliente,
    id_producto,
    id_vendedor,
    id_metodoP,
    id_tiempo,
    pk_venta,
    pk_detalle,
    cantidad,
    precio_unitario,
    monto_venta,
    descuento,
    total_venta,
    costo_total,
    utilidad
)
SELECT
    DC.id_cliente,
    DP.id_producto,
    DV.id_vendedor,
    DM.id_metodoP,
    DT.id_tiempo,
    V.id_venta,
    DET.id_detalle,
    DET.cantidad,
    DET.precio_unitario,
    -- Medidas calculadas
    CAST(DET.cantidad * DET.precio_unitario AS DECIMAL(12,2)) AS monto_venta,
    DET.descuento,
    CAST((DET.cantidad * DET.precio_unitario) - DET.descuento AS DECIMAL(12,2)) AS total_venta,
    CAST(DET.cantidad * P.costo_fabricacion AS DECIMAL(12,2)) AS costo_total,
    CAST(((DET.cantidad * DET.precio_unitario) - DET.descuento) - (DET.cantidad * P.costo_fabricacion) AS DECIMAL(12,2)) AS utilidad
FROM dbo_DNX_Cauchos_SRL.dbo.Venta V
INNER JOIN dbo_DNX_Cauchos_SRL.dbo.DetalleVenta DET ON V.id_venta = DET.id_venta
INNER JOIN dbo_DNX_Cauchos_SRL.dbo.Producto P ON DET.id_producto = P.id_producto
-- Enlaces con las dimensiones mediante las llaves de negocio (pk_...)
INNER JOIN dim_cliente DC ON V.id_cliente = DC.pk_cliente
INNER JOIN dim_producto DP ON DET.id_producto = DP.pk_producto
INNER JOIN dim_vendedor DV ON V.id_vendedor = DV.pk_vendedor
INNER JOIN dim_metodoPago DM ON V.id_metodo_pago = DM.pk_metodoP
INNER JOIN dim_tiempo DT ON V.fecha = DT.fecha
WHERE V.estado = 'COMPLETADO';
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