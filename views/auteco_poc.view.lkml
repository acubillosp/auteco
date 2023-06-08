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
    sql: ${TABLE}.ANIO || '-' || ${TABLE}.MES || '-01' ;;
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
#######################Link
  dimension: empresa_link {
    type: string
    sql: ${TABLE}.EMPRESA ;;
    link: {
      label: "Google"
      url: "http://www.google.com/search?q={{ value }}"
      icon_url: "http://google.com/favicon.ico"
    }
  }
  dimension: empresa_imagen {
    type: string
    sql: ${empresa} ;;
    html: |
          {% if empresa._value == "AKT" %}
            <img src="https://upload.wikimedia.org/wikipedia/commons/3/35/AKT_logo.PNG" height="170" width="255">
          {% elsif empresa._value == "AUTECO" %}
            <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/6/60/Auteco_logo.svg/1200px-Auteco_logo.svg.png" height="170" width="255">
          {% elsif empresa._value == "HERO" %}
            <img src="https://heromotored.com/wp-content/uploads/2020/11/Hero-logo.png" height="170" width="255">
          {% elsif empresa._value == "HONDA"%}
            <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/3/38/Honda.svg/2560px-Honda.svg.png" height="170" width="255">
          {% elsif empresa._value == "MOBILITY"%}
            <img src="https://auteco.vteximg.com.br/arquivos/logo-open-graph.png?v=637289648336900000" height="170" width="255">
          {% elsif empresa._value == "SUZUKI"%}
            <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/1/12/Suzuki_logo_2.svg/2560px-Suzuki_logo_2.svg.png" height="170" width="255">
          {% elsif empresa._value == "UMA"%}
            <img src="https://grupouma.com/colombia/wp-content/uploads/sites/2/2022/08/LOGO-GrupoUMA_2.pngC" height="170" width="255">
          {% elsif empresa._value == "YAMAHA"%}
            <img src="https://1000marcas.net/wp-content/uploads/2019/12/Yamaha-Log%D0%BE.png" height="170" width="255">
          {% else %}
            <img src="https://www.auteco.com.co/wp-content/uploads/2022/11/01-4.png" height="170" width="225">
          {% endif %}
        ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
  measure: promedio_precio {
    type: number
    sql: ROUND(AVG(${TABLE}.AVG_PRECIO),2) ;;
    value_format: "0.00"
  }

}
