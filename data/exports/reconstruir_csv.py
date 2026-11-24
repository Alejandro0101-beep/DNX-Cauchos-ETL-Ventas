#!/usr/bin/env python3
"""Reconstruye los seis CSV sintéticos DNX a partir de los .csv.gz del repositorio.

Uso desde la raíz: python data/exports/reconstruir_csv.py
Salida: data/exports/restaurados/
No requiere paquetes externos.
"""
from pathlib import Path
import gzip
import hashlib
import json

BASE = Path(__file__).resolve().parent
DEST = BASE / "restaurados"
DEST.mkdir(parents=True, exist_ok=True)

def sha256(path):
    h = hashlib.sha256()
    with path.open("rb") as f:
        for block in iter(lambda: f.read(1024 * 1024), b""):
            h.update(block)
    return h.hexdigest()

def extraer(nombre):
    with gzip.open(BASE / (nombre + ".gz"), "rb") as inp, (DEST / nombre).open("wb") as out:
        for chunk in iter(lambda: inp.read(1024 * 1024), b""):
            out.write(chunk)

# Concatenar los ocho tramos y no repetir el encabezado.
with (DEST / "dim_cliente.csv").open("wb") as output:
    for i in range(1, 9):
        with gzip.open(BASE / f"dim_cliente_{i:02d}.csv.gz", "rb") as inp:
            if i != 1:
                inp.readline()  # omitir la cabecera duplicada
            for chunk in iter(lambda: inp.read(1024 * 1024), b""):
                output.write(chunk)

for name in ["dim_producto.csv", "dim_vendedor.csv",
             "dim_tiempo.csv", "dim_metodoPago.csv", "Hecho_ventas.csv"]:
    extraer(name)

manifest = json.loads((BASE / "MANIFIESTO.json").read_text(encoding="utf-8"))
for item in manifest:
    path = DEST / item["file"]
    digest = sha256(path)
    expected = item["sha256"]
    if digest != expected or path.stat().st_size != item["size_bytes"]:
        raise ValueError(f"Archivo no coincide con el original: {path.name}")
    print(f"OK {path.name} | {path.stat().st_size:,} bytes | SHA-256 verificado")
print(f"Listo: {DEST}")
