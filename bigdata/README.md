# Databricks / PySpark — DNX Cauchos

Se publica el proyecto académico con **datos sintéticos generados para pruebas**, según lo indicado por su autor.

## Archivos

- [`DNX_Cauchos_BigData.ipynb`](DNX_Cauchos_BigData.ipynb): notebook compatible con Jupyter/Databricks; conserva el código y las celdas Markdown, pero elimina resultados guardados para facilitar su inspección en GitHub.
- [`DNX_Cauchos_BigData_original.ipynb.gz`](DNX_Cauchos_BigData_original.ipynb.gz): copia comprimida del notebook **original completo**, incluyendo las salidas de las celdas. Descomprimir con `gzip -dk DNX_Cauchos_BigData_original.ipynb.gz` o la herramienta gzip que prefieras.
- [`../data/exports/`](../data/exports/): seis CSV originales comprimidos; `dim_cliente` está dividido en 8 partes. [`reconstruir_csv.py`](../data/exports/reconstruir_csv.py) reconstruye y verifica su integridad.
- [`ejemplo_pyspark.py`](ejemplo_pyspark.py): ejemplo mínimo de lectura y validación; no reemplaza el notebook completo.

## Exportaciones del Data Mart

| CSV recuperado | Filas |
|---|---:|
| `dim_cliente.csv` | 240 000 |
| `dim_producto.csv` | 24 000 |
| `dim_vendedor.csv` | 24 000 |
| `dim_metodoPago.csv` | 4 |
| `dim_tiempo.csv` | 688 |
| `Hecho_ventas.csv` | 2 828 |

Las tres primeras dimensiones se ampliaron intencionalmente para prácticas de duplicados y procesamiento de volumen, por lo que los recuentos no son números de clientes, productos y vendedores **únicos**. El origen sintético y el Data Mart están en `sql/`.

## Procedimiento de ejecución

1. Descargar el contenido de [`data/exports`](../data/exports/) o clonar el repositorio.
2. Ejecutar `python data/exports/reconstruir_csv.py`. Esto crea la carpeta `data/exports/restaurados/`, restaura los CSV completos y compara sus hash SHA-256 con el manifiesto.
3. Cargar los seis CSV restaurados en un Volume de Databricks.
4. Abrir `DNX_Cauchos_BigData.ipynb`, configurar la ruta del Volume y, si corresponde, el catálogo y esquema.
5. Ejecutar las celdas de preparación y limpieza antes de generar las tablas Delta y los KPI.

El notebook original contiene lógica para revisar duplicados, nulos, claves dimensionales, indicadores de ventas, descuentos, productos, vendedores y distritos; crea tablas como `kpi_anual`, `kpi_descuento_anual`, `kpi_descuento_mensual`, `kpi_productos`, `kpi_vendedores` y `kpi_distritos`. Se usa un umbral académico de descuento anual de S/ 30 000.

**Alcance:** se verificó la integridad de los archivos restaurables por hash; no se ejecutó el notebook en un clúster Databricks como parte de esta publicación. La revisión de claves del notebook sigue siendo necesaria antes de interpretar resultados.
