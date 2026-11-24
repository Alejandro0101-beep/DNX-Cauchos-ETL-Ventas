USE MASTER
GO

CREATE DATABASE dbo_DNX_Cauchos_SRL
GO

USE dbo_DNX_Cauchos_SRL
GO

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

-- ===================================================================
-- 1. INSERCIÓN DE 75 CLIENTES
-- ===================================================================

INSERT INTO Cliente (id_cliente, nombre_cliente, tipo_cliente, dni, telefono, distrito) VALUES
('CLI-00001', 'Calzados El Inca S.A.C.', 'Cliente corporativo', '20489123451', '987654321', 'San Juan de Lurigancho'),
('CLI-00002', 'Industrias del Cuero Lima S.A.', 'Cliente corporativo', '20601234567', '912345678', 'Ate'),
('CLI-00003', 'Leandro García Quispe', 'Cliente normal', '47182930', '998877665', 'El Agustino'),
('CLI-00004', 'Calzados Trujillo E.I.R.L.', 'Cliente corporativo', '20556789123', '945612378', 'Comas'),
('CLI-00005', 'Zapatería y Calzados Moderna S.A.C.', 'Cliente corporativo', '20781293845', '932145687', 'Los Olivos'),
('CLI-00006', 'Calzado Seguro Perú S.A.', 'Cliente corporativo', '20789456123', '911223344', 'Villa El Salvador'),
('CLI-00007', 'Rosa Elvira Martínez Soto', 'Cliente normal', '09283741', '977889900', 'Rímac'),
('CLI-00008', 'Botas y Borceguíes del Norte S.R.L.', 'Cliente corporativo', '20123498765', '966554433', 'Puente Piedra'),
('CLI-00009', 'Jorge Luis Mendoza Aliaga', 'Cliente normal', '45819203', '922334455', 'San Martín de Porres'),
('CLI-00010', 'Fabrica de Botines Andinos S.A.C.', 'Cliente corporativo', '20512839401', '933445566', 'San Juan de Lurigancho'),
('CLI-00011', 'Marcos Aurelio Huamán', 'Cliente normal', '70192834', '944556677', 'La Victoria'),
('CLI-00012', 'Creaciones Nicole Calzados', 'Cliente normal', '41209384', '955667788', 'Santa Anita'),
('CLI-00013', 'Suelas y Plantillas Peruanas E.I.R.L.', 'Cliente corporativo', '20603491823', '966778899', 'Ate'),
('CLI-00014', 'Carlos Alberto Valdivia', 'Cliente normal', '10293847', '977889911', 'Breña'),
('CLI-00015', 'Taller Zapatero San Pedro', 'Cliente normal', '08192837', '988990022', 'Independencia'),
('CLI-00016', 'Consorcio Zapatero del Sur S.A.C.', 'Cliente corporativo', '20718293041', '999001133', 'Villa María del Triunfo'),
('CLI-00017', 'Diana Carolina Rojas Cruz', 'Cliente normal', '72384910', '912349876', 'Los Olivos'),
('CLI-00018', 'Calzados Chosica Modas', 'Cliente normal', '43019283', '923458765', 'Lurigancho-Chosica'),
('CLI-00019', 'Manufacturas de Cuero Real S.A.', 'Cliente corporativo', '20491820394', '934567654', 'Comas'),
('CLI-00020', 'Víctor Hugo Zúñiga Paredes', 'Cliente normal', '07192834', '945676543', 'Carabayllo'),
('CLI-00021', 'Calzados y Zapatillas Cóndor E.I.R.L.', 'Cliente corporativo', '20581928301', '956785432', 'San Juan de Lurigancho'),
('CLI-00022', 'Patricia Elena Campos Salazar', 'Cliente normal', '46192830', '967894321', 'Rímac'),
('CLI-00023', 'Industrias Pegaso del Calzado S.A.C.', 'Cliente corporativo', '20608192039', '978903210', 'Ate'),
('CLI-00024', 'Raúl Fernando Espinoza Guerra', 'Cliente normal', '10928374', '989012109', 'El Agustino'),
('CLI-00025', 'Corporación Calzatec Perú S.A.', 'Cliente corporativo', '20729182736', '990123098', 'San Martín de Porres'),
('CLI-00026', 'Taller El Artesano de Villa', 'Cliente normal', '44102938', '911234187', 'Villa El Salvador'),
('CLI-00027', 'Fábrica de Botas Fortaleza S.A.C.', 'Cliente corporativo', '20501928345', '922345276', 'Puente Piedra'),
('CLI-00028', 'Silvia Janet Morales Ríos', 'Cliente normal', '73019283', '933456365', 'Los Olivos'),
('CLI-00029', 'Comercializadora de Calzado Lima E.I.R.L.', 'Cliente corporativo', '20601928374', '944567454', 'La Victoria'),
('CLI-00030', 'Manuel Antonio Rivas Castillo', 'Cliente normal', '08910293', '955678543', 'San Miguel'),
('CLI-00031', 'Calzados Vulcano S.A.C.', 'Cliente corporativo', '20419283019', '966789632', 'San Juan de Lurigancho'),
('CLI-00032', 'Lucía Fernanda Vega Ramos', 'Cliente normal', '48192039', '977890721', 'Pueblo Libre'),
('CLI-00033', 'Boutique del Cuero Elegante', 'Cliente normal', '40192837', '988901810', 'Jesús María'),
('CLI-00034', 'Distribuidora Zapatos Express S.A.C.', 'Cliente corporativo', '20701928345', '999012909', 'Ate'),
('CLI-00035', 'Guillermo Enrique Chávez Luna', 'Cliente normal', '10293819', '912123098', 'Cercado de Lima'),
('CLI-00036', 'Calzados Ranger Perú S.R.L.', 'Cliente corporativo', '20591827364', '923234187', 'Comas'),
('CLI-00037', 'Beatriz Mercedes Alarcón Peña', 'Cliente normal', '71928301', '934345276', 'San Juan de Miraflores'),
('CLI-00038', 'Seguridad y Calzado Pro S.A.C.', 'Cliente corporativo', '20609182736', '945456365', 'Villa El Salvador'),
('CLI-00039', 'Arturo Jesús Salazar Benítez', 'Cliente normal', '42019283', '956567454', 'Los Olivos'),
('CLI-00040', 'Mega Calzado Industrial E.I.R.L.', 'Cliente corporativo', '20518293041', '967678543', 'San Martín de Porres'),
('CLI-00041', 'Elena Beatriz Cruzado Ramos', 'Cliente normal', '09182736', '978789632', 'El Agustino'),
('CLI-00042', 'Calzados Dakar Sport S.A.C.', 'Cliente corporativo', '20739182734', '989890721', 'Santa Anita'),
('CLI-00043', 'Óscar Eduardo Pinedo Silva', 'Cliente normal', '45019283', '990901810', 'Chorrillos'),
('CLI-00044', 'Inversiones Podológicas y Calzado S.A.', 'Cliente corporativo', '20481920391', '913123909', 'Ate'),
('CLI-00045', 'Gloria Patricia Soto Cárdenas', 'Cliente normal', '74192830', '924234098', 'San Juan de Lurigancho'),
('CLI-00046', 'Zapatería Chic & Sport', 'Cliente normal', '43102938', '935345187', 'Surquillo'),
('CLI-00047', 'Calzado Militar y Seguridad S.A.C.', 'Cliente corporativo', '20602938471', '946456276', 'Puente Piedra'),
('CLI-00048', 'César Augusto Farfán Morales', 'Cliente normal', '10918273', '957567365', 'Comas'),
('CLI-00049', 'Textil y Cuero Universal S.A.C.', 'Cliente corporativo', '20582910293', '968678454', 'La Victoria'),
('CLI-00050', 'Miriam Raquel Córdova Lara', 'Cliente normal', '46019283', '979789543', 'Los Olivos'),
('CLI-00051', 'Industrial Zapatera del Rimac E.I.R.L.', 'Cliente corporativo', '20748192039', '980890632', 'Rímac'),
('CLI-00052', 'Walter Enrique Solís Barreto', 'Cliente normal', '07918273', '991901721', 'Independencia'),
('CLI-00053', 'Diseños & Modelos Urban Shoes S.A.C.', 'Cliente corporativo', '20601928475', '914123810', 'San Martín de Porres'),
('CLI-00054', 'Sonia Maribel Tello Vargas', 'Cliente normal', '75019283', '925234909', 'San Juan de Lurigancho'),
('CLI-00055', 'Importadora & Exportadora Suelitas S.A.', 'Cliente corporativo', '20529182734', '936345098', 'Ate'),
('CLI-00056', 'Rubén Darío Navarro Cáceres', 'Cliente normal', '41920394', '947456187', 'Carabayllo'),
('CLI-00057', 'Calzados Imperio de Gamarra S.A.C.', 'Cliente corporativo', '20759182734', '958567276', 'La Victoria'),
('CLI-00058', 'Verónica Lucía Quintana Díaz', 'Cliente normal', '08102938', '969678365', 'El Agustino'),
('CLI-00059', 'Fábrica de Zapatos Huascarán S.A.C.', 'Cliente corporativo', '20491827365', '970789454', 'Comas'),
('CLI-00060', 'Gonzalo Martín Paredes Ríos', 'Cliente normal', '47019283', '981890543', 'Villa El Salvador'),
('CLI-00061', 'Corporación Cuero & Suela Andina S.A.', 'Cliente corporativo', '20603847561', '992901632', 'San Juan de Lurigancho'),
('CLI-00062', 'Carmen Rosa Vilchez Mendoza', 'Cliente normal', '76019283', '915123721', 'Los Olivos'),
('CLI-00063', 'Zapatillas Fénix Urban E.I.R.L.', 'Cliente corporativo', '20539182736', '926234810', 'Ate'),
('CLI-00064', 'Javier Ignacio Benavides Soto', 'Cliente normal', '10819283', '937345909', 'Breña'),
('CLI-00065', 'Seguridad Minera & Calzado S.A.C.', 'Cliente corporativo', '20769182735', '948456098', 'Puente Piedra'),
('CLI-00066', 'Lorena Paola Aguirre Bravo', 'Cliente normal', '44019283', '959567187', 'San Juan de Miraflores'),
('CLI-00067', 'Taller Zapatería Los Diamantes', 'Cliente normal', '09019283', '960678276', 'Santa Anita'),
('CLI-00068', 'Grupo Comercial Calzamundo S.A.C.', 'Cliente corporativo', '20604958671', '971789365', 'San Martín de Porres'),
('CLI-00069', 'Felipe Santiago Carrillo Ramos', 'Cliente normal', '48019283', '982890454', 'Comas'),
('CLI-00070', 'Calzados Premier Perú E.I.R.L.', 'Cliente corporativo', '20549182735', '993901543', 'Los Olivos'),
('CLI-00071', 'Nelly Haydée Palacios Huamán', 'Cliente normal', '77019283', '916123632', 'Rímac'),
('CLI-00072', 'Calzados Cóndor Blanco S.A.C.', 'Cliente corporativo', '20779182736', '927234721', 'San Juan de Lurigancho'),
('CLI-00073', 'Hugo Leonardo Gamboa Cruz', 'Cliente normal', '42910293', '938345810', 'El Agustino'),
('CLI-00074', 'Zapatería El Dorado de Gamarra', 'Cliente normal', '08291029', '949456909', 'La Victoria'),
('CLI-00075', 'Calzados Titán Industrial S.A.C.', 'Cliente corporativo', '20605968741', '950567098', 'Villa El Salvador');
GO

