# 1) Какого типа команда cd? Попробуйте объяснить, почему она именно такого типа: опишите ход своих мыслей, если считаете, что она могла бы быть другого типа.
    cd - команда, встроенная в оболочку
        mon@mon-VM:~$ type -a cd
        cd is a shell builtin
# 2) Какая альтернатива без pipe команде grep <some_string> <some_file> | wc -l?
    mon@mon-VM:~$ grep systemd /var/log/syslog | wc -l
    468
    mon@mon-VM:~$ grep -c systemd /var/log/syslog
    468
# 3) Какой процесс с PID 1 является родителем для всех процессов в вашей виртуальной машине Ubuntu 20.04?
    mon@mon-VM:~$ ps -p 1
    PID TTY          TIME CMD
      1 ?        00:00:03 systemd
# 4) Как будет выглядеть команда, которая перенаправит вывод stderr ls на другую сессию терминала?
### Находясь в сессии 1 перенаправляю в 0:
    mon@mon-VM:/dev/pts$ ls /no/such/directory 2> /dev/pts/0
### в соседнем экране:
    ls: cannot access '/no/such/directory': No such file or directory
# 5) Получится ли одновременно передать команде файл на stdin и вывести ее stdout в другой файл? Приведите работающий пример.
    mon@mon-VM:/dev/pts$ grep -c systemd /var/log/syslog > ~/syslog_systemd_lines_counter.txt
    mon@mon-VM:/dev/pts$ cat ~/syslog_systemd_lines_counter.txt
    485
# 6) Получится ли, находясь в графическом режиме, вывести данные из PTY в какой-либо из эмуляторов TTY? Сможете ли вы наблюдать выводимые данные?
### Сначала откроем сессию в TTY3 (залогинимся) CTRL + ALT + F3. После чего, вернемся в PTY0 - CTRL + ALT + F2, и напишием echo, перенаправив stdout в tty3. Чтобы увидеть контент, надо снова переключиться - CTRL + ALT + F3.
    mon@mon-VM:~$ tty
    /dev/pts/0
    mon@mon-VM:~$ echo "hello from pty0" >/dev/tty3
    
# 7) Выполните команду bash 5>&1. К чему она приведет? Что будет, если вы выполните echo netology > /proc/$$/fd/5? Почему так происходит?
    bash 5>&1  
### создаст файловый дескриптор 5 процесса bash текущей сессии и перенаправит его в stoud
    echo netology > /proc/$$/fd/5
### сделает запись слова netology в файловый дескриптор 5, а так как он ассоциирован с stdout, то мы увидим это слово в терминале

# 8) Получится ли в качестве входного потока для pipe использовать только stderr команды, не потеряв при этом отображение stdout на pty? Напоминаем: по умолчанию через pipe передается только stdout команды слева от | на stdin команды справа. Это можно сделать, поменяв стандартные потоки местами через промежуточный новый дескриптор, который вы научились создавать в предыдущем вопросе.
### смотрим стандартный вывод команды
    mon@mon-VM:~$ ls -l /var/
    total 48
    drwxr-xr-x  2 root root     4096 дек 30 09:21 backups
    drwxr-xr-x 18 root root     4096 дек  1 17:44 cache
    drwxrwsrwt  2 root whoopsie 4096 янв  2 15:51 crash
    drwxr-xr-x 70 root root     4096 дек 26 12:48 lib
    drwxrwsr-x  2 root staff    4096 апр 18  2022 local
    lrwxrwxrwx  1 root root        9 ноя 30 09:18 lock -> /run/lock
    drwxrwxr-x 13 root syslog   4096 янв  2 15:51 log
    drwxrwsr-x  2 root mail     4096 авг  9 14:48 mail
    drwxrwsrwt  2 root whoopsie 4096 авг  9 14:51 metrics
    drwxr-xr-x  2 root root     4096 авг  9 14:48 opt
    lrwxrwxrwx  1 root root        4 ноя 30 09:18 run -> /run
    drwxr-xr-x 10 root root     4096 авг  9 14:55 snap
    drwxr-xr-x  7 root root     4096 авг  9 14:50 spool
    drwxrwxrwt 11 root root     4096 янв  2 17:52 tmp
