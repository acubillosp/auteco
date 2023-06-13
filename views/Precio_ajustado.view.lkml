view: precio_ajustado {
  derived_table: {
    explore_source: auteco_poc {
      column: fecha {}
      column: linea {}
      column: avg_trm {}
      column: avg_precio {}
      column: empresa {}
    }
  }

  dimension: fecha {
    description: ""
    type: date
    sql: ${TABLE}.ANIO || '-' || ${TABLE}.MES || '-01' ;;
  }

  dimension: linea {
    description: ""
  }

  dimension: avg_precio {
    type: number
  }

  dimension: avg_trm {
    type: number
  }

  dimension: menor_fecha {
    type: date
    sql: CASE WHEN ${avg_precio} <> 0 THEN ${fecha} END;;
  }

  dimension: precio_dolarizado {
    type: string
    sql: CASE WHEN ${fecha} = (SELECT MIN(${fecha}) FROM auteco_poc WHERE ${avg_precio} <> 0) THEN CAST(${avg_precio}/${avg_trm} AS STRING) END;;
  }

  dimension: precio_promedio_menor_fecha {
    type: number
    sql: CASE WHEN ${fecha} = (FIRST_VALUE(${fecha}) OVER (PARTITION BY ${linea} ORDER BY ${fecha})) FROM auteco_poc WHERE ${avg_precio} <> 0) THEN ${avg_precio} END;;
    value_format: "0.00"
  }


}
