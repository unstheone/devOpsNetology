## Задание 1

Есть скрипт:
```bash
a=1
b=2
c=a+b
d=$a+$b
e=$(($a+$b))
```

Какие значения переменным c,d,e будут присвоены? Почему?

| Переменная  | Значение | Обоснование                                                                                                                                                                              |
| ------------- |----------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `c`  | a+b      | В переменную 'c' записали строку 'a+b'                                                                                                                                                   |
| `d`  | 1+2      | В переменную 'd' записали строку, состоящую из значения переменных 'a' и 'b', разделенных символом '+'. 'a' и 'b' объявленны в неявном виде, по умолчанию баш воспринимает их как строку |
| `e`  | 3        | В переменную 'e' записыли сумму переменных 'a' и 'b', т.к. перед первыми скобками есть знак доллара ($), заставляющих bash преобразовать значения внутри скобок в целочисленные          |

----

## Задание 2

На нашем локальном сервере упал сервис и мы написали скрипт, который постоянно проверяет его доступность, записывая дату проверок до тех пор, пока сервис не станет доступным (после чего скрипт должен завершиться). В скрипте допущена ошибка, из-за которой выполнение не может завершиться, при этом место на Жёстком Диске постоянно уменьшается. Что необходимо сделать, чтобы его исправить:
```bash
while ((1==1)
do
	curl https://localhost:4757
	if (($? != 0))
	then
		date >> curl.log
	fi
done
```
### Ваш скрипт:
```bash
while ((1==1))
do
	curl https://localhost:4757
	if (($? != 0))
	then
	    date > curl.log
	else
	    break
	fi
done
```
## Задание 3

Необходимо написать скрипт, который проверяет доступность трёх IP: `192.168.0.1`, `173.194.222.113`, `87.250.250.242` по `80` порту и записывает результат в файл `log`. Проверять доступность необходимо пять раз для каждого узла.

### Ваш скрипт:
```bash
!#/bin/bash
array_ip=("192.168.0.1:80" "173.194.222.113:80" "87.250.250.242:80" )
for i in ${array_ip[@]}
do
        for j in {1..5}
        do
                echo "Тестируем $i $j раз"
                curl -m 10 $i > ~/log
        done
done
```

---
## Задание 4

Необходимо дописать скрипт из предыдущего задания так, чтобы он выполнялся до тех пор, пока один из узлов не окажется недоступным. Если любой из узлов недоступен - IP этого узла пишется в файл error, скрипт прерывается.

### Ваш скрипт:
```bash
!#/bin/bash
array_ip=("173.194.222.113:80" "87.250.250.242:80" "192.168.0.1:80")
check_status=0
while (($check_status == 0))
do
        for i in ${array_ip[@]}
        do
                echo "Тестируем $i"
                curl -m 10 $i
                check_status=$?
                if (($check_status != 0))
                then
                        echo "$i оказался недоступен" >> error
                        break
                else
                        echo "$i доступен, проверка продолжается" > log

                fi
        done
done
```

---