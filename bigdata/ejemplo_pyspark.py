# Databricks / PySpark: exploración inicial de CSV anonimizados.
# Ejemplo de lectura, no reemplaza el notebook completo del proyecto.
from pyspark.sql import functions as F

RUTA = "/Volumes/[catalogo]/[esquema]/[volume]/"
archivos = [
    "dim_cliente.csv", "dim_producto.csv", "dim_vendedor.csv",
    "dim_metodoPago.csv", "dim_tiempo.csv", "Hecho_ventas.csv"
]

def leer_csv(nombre):
    return (
        spark.read.option("header", True)
        .option("inferSchema", True)
        .option("encoding", "UTF-8")
        .csv(RUTA + nombre)
    )

dfs = {nombre: leer_csv(nombre) for nombre in archivos}
for nombre, df in dfs.items():
    print(nombre, "filas:", df.count(), "distintas:", df.distinct().count())

hechos = dfs["Hecho_ventas.csv"]
hechos.select(
    F.count("*").alias("lineas_detalle"),
    F.countDistinct("pk_venta").alias("ventas_distintas"),
    F.sum(F.col("total_venta").cast("double")).alias("venta_neta"),
    F.sum(F.col("utilidad").cast("double")).alias("utilidad_estimada"),
).show(truncate=False)
