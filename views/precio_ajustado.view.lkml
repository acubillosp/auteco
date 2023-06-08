view: precio_ajustado {
  derived_table: {
    sql:
      SELECT
        anio,
        mes,
        linea,
        avg_trm,
        avg_precio,
        CASE
          WHEN mes = 1 THEN avg_trm
          ELSE NULL
        END AS promedio_trm_enero
      FROM auteco_poc
      GROUP BY anio, mes, linea, avg_trm, avg_precio
    ;;
  }

  dimension: anio {
    description: ""
    type: number
  }
  dimension: mes {
    description: ""
    type: number
  }
  dimension: linea {
    description: ""
  }
  dimension: avg_trm {
    description: ""
    type: number
  }
  dimension: avg_precio {
    description: ""
    type: number
  }
  measure: promedio_trm_enero {
    type: average
    sql: ${TABLE}.promedio_trm_enero ;;
  }

  measure: precio_ajustado {
    type: number
    sql: (${avg_precio} / ${promedio_trm_enero}) * ${avg_trm} ;;
  }
}