-- ===================================================================
-- 2. INSERCIÓN DE 10 PRODUCTOS CON SUS 6 TALLAS (60 REGISTROS)
--    (Tallas: 37, 38, 39, 40, 41, 42 - A mayor talla sube precio/costo)
-- ===================================================================

INSERT INTO Producto (id_producto, nombre_producto, tipo_suela, talla, stock, costo_fabricacion, precio, categoria, material) VALUES
-- Producto 1: Suela Runner Pro (Deportivo / PU)
('PRO-00001', 'Suela Runner Pro Air', 'Suela de PU', '37', 500, 11.50, 22.00, 'Deportivo', 'PU'),
('PRO-00002', 'Suela Runner Pro Air', 'Suela de PU', '38', 500, 12.00, 23.00, 'Deportivo', 'PU'),
('PRO-00003', 'Suela Runner Pro Air', 'Suela de PU', '39', 500, 12.50, 24.00, 'Deportivo', 'PU'),
('PRO-00004', 'Suela Runner Pro Air', 'Suela de PU', '40', 500, 13.00, 25.00, 'Deportivo', 'PU'),
('PRO-00005', 'Suela Runner Pro Air', 'Suela de PU', '41', 500, 13.50, 26.00, 'Deportivo', 'PU'),
('PRO-00006', 'Suela Runner Pro Air', 'Suela de PU', '42', 500, 14.00, 27.00, 'Deportivo', 'PU'),

-- Producto 2: Suela Vulcano Extrema (Seguridad / Caucho Nitrilo)
('PRO-00007', 'Suela Vulcano Extrema Heavy', 'Suela de Nitrilo', '37', 400, 24.00, 44.00, 'Seguridad', 'Caucho Nitrilo'),
('PRO-00008', 'Suela Vulcano Extrema Heavy', 'Suela de Nitrilo', '38', 400, 25.00, 46.00, 'Seguridad', 'Caucho Nitrilo'),
('PRO-00009', 'Suela Vulcano Extrema Heavy', 'Suela de Nitrilo', '39', 400, 26.00, 48.00, 'Seguridad', 'Caucho Nitrilo'),
('PRO-00010', 'Suela Vulcano Extrema Heavy', 'Suela de Nitrilo', '40', 400, 27.00, 50.00, 'Seguridad', 'Caucho Nitrilo'),
('PRO-00011', 'Suela Vulcano Extrema Heavy', 'Suela de Nitrilo', '41', 400, 28.50, 52.00, 'Seguridad', 'Caucho Nitrilo'),
('PRO-00012', 'Suela Vulcano Extrema Heavy', 'Suela de Nitrilo', '42', 400, 30.00, 55.00, 'Seguridad', 'Caucho Nitrilo'),

-- Producto 3: Suela City Walk Flex (Casual / TPU)
('PRO-00013', 'Suela City Walk Flex', 'Suela de TPU', '37', 600, 10.00, 20.00, 'Casual', 'Caucho Natural'),
('PRO-00014', 'Suela City Walk Flex', 'Suela de TPU', '38', 600, 10.50, 21.00, 'Casual', 'Caucho Natural'),
('PRO-00015', 'Suela City Walk Flex', 'Suela de TPU', '39', 600, 11.00, 22.00, 'Casual', 'Caucho Natural'),
('PRO-00016', 'Suela City Walk Flex', 'Suela de TPU', '40', 600, 11.50, 23.00, 'Casual', 'Caucho Natural'),
('PRO-00017', 'Suela City Walk Flex', 'Suela de TPU', '41', 600, 12.00, 24.00, 'Casual', 'Caucho Natural'),
('PRO-00018', 'Suela City Walk Flex', 'Suela de TPU', '42', 600, 12.50, 25.00, 'Casual', 'Caucho Natural'),

-- Producto 4: Suela Oxford Classic (Formal / PVC)
('PRO-00019', 'Suela Oxford Classic Dress', 'Suela de PVC', '37', 550, 8.00, 16.00, 'Formal', 'Suela de PVC'),
('PRO-00020', 'Suela Oxford Classic Dress', 'Suela de PVC', '38', 550, 8.50, 17.00, 'Formal', 'Suela de PVC'),
('PRO-00021', 'Suela Oxford Classic Dress', 'Suela de PVC', '39', 550, 9.00, 18.00, 'Formal', 'Suela de PVC'),
('PRO-00022', 'Suela Oxford Classic Dress', 'Suela de PVC', '40', 550, 9.50, 19.00, 'Formal', 'Suela de PVC'),
('PRO-00023', 'Suela Oxford Classic Dress', 'Suela de PVC', '41', 550, 10.00, 20.00, 'Formal', 'Suela de PVC'),
('PRO-00024', 'Suela Oxford Classic Dress', 'Suela de PVC', '42', 550, 10.50, 21.00, 'Formal', 'Suela de PVC'),

-- Producto 5: Suela Max Armor Dieléctrica (Seguridad / PU doble densidad)
('PRO-00025', 'Suela Max Armor Dieléctrica', 'PU doble densidad', '37', 350, 26.00, 48.00, 'Seguridad', 'PU doble densidad'),
('PRO-00026', 'Suela Max Armor Dieléctrica', 'PU doble densidad', '38', 350, 27.00, 50.00, 'Seguridad', 'PU doble densidad'),
('PRO-00027', 'Suela Max Armor Dieléctrica', 'PU doble densidad', '39', 350, 28.00, 52.00, 'Seguridad', 'PU doble densidad'),
('PRO-00028', 'Suela Max Armor Dieléctrica', 'PU doble densidad', '40', 350, 29.50, 55.00, 'Seguridad', 'PU doble densidad'),
('PRO-00029', 'Suela Max Armor Dieléctrica', 'PU doble densidad', '41', 350, 31.00, 58.00, 'Seguridad', 'PU doble densidad'),
('PRO-00030', 'Suela Max Armor Dieléctrica', 'PU doble densidad', '42', 350, 32.50, 60.00, 'Seguridad', 'PU doble densidad'),

