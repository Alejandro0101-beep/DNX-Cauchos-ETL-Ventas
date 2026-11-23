# Databricks / PySpark

El notebook de trabajo compartido usa CSV exportados del Data Mart como entrada, un Volume de Databricks, PySpark y tablas Delta. El archivo original completo no se publica aquí por contener resultados incrustados y referencias a dimensiones con datos identificables. Este directorio incluye un ejemplo de lectura y verificaciones iniciales.

## Archivos esperados

| CSV | Filas en exportación revisada | Observaciones |
|---|---:|---|
| `dim_cliente.csv` | 240 000 | Duplicación intencional para pruebas |
| `dim_producto.csv` | 24 000 | Duplicación intencional para pruebas |
| `dim_vendedor.csv` | 24 000 | Duplicación intencional para pruebas |
| `dim_metodoPago.csv` | 4 | Métodos de pago |
| `dim_tiempo.csv` | 688 | Calendario |
| `Hecho_ventas.csv` | 2 828 | Detalles de ventas completadas |

Los recuentos describen **estos CSV recibidos**, no el resultado garantizado de cada ejecución SQL. La expansión 400× de dimensiones se empleó para ejercicios de volumen de datos, no representa clientes o trabajadores únicos.

## Reproducción

1. Preparar versiones **anonimizadas** de los CSV.
2. Subirlos a un Volume con permisos apropiados.
3. Configurar la ruta en [`ejemplo_pyspark.py`](ejemplo_pyspark.py) y ejecutarlo desde un notebook de Databricks o un entorno Spark compatible.
4. El notebook académico completo, cuando se incorpore sin datos sensibles, deberá realizar normalización, eliminación de duplicados, recuperación de claves dimensionales y validaciones de integridad antes de generar KPI.
5. Guardar tablas procesadas como Delta en el catálogo/esquema elegido.

En el notebook original se definen los indicadores `kpi_anual`, `kpi_descuento_anual`, `kpi_descuento_mensual`, `kpi_productos`, `kpi_vendedores` y `kpi_distritos`. Para alertas de descuentos se utiliza `TOPE_DESCUENTO = 30000.0` y umbral amarillo del 80%.

**Nota:** no se ha ejecutado aquí un cluster Databricks para validar la transformación final.