### направляем временный дескриптор в stderr, stderr - в stdout, а stdout - во временный дескриптор.
    mon@mon-VM:~$ ls -l /var/ 6>&2 2>&1 1>&6 | grep snap
    total 48
    drwxr-xr-x  2 root root     4096 дек 30 09:21 backups
    drwxr-xr-x 18 root root     4096 дек  1 17:44 cache
    drwxrwsrwt  2 root whoopsie 4096 янв  2 15:51 crash
    drwxr-xr-x 70 root root     4096 дек 26 12:48 lib
    drwxrwsr-x  2 root staff    4096 апр 18  2022 local
    lrwxrwxrwx  1 root root        9 ноя 30 09:18 lock -> /run/lock
    drwxrwxr-x 13 root syslog   4096 янв  2 15:51 log
    drwxrwsr-x  2 root mail     4096 авг  9 14:48 mail
    drwxrwsrwt  2 root whoopsie 4096 авг  9 14:51 metrics
    drwxr-xr-x  2 root root     4096 авг  9 14:48 opt
    lrwxrwxrwx  1 root root        4 ноя 30 09:18 run -> /run
    drwxr-xr-x 10 root root     4096 авг  9 14:55 snap
    drwxr-xr-x  7 root root     4096 авг  9 14:50 spool
    drwxrwxrwt 11 root root     4096 янв  2 17:52 tmp
### без перенаправления потоков команда выдала бы только строчку с директорией snap, но в нашем случае даёт полный stdout. В pipe при этом уходит на stdin контент stderr, проверим, попытавшись посмотреть несуществующий файл:
    mon@mon-VM:~$ ls -l /var/hh 6>&2 2>&1 1>&6 | grep No
    ls: cannot access '/var/hh': No such file or directory
# 9) Что выведет команда cat /proc/$$/environ? Как еще можно получить аналогичный по содержанию вывод?
### выводятся переменные окружения в одну строку. В более читаемом формате можно получить тот же результат командой **env**.
# 10) Используя man, опишите что доступно по адресам /proc/<PID>/cmdline, /proc/<PID>/exe
## /proc/<PID\>/cmdline - путь к исполняемому файлу процесса
## /proc/<PID\>/exe - ссылка на файл, запущенный процессом
# 11) Узнайте, какую наиболее старшую версию набора инструкций SSE поддерживает ваш процессор с помощью /proc/cpuinfo
### sse4_2
    root@mon-VM:/proc# cat cpuinfo | grep sse
    flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx rdtscp lm constant_tsc rep_good nopl xtopology nonstop_tsc cpuid tsc_known_freq pni ssse3 cx16 pcid sse4_1 sse4_2 x2apic hypervisor lahf_lm invpcid_single fsgsbase invpcid md_clear flush_l1d arch_capabilities
    flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx rdtscp lm constant_tsc rep_good nopl xtopology nonstop_tsc cpuid tsc_known_freq pni ssse3 cx16 pcid sse4_1 sse4_2 x2apic hypervisor lahf_lm invpcid_single fsgsbase invpcid md_clear flush_l1d arch_capabilities
# 12) При открытии нового окна терминала и vagrant ssh создается новая сессия и выделяется pty. Это можно подтвердить командой tty, которая упоминалась в лекции 3.2. Однако: vagrant@netology1:~$ ssh localhost 'tty' not a tty. Почитайте, почему так происходит, и как изменить поведение.
    При выполнении команды ssh без аттрибутов на удаленном сервере не выделяется TTY
    Опция -t принудительно выделит псевдотерминал: ssh -t localhost 'tty'
# 13) Бывает, что есть необходимость переместить запущенный процесс из одной сессии в другую. Попробуйте сделать это, воспользовавшись reptyr. Например, так можно перенести в screen процесс, который вы запустили по ошибке в обычной SSH-сессии.
### перенес идущий пинг из одной сессии в другую:
    sudo reptyr -s 6207
    64 bytes from localhost (127.0.0.1): icmp_seq=327 ttl=64 time=0.021 ms
    64 bytes from localhost (127.0.0.1): icmp_seq=328 ttl=64 time=0.019 ms
    64 bytes from localhost (127.0.0.1): icmp_seq=329 ttl=64 time=0.033 ms
    64 bytes from localhost (127.0.0.1): icmp_seq=330 ttl=64 time=0.021 ms
# 14) sudo echo string > /root/new_file не даст выполнить перенаправление под обычным пользователем, так как перенаправлением занимается процесс shell'а, который запущен без sudo под вашим пользователем. Для решения данной проблемы можно использовать конструкцию echo string | sudo tee /root/new_file. Узнайте? что делает команда tee и почему в отличие от sudo echo команда с sudo tee будет работать.
### tee читает с stdin и записывает в stdout и файлы. В первом примере sudo относится к команде echo, но не к перенаправлению и записи в файл, поэтому permission denied. Во втором примере sudo перед tee, соответственно запись идёт с правами суперпользователя.