-- Producto 6: Suela Skate Grip Street (Urbano / Goma Vulcanizada)
('PRO-00031', 'Suela Skate Grip Street', 'Suela de Goma', '37', 450, 13.00, 25.00, 'Urbano', 'Caucho Natural'),
('PRO-00032', 'Suela Skate Grip Street', 'Suela de Goma', '38', 450, 13.50, 26.00, 'Urbano', 'Caucho Natural'),
('PRO-00033', 'Suela Skate Grip Street', 'Suela de Goma', '39', 450, 14.00, 27.00, 'Urbano', 'Caucho Natural'),
('PRO-00034', 'Suela Skate Grip Street', 'Suela de Goma', '40', 450, 14.50, 28.00, 'Urbano', 'Caucho Natural'),
('PRO-00035', 'Suela Skate Grip Street', 'Suela de Goma', '41', 450, 15.00, 29.00, 'Urbano', 'Caucho Natural'),
('PRO-00036', 'Suela Skate Grip Street', 'Suela de Goma', '42', 450, 15.50, 30.00, 'Urbano', 'Caucho Natural'),

-- Producto 7: Suela Trekking Master 4x4 (Industrial / Goma Alta Tracción)
('PRO-00037', 'Suela Trekking Master 4x4', 'Suela de Goma', '37', 400, 20.00, 38.00, 'Industrial', 'Caucho Natural'),
('PRO-00038', 'Suela Trekking Master 4x4', 'Suela de Goma', '38', 400, 21.00, 40.00, 'Industrial', 'Caucho Natural'),
('PRO-00039', 'Suela Trekking Master 4x4', 'Suela de Goma', '39', 400, 22.00, 42.00, 'Industrial', 'Caucho Natural'),
('PRO-00040', 'Suela Trekking Master 4x4', 'Suela de Goma', '40', 400, 23.00, 44.00, 'Industrial', 'Caucho Natural'),
('PRO-00041', 'Suela Trekking Master 4x4', 'Suela de Goma', '41', 400, 24.50, 46.00, 'Industrial', 'Caucho Natural'),
('PRO-00042', 'Suela Trekking Master 4x4', 'Suela de Goma', '42', 400, 26.00, 49.00, 'Industrial', 'Caucho Natural'),

-- Producto 8: Suela Mocasín Confort Soft (Casual / PU)
('PRO-00043', 'Suela Mocasín Confort Soft', 'Suela de PU', '37', 500, 9.50, 19.00, 'Casual', 'PU'),
('PRO-00044', 'Suela Mocasín Confort Soft', 'Suela de PU', '38', 500, 10.00, 20.00, 'Casual', 'PU'),
('PRO-00045', 'Suela Mocasín Confort Soft', 'Suela de PU', '39', 500, 10.50, 21.00, 'Casual', 'PU'),
('PRO-00046', 'Suela Mocasín Confort Soft', 'Suela de PU', '40', 500, 11.00, 22.00, 'Casual', 'PU'),
('PRO-00047', 'Suela Mocasín Confort Soft', 'Suela de PU', '41', 500, 11.50, 23.00, 'Casual', 'PU'),
('PRO-00048', 'Suela Mocasín Confort Soft', 'Suela de PU', '42', 500, 12.00, 24.00, 'Casual', 'PU'),

-- Producto 9: Suela Botín Minero Titan (Seguridad / Nitrilo Antideslizante)
('PRO-00049', 'Suela Botín Minero Titan', 'Suela de Nitrilo', '37', 300, 28.00, 54.00, 'Seguridad', 'Caucho Nitrilo'),
('PRO-00050', 'Suela Botín Minero Titan', 'Suela de Nitrilo', '38', 300, 29.00, 56.00, 'Seguridad', 'Caucho Nitrilo'),
('PRO-00051', 'Suela Botín Minero Titan', 'Suela de Nitrilo', '39', 300, 30.50, 58.00, 'Seguridad', 'Caucho Nitrilo'),
('PRO-00052', 'Suela Botín Minero Titan', 'Suela de Nitrilo', '40', 300, 32.00, 61.00, 'Seguridad', 'Caucho Nitrilo'),
('PRO-00053', 'Suela Botín Minero Titan', 'Suela de Nitrilo', '41', 300, 33.50, 64.00, 'Seguridad', 'Caucho Nitrilo'),
('PRO-00054', 'Suela Botín Minero Titan', 'Suela de Nitrilo', '42', 300, 35.00, 67.00, 'Seguridad', 'Caucho Nitrilo'),

-- Producto 10: Suela Urban Retro Sneaker (Urbano / TPU)
('PRO-00055', 'Suela Urban Retro Sneaker', 'Suela de TPU', '37', 500, 12.00, 24.00, 'Urbano', 'Caucho Natural'),
('PRO-00056', 'Suela Urban Retro Sneaker', 'Suela de TPU', '38', 500, 12.50, 25.00, 'Urbano', 'Caucho Natural'),
('PRO-00057', 'Suela Urban Retro Sneaker', 'Suela de TPU', '39', 500, 13.00, 26.00, 'Urbano', 'Caucho Natural'),
('PRO-00058', 'Suela Urban Retro Sneaker', 'Suela de TPU', '40', 500, 13.50, 27.00, 'Urbano', 'Caucho Natural'),
('PRO-00059', 'Suela Urban Retro Sneaker', 'Suela de TPU', '41', 500, 14.00, 28.00, 'Urbano', 'Caucho Natural'),
('PRO-00060', 'Suela Urban Retro Sneaker', 'Suela de TPU', '42', 500, 14.50, 29.00, 'Urbano', 'Caucho Natural');
GO

-- ===================================================================
-- 3. INSERCIÓN DE 12 VENDEDORES
-- ===================================================================

INSERT INTO Vendedor (id_vendedor, dni, nombre_vendedor, apellido, usuario, cargo) VALUES
('VEN-00001', '71829304', 'Carlos Alberto', 'Gómez Salazar', 'cgomez', 'Ejecutivo de Ventas Senior'),
('VEN-00002', '45892301', 'Mariana Lucía', 'Reyes Morales', 'mreyes', 'Asesor Comercial Mayorista'),
('VEN-00003', '70192837', 'Jorge Luis', 'Paredes Vento', 'jparedes', 'Atención al Cliente y Ventas'),
('VEN-00004', '42918273', 'Rosa Mercedes', 'Medina Farfán', 'rmedina', 'Ejecutivo de Ventas'),
('VEN-00005', '73819204', 'Alejandro Jesús', 'Castro Huamán', 'acastro', 'Asesor Técnico Comercial'),
('VEN-00006', '46192835', 'Claudia Janet', 'Villanueva Paz', 'cvillanueva', 'Ejecutivo de Cuentas Clave'),
('VEN-00007', '75918203', 'Diego Alonso', 'Navarro Torres', 'dnavarro', 'Asesor Comercial Minorista'),
('VEN-00008', '40192834', 'Patricia Elena', 'Sánchez Ramos', 'psanchez', 'Atención al Cliente Corporativo'),
('VEN-00009', '72819302', 'Fernando Javier', 'Ortega Silva', 'fortega', 'Ejecutivo de Ventas Regional'),
('VEN-00010', '48192031', 'Gabriela Sofía', 'Chávez Barreto', 'gchavez', 'Asesor Comercial'),
('VEN-00011', '76918273', 'Ricardo Manuel', 'Flores Dávila', 'rflores', 'Ejecutivo de Ventas Mayorista'),
('VEN-00012', '41920384', 'Vanessa Beatriz', 'Herrera Cruz', 'vherrera', 'Atención al Cliente');
GO

-- ===================================================================
-- 4. INSERCIÓN DE 4 MÉTODOS DE PAGO
-- ===================================================================

INSERT INTO MetodoPago (id_metodo_pago, nombre_metodo, tipo_pago) VALUES
('MTP-01', 'Efectivo', 'Contado'),
('MTP-02', 'Transferencia Bancaria', 'Bancario'),
('MTP-03', 'Yape / Plin', 'Digital'),
('MTP-04', 'Tarjeta de Crédito / Débito', 'Bancario');
GO

