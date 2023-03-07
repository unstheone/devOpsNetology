## Задание 1

Есть скрипт:
```python
#!/usr/bin/env python3
a = 1
b = '2'
c = a + b
```

### Вопросы:

| Вопрос  | Ответ                                                                                             |
| ------------- |---------------------------------------------------------------------------------------------------|
| Какое значение будет присвоено переменной `c`?  | Никакого, выдаст ошибку на операцию сложения, т.к. пытаемся сложить str и int                     |
| Как получить для переменной `c` значение 12?  | Сделать a = '1', тогда она станет строкой, а переменная 'c' - строкой '12'                        |
| Как получить для переменной `c` значение 3?  | Вернуть a = 1. Сделать b = 2, тогда она станет целочисленной, а переменная 'c' - целочисленным 3. |

------

## Задание 2

Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. 

Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        break
```

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os

bash_command = ["cd $(git rev-parse --show-toplevel)", "git ls-files -m --full-name"]
result_os = os.popen(' && '.join(bash_command)).read()

for result in result_os.split('\n'):
    if result != '':
        print(os.path.abspath(result))
```

### Вывод скрипта при запуске при тестировании:
```
vagrant@vagrant:~$ python3 2.py
/home/vagrant/1.py
/home/vagrant/log
```

------

## Задание 3

Доработать скрипт выше так, чтобы он не только мог проверять локальный репозиторий в текущей директории, но и умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os, sys

directory = sys.argv[1]
bash_command = [f"cd {directory})", "git ls-files -m --full-name"]
result_os = os.popen(' && '.join(bash_command)).read()

for result in result_os.split('\n'):
    if result != '':
        print(os.path.abspath(result))
```

### Вывод скрипта при запуске при тестировании:
```
vagrant@vagrant:~$ python3 3.py /home
fatal: not a git repository (or any of the parent directories): .git
vagrant@vagrant:~$ python3 3.py /home/vagrant/
/home/vagrant/1.py
/home/vagrant/log
vagrant@vagrant:~$
```

------

## Задание 4

Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. 

Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. 

Мы хотим написать скрипт, который: 
- опрашивает веб-сервисы, 
- получает их IP, 
- выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. 

Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: `drive.google.com`, `mail.google.com`, `google.com`.

### Ваш скрипт:
```python
#!/usr/bin/env python3
import time, socket

hosts = ['drive.google.com', 'google.com', 'mail.google.com']
IPs = {}
while (True):
    for host in hosts:
        ip = socket.gethostbyname(host)
        try:
            if (IPs[host] == ip):
                print ("[OK] - no change "+ host + " " + ip )
            else:
                print("[ERROR] " + host +" IP missmatch: " + IPs[host] + " " + ip)
            IPs[host] = ip
        except:
            IPs[host] = ip
            print ("[FIRST TEST] " + host + " " + ip)
    time.sleep(5)
```

### Вывод скрипта при запуске при тестировании:
```
vagrant@vagrant:~$ python3 4.py
[FIRST TEST] drive.google.com 64.233.165.194
[FIRST TEST] google.com 209.85.233.139
[FIRST TEST] mail.google.com 64.233.162.18
[OK] - no change drive.google.com 64.233.165.194
[ERROR] google.com IP missmatch: 209.85.233.139 209.85.233.100
[ERROR] mail.google.com IP missmatch: 64.233.162.18 64.233.162.83
[OK] - no change drive.google.com 64.233.165.194
[OK] - no change google.com 209.85.233.100
[OK] - no change mail.google.com 64.233.162.83
[OK] - no change drive.google.com 64.233.165.194
[OK] - no change google.com 209.85.233.100
[OK] - no change mail.google.com 64.233.162.83
[OK] - no change drive.google.com 64.233.165.194
[OK] - no change google.com 209.85.233.100
[OK] - no change mail.google.com 64.233.162.83
[OK] - no change drive.google.com 64.233.165.194
[OK] - no change google.com 209.85.233.100
[OK] - no change mail.google.com 64.233.162.83
[OK] - no change drive.google.com 64.233.165.194
[OK] - no change google.com 209.85.233.100
[OK] - no change mail.google.com 64.233.162.83
[ERROR] drive.google.com IP missmatch: 64.233.165.194 64.233.162.194
[OK] - no change google.com 209.85.233.100
[OK] - no change mail.google.com 64.233.162.83
^CTraceback (most recent call last):
  File "4.py", line 17, in <module>
    time.sleep(5)
KeyboardInterrupt

vagrant@vagrant:~$
```

------