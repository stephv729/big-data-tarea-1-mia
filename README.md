# big-data-tarea-1-mia

Proyecto dbt para la tarea de Big Data - MIA.

## Arquitectura

```
fuentes RAW (Fivetran en BigQuery)  →  staging (views)  →  marts (tables)
```

| Capa | Dataset BigQuery | Materializacion | Proposito |
|---|---|---|---|
| Sources | `sales_datamart`, `airtable_*`, `google_sheets`, `google_drive` | (raw) | Datos crudos cargados por Fivetran |
| Staging | `sales_datamart_dev_staging` | view | Limpieza, renombres, filtro de `_fivetran_deleted` |
| Marts | `sales_datamart_dev_marts` | table | Modelo dimensional (star schema) |

## Estructura

```
models/
├── staging/
│   ├── _sources.yml
│   ├── _stg_models.yml
│   ├── stg_customers.sql      ← desde RDS MySQL
│   ├── stg_products.sql       ← desde Airtable
│   ├── stg_stores.sql         ← desde Google Sheets
│   ├── stg_dates.sql          ← desde Google Drive
│   └── stg_sales.sql          ← desde Google Drive (fact)
└── marts/
    ├── _marts_models.yml
    ├── dim_customer.sql
    ├── dim_product.sql
    ├── dim_store.sql
    ├── dim_date.sql
    └── fact_sales.sql
```

## Setup local

```bash
# 1. Crear y activar virtualenv
python3 -m venv .venv
source .venv/bin/activate

# 2. Instalar dbt-bigquery
pip install dbt-bigquery

# 3. Configurar credenciales de BigQuery
gcloud auth application-default login

# 4. Copiar el profile y ajustar
mkdir -p ~/.dbt
cp profiles.example.yml ~/.dbt/profiles.yml
# (edita ~/.dbt/profiles.yml con tu dataset de desarrollo)

# 5. Verificar conexion
dbt debug

# 6. Correr todo
dbt run
dbt test
```

## Uso en dbt Cloud

Como este repo esta conectado a dbt Cloud, los models se ejecutan
automaticamente segun los jobs configurados en la UI. La conexion a
BigQuery se gestiona desde Account Settings → Projects → Connection.

## Comandos utiles

```bash
dbt run --select staging              # solo staging
dbt run --select marts                # solo marts
dbt run --select +fact_sales          # fact_sales y todo lo upstream
dbt test --select dim_customer        # tests de un model
dbt docs generate && dbt docs serve   # documentacion interactiva
```

## TODOs antes de correr

1. Confirmar el nombre exacto del dataset Airtable en `models/staging/_sources.yml`
   (linea con `airtable_tarea_1_mia_apptrkcl`).
2. Validar columnas reales de cada tabla raw en BigQuery y ajustar los
   `stg_*.sql` (productos, tiendas, fechas, ventas) si difieren.
3. `dbt compile` ayuda a detectar columnas inexistentes antes de correr.
