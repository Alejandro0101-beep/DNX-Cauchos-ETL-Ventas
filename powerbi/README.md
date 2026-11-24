# Dashboard Power BI

- [`DNX_Cauchos_Dashboard_Final.pbix`](DNX_Cauchos_Dashboard_Final.pbix): dashboard descrito en [`../documentacion/PowerBI/`](../documentacion/PowerBI/Documentacion.md).
- La versión inicial está en [`../archivo/powerbi/`](../archivo/powerbi/DNX_Power_BI_historico.pbix).

Se usa para estudiar ventas completadas del Data Mart (ventas netas, unidades, descuentos, costos y utilidad). Para abrirlo, usar Power BI Desktop; si la consulta apunta a un SQL Server local de otro equipo, cambiar el origen de datos y las credenciales.

**Pendiente:** confirmar que este PBIX corresponde a la misma carga que el Data Mart y los CSV, añadir capturas de las páginas y el listado de medidas DAX confirmadas.

**Pedidos cancelados y pendientes:** están en `dbo_DNX_Cauchos_SRL.dbo.Venta`. La tabla de hechos no los almacena porque el ETL filtra `COMPLETADO`.
