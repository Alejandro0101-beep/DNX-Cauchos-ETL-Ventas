# DNX Cauchos S.R.L. | Data Mart de ventas y análisis Big Data

Proyecto de Business Intelligence sobre ventas de suelas para calzado: base transaccional en SQL Server, ETL en T-SQL, Data Mart en esquema estrella, reporte en Power BI y análisis complementario en Databricks/PySpark.

> Datos **sintéticos** generados con fines académicos. Las cifras no son estados financieros auditados.

## Arquitectura

```text
SQL Server (dbo_DNX_Cauchos_SRL)            Origen transaccional
  Cliente | Producto | Vendedor | MetodoPago | Venta | DetalleVenta
                    |
                    v   ETL T-SQL (carga completa, sin staging)
SQL Server (dm_DNX_Cauchos_SRL)             Data Mart
  dim_cliente | dim_producto | dim_vendedor | dim_metodoPago | dim_tiempo
                    |
                 hecho_ventas
                    |
                    +--> Power BI
                    +--> CSV exportados --> Databricks / PySpark --> Delta / KPI
```

## Estructura del repositorio

```text
.
├── README.md
├── sql/                          # Scripts vigentes, en orden de ejecución
│   ├── 01_transaccional/
│   │   ├── 01_crear_esquema.sql              # solo DDL
│   │   └── 02_cargar_datos_sinteticos.sql    # datos sintéticos (600 clientes, 2 000 ventas)
│   ├── 02_datamart/
│   │   └── 01_crear_datamart.sql
│   ├── 03_etl/
│   │   └── 01_cargar_datamart.sql            # solo la carga (RESEED en 0)
│   └── 04_validaciones/
│       ├── 01_validaciones_origen_vs_datamart.sql
│       └── 02_validaciones_post_etl.sql
├── bigdata/                      # Notebook Databricks y ejemplo PySpark
├── data/exports/                 # CSV del Data Mart comprimidos + reconstruir_csv.py + MANIFIESTO.json
├── powerbi/                      # Dashboard (.pbix) y su README
├── documentacion/                # Informes (SQL/ETL, Power BI, Big Data) y decisiones técnicas
└── archivo/                      # Versiones anteriores conservadas solo por trazabilidad
```

## Ejecución en SQL Server

**Requisitos:** SQL Server con permisos para crear bases de datos y SSMS. Usar una instancia de pruebas: el ETL vacía el Data Mart antes de cargarlo. Ambas bases deben estar en la misma instancia.

1. [`sql/01_transaccional/01_crear_esquema.sql`](sql/01_transaccional/01_crear_esquema.sql): crea la base de origen (solo DDL).
2. [`sql/01_transaccional/02_cargar_datos_sinteticos.sql`](sql/01_transaccional/02_cargar_datos_sinteticos.sql): inserta los datos sintéticos.
3. [`sql/02_datamart/01_crear_datamart.sql`](sql/02_datamart/01_crear_datamart.sql): crea dimensiones y tabla de hechos.
4. [`sql/03_etl/01_cargar_datamart.sql`](sql/03_etl/01_cargar_datamart.sql): carga el Data Mart. Solo incluye ventas `COMPLETADO`.
5. [`sql/04_validaciones/`](sql/04_validaciones/): compara origen y Data Mart y revisa los KPI.
6. Abrir [`powerbi/DNX_Cauchos_Dashboard_Final.pbix`](powerbi/DNX_Cauchos_Dashboard_Final.pbix) en Power BI Desktop y ajustar la conexión al servidor.

> No se ha certificado la ejecución completa en una instancia SQL Server desde este repositorio.

## Modelo dimensional

**Granularidad:** una fila de `hecho_ventas` por `pk_detalle` de una venta completada.

| Tabla | Contenido |
|---|---|
| `dim_cliente` | Cliente, tipo y distrito |
| `dim_producto` | Producto, suela, categoría, material, precio y costo de fabricación |
| `dim_vendedor` | Vendedor y cargo |
| `dim_metodoPago` | Método y tipo de pago |
| `dim_tiempo` | Día, mes, trimestre y año |
| `hecho_ventas` | Cantidad, precio, monto, descuento, venta neta, costo y utilidad |

`monto_venta = cantidad × precio_unitario` · `total_venta = monto_venta − descuento` · `costo_total = cantidad × costo_fabricacion` · `utilidad = total_venta − costo_total` (aproximada, antes de otros costos e impuestos).

Los pedidos cancelados y pendientes **no** están en la tabla de hechos; se consultan en `Venta` del origen.

## Big Data

El notebook de [`bigdata/`](bigdata/README.md) usa los CSV de [`data/exports/`](data/exports/) (comprimidos; `reconstruir_csv.py` los reconstruye y verifica su SHA-256). Las dimensiones se expandieron ×400 para pruebas de volumen, por lo que **no representan clientes o trabajadores únicos**.

## Documentación

Informes técnicos y de experimentación en [`documentacion/`](documentacion/README.md). Decisiones técnicas y pendientes en [`documentacion/decisiones_tecnicas.md`](documentacion/decisiones_tecnicas.md).

## Evidencias y pendientes

| Elemento | Estado |
|---|---|
| Scripts SQL organizados | Disponibles en `sql/` |
| Notebook Databricks y CSV | Publicados |
| Validaciones de consistencia | Script disponible, ejecución pendiente |
| Captura de esquema estrella | Pendiente |
| Capturas de ETL y dashboard final | Pendiente |
| Medidas DAX y KPI del PBIX final | Pendiente |

## Limitaciones

- Carga completa, sin incrementales ni historial de cambios de atributos (SCD).
- La dimensión de producto guarda el costo vigente al cargar, no costos históricos.
- Las exportaciones CSV y el Data Mart deben contrastarse antes de reutilizar claves o agregados. Ver [`archivo/README.md`](archivo/README.md) sobre el `RESEED` con que se generaron.