-- ===================================================================
-- 5. INSERCIÓN DE 160 ventas
-- ===================================================================

INSERT INTO Venta (id_venta, fecha, id_cliente, id_vendedor, id_metodo_pago, estado) VALUES
('VNT-00001', '2025-01-12', 'CLI-00001', 'VEN-00001', 'MTP-02', 'COMPLETADO'),
('VNT-00002', '2025-01-15', 'CLI-00003', 'VEN-00003', 'MTP-03', 'COMPLETADO'),
('VNT-00003', '2025-01-19', 'CLI-00006', 'VEN-00002', 'MTP-02', 'COMPLETADO'),
('VNT-00004', '2025-01-24', 'CLI-00007', 'VEN-00004', 'MTP-01', 'COMPLETADO'),
('VNT-00005', '2025-02-02', 'CLI-00002', 'VEN-00005', 'MTP-04', 'COMPLETADO'),
('VNT-00006', '2025-02-07', 'CLI-00009', 'VEN-00003', 'MTP-03', 'COMPLETADO'),
('VNT-00007', '2025-02-14', 'CLI-00004', 'VEN-00006', 'MTP-02', 'COMPLETADO'),
('VNT-00008', '2025-02-18', 'CLI-00011', 'VEN-00007', 'MTP-01', 'COMPLETADO'),
('VNT-00009', '2025-02-23', 'CLI-00008', 'VEN-00001', 'MTP-02', 'COMPLETADO'),
('VNT-00010', '2025-03-01', 'CLI-00014', 'VEN-00008', 'MTP-03', 'COMPLETADO'),
('VNT-00011', '2025-03-06', 'CLI-00010', 'VEN-00009', 'MTP-04', 'COMPLETADO'),
('VNT-00012', '2025-03-11', 'CLI-00017', 'VEN-00010', 'MTP-01', 'COMPLETADO'),
('VNT-00013', '2025-03-16', 'CLI-00013', 'VEN-00002', 'MTP-02', 'COMPLETADO'),
('VNT-00014', '2025-03-21', 'CLI-00020', 'VEN-00011', 'MTP-03', 'COMPLETADO'),
('VNT-00015', '2025-03-27', 'CLI-00016', 'VEN-00005', 'MTP-02', 'COMPLETADO'),
('VNT-00016', '2025-04-02', 'CLI-00022', 'VEN-00012', 'MTP-01', 'COMPLETADO'),
('VNT-00017', '2025-04-08', 'CLI-00019', 'VEN-00004', 'MTP-04', 'COMPLETADO'),
('VNT-00018', '2025-04-13', 'CLI-00024', 'VEN-00007', 'MTP-03', 'COMPLETADO'),
('VNT-00019', '2025-04-19', 'CLI-00021', 'VEN-00001', 'MTP-02', 'COMPLETADO'),
('VNT-00020', '2025-04-25', 'CLI-00028', 'VEN-00006', 'MTP-01', 'COMPLETADO'),
('VNT-00021', '2025-05-02', 'CLI-00023', 'VEN-00009', 'MTP-02', 'COMPLETADO'),
('VNT-00022', '2025-05-07', 'CLI-00030', 'VEN-00008', 'MTP-03', 'COMPLETADO'),
('VNT-00023', '2025-05-13', 'CLI-00025', 'VEN-00011', 'MTP-04', 'COMPLETADO'),
('VNT-00024', '2025-05-18', 'CLI-00032', 'VEN-00003', 'MTP-01', 'COMPLETADO'),
('VNT-00025', '2025-05-24', 'CLI-00027', 'VEN-00010', 'MTP-02', 'COMPLETADO'),
('VNT-00026', '2025-05-30', 'CLI-00035', 'VEN-00012', 'MTP-03', 'COMPLETADO'),
('VNT-00027', '2025-06-04', 'CLI-00029', 'VEN-00002', 'MTP-02', 'COMPLETADO'),
('VNT-00028', '2025-06-09', 'CLI-00037', 'VEN-00005', 'MTP-01', 'COMPLETADO'),
('VNT-00029', '2025-06-15', 'CLI-00031', 'VEN-00004', 'MTP-04', 'COMPLETADO'),
('VNT-00030', '2025-06-20', 'CLI-00039', 'VEN-00007', 'MTP-03', 'COMPLETADO'),
('VNT-00031', '2025-06-26', 'CLI-00034', 'VEN-00001', 'MTP-02', 'COMPLETADO'),
('VNT-00032', '2025-07-02', 'CLI-00041', 'VEN-00008', 'MTP-01', 'COMPLETADO'),
('VNT-00033', '2025-07-07', 'CLI-00036', 'VEN-00006', 'MTP-02', 'COMPLETADO'),
('VNT-00034', '2025-07-13', 'CLI-00043', 'VEN-00011', 'MTP-03', 'COMPLETADO'),
('VNT-00035', '2025-07-18', 'CLI-00038', 'VEN-00009', 'MTP-04', 'COMPLETADO'),
('VNT-00036', '2025-07-24', 'CLI-00045', 'VEN-00010', 'MTP-01', 'COMPLETADO'),
('VNT-00037', '2025-07-30', 'CLI-00040', 'VEN-00002', 'MTP-02', 'COMPLETADO'),
('VNT-00038', '2025-08-04', 'CLI-00048', 'VEN-00012', 'MTP-03', 'COMPLETADO'),
('VNT-00039', '2025-08-10', 'CLI-00042', 'VEN-00003', 'MTP-02', 'COMPLETADO'),
('VNT-00040', '2025-08-15', 'CLI-00050', 'VEN-00005', 'MTP-01', 'COMPLETADO'),
('VNT-00041', '2025-08-21', 'CLI-00044', 'VEN-00007', 'MTP-04', 'COMPLETADO'),
('VNT-00042', '2025-08-26', 'CLI-00052', 'VEN-00004', 'MTP-03', 'COMPLETADO'),
('VNT-00043', '2025-09-01', 'CLI-00047', 'VEN-00001', 'MTP-02', 'COMPLETADO'),
('VNT-00044', '2025-09-06', 'CLI-00054', 'VEN-00008', 'MTP-01', 'COMPLETADO'),
('VNT-00045', '2025-09-12', 'CLI-00049', 'VEN-00010', 'MTP-02', 'COMPLETADO'),
('VNT-00046', '2025-09-17', 'CLI-00056', 'VEN-00006', 'MTP-03', 'COMPLETADO'),
('VNT-00047', '2025-09-23', 'CLI-00051', 'VEN-00011', 'MTP-04', 'COMPLETADO'),
('VNT-00048', '2025-09-28', 'CLI-00058', 'VEN-00009', 'MTP-01', 'COMPLETADO'),
('VNT-00049', '2025-10-03', 'CLI-00053', 'VEN-00002', 'MTP-02', 'COMPLETADO'),
('VNT-00050', '2025-10-09', 'CLI-00060', 'VEN-00012', 'MTP-03', 'COMPLETADO'),
('VNT-00051', '2025-10-14', 'CLI-00055', 'VEN-00005', 'MTP-02', 'COMPLETADO'),
('VNT-00052', '2025-10-20', 'CLI-00062', 'VEN-00003', 'MTP-01', 'COMPLETADO'),
('VNT-00053', '2025-10-25', 'CLI-00057', 'VEN-00007', 'MTP-04', 'COMPLETADO'),
('VNT-00054', '2025-10-31', 'CLI-00064', 'VEN-00004', 'MTP-03', 'COMPLETADO'),
('VNT-00055', '2025-11-05', 'CLI-00059', 'VEN-00001', 'MTP-02', 'COMPLETADO'),
('VNT-00056', '2025-11-11', 'CLI-00066', 'VEN-00008', 'MTP-01', 'COMPLETADO'),
('VNT-00057', '2025-11-16', 'CLI-00061', 'VEN-00010', 'MTP-02', 'COMPLETADO'),
('VNT-00058', '2025-11-22', 'CLI-00069', 'VEN-00006', 'MTP-03', 'COMPLETADO'),
('VNT-00059', '2025-11-27', 'CLI-00063', 'VEN-00011', 'MTP-04', 'COMPLETADO'),
('VNT-00060', '2025-12-02', 'CLI-00071', 'VEN-00009', 'MTP-01', 'COMPLETADO'),
('VNT-00061', '2025-12-08', 'CLI-00065', 'VEN-00002', 'MTP-02', 'COMPLETADO'),
('VNT-00062', '2025-12-13', 'CLI-00073', 'VEN-00012', 'MTP-03', 'COMPLETADO'),
('VNT-00063', '2025-12-19', 'CLI-00068', 'VEN-00005', 'MTP-02', 'COMPLETADO'),
('VNT-00064', '2025-12-24', 'CLI-00003', 'VEN-00007', 'MTP-01', 'COMPLETADO'),
('VNT-00065', '2025-12-29', 'CLI-00070', 'VEN-00001', 'MTP-04', 'COMPLETADO'),
('VNT-00066', '2026-01-04', 'CLI-00005', 'VEN-00004', 'MTP-03', 'COMPLETADO'),
('VNT-00067', '2026-01-09', 'CLI-00072', 'VEN-00008', 'MTP-02', 'COMPLETADO'),
('VNT-00068', '2026-01-15', 'CLI-00007', 'VEN-00003', 'MTP-01', 'COMPLETADO'),
('VNT-00069', '2026-01-20', 'CLI-00075', 'VEN-00010', 'MTP-02', 'COMPLETADO'),
('VNT-00070', '2026-01-26', 'CLI-00009', 'VEN-00006', 'MTP-03', 'COMPLETADO'),
('VNT-00071', '2026-01-31', 'CLI-00001', 'VEN-00011', 'MTP-04', 'COMPLETADO'),
('VNT-00072', '2026-02-05', 'CLI-00011', 'VEN-00002', 'MTP-01', 'COMPLETADO'),
('VNT-00073', '2026-02-10', 'CLI-00002', 'VEN-00009', 'MTP-02', 'COMPLETADO'),
('VNT-00074', '2026-02-16', 'CLI-00014', 'VEN-00005', 'MTP-03', 'COMPLETADO'),
('VNT-00075', '2026-02-21', 'CLI-00004', 'VEN-00012', 'MTP-02', 'COMPLETADO'),
('VNT-00076', '2026-02-26', 'CLI-00017', 'VEN-00001', 'MTP-01', 'COMPLETADO'),
('VNT-00077', '2026-03-03', 'CLI-00006', 'VEN-00007', 'MTP-04', 'COMPLETADO'),
('VNT-00078', '2026-03-08', 'CLI-00020', 'VEN-00004', 'MTP-03', 'COMPLETADO'),
('VNT-00079', '2026-03-14', 'CLI-00008', 'VEN-00010', 'MTP-02', 'COMPLETADO'),
('VNT-00080', '2026-03-19', 'CLI-00022', 'VEN-00008', 'MTP-01', 'COMPLETADO'),
('VNT-00081', '2026-03-24', 'CLI-00010', 'VEN-00003', 'MTP-02', 'COMPLETADO'),
('VNT-00082', '2026-03-30', 'CLI-00024', 'VEN-00006', 'MTP-03', 'COMPLETADO'),
('VNT-00083', '2026-04-04', 'CLI-00013', 'VEN-00011', 'MTP-04', 'COMPLETADO'),
('VNT-00084', '2026-04-09', 'CLI-00026', 'VEN-00002', 'MTP-01', 'COMPLETADO'),
('VNT-00085', '2026-04-15', 'CLI-00015', 'VEN-00009', 'MTP-02', 'COMPLETADO'),
('VNT-00086', '2026-04-20', 'CLI-00028', 'VEN-00005', 'MTP-03', 'COMPLETADO'),
('VNT-00087', '2026-04-25', 'CLI-00016', 'VEN-00012', 'MTP-02', 'COMPLETADO'),
('VNT-00088', '2026-04-30', 'CLI-00030', 'VEN-00001', 'MTP-01', 'COMPLETADO'),
('VNT-00089', '2026-05-06', 'CLI-00018', 'VEN-00007', 'MTP-04', 'COMPLETADO'),
('VNT-00090', '2026-05-11', 'CLI-00032', 'VEN-00004', 'MTP-03', 'COMPLETADO'),
('VNT-00091', '2026-05-16', 'CLI-00019', 'VEN-00010', 'MTP-02', 'COMPLETADO'),
('VNT-00092', '2026-05-22', 'CLI-00035', 'VEN-00008', 'MTP-01', 'COMPLETADO'),
('VNT-00093', '2026-05-27', 'CLI-00021', 'VEN-00003', 'MTP-02', 'COMPLETADO'),
('VNT-00094', '2026-06-01', 'CLI-00037', 'VEN-00006', 'MTP-03', 'COMPLETADO'),
('VNT-00095', '2026-06-06', 'CLI-00023', 'VEN-00011', 'MTP-04', 'COMPLETADO'),
('VNT-00096', '2026-06-12', 'CLI-00039', 'VEN-00002', 'MTP-01', 'COMPLETADO'),
('VNT-00097', '2026-06-17', 'CLI-00025', 'VEN-00009', 'MTP-02', 'COMPLETADO'),
('VNT-00098', '2026-06-22', 'CLI-00041', 'VEN-00005', 'MTP-03', 'COMPLETADO'),
('VNT-00099', '2026-06-27', 'CLI-00027', 'VEN-00012', 'MTP-02', 'COMPLETADO'),
('VNT-00100', '2026-07-02', 'CLI-00043', 'VEN-00001', 'MTP-01', 'COMPLETADO'),
('VNT-00101', '2026-07-07', 'CLI-00029', 'VEN-00007', 'MTP-04', 'COMPLETADO'),
('VNT-00102', '2026-07-13', 'CLI-00045', 'VEN-00004', 'MTP-03', 'COMPLETADO'),
('VNT-00103', '2026-07-18', 'CLI-00031', 'VEN-00010', 'MTP-02', 'COMPLETADO'),
('VNT-00104', '2026-07-23', 'CLI-00046', 'VEN-00008', 'MTP-01', 'COMPLETADO'),
('VNT-00105', '2026-07-28', 'CLI-00033', 'VEN-00003', 'MTP-02', 'COMPLETADO'),
('VNT-00106', '2026-08-02', 'CLI-00048', 'VEN-00006', 'MTP-03', 'COMPLETADO'),
('VNT-00107', '2026-08-07', 'CLI-00034', 'VEN-00011', 'MTP-04', 'COMPLETADO'),
('VNT-00108', '2026-08-12', 'CLI-00050', 'VEN-00002', 'MTP-01', 'COMPLETADO'),
('VNT-00109', '2026-08-17', 'CLI-00036', 'VEN-00009', 'MTP-02', 'COMPLETADO'),
('VNT-00110', '2026-08-22', 'CLI-00052', 'VEN-00005', 'MTP-03', 'COMPLETADO'),
('VNT-00111', '2026-08-27', 'CLI-00038', 'VEN-00012', 'MTP-02', 'COMPLETADO'),
('VNT-00112', '2026-09-01', 'CLI-00054', 'VEN-00001', 'MTP-01', 'COMPLETADO'),
('VNT-00113', '2026-09-05', 'CLI-00040', 'VEN-00007', 'MTP-04', 'COMPLETADO'),
('VNT-00114', '2026-09-08', 'CLI-00056', 'VEN-00004', 'MTP-03', 'COMPLETADO'),
('VNT-00115', '2026-09-12', 'CLI-00042', 'VEN-00010', 'MTP-02', 'COMPLETADO'),
('VNT-00116', '2026-09-15', 'CLI-00058', 'VEN-00008', 'MTP-01', 'COMPLETADO'),
('VNT-00117', '2026-09-18', 'CLI-00044', 'VEN-00003', 'MTP-02', 'COMPLETADO'),
('VNT-00118', '2026-09-21', 'CLI-00060', 'VEN-00006', 'MTP-03', 'COMPLETADO'),
('VNT-00119', '2026-09-24', 'CLI-00047', 'VEN-00011', 'MTP-04', 'COMPLETADO'),
('VNT-00120', '2026-09-27', 'CLI-00062', 'VEN-00002', 'MTP-01', 'COMPLETADO'),
('VNT-00121', '2026-09-30', 'CLI-00049', 'VEN-00009', 'MTP-02', 'COMPLETADO'),
('VNT-00122', '2026-10-02', 'CLI-00064', 'VEN-00005', 'MTP-03', 'COMPLETADO'),
('VNT-00123', '2026-10-04', 'CLI-00051', 'VEN-00012', 'MTP-02', 'COMPLETADO'),
('VNT-00124', '2026-10-06', 'CLI-00066', 'VEN-00001', 'MTP-01', 'COMPLETADO'),
('VNT-00125', '2026-10-08', 'CLI-00053', 'VEN-00007', 'MTP-04', 'COMPLETADO'),
('VNT-00126', '2026-10-10', 'CLI-00067', 'VEN-00004', 'MTP-03', 'COMPLETADO'),
('VNT-00127', '2025-02-11', 'CLI-00055', 'VEN-00010', 'MTP-02', 'COMPLETADO'),
('VNT-00128', '2025-02-27', 'CLI-00069', 'VEN-00008', 'MTP-01', 'COMPLETADO'),
('VNT-00129', '2025-03-14', 'CLI-00057', 'VEN-00003', 'MTP-02', 'COMPLETADO'),
('VNT-00130', '2025-03-29', 'CLI-00071', 'VEN-00006', 'MTP-03', 'COMPLETADO'),
('VNT-00131', '2025-04-16', 'CLI-00059', 'VEN-00011', 'MTP-04', 'COMPLETADO'),
('VNT-00132', '2025-05-04', 'CLI-00073', 'VEN-00002', 'MTP-01', 'COMPLETADO'),
('VNT-00133', '2025-05-21', 'CLI-00061', 'VEN-00009', 'MTP-02', 'COMPLETADO'),
('VNT-00134', '2025-06-08', 'CLI-00074', 'VEN-00005', 'MTP-03', 'COMPLETADO'),
('VNT-00135', '2025-06-24', 'CLI-00063', 'VEN-00012', 'MTP-02', 'COMPLETADO'),
('VNT-00136', '2025-07-11', 'CLI-00003', 'VEN-00001', 'MTP-01', 'COMPLETADO'),
('VNT-00137', '2025-07-27', 'CLI-00065', 'VEN-00007', 'MTP-04', 'COMPLETADO'),
('VNT-00138', '2025-08-14', 'CLI-00007', 'VEN-00004', 'MTP-03', 'COMPLETADO'),
('VNT-00139', '2025-08-30', 'CLI-00068', 'VEN-00010', 'MTP-02', 'COMPLETADO'),
('VNT-00140', '2025-09-15', 'CLI-00012', 'VEN-00008', 'MTP-01', 'COMPLETADO'),
('VNT-00141', '2025-10-01', 'CLI-00070', 'VEN-00003', 'MTP-02', 'COMPLETADO'),
('VNT-00142', '2025-10-18', 'CLI-00015', 'VEN-00006', 'MTP-03', 'COMPLETADO'),
('VNT-00143', '2025-11-03', 'CLI-00072', 'VEN-00011', 'MTP-04', 'COMPLETADO'),
('VNT-00144', '2025-11-19', 'CLI-00018', 'VEN-00002', 'MTP-01', 'COMPLETADO'),
('VNT-00145', '2025-12-06', 'CLI-00075', 'VEN-00009', 'MTP-02', 'COMPLETADO'),
('VNT-00146', '2025-12-22', 'CLI-00026', 'VEN-00005', 'MTP-03', 'COMPLETADO'),
('VNT-00147', '2026-01-11', 'CLI-00001', 'VEN-00012', 'MTP-02', 'COMPLETADO'),
('VNT-00148', '2026-01-28', 'CLI-00033', 'VEN-00001', 'MTP-01', 'COMPLETADO'),
('VNT-00149', '2026-02-14', 'CLI-00002', 'VEN-00007', 'MTP-04', 'COMPLETADO'),
('VNT-00150', '2026-03-02', 'CLI-00046', 'VEN-00004', 'MTP-03', 'COMPLETADO'),
('VNT-00151', '2026-03-18', 'CLI-00004', 'VEN-00010', 'MTP-02', 'COMPLETADO'),
('VNT-00152', '2026-04-05', 'CLI-00050', 'VEN-00008', 'MTP-01', 'COMPLETADO'),
('VNT-00153', '2026-04-22', 'CLI-00006', 'VEN-00003', 'MTP-02', 'COMPLETADO'),
('VNT-00154', '2026-05-09', 'CLI-00054', 'VEN-00006', 'MTP-03', 'COMPLETADO'),
('VNT-00155', '2026-05-25', 'CLI-00008', 'VEN-00011', 'MTP-04', 'COMPLETADO'),
('VNT-00156', '2026-06-11', 'CLI-00058', 'VEN-00002', 'MTP-01', 'COMPLETADO'),
('VNT-00157', '2026-06-28', 'CLI-00010', 'VEN-00009', 'MTP-02', 'COMPLETADO'),
('VNT-00158', '2026-07-15', 'CLI-00062', 'VEN-00005', 'MTP-03', 'COMPLETADO'),
('VNT-00159', '2026-08-01', 'CLI-00013', 'VEN-00012', 'MTP-02', 'COMPLETADO'),
('VNT-00160', '2026-08-20', 'CLI-00066', 'VEN-00001', 'MTP-01', 'COMPLETADO');
GO

