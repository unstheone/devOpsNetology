## Задание 1

Мы выгрузили JSON, который получили через API запрос к нашему сервису:

```
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            }
            { "name" : "second",
            "type" : "proxy",
            "ip : 71.78.22.43
            }
        ]
    }
```
  Нужно найти и исправить все ошибки, которые допускает наш сервис

### Ваш скрипт:
```json
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            },
            { "name" : "second",
            "type" : "proxy",
            "ip : "71.78.22.43"
            }
        ]
    }
```

---

## Задание 2

В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: `{ "имя сервиса" : "его IP"}`. Формат записи YAML по одному сервису: `- имя сервиса: его IP`. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

### Ваш скрипт:
```python
#!/usr/bin/env python3
import time, socket, json, yaml

hosts_dict = {"drive.google.com": "192.168.1.1", "mail.google.com": "192.168.1.2", "google.com": "192.168.1.3"}

while(True):
    try: #открывыем файл при его присутствии в директории
        with open ('data.json', 'r') as json_file:
            try: # загружаем файл как словарь python, с проверкой на корректность
                json_hosts = json.load(json_file)
                print(f"Подгружен файл data.json")
            except json.decoder.JSONDecodeError as e:
                print(f"Файл data.json имеет неверный формат. Пожалуйста, удалите файл с диска и запустите скрипт ещё раз")
                exit()
        for host in hosts_dict:
            ip = socket.gethostbyname(host)
            try:
                if (json_hosts[host] == ip):
                    print ("[OK] - no change "+ host + " " + ip )
                else:
                    print("[ERROR] " + host +" IP missmatch: " + json_hosts[host] + " " + ip)
                json_hosts[host] = ip
            except:
                json_hosts[host] = ip
                print ("[FIRST TEST] " + host + " " + ip)
        #json_result = json.dump(json_hosts)
        #yaml_result = yaml.dump(json_hosts)
        with open ('data.json', 'w') as js:
            js.write(json.dumps(json_hosts))
        with open ('data.yml', 'w') as yml:
            yml.write(yaml.dump(json_hosts, default_flow_style=False))
    except FileNotFoundError as e:
        print(f'Нет файла {e.filename}, создаём с временными IP адресами')
        tmp = open(e.filename, 'w+')
        tmp.write(json.dumps(hosts_dict, indent=4))
        tmp.read()
    time.sleep(5)
```

### Вывод скрипта при запуске при тестировании:
```
vagrant@vagrant:~$ python3 7.py

Нет файла data.json, создаём с временными IP адресами
Подгружен файл data.json
[ERROR] drive.google.com IP missmatch: 192.168.1.1 142.250.74.78
[ERROR] mail.google.com IP missmatch: 192.168.1.2 216.58.207.197
[ERROR] google.com IP missmatch: 192.168.1.3 142.250.74.174
Подгружен файл data.json
[OK] - no change drive.google.com 142.250.74.78
[OK] - no change mail.google.com 216.58.207.197
[OK] - no change google.com 142.250.74.174
Подгружен файл data.json
[OK] - no change drive.google.com 142.250.74.78
[OK] - no change mail.google.com 216.58.207.197
[OK] - no change google.com 142.250.74.174
```

### json-файл(ы), который(е) записал ваш скрипт:
`vagrant@vagrant:~$ cat data.json`
```json
{"drive.google.com": "142.250.74.78", "mail.google.com": "216.58.207.197", "google.com": "142.250.74.174"}
```

### yml-файл(ы), который(е) записал ваш скрипт:
`vagrant@vagrant:~$ cat data.yml`
```yaml
drive.google.com: 142.250.74.78
google.com: 142.250.74.174
mail.google.com: 216.58.207.197
```

---