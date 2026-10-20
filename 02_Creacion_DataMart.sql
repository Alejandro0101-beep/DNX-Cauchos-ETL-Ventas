USE MASTER
GO

CREATE DATABASE dm_DNX_Cauchos_SRL;
GO

USE dm_DNX_Cauchos_SRL;
GO

-- 1. DIMENSIÓN CLIENTE
CREATE TABLE dim_cliente (
    id_cliente INT IDENTITY(1,1) PRIMARY KEY, -- Clave subrogada del Data Mart
    pk_cliente VARCHAR(10) NOT NULL,          -- Código del sistema origen: CLI-XXXXX
    nombre_cliente VARCHAR(80) NOT NULL,
    tipo_cliente VARCHAR(50) NOT NULL,
    dni VARCHAR(12) NOT NULL,
    telefono VARCHAR(20),
    distrito VARCHAR(60) NOT NULL
);
GO

-- 2. DIMENSIÓN PRODUCTO (Incluye stock, costo de fabricación y precio)
CREATE TABLE dim_producto (
    id_producto INT IDENTITY(1,1) PRIMARY KEY, -- Clave subrogada
    pk_producto VARCHAR(10) NOT NULL,          -- Código del sistema origen: PRO-XXXXX
    nombre_producto VARCHAR(100) NOT NULL,
    tipo_suela VARCHAR(50) NOT NULL,
    talla VARCHAR(10) NOT NULL,
    stock INT NOT NULL,
    costo_fabricacion DECIMAL(10,2) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    material VARCHAR(50) NOT NULL
);
GO

-- 3. DIMENSIÓN VENDEDOR (Incluye DNI y usuario)
CREATE TABLE dim_vendedor (
    id_vendedor INT IDENTITY(1,1) PRIMARY KEY, -- Clave subrogada
    pk_vendedor VARCHAR(10) NOT NULL,          -- Código del sistema origen: VEN-XXXXX
    dni VARCHAR(8) NOT NULL,
    nombre_vendedor VARCHAR(80) NOT NULL,
    apellido VARCHAR(80) NOT NULL,
    usuario VARCHAR(30) NOT NULL,
    cargo VARCHAR(50) NOT NULL
);
GO

-- 4. DIMENSIÓN MÉTODO DE PAGO
CREATE TABLE dim_metodoPago (
    id_metodoP INT IDENTITY(1,1) PRIMARY KEY, -- Clave subrogada
    pk_metodoP VARCHAR(10) NOT NULL,          -- Código del sistema origen: MTP-XX
    nombre_metodo VARCHAR(50) NOT NULL,
    tipo_pago VARCHAR(50) NOT NULL
);
GO

-- 5. DIMENSIÓN TIEMPO
CREATE TABLE dim_tiempo (
    id_tiempo INT IDENTITY(1,1) PRIMARY KEY,
    fecha DATE NOT NULL UNIQUE,
    dia INT NOT NULL,
    mes INT NOT NULL,
    nombre_mes VARCHAR(20) NOT NULL,
    trimestre INT NOT NULL,
    anio INT NOT NULL
);
GO

-- 6. TABLA DE HECHOS: HECHO_VENTAS (Centro del Modelo Estrella)
CREATE TABLE hecho_ventas (
    id_hecho INT IDENTITY(1,1) PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_producto INT NOT NULL,
    id_vendedor INT NOT NULL,
    id_metodoP INT NOT NULL,
    id_tiempo INT NOT NULL,
   
    pk_venta VARCHAR(10) NOT NULL,    -- Código de venta origen: VNT-XXXXX
    pk_detalle VARCHAR(10) NOT NULL,  -- Código de detalle origen: DET-XXXXX

    -- Medidas de análisis
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    monto_venta DECIMAL(12,2) NOT NULL,     -- Importe bruto (cantidad * precio)
    descuento DECIMAL(10,2) NOT NULL,       -- Descuento aplicado
    total_venta DECIMAL(12,2) NOT NULL,     -- Venta neta (monto_venta - descuento)
    costo_total DECIMAL(12,2) NOT NULL,     -- Costo fabricación (cantidad * costo_fabricacion)
    utilidad DECIMAL(12,2) NOT NULL,        -- Ganancia neta (total_venta - costo_total)

    -- Relaciones con las dimensiones
    CONSTRAINT FK_hecho_cliente FOREIGN KEY (id_cliente) REFERENCES dim_cliente(id_cliente),
    CONSTRAINT FK_hecho_producto FOREIGN KEY (id_producto) REFERENCES dim_producto(id_producto),
    CONSTRAINT FK_hecho_vendedor FOREIGN KEY (id_vendedor) REFERENCES dim_vendedor(id_vendedor),
    CONSTRAINT FK_hecho_metodoPago FOREIGN KEY (id_metodoP) REFERENCES dim_metodoPago(id_metodoP),
    CONSTRAINT FK_hecho_tiempo FOREIGN KEY (id_tiempo) REFERENCES dim_tiempo(id_tiempo)
);
GO