-- ===================================================================
-- 6. INSERCIÓN DE LOS 210 detalles de venta
-- ===================================================================

INSERT INTO DetalleVenta (id_detalle, id_venta, id_producto, cantidad, precio_unitario, descuento) VALUES
('DET-00001', 'VNT-00001', 'PRO-00004', 36, 25.00, 135.00),
('DET-00002', 'VNT-00001', 'PRO-00005', 24, 26.00, 93.60),
('DET-00003', 'VNT-00002', 'PRO-00015', 4, 22.00, 0.00),
('DET-00004', 'VNT-00003', 'PRO-00010', 48, 50.00, 360.00),
('DET-00005', 'VNT-00003', 'PRO-00011', 24, 52.00, 187.20),
('DET-00006', 'VNT-00004', 'PRO-00020', 6, 17.00, 0.00),
('DET-00007', 'VNT-00005', 'PRO-00027', 36, 52.00, 280.80),
('DET-00008', 'VNT-00005', 'PRO-00028', 36, 55.00, 297.00),
('DET-00009', 'VNT-00006', 'PRO-00032', 8, 26.00, 0.00),
('DET-00010', 'VNT-00007', 'PRO-00039', 60, 42.00, 378.00),
('DET-00011', 'VNT-00008', 'PRO-00045', 5, 21.00, 0.00),
('DET-00012', 'VNT-00009', 'PRO-00051', 48, 58.00, 417.60),
('DET-00013', 'VNT-00009', 'PRO-00052', 48, 61.00, 439.20),
('DET-00014', 'VNT-00010', 'PRO-00057', 3, 26.00, 0.00),
('DET-00015', 'VNT-00011', 'PRO-00002', 24, 23.00, 82.80),
('DET-00016', 'VNT-00011', 'PRO-00003', 24, 24.00, 86.40),
('DET-00017', 'VNT-00012', 'PRO-00016', 6, 23.00, 0.00),
('DET-00018', 'VNT-00013', 'PRO-00022', 36, 19.00, 102.60),
('DET-00019', 'VNT-00014', 'PRO-00034', 4, 28.00, 0.00),
('DET-00020', 'VNT-00015', 'PRO-00008', 48, 46.00, 331.20),
('DET-00021', 'VNT-00015', 'PRO-00009', 36, 48.00, 259.20),
('DET-00022', 'VNT-00016', 'PRO-00044', 6, 20.00, 0.00),
('DET-00023', 'VNT-00017', 'PRO-00026', 24, 50.00, 180.00),
('DET-00024', 'VNT-00018', 'PRO-00058', 5, 27.00, 0.00),
('DET-00025', 'VNT-00019', 'PRO-00038', 48, 40.00, 288.00),
('DET-00026', 'VNT-00019', 'PRO-00040', 24, 44.00, 158.40),
('DET-00027', 'VNT-00020', 'PRO-00014', 12, 21.00, 37.80),
('DET-00028', 'VNT-00021', 'PRO-00053', 36, 64.00, 345.60),
('DET-00029', 'VNT-00022', 'PRO-00006', 4, 27.00, 0.00),
('DET-00030', 'VNT-00023', 'PRO-00029', 60, 58.00, 522.00),
('DET-00031', 'VNT-00023', 'PRO-00030', 24, 60.00, 216.00),
('DET-00032', 'VNT-00024', 'PRO-00021', 8, 18.00, 0.00),
('DET-00033', 'VNT-00025', 'PRO-00012', 36, 55.00, 297.00),
('DET-00034', 'VNT-00026', 'PRO-00035', 5, 29.00, 0.00),
('DET-00035', 'VNT-00027', 'PRO-00041', 48, 46.00, 331.20),
('DET-00036', 'VNT-00027', 'PRO-00042', 24, 49.00, 176.40),
('DET-00037', 'VNT-00028', 'PRO-00047', 6, 23.00, 0.00),
('DET-00038', 'VNT-00029', 'PRO-00004', 36, 25.00, 135.00),
('DET-00039', 'VNT-00030', 'PRO-00017', 4, 24.00, 0.00),
('DET-00040', 'VNT-00031', 'PRO-00054', 48, 67.00, 482.40),
('DET-00041', 'VNT-00031', 'PRO-00053', 24, 64.00, 230.40),
('DET-00042', 'VNT-00032', 'PRO-00023', 8, 20.00, 0.00),
('DET-00043', 'VNT-00033', 'PRO-00010', 36, 50.00, 270.00),
('DET-00044', 'VNT-00034', 'PRO-00033', 6, 27.00, 0.00),
('DET-00045', 'VNT-00035', 'PRO-00028', 60, 55.00, 495.00),
('DET-00046', 'VNT-00035', 'PRO-00027', 24, 52.00, 187.20),
('DET-00047', 'VNT-00036', 'PRO-00046', 4, 22.00, 0.00),
('DET-00048', 'VNT-00037', 'PRO-00039', 48, 42.00, 302.40),
('DET-00049', 'VNT-00038', 'PRO-00059', 8, 28.00, 0.00),
('DET-00050', 'VNT-00039', 'PRO-00003', 24, 24.00, 86.40),
('DET-00051', 'VNT-00039', 'PRO-00005', 24, 26.00, 93.60),
('DET-00052', 'VNT-00040', 'PRO-00018', 6, 25.00, 0.00),
('DET-00053', 'VNT-00041', 'PRO-00052', 36, 61.00, 329.40),
('DET-00054', 'VNT-00042', 'PRO-00024', 5, 21.00, 0.00),
('DET-00055', 'VNT-00043', 'PRO-00011', 48, 52.00, 374.40),
('DET-00056', 'VNT-00043', 'PRO-00012', 24, 55.00, 198.00),
('DET-00057', 'VNT-00044', 'PRO-00036', 6, 30.00, 0.00),
('DET-00058', 'VNT-00045', 'PRO-00025', 24, 48.00, 172.80),
('DET-00059', 'VNT-00046', 'PRO-00048', 4, 24.00, 0.00),
('DET-00060', 'VNT-00047', 'PRO-00040', 60, 44.00, 396.00),
('DET-00061', 'VNT-00047', 'PRO-00038', 36, 40.00, 216.00),
('DET-00062', 'VNT-00048', 'PRO-00060', 6, 29.00, 0.00),
('DET-00063', 'VNT-00049', 'PRO-00001', 24, 22.00, 79.20),
('DET-00064', 'VNT-00050', 'PRO-00013', 8, 20.00, 0.00),
('DET-00065', 'VNT-00051', 'PRO-00050', 36, 56.00, 302.40),
('DET-00066', 'VNT-00051', 'PRO-00049', 24, 54.00, 194.40),
('DET-00067', 'VNT-00052', 'PRO-00019', 4, 16.00, 0.00),
('DET-00068', 'VNT-00053', 'PRO-00030', 48, 60.00, 432.00),
('DET-00069', 'VNT-00054', 'PRO-00031', 6, 25.00, 0.00),
('DET-00070', 'VNT-00055', 'PRO-00042', 36, 49.00, 264.60),
('DET-00071', 'VNT-00055', 'PRO-00041', 24, 46.00, 165.60),
('DET-00072', 'VNT-00056', 'PRO-00043', 5, 19.00, 0.00),
('DET-00073', 'VNT-00057', 'PRO-00007', 48, 44.00, 316.80),
('DET-00074', 'VNT-00058', 'PRO-00055', 8, 24.00, 0.00),
('DET-00075', 'VNT-00059', 'PRO-00027', 36, 52.00, 280.80),
('DET-00076', 'VNT-00059', 'PRO-00026', 24, 50.00, 180.00),
('DET-00077', 'VNT-00060', 'PRO-00015', 6, 22.00, 0.00),
('DET-00078', 'VNT-00061', 'PRO-00037', 48, 38.00, 273.60),
('DET-00079', 'VNT-00062', 'PRO-00021', 4, 18.00, 0.00),
('DET-00080', 'VNT-00063', 'PRO-00051', 60, 58.00, 522.00),
('DET-00081', 'VNT-00063', 'PRO-00052', 24, 61.00, 219.60),
('DET-00082', 'VNT-00064', 'PRO-00032', 8, 26.00, 0.00),
('DET-00083', 'VNT-00065', 'PRO-00009', 36, 48.00, 259.20),
('DET-00084', 'VNT-00066', 'PRO-00045', 12, 21.00, 37.80),
('DET-00085', 'VNT-00067', 'PRO-00029', 48, 58.00, 417.60),
('DET-00086', 'VNT-00067', 'PRO-00028', 24, 55.00, 198.00),
('DET-00087', 'VNT-00068', 'PRO-00056', 5, 25.00, 0.00),
('DET-00088', 'VNT-00069', 'PRO-00054', 36, 67.00, 361.80),
('DET-00089', 'VNT-00070', 'PRO-00002', 6, 23.00, 0.00),
('DET-00090', 'VNT-00071', 'PRO-00005', 48, 26.00, 187.20),
('DET-00091', 'VNT-00071', 'PRO-00006', 24, 27.00, 97.20),
('DET-00092', 'VNT-00072', 'PRO-00017', 4, 24.00, 0.00),
('DET-00093', 'VNT-00073', 'PRO-00025', 36, 48.00, 259.20),
('DET-00094', 'VNT-00074', 'PRO-00023', 8, 20.00, 0.00),
('DET-00095', 'VNT-00075', 'PRO-00039', 60, 42.00, 378.00),
('DET-00096', 'VNT-00075', 'PRO-00040', 24, 44.00, 158.40),
('DET-00097', 'VNT-00076', 'PRO-00034', 6, 28.00, 0.00),
('DET-00098', 'VNT-00077', 'PRO-00010', 48, 50.00, 360.00),
('DET-00099', 'VNT-00078', 'PRO-00047', 4, 23.00, 0.00),
('DET-00100', 'VNT-00079', 'PRO-00053', 36, 64.00, 345.60),
('DET-00101', 'VNT-00079', 'PRO-00054', 24, 67.00, 241.20),
('DET-00102', 'VNT-00080', 'PRO-00059', 8, 28.00, 0.00),
('DET-00103', 'VNT-00081', 'PRO-00004', 24, 25.00, 90.00),
('DET-00104', 'VNT-00082', 'PRO-00014', 6, 21.00, 0.00),
('DET-00105', 'VNT-00083', 'PRO-00020', 48, 17.00, 122.40),
('DET-00106', 'VNT-00083', 'PRO-00022', 24, 19.00, 68.40),
('DET-00107', 'VNT-00084', 'PRO-00035', 5, 29.00, 0.00),
('DET-00108', 'VNT-00085', 'PRO-00046', 10, 22.00, 0.00),
('DET-00109', 'VNT-00086', 'PRO-00001', 6, 22.00, 0.00),
('DET-00110', 'VNT-00087', 'PRO-00008', 36, 46.00, 248.40),
('DET-00111', 'VNT-00087', 'PRO-00012', 24, 55.00, 198.00),
('DET-00112', 'VNT-00088', 'PRO-00018', 4, 25.00, 0.00),
('DET-00113', 'VNT-00089', 'PRO-00024', 8, 21.00, 0.00),
('DET-00114', 'VNT-00090', 'PRO-00031', 6, 25.00, 0.00),
('DET-00115', 'VNT-00091', 'PRO-00026', 48, 50.00, 360.00),
('DET-00116', 'VNT-00091', 'PRO-00027', 24, 52.00, 187.20),
('DET-00117', 'VNT-00092', 'PRO-00044', 5, 20.00, 0.00),
('DET-00118', 'VNT-00093', 'PRO-00037', 36, 38.00, 205.20),
('DET-00119', 'VNT-00094', 'PRO-00057', 4, 26.00, 0.00),
('DET-00120', 'VNT-00095', 'PRO-00050', 60, 56.00, 504.00),
('DET-00121', 'VNT-00095', 'PRO-00049', 24, 54.00, 194.40),
('DET-00122', 'VNT-00096', 'PRO-00003', 8, 24.00, 0.00),
('DET-00123', 'VNT-00097', 'PRO-00030', 36, 60.00, 324.00),
('DET-00124', 'VNT-00098', 'PRO-00016', 6, 23.00, 0.00),
('DET-00125', 'VNT-00099', 'PRO-00042', 48, 49.00, 352.80),
('DET-00126', 'VNT-00099', 'PRO-00041', 24, 46.00, 165.60),
('DET-00127', 'VNT-00100', 'PRO-00023', 4, 20.00, 0.00),
('DET-00128', 'VNT-00101', 'PRO-00040', 36, 44.00, 237.60),
('DET-00129', 'VNT-00102', 'PRO-00033', 6, 27.00, 0.00),
('DET-00130', 'VNT-00103', 'PRO-00006', 48, 27.00, 194.40),
('DET-00131', 'VNT-00103', 'PRO-00005', 24, 26.00, 93.60),
('DET-00132', 'VNT-00104', 'PRO-00048', 8, 24.00, 0.00),
('DET-00133', 'VNT-00105', 'PRO-00019', 12, 16.00, 28.80),
('DET-00134', 'VNT-00106', 'PRO-00058', 5, 27.00, 0.00),
('DET-00135', 'VNT-00107', 'PRO-00054', 48, 67.00, 482.40),
('DET-00136', 'VNT-00107', 'PRO-00053', 24, 64.00, 230.40),
('DET-00137', 'VNT-00108', 'PRO-00015', 6, 22.00, 0.00),
('DET-00138', 'VNT-00109', 'PRO-00011', 36, 52.00, 280.80),
('DET-00139', 'VNT-00110', 'PRO-00022', 4, 19.00, 0.00),
('DET-00140', 'VNT-00111', 'PRO-00028', 60, 55.00, 495.00),
('DET-00141', 'VNT-00111', 'PRO-00029', 24, 58.00, 208.80),
('DET-00142', 'VNT-00112', 'PRO-00036', 8, 30.00, 0.00),
('DET-00143', 'VNT-00113', 'PRO-00038', 36, 40.00, 216.00),
('DET-00144', 'VNT-00114', 'PRO-00043', 6, 19.00, 0.00),
('DET-00145', 'VNT-00115', 'PRO-00051', 48, 58.00, 417.60),
('DET-00146', 'VNT-00115', 'PRO-00052', 24, 61.00, 219.60),
('DET-00147', 'VNT-00116', 'PRO-00055', 4, 24.00, 0.00),
('DET-00148', 'VNT-00117', 'PRO-00007', 36, 44.00, 237.60),
('DET-00149', 'VNT-00118', 'PRO-00013', 6, 20.00, 0.00),
('DET-00150', 'VNT-00119', 'PRO-00030', 48, 60.00, 432.00),
('DET-00151', 'VNT-00119', 'PRO-00027', 24, 52.00, 187.20),
('DET-00152', 'VNT-00120', 'PRO-00020', 8, 17.00, 0.00),
('DET-00153', 'VNT-00121', 'PRO-00041', 36, 46.00, 248.40),
('DET-00154', 'VNT-00122', 'PRO-00032', 4, 26.00, 0.00),
('DET-00155', 'VNT-00123', 'PRO-00049', 48, 54.00, 388.80),
('DET-00156', 'VNT-00123', 'PRO-00050', 24, 56.00, 201.60),
('DET-00157', 'VNT-00124', 'PRO-00045', 6, 21.00, 0.00),
('DET-00158', 'VNT-00125', 'PRO-00004', 36, 25.00, 135.00),
('DET-00159', 'VNT-00126', 'PRO-00056', 8, 25.00, 0.00),
('DET-00160', 'VNT-00127', 'PRO-00010', 48, 50.00, 360.00),
('DET-00161', 'VNT-00127', 'PRO-00009', 24, 48.00, 172.80),
('DET-00162', 'VNT-00128', 'PRO-00017', 5, 24.00, 0.00),
('DET-00163', 'VNT-00129', 'PRO-00026', 36, 50.00, 270.00),
('DET-00164', 'VNT-00130', 'PRO-00021', 6, 18.00, 0.00),
('DET-00165', 'VNT-00131', 'PRO-00039', 48, 42.00, 302.40),
('DET-00166', 'VNT-00131', 'PRO-00040', 24, 44.00, 158.40),
('DET-00167', 'VNT-00132', 'PRO-00034', 4, 28.00, 0.00),
('DET-00168', 'VNT-00133', 'PRO-00052', 36, 61.00, 329.40),
('DET-00169', 'VNT-00134', 'PRO-00047', 8, 23.00, 0.00),
('DET-00170', 'VNT-00135', 'PRO-00001', 36, 22.00, 118.80),
('DET-00171', 'VNT-00135', 'PRO-00003', 24, 24.00, 86.40),
('DET-00172', 'VNT-00136', 'PRO-00014', 6, 21.00, 0.00),
('DET-00173', 'VNT-00137', 'PRO-00028', 48, 55.00, 396.00),
('DET-00174', 'VNT-00138', 'PRO-00059', 4, 28.00, 0.00),
('DET-00175', 'VNT-00139', 'PRO-00042', 36, 49.00, 264.60),
('DET-00176', 'VNT-00139', 'PRO-00041', 24, 46.00, 165.60),
('DET-00177', 'VNT-00140', 'PRO-00018', 6, 25.00, 0.00),
('DET-00178', 'VNT-00141', 'PRO-00008', 48, 46.00, 331.20),
('DET-00179', 'VNT-00142', 'PRO-00023', 8, 20.00, 0.00),
('DET-00180', 'VNT-00143', 'PRO-00054', 48, 67.00, 482.40),
('DET-00181', 'VNT-00143', 'PRO-00053', 24, 64.00, 230.40),
('DET-00182', 'VNT-00144', 'PRO-00031', 4, 25.00, 0.00),
('DET-00183', 'VNT-00145', 'PRO-00029', 36, 58.00, 313.20),
('DET-00184', 'VNT-00146', 'PRO-00044', 6, 20.00, 0.00),
('DET-00185', 'VNT-00147', 'PRO-00005', 48, 26.00, 187.20),
('DET-00186', 'VNT-00147', 'PRO-00006', 24, 27.00, 97.20),
('DET-00187', 'VNT-00148', 'PRO-00057', 5, 26.00, 0.00),
('DET-00188', 'VNT-00149', 'PRO-00037', 36, 38.00, 205.20),
('DET-00189', 'VNT-00150', 'PRO-00015', 6, 22.00, 0.00),
('DET-00190', 'VNT-00151', 'PRO-00050', 48, 56.00, 403.20),
('DET-00191', 'VNT-00151', 'PRO-00051', 24, 58.00, 208.80),
('DET-00192', 'VNT-00152', 'PRO-00033', 4, 27.00, 0.00),
('DET-00193', 'VNT-00153', 'PRO-00011', 36, 52.00, 280.80),
('DET-00194', 'VNT-00154', 'PRO-00048', 8, 24.00, 0.00),
('DET-00195', 'VNT-00155', 'PRO-00025', 48, 48.00, 345.60),
('DET-00196', 'VNT-00155', 'PRO-00027', 24, 52.00, 187.20),
('DET-00197', 'VNT-00156', 'PRO-00055', 6, 24.00, 0.00),
('DET-00198', 'VNT-00157', 'PRO-00038', 36, 40.00, 216.00),
('DET-00199', 'VNT-00158', 'PRO-00022', 4, 19.00, 0.00),
('DET-00200', 'VNT-00159', 'PRO-00007', 48, 44.00, 316.80),
('DET-00201', 'VNT-00159', 'PRO-00009', 24, 48.00, 172.80),
('DET-00202', 'VNT-00160', 'PRO-00035', 6, 29.00, 0.00),
-- Líneas multidetalle adicionales para completar la variedad comercial:
('DET-00203', 'VNT-00010', 'PRO-00058', 2, 27.00, 0.00),
('DET-00204', 'VNT-00020', 'PRO-00016', 3, 23.00, 0.00),
('DET-00205', 'VNT-00040', 'PRO-00017', 2, 24.00, 0.00),
('DET-00206', 'VNT-00060', 'PRO-00013', 4, 20.00, 0.00),
('DET-00207', 'VNT-00080', 'PRO-00055', 3, 24.00, 0.00),
('DET-00208', 'VNT-00100', 'PRO-00021', 2, 18.00, 0.00),
('DET-00209', 'VNT-00120', 'PRO-00022', 4, 19.00, 0.00),
('DET-00210', 'VNT-00140', 'PRO-00019', 3, 16.00, 0.00);
GO 