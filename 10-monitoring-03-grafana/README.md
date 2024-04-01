# Домашнее задание к занятию 14 «Средство визуализации Grafana»

### Задание 1

> 1. Используя директорию [help](./help) внутри этого домашнего задания, запустите связку prometheus-grafana.
```commandline
# docker-compose up -d
Starting nodeexporter ... done
Starting prometheus   ... done
Starting grafana      ... done
# docker-compose ps
    Name                  Command               State                    Ports                  
------------------------------------------------------------------------------------------------
grafana        /run.sh                          Up      0.0.0.0:3000->3000/tcp,:::3000->3000/tcp
nodeexporter   /bin/node_exporter --path. ...   Up      9100/tcp                                
prometheus     /bin/prometheus --config.f ...   Up      9090/tcp
```

> 2. Зайдите в веб-интерфейс grafana, используя авторизационные данные, указанные в манифесте docker-compose.

![1.png](img%2F1.png)
> 3. Подключите поднятый вами prometheus, как источник данных.

![2.png](img%2F2.png)
> 4. Решение домашнего задания — скриншот веб-интерфейса grafana со списком подключенных Datasource.

![3.png](img%2F3.png)
## Задание 2

> Изучите самостоятельно ресурсы:
>
>1. [PromQL tutorial for beginners and humans](https://valyala.medium.com/promql-tutorial-for-beginners-9ab455142085).
>1. [Understanding Machine CPU usage](https://www.robustperception.io/understanding-machine-cpu-usage).
>1. [Introduction to PromQL, the Prometheus query language](https://grafana.com/blog/2020/02/04/introduction-to-promql-the-prometheus-query-language/).
>
>Создайте Dashboard и в ней создайте Panels:
>
>- утилизация CPU для nodeexporter (в процентах, 100-idle);
>- CPULA 1/5/15;
>- количество свободной оперативной памяти;
>- количество места на файловой системе.

```commandline
1. avg by (mode, instance) ((rate(node_cpu_seconds_total{job="nodeexporter", mode="idle"}[1m])) * 100)
2.1 rate(node_load1{}[$__rate_interval]) 
2.2 rate(node_load5{}[$__rate_interval])
2.3 rate(node_load15{}[$__rate_interval])
3.1 node_memory_MemFree_bytes{job="nodeexporter"}
3.2 node_memory_MemAvailable_bytes{job="nodeexporter"}
3.3 node_memory_MemTotal_bytes{job="nodeexporter"}
4.1 node_filesystem_free_bytes {job="nodeexporter", fstype="ext4", mountpoint="/"} 
4.2 node_filesystem_avail_bytes {job="nodeexporter", fstype="ext4", mountpoint="/"} 

```

![4.png](img%2F4.png)

## Задание 3

>1. Создайте для каждой Dashboard подходящее правило alert — можно обратиться к первой лекции в блоке «Мониторинг».
>1. В качестве решения задания приведите скриншот вашей итоговой Dashboard.

![6.png](img%2F6.png)
## Задание 4

>1. Сохраните ваш Dashboard.Для этого перейдите в настройки Dashboard, выберите в боковом меню «JSON MODEL». Далее скопируйте отображаемое json-содержимое в отдельный файл и сохраните его.
>1. В качестве решения задания приведите листинг этого файла.

```json
{
  "annotations": {
    "list": [
      {
        "builtIn": 1,
        "datasource": "-- Grafana --",
        "enable": true,
        "hide": true,
        "iconColor": "rgba(0, 211, 255, 1)",
        "name": "Annotations & Alerts",
        "type": "dashboard"
      }
    ]
  },
  "editable": true,
  "gnetId": null,
  "graphTooltip": 0,
  "id": 1,
  "links": [],
  "panels": [
    {
      "alert": {
        "alertRuleTags": {},
        "conditions": [
          {
            "evaluator": {
              "params": [
                30
              ],
              "type": "lt"
            },
            "operator": {
              "type": "and"
            },
            "query": {
              "params": [
                "A",
                "1m",
                "now"
              ]
            },
            "reducer": {
              "params": [],
              "type": "avg"
            },
            "type": "query"
          }
        ],
        "executionErrorState": "alerting",
        "for": "5m",
        "frequency": "1m",
        "handler": 1,
        "message": "CPU idle is less than 30%",
        "name": "CPU idle alert",
        "noDataState": "no_data",
        "notifications": []
      },
      "aliasColors": {
        "Idle time": "red",
        "{instance=\"nodeexporter:9100\", mode=\"idle\"}": "red"
      },
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": null,
      "fieldConfig": {
        "defaults": {
          "custom": {}
        },
        "overrides": []
      },
      "fill": 1,
      "fillGradient": 0,
      "gridPos": {
        "h": 9,
        "w": 12,
        "x": 0,
        "y": 0
      },
      "hiddenSeries": false,
      "id": 2,
      "legend": {
        "avg": false,
        "current": false,
        "max": false,
        "min": false,
        "show": true,
        "total": false,
        "values": false
      },
      "lines": true,
      "linewidth": 1,
      "nullPointMode": "null",
      "options": {
        "alertThreshold": true
      },
      "percentage": false,
      "pluginVersion": "7.4.0",
      "pointradius": 2,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "expr": "avg by (mode, instance) ((rate(node_cpu_seconds_total{job=\"nodeexporter\", mode=\"idle\"}[1m])) * 100)",
          "interval": "",
          "legendFormat": "Idle time",
          "refId": "A"
        }
      ],
      "thresholds": [
        {
          "colorMode": "critical",
          "fill": true,
          "line": true,
          "op": "lt",
          "value": 30,
          "visible": true
        }
      ],
      "timeFrom": null,
      "timeRegions": [],
      "timeShift": null,
      "title": "CPU Idle",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "type": "graph",
      "xaxis": {
        "buckets": null,
        "mode": "time",
        "name": null,
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "$$hashKey": "object:1240",
          "format": "short",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": true
        },
        {
          "$$hashKey": "object:1241",
          "format": "short",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": true
        }
      ],
      "yaxis": {
        "align": false,
        "alignLevel": null
      }
    },
    {
      "alert": {
        "alertRuleTags": {},
        "conditions": [
          {
            "evaluator": {
              "params": [
                0.6
              ],
              "type": "gt"
            },
            "operator": {
              "type": "or"
            },
            "query": {
              "params": [
                "C",
                "15m",
                "now"
              ]
            },
            "reducer": {
              "params": [],
              "type": "avg"
            },
            "type": "query"
          }
        ],
        "executionErrorState": "alerting",
        "for": "5m",
        "frequency": "1m",
        "handler": 1,
        "message": "CPU Latency is too high",
        "name": "CPU Latency Average alert",
        "noDataState": "alerting",
        "notifications": []
      },
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": null,
      "fieldConfig": {
        "defaults": {
          "custom": {}
        },
        "overrides": []
      },
      "fill": 1,
      "fillGradient": 0,
      "gridPos": {
        "h": 9,
        "w": 12,
        "x": 12,
        "y": 0
      },
      "hiddenSeries": false,
      "id": 4,
      "legend": {
        "avg": false,
        "current": false,
        "max": false,
        "min": false,
        "show": true,
        "total": false,
        "values": false
      },
      "lines": true,
      "linewidth": 1,
      "nullPointMode": "null",
      "options": {
        "alertThreshold": true
      },
      "percentage": false,
      "pluginVersion": "7.4.0",
      "pointradius": 2,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "expr": "rate(node_load1{}[$__rate_interval])",
          "interval": "",
          "legendFormat": "LA_1",
          "refId": "A"
        },
        {
          "expr": "rate(node_load5{}[$__rate_interval])",
          "hide": false,
          "interval": "",
          "legendFormat": "LA5",
          "refId": "B"
        },
        {
          "expr": "rate(node_load15{}[$__rate_interval])",
          "hide": false,
          "interval": "",
          "legendFormat": "LA15",
          "refId": "C"
        }
      ],
      "thresholds": [
        {
          "colorMode": "critical",
          "fill": true,
          "line": true,
          "op": "gt",
          "value": 0.6,
          "visible": true
        }
      ],
      "timeFrom": null,
      "timeRegions": [],
      "timeShift": null,
      "title": "CPU Latency Average",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "type": "graph",
      "xaxis": {
        "buckets": null,
        "mode": "time",
        "name": null,
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "$$hashKey": "object:1412",
          "format": "short",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": true
        },
        {
          "$$hashKey": "object:1413",
          "format": "short",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": true
        }
      ],
      "yaxis": {
        "align": false,
        "alignLevel": null
      }
    },
    {
      "alert": {
        "alertRuleTags": {},
        "conditions": [
          {
            "evaluator": {
              "params": [
                1555555550
              ],
              "type": "lt"
            },
            "operator": {
              "type": "and"
            },
            "query": {
              "params": [
                "B",
                "5m",
                "now"
              ]
            },
            "reducer": {
              "params": [],
              "type": "avg"
            },
            "type": "query"
          }
        ],
        "executionErrorState": "alerting",
        "for": "5m",
        "frequency": "1m",
        "handler": 1,
        "message": "available memory is less than 1.5 G",
        "name": "RAM alert",
        "noDataState": "no_data",
        "notifications": []
      },
      "aliasColors": {
        "RAM Available": "blue",
        "RAM Total": "yellow",
        "node_memory_MemAvailable_bytes{instance=\"nodeexporter:9100\", job=\"nodeexporter\"}": "blue",
        "node_memory_MemTotal_bytes{instance=\"nodeexporter:9100\", job=\"nodeexporter\"}": "yellow"
      },
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": null,
      "fieldConfig": {
        "defaults": {
          "custom": {}
        },
        "overrides": []
      },
      "fill": 1,
      "fillGradient": 0,
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 0,
        "y": 9
      },
      "hiddenSeries": false,
      "id": 6,
      "legend": {
        "avg": false,
        "current": false,
        "max": false,
        "min": false,
        "show": true,
        "total": false,
        "values": false
      },
      "lines": true,
      "linewidth": 1,
      "nullPointMode": "null",
      "options": {
        "alertThreshold": true
      },
      "percentage": false,
      "pluginVersion": "7.4.0",
      "pointradius": 2,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "expr": "node_memory_MemFree_bytes{job=\"nodeexporter\"}",
          "interval": "",
          "legendFormat": "RAM Free",
          "refId": "A"
        },
        {
          "expr": "node_memory_MemAvailable_bytes{job=\"nodeexporter\"}",
          "hide": false,
          "interval": "",
          "legendFormat": "RAM Available",
          "refId": "B"
        },
        {
          "expr": "node_memory_MemTotal_bytes{job=\"nodeexporter\"}",
          "hide": false,
          "interval": "",
          "legendFormat": "RAM Total",
          "refId": "C"
        }
      ],
      "thresholds": [
        {
          "colorMode": "critical",
          "fill": true,
          "line": true,
          "op": "lt",
          "value": 1555555550,
          "visible": true
        }
      ],
      "timeFrom": null,
      "timeRegions": [],
      "timeShift": null,
      "title": "RAM",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "type": "graph",
      "xaxis": {
        "buckets": null,
        "mode": "time",
        "name": null,
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "$$hashKey": "object:1501",
          "format": "bytes",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": true
        },
        {
          "$$hashKey": "object:1502",
          "format": "short",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": true
        }
      ],
      "yaxis": {
        "align": false,
        "alignLevel": null
      }
    },
    {
      "alert": {
        "alertRuleTags": {},
        "conditions": [
          {
            "evaluator": {
              "params": [
                10000000000
              ],
              "type": "lt"
            },
            "operator": {
              "type": "and"
            },
            "query": {
              "params": [
                "A",
                "5m",
                "now"
              ]
            },
            "reducer": {
              "params": [],
              "type": "avg"
            },
            "type": "query"
          }
        ],
        "executionErrorState": "alerting",
        "for": "5m",
        "frequency": "1m",
        "handler": 1,
        "message": "Disk space available is less than 10 GB",
        "name": "Disk alert",
        "noDataState": "no_data",
        "notifications": []
      },
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": null,
      "fieldConfig": {
        "defaults": {
          "custom": {}
        },
        "overrides": []
      },
      "fill": 1,
      "fillGradient": 0,
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 12,
        "y": 9
      },
      "hiddenSeries": false,
      "id": 8,
      "legend": {
        "avg": false,
        "current": false,
        "max": false,
        "min": false,
        "show": true,
        "total": false,
        "values": false
      },
      "lines": true,
      "linewidth": 1,
      "nullPointMode": "null",
      "options": {
        "alertThreshold": true
      },
      "percentage": false,
      "pluginVersion": "7.4.0",
      "pointradius": 2,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "expr": "node_filesystem_free_bytes {job=\"nodeexporter\", fstype=\"ext4\", mountpoint=\"/\"} ",
          "interval": "",
          "legendFormat": "Disk Free",
          "refId": "A"
        },
        {
          "expr": "node_filesystem_avail_bytes {job=\"nodeexporter\", fstype=\"ext4\", mountpoint=\"/\"} ",
          "hide": false,
          "interval": "",
          "legendFormat": "Disk Available",
          "refId": "B"
        }
      ],
      "thresholds": [
        {
          "colorMode": "critical",
          "fill": true,
          "line": true,
          "op": "lt",
          "value": 10000000000,
          "visible": true
        }
      ],
      "timeFrom": null,
      "timeRegions": [],
      "timeShift": null,
      "title": "Disk",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "type": "graph",
      "xaxis": {
        "buckets": null,
        "mode": "time",
        "name": null,
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "$$hashKey": "object:1590",
          "format": "bytes",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": true
        },
        {
          "$$hashKey": "object:1591",
          "format": "short",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": true
        }
      ],
      "yaxis": {
        "align": false,
        "alignLevel": null
      }
    }
  ],
  "schemaVersion": 27,
  "style": "dark",
  "tags": [],
  "templating": {
    "list": []
  },
  "time": {
    "from": "now-6h",
    "to": "now"
  },
  "timepicker": {},
  "timezone": "",
  "title": "Node exporter",
  "uid": "qKGHqTbSz",
  "version": 7
}
```
---