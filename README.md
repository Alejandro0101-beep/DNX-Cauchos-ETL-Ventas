# DNX Cauchos S.R.L. | Data Mart de ventas y análisis Big Data

Proyecto de Business Intelligence orientado al análisis de ventas de suelas para calzado. Se implementó una base transaccional en SQL Server, un proceso ETL con T-SQL y un Data Mart en esquema estrella. También se desarrolló un análisis complementario en Databricks/PySpark sobre exportaciones CSV y un reporte en Power BI.

## Objetivo

Unificar la información de clientes, productos, vendedores, métodos de pago y transacciones para analizar ventas netas, unidades, descuentos, costos de fabricación y utilidad estimada. La tabla de hechos incorpora **solo ventas completadas**; el estado de las operaciones restantes se consulta en la tabla de origen `Venta`.

## Arquitectura

```text
SQL Server (dbo_DNX_Cauchos_SRL)
  Cliente | Producto | Vendedor | MetodoPago | Venta | DetalleVenta
                    |
                    v
       ETL T-SQL (extracción y transformaciones directas)
                    |
                    v
SQL Server (dm_DNX_Cauchos_SRL)
  dim_cliente | dim_producto | dim_vendedor | dim_metodoPago | dim_tiempo
                    |
                    v
              hecho_ventas
                    |
                    +----> Power BI
                    |
                    +----> CSV exportados -> Databricks / PySpark -> Delta / KPI
```

El ETL actual **no usa staging físico**. Es una carga completa: vacía las dimensiones y la tabla de hechos, vuelve a cargar las dimensiones y finalmente la tabla de hechos. El tratamiento de estado de pedidos es distinto del análisis de importes completados.

## Tecnología

| Componente | Herramienta |
|---|---|
| OLTP y Data Mart | SQL Server |
| Desarrollo SQL | SSMS / T-SQL |
| ETL | Consultas T-SQL entre bases de datos |
| Modelo dimensional | Esquema estrella |
| Visualización | Power BI Desktop / DAX |
| Procesamiento adicional | Databricks / PySpark / Delta Lake |
| Versionamiento | GitHub |

## Estructura del repositorio

```text
.
├── README.md
├── sql/
│   ├── 01_origen/crear_esquema.sql
│   ├── 02_datamart/crear_datamart.sql
│   ├── 03_etl/cargar_datamart.sql
│   └── 04_validaciones/validaciones.sql
├── bigdata/
│   ├── README.md
│   └── ejemplo_pyspark.py
├── powerbi/README.md
├── docs/decisiones_tecnicas.md
├── 01_Base_Datos_Origen.sql      # legado, conservado
├── 02_Creacion_DataMart.sql       # legado, conservado
├── 03_Proceso_ETL.sql             # legado, conservado
└── DNX_Power_BI.pbix             # versión existente
```

Los archivos de la raíz permanecen para preservar los enlaces existentes y el historial. Los archivos dentro de `sql/` provienen de las versiones entregadas posteriormente; incluyen correcciones puntuales señaladas en `docs/decisiones_tecnicas.md`.

## Modelo dimensional

**Granularidad:** una fila de `hecho_ventas` por `pk_detalle` de una venta completada. Una cabecera `pk_venta` puede originar varias filas.

| Tabla | Contenido |
|---|---|
| `dim_cliente` | Cliente, tipo y distrito |
| `dim_producto` | Producto, suela, categoría, material, precio y costo de fabricación |
| `dim_vendedor` | Vendedor y cargo |
| `dim_metodoPago` | Método y tipo de pago |
| `dim_tiempo` | Día, mes, trimestre y año |
| `hecho_ventas` | Cantidad, precio unitario, monto, descuento, venta neta, costo y utilidad |

En la tabla de hechos: `monto_venta = cantidad * precio_unitario`; `total_venta = monto_venta - descuento`; `costo_total = cantidad * costo_fabricacion`; `utilidad = total_venta - costo_total`. La utilidad es una aproximación **antes** de otros costos operativos e impuestos.

## Ejecución en SQL Server

**Requisitos:** SQL Server con permisos para crear bases de datos, SSMS y ambas bases en la misma instancia. Usar una instancia de pruebas: el script ETL elimina el contenido previo del Data Mart.

