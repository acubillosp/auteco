
view: precio_ajustado {
  derived_table: {
    explore_source: auteco_poc {
      column: anio {}
      column: mes {}
      column: fecha {}
      column: linea {}
      column: avg_trm {}
    }
  }
  dimension: anio {
    description: ""
    type: number
  }
  dimension: mes {
    description: ""
    type: number
  }
  dimension: fecha {
    description: ""
    type: date
  }
  dimension: linea {
    description: ""
  }
  dimension: avg_trm {
    description: ""
    type: number
  }
 #

}
