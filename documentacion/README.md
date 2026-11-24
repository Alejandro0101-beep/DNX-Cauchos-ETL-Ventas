# Documentación y experimentación — DNX Cauchos S.R.L.

Documentos complementarios del proyecto de Business Intelligence. Se incluyen **dos entregables por área**: documentación y experimentación. Esta carpeta se preparó a partir de los archivos SQL, el PBIX, las exportaciones CSV y los informes compartidos por el equipo.

| Área | Documentación | Experimentación |
|---|---|---|
| SQL Server, ETL y Data Mart | [Documento técnico](SQL_ETL_DataMart/Documentacion.md) | [Pruebas y resultados](SQL_ETL_DataMart/Experimentacion.md) |
| Power BI | [Modelo y visualizaciones](PowerBI/Documentacion.md) | [Validaciones y diferencias](PowerBI/Experimentacion.md) |
| Big Data / Databricks | [Documentación existente](../bigdata/README.md) | [Notebook y datos](../bigdata/DNX_Cauchos_BigData.ipynb) |

## Evidencias y alcance de los informes

Las capturas auténticas de SQL Server incorporadas en la versión ilustrada del informe de experimentación proceden del documento `Experimentacion.docx` aportado por el compañero. Los diagramas del esquema estrella y los gráficos numéricos se reconstruyeron a partir del DDL y de los CSV. La disposición de la página Power BI procede de los metadatos del PBIX aportado: **no representa una captura de Power BI Desktop en ejecución**.

Los valores del CSV ampliado incluyen 2,828 detalles, 1,406 ventas distintas, ventas netas de **S/ 4,816,594.00** y utilidad estimada de **S/ 298,346.50**. No deben atribuirse al script transaccional alternativo `(1)`, que corresponde a una carga más pequeña. La experimentación también identifica **857 líneas de hechos** con al menos una clave no localizada en cuatro dimensiones exportadas; no se debe confundir ese número con ventas distintas.

## Evidencia final por añadir desde el equipo

- Capturas reales de SSMS: ejecución de scripts, filas cargadas y validación de integridad tras corregir el ETL.
- Capturas reales de Power BI: conexión y relaciones, fórmulas DAX, dashboard abierto, filtros por año y pruebas antes/después.
- Confirmación de que las versiones de origen, Data Mart, exportación CSV y archivo PBIX pertenecen a una carga única.
- Documentación definitiva de los indicadores y los criterios de la meta de descuento.

> Los informes de Word y PDF con las figuras originales se entregaron junto a esta documentación. Esta versión Markdown permite consultar el contenido desde GitHub sin abrir documentos locales.
