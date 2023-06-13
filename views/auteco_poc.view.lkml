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
          {% if empresa._is_filtered %}
            {% if empresa._value == "AKT" %}
              <img src="https://upload.wikimedia.org/wikipedia/commons/3/35/AKT_logo.PNG" height="160" width="240">
            {% elsif empresa._value == "AUTECO" %}
              <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/6/60/Auteco_logo.svg/1200px-Auteco_logo.svg.png" height="140" width="240">
            {% elsif empresa._value == "HERO" %}
              <img src="https://heromotored.com/wp-content/uploads/2020/11/Hero-logo.png" height="140" width="240">
            {% elsif empresa._value == "HONDA" %}
              <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/3/38/Honda.svg/2560px-Honda.svg.png" height="140" width="240">
            {% elsif empresa._value == "MOBILITY" %}
              <img src="https://auteco.vteximg.com.br/arquivos/logo-open-graph.png?v=637289648336900000" height="140" width="240">
            {% elsif empresa._value == "SUZUKI" %}
              <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/1/12/Suzuki_logo_2.svg/2560px-Suzuki_logo_2.svg.png" height="140" width="240">
            {% elsif empresa._value == "UMA" %}
              <img src="https://www.coopetrol.coop/wp-content/uploads/2023/03/Logo-Grupo-Uma.png" height="140" width="240">
            {% elsif empresa._value == "YAMAHA" %}
              <img src="https://1000marcas.net/wp-content/uploads/2019/12/Yamaha-Log%D0%BE.png" height="140" width="240">
            {% else %}
              <img src="https://www.auteco.com.co/wp-content/uploads/2022/11/01-4.png" height="170" width="255">
            {% endif %}
          {% else %}
            <img src="https://www.auteco.com.co/wp-content/uploads/2022/11/01-4.png" height="170" width="255">
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
    value_format: "$#,##0.00"
  }
  dimension: valor_tmr_primera_fecha {
    type: number
    sql: CASE
         WHEN ${mes} = 1 THEN ${avg_trm}
         ELSE (SELECT ${avg_trm} FROM ${TABLE} WHERE ${mes} = 1 AND ${linea} = ${linea} GROUP BY ${linea} LIMIT 1)
       END ;;
  }
#######################################################################

  dimension: precio_dolarizado {
    type: string
    sql: CASE
    WHEN ${date} =
    (SELECT MIN(${date}) FROM auteco_poc WHERE ${avg_precio} <> 0 AND ${linea} = ${TABLE}.linea)
    THEN CAST(${avg_precio}/${avg_trm} AS STRING) END ;;
  }

  dimension: primera_fecha_valida {
    type: string
    sql: CASE WHEN ${mes} = (SELECT FIRST_VALUE(${mes}) OVER (PARTITION BY ${linea} ORDER BY ${mes}) FROM auteco_poc WHERE ${avg_precio} <> 0 limit 1) THEN '1' ELSE '0' END ;;
  }

}
