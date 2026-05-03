# big-data-tarea-1-mia

Tarea 1 - Modern BI - MIA. Plataforma de BI a baja escala con:

| Capa | Herramienta |
|---|---|
| Origenes | MySQL RDS (AWS), Airtable, Google Drive, Google Sheets |
| Ingesta | Fivetran |
| DWH | BigQuery (`tarea-1-mia`) |
| Transformacion | dbt Cloud (este repo) |
| Visualizacion | Power BI Desktop / Looker Studio |

## Arquitectura del proyecto dbt

```
fuentes RAW (Fivetran)  →  staging (views)  →  marts/core (star schema)  →  marts/analytics (preguntas)
```

```
models/
├── staging/                       (limpieza, snake_case, cast tipos)
│   ├── _sources.yml
│   ├── _stg_models.yml
│   ├── stg_customers.sql          ← RDS MySQL
│   ├── stg_products.sql           ← Airtable
│   ├── stg_stores.sql             ← Google Sheets
│   ├── stg_dates.sql              ← Google Drive
│   └── stg_sales.sql              ← Google Drive
└── marts/
    ├── core/                      (modelo dimensional reusable)
    │   ├── _core_models.yml
    │   ├── dim_customer.sql
    │   ├── dim_product.sql
    │   ├── dim_store.sql
    │   ├── dim_date.sql
    │   └── fact_sales.sql
    └── analytics/                 (responde las 5 preguntas del PDF)
        ├── _analytics_models.yml
        ├── weekly_product_sales.sql        ← Q1 productos mas vendidos x semana
        ├── top_customers.sql               ← Q2 cliente que compra mas
        ├── product_trend_monthly.sql       ← Q3 productos en declive
        ├── sales_over_time.sql             ← Q4 volumen vendido en el tiempo
        └── customer_demographics.sql       ← Q5 distribucion edad/sexo/nacionalidad
```

## Mapping preguntas → modelo → grafico Power BI

| # | Pregunta | Modelo a usar | Visualizacion sugerida |
|---|---|---|---|
| Q1 | Productos mas vendidos semana a semana | `weekly_product_sales` | Stacked bar / line chart con week_start en eje X, units_sold en Y, color por product_name |
| Q2 | Cliente que compra mas | `top_customers` | Tabla ordenada por `total_spent desc` o bar chart top-10 |
| Q3 | Productos cuya venta ha caido | `product_trend_monthly` | Line chart por producto + filtro `revenue_change_pct < 0` para destacar |
| Q4 | Volumen vendido en el tiempo | `sales_over_time` | Line chart con eje temporal (sale_date / week_start / month_start) |
| Q5 | Distribucion edad, sexo, nacionalidad | `customer_demographics` | 3 graficos: histograma de age_group, pie de gender, bar de nationality |

## Datasets en BigQuery (post `dbt run`)

Cada capa crea su propio dataset (el prefijo depende del target del profile):

- `<target>_staging` → views de la capa staging
- `<target>_marts_core` → tablas dim_* y fact_sales
- `<target>_marts_analytics` → tablas que responden las 5 preguntas

## Setup local (opcional - tambien funciona desde dbt Cloud IDE)

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install dbt-bigquery

gcloud auth application-default login
mkdir -p ~/.dbt
cp profiles.example.yml ~/.dbt/profiles.yml   # ajustar dataset

dbt debug
dbt run
dbt test
```

## Comandos utiles

```bash
dbt run --select staging          # solo staging
dbt run --select marts.core       # solo star schema
dbt run --select marts.analytics  # solo modelos de negocio
dbt run --select +top_customers   # un modelo y todo upstream
dbt test
dbt docs generate && dbt docs serve
```
