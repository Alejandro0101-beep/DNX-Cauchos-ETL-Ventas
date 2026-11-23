USE MASTER
GO

CREATE DATABASE dbo_DNX_Cauchos_SRL
GO

USE dbo_DNX_Cauchos_SRL
GO

-- Esquema inicial: no se eliminan tablas antes de crearlas.
-- 1. TABLA CLIENTE
CREATE TABLE Cliente (
    id_cliente VARCHAR(10) PRIMARY KEY, -- Ejemplo: CLI-00001
    nombre_cliente VARCHAR(80) NOT NULL,-- Ejemplo: Mathias Barrera
    tipo_cliente VARCHAR(50) NOT NULL,  -- Cliente normal, Cliente corporativo
    dni VARCHAR(12) NOT NULL,           -- DNI (8) o RUC (11)
    telefono VARCHAR(20),               -- Ejemplo: 912912943
    distrito VARCHAR(60) NOT NULL       -- Ejemplo: Comas
);
GO

-- 2. TABLA PRODUCTO
CREATE TABLE Producto (
    id_producto VARCHAR(10) PRIMARY KEY,    -- Ejemplo: PRO-00001
    nombre_producto VARCHAR(100) NOT NULL,  -- Ejemplo: Suelx extra X
    tipo_suela VARCHAR(50) NOT NULL,        -- Ejemplo: Suela de PU, PU doble densidad, Suela de TPU, Suela de Goma, Suela de Nitrilo, Suela de PVC
    talla VARCHAR(10) NOT NULL,             -- Ejemplo: 38, 40, 42
    stock INT NOT NULL DEFAULT 500,         -- Stock de maximo 500
    precio DECIMAL(10,2) NOT NULL,          -- Precio de venta al público
    costo_fabricacion DECIMAL(10,2) NOT NULL,-- Costo de elaboración de la suela
    categoria VARCHAR(50) NOT NULL,         -- Casual, Urbano, Deportivo, formal, industrial, seguridad, etc.
    material VARCHAR(50) NOT NULL           -- Caucho Nitrilo, Caucho Natural, PU
);
GO

-- 3. TABLA VENDEDOR
CREATE TABLE Vendedor (
    id_vendedor VARCHAR(10) PRIMARY KEY, -- VEN-00001 (sirve de código y PK)
    dni VARCHAR(8) NOT NULL,             -- Ejemplo: 74819203
    nombre_vendedor VARCHAR(80) NOT NULL,-- Ejemplo: Juan
    apellido VARCHAR(80) NOT NULL,       -- Ejemplo: Rodriguez
    usuario VARCHAR(30) NOT NULL,        -- ej: jrodriguez
    cargo VARCHAR(50) NOT NULL           -- Ejemplo: Asesor Comercial, Ejecutivo de Ventas, Atención al cliente
);
GO

-- 4. TABLA METODO DE PAGO
CREATE TABLE MetodoPago (
    id_metodo_pago VARCHAR(10) PRIMARY KEY, -- MTP-01, MTP-02, MTP-03, MTP-04
    nombre_metodo VARCHAR(50) NOT NULL,     -- Yape, Efectivo, Tarjeta, Transferencia Bancaria
    tipo_pago VARCHAR(50) NOT NULL          -- Digital, Contado, Bancario
);
GO

-- 5. TABLA VENTA (Cabecera)
CREATE TABLE Venta (
    id_venta VARCHAR(10) PRIMARY KEY, -- VNT-00001
    fecha DATE NOT NULL,              -- Fecha en la que se hizo la venta
    id_cliente VARCHAR(10) NOT NULL,  -- ID del cliente
    id_vendedor VARCHAR(10) NOT NULL, -- ID del vendedor
    id_metodo_pago VARCHAR(10) NOT NULL,-- ID de metodo del pago
    estado VARCHAR(30) DEFAULT 'COMPLETADO',-- El estado en el que se encuentre

    CONSTRAINT FK_Venta_Cliente FOREIGN KEY (id_cliente)
        REFERENCES Cliente(id_cliente),

    CONSTRAINT FK_Venta_Vendedor FOREIGN KEY (id_vendedor)
        REFERENCES Vendedor(id_vendedor),

    CONSTRAINT FK_Venta_MetodoPago FOREIGN KEY (id_metodo_pago)
        REFERENCES MetodoPago(id_metodo_pago)
);
GO


-- 6. TABLA DETALLE DE VENTA
CREATE TABLE DetalleVenta (
    id_detalle VARCHAR(10) PRIMARY KEY, -- DET-00001
    id_venta VARCHAR(10) NOT NULL,      -- ID de la venta
    id_producto VARCHAR(10) NOT NULL,   -- ID del producto
    cantidad INT NOT NULL,              -- La cantidad del producto
    precio_unitario DECIMAL(10,2) NOT NULL, -- Precio unitario
    descuento DECIMAL(10,2) DEFAULT 0.00,   -- Descuento si se aplica
    
    -- 1. Importe sin descuento (Precio bruto: cantidad * precio)
    importe_bruto AS (CAST(cantidad * precio_unitario AS DECIMAL(10,2))),
    
    -- 2. Importe con descuento (Precio neto / Subtotal: importe_bruto - descuento)
    subtotal AS (CAST((cantidad * precio_unitario) - descuento AS DECIMAL(10,2))),

    CONSTRAINT FK_Detalle_Venta FOREIGN KEY (id_venta)
        REFERENCES Venta(id_venta),

    CONSTRAINT FK_Detalle_Producto FOREIGN KEY (id_producto)
        REFERENCES Producto(id_producto)
);
GO
