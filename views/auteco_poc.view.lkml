view: auteco_poc {
  sql_table_name: `auteco.auteco_poc`
    ;;

  dimension: anio {
    type: number
    sql: ${TABLE}.ANIO ;;
  }

  dimension: avg_precio {
    type: number
    sql: ${TABLE}.AVG_PRECIO ;;
  }

  dimension: avg_trm {
    type: number
    sql: ${TABLE}.AVG_TRM ;;
  }

  dimension: cantidad {
    type: number
    sql: ${TABLE}.CANTIDAD ;;
  }

  dimension: empresa {
    type: string
    sql: ${TABLE}.EMPRESA ;;
  }

  dimension: linea {
    type: string
    sql: ${TABLE}.LINEA ;;
  }

  dimension: marca {
    type: string
    sql: ${TABLE}.MARCA ;;
  }

  dimension: mes {
    type: number
    sql: ${TABLE}.MES ;;
  }

  dimension: segmento {
    type: string
    sql: ${TABLE}.SEGMENTO ;;
  }

  dimension: subcategoria {
    type: string
    sql: ${TABLE}.SUBCATEGORIA ;;
  }

  dimension: subsegmento {
    type: string
    sql: ${TABLE}.SUBSEGMENTO ;;
  }
#############Dimensiones creadas############################
  dimension: fecha {
    type: date
    sql: ${TABLE}.ANIO || '-' || ${TABLE}.MES ;;
  }
##############fecha granular#########
  dimension_group: fecha {
    type: time
    view_label: "Fecha granular"
    timeframes: [
      date,
      month,
      month_name,
      month_num,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${fecha} ;;
  }
  parameter: date_granularity {
    type: unquoted
    allowed_value: {
      label: "Year"
      value: "year"
    }
    allowed_value: {
      label: "Month"
      value: "month"
    }
  }

  dimension: date {
    sql:
    {% if date_granularity._parameter_value == 'year' %}
      ${fecha_year}
    {% elsif date_granularity._parameter_value == 'month' %}
      ${fecha_month}
    {% else %}
      ${fecha_date}
    {% endif %};;
  }


  measure: count {
    type: count
    drill_fields: []
  }
}
