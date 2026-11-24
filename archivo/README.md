# Archivo

Versiones anteriores conservadas **solo por trazabilidad**. No forman parte del flujo de ejecución (ver `sql/`).

| Archivo | Qué es | Por qué se conserva |
|---|---|---|
| `sql/transaccional_primera_version.sql` | Script de la primera subida del repositorio | Historial. Su tabla `Vendedor` parece declarar `dni` dos veces, por lo que puede fallar en SQL Server. |
| `sql/etl_primera_version.sql` | ETL de la primera subida | Historial |
| `sql/transaccional_original_completo.sql` | Script transaccional ampliado, DDL + datos | Trazabilidad. Incluye `DELETE` antes de `CREATE TABLE`: **no ejecutar sobre una base nueva**. |
| `sql/etl_original_reseed1.sql` | ETL entregado con `DBCC CHECKIDENT(..., RESEED, 1)` | Es el que produjo los CSV de `data/exports/`: sus claves sustitutas empiezan en 2. La versión vigente usa `RESEED, 0`. |
| `sql/transaccional_carga_pequena_75_clientes.sql` | Carga alternativa pequeña (75 clientes, 360 ventas, 470 detalles) | No corresponde a los CSV ni al notebook. No mezclar sus recuentos con los de la carga ampliada. |
| `powerbi/DNX_Power_BI_historico.pbix` | Dashboard de la versión inicial | Historial |