1. Crear la base de origen con [`sql/01_origen/crear_esquema.sql`](sql/01_origen/crear_esquema.sql). Este archivo contiene **solo DDL**, no inserta datos.
2. Importar/cargar registros de ejemplo del origen **previamente anonimizados**. La versión inicial del repositorio cuenta con [un script histórico](01_Base_Datos_Origen.sql), pero no debe confundirse con el conjunto de datos de la versión ampliada.
3. Ejecutar [`sql/02_datamart/crear_datamart.sql`](sql/02_datamart/crear_datamart.sql).
4. Ejecutar [`sql/03_etl/cargar_datamart.sql`](sql/03_etl/cargar_datamart.sql).
5. Ejecutar [`sql/04_validaciones/validaciones.sql`](sql/04_validaciones/validaciones.sql) y comparar los registros del origen y el Data Mart.
6. Abrir [`DNX_Power_BI.pbix`](DNX_Power_BI.pbix) en Power BI Desktop y ajustar la conexión al servidor SQL si corresponde.

**Importante:** el script del origen ampliado compartido para este trabajo contenía instrucciones `DELETE` antes de los `CREATE TABLE`. No se publicó como instalador reproducible. Se extrajo su DDL y se eliminó ese bloque inicial. El ETL actualizado restablece los `IDENTITY` con `RESEED, 0` después de `DELETE`, para que las siguientes inserciones comiencen en 1. No se ha certificado la ejecución en una instancia SQL Server desde este repositorio.

## Preguntas de negocio

- ¿Cuánto se vendió y cuál fue la utilidad estimada por mes y año?
- ¿Qué suelas, productos y categorías concentran mayor venta?
- ¿Qué clientes y vendedores participan más en las ventas completadas?
- ¿Cómo se distribuyen las ventas por método de pago y distrito?
- ¿Cuánto se descuenta en ventas completadas?
- ¿Cuántas ventas están completadas, canceladas o pendientes? **Esta última pregunta se responde desde el origen**, no sumando la tabla de hechos.

**KPI y medidas DAX definitivas de Power BI:** [pendiente de verificar con el PBIX final].

## Big Data

El notebook académico entregado se apoyó en seis CSV exportados del Data Mart y preparó transformaciones en PySpark, tablas Delta e indicadores por año, producto, vendedor y distrito. Incluye un parámetro de control de descuentos de S/ 30,000 anual, utilizado como referencia analítica, **no como política comercial confirmada de la empresa**.

Los CSV de clientes y vendedores contienen campos como nombres, DNI y teléfonos, y por eso **no se publican en esta versión abierta**. En [`bigdata/README.md`](bigdata/README.md) se documentan los archivos esperados, los recuentos observados y el acceso desde Databricks. Se proporciona un ejemplo de lectura, no una reproducción íntegra del notebook original.

## Evidencias y pendientes

| Elemento | Estado |
|---|---|
| Scripts SQL organizados | Disponibles en `sql/` |
| Definición de dimensiones/hechos | Disponible |
| Validaciones de consistencia | Script disponible, ejecución pendiente |
| Power BI histórico | Disponible en la raíz |
| Notebook completo de Databricks | [pendiente de publicar versión revisada y sin resultados sensibles] |
| CSV originales | No publicados por precaución de privacidad |
| Captura de esquema estrella | [pendiente] |
| Capturas de ETL y dashboard final | [pendiente] |
| Medidas DAX y KPI del PBIX final | [pendiente] |

## Alcance y limitaciones

- Datos del proyecto académico; las cifras no deben interpretarse como estados financieros auditados.
- Recarga completa, sin cargas incrementales ni historial de cambios de atributos.
- La dimensión de producto conserva el costo disponible al cargar; no calcula costos históricos.
- Las exportaciones CSV y el Data Mart cargado deben contrastarse antes de reutilizar claves, fechas o agregados.
- No se ejecutaron pruebas automáticas contra SQL Server ni Databricks al preparar esta organización.

**Repositorio:** [DNX-Cauchos-ETL-Ventas](https://github.com/Alejandro0101-beep/DNX-Cauchos-ETL-Ventas)
