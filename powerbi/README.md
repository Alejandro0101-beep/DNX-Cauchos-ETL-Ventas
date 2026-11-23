# Dashboard Power BI

El archivo [`DNX_Power_BI.pbix`](../DNX_Power_BI.pbix) permanece en la raíz para conservar los enlaces históricos.

Se utiliza para estudiar ventas completadas del Data Mart, con medidas de ventas netas, unidades, descuentos, costos y utilidad según el modelo disponible. Las medidas y páginas específicas del PBIX requieren verificación antes de documentarlas como implementadas.

Para abrirlo, usar Power BI Desktop. Si la consulta apunta a un SQL Server local de otro equipo, cambiar el origen de datos y actualizar credenciales.

**Pendiente:** incorporar el PBIX final auditado, capturas de las páginas y listado de medidas DAX confirmadas.

**Pedidos cancelados y pendientes:** los estados están en `dbo_DNX_Cauchos_SRL.dbo.Venta`. La tabla de hechos no los almacena porque el ETL filtra `COMPLETADO`. Cualquier reporte de estados debe obtener esa información por separado, evitando sumarla como ventas realizadas.
