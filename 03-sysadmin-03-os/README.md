# 1) Какой системный вызов делает команда cd?
        chdir("/tmp")
# 2) Попробуйте использовать команду file на объекты разных типов в файловой системе. Используя strace выясните, где находится база данных file, на основании которой она делает свои догадки.
        "/usr/share/misc/magic.mgc"
# 3) Предположим, приложение пишет лог в текстовый файл. Этот файл оказался удален (deleted в lsof), однако возможности сигналом сказать приложению переоткрыть файлы или просто перезапустить приложение – нет. Так как приложение продолжает писать в удаленный файл, место на диске постепенно заканчивается. Основываясь на знаниях о перенаправлении потоков предложите способ обнуления открытого удаленного файла (чтобы освободить место на файловой системе).
        mon@mon-VM:~$ lsof -p 1636 | grep deleted - ищем пример удаленных файлов у конкретного процесса
        gnome-she 1636  mon   47r      REG                8,3    32768  791067 /home/mon/.local/share/gvfs-metadata/root-a23df801.log (deleted)
        mon@mon-VM:~$ > /proc/1636/fd/47 - записываем "ничего" в найденный файловый дескриптор
        mon@mon-VM:~$ lsof -p 1636 | grep deleted - убеждаемся, что размер изменился с 32768 на 0
        gnome-she 1636  mon   47r      REG                8,3        0  791067 /home/mon/.local/share/gvfs-metadata/root-a23df801.log (deleted)
# 4) Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?
        процессы "зомби" не потребляют ресурсов:
        mon@mon-VM:~$ ps axo stat,ppid,pid,comm,%mem,%cpu | grep -w defunct
        Z+     27335   27336 zombi <defunct>  0.0  0.0
# 5) В iovisor BCC есть утилита opensnoop. На какие файлы вы увидели вызовы группы open за первую секунду работы утилиты? Воспользуйтесь пакетом bpfcc-tools для Ubuntu 20.04.
    mon@mon-VM:~$ sudo opensnoop-bpfcc -d 1
    PID    COMM               FD ERR PATH
    552    systemd-oomd        7   0 /proc/meminfo
    552    systemd-oomd        7   0 /proc/meminfo
    552    systemd-oomd        7   0 /proc/meminfo
    552    systemd-oomd        7   0 /sys/fs/cgroup/user.slice/user-1000.slice/user@1000.service/memory.pressure
    552    systemd-oomd        7   0 /sys/fs/cgroup/user.slice/user-1000.slice/user@1000.service/memory.current
    552    systemd-oomd        7   0 /sys/fs/cgroup/user.slice/user-1000.slice/user@1000.service/memory.min
    552    systemd-oomd        7   0 /sys/fs/cgroup/user.slice/user-1000.slice/user@1000.service/memory.low
    552    systemd-oomd        7   0 /sys/fs/cgroup/user.slice/user-1000.slice/user@1000.service/memory.swap.current
    552    systemd-oomd        7   0 /sys/fs/cgroup/user.slice/user-1000.slice/user@1000.service/memory.stat
    552    systemd-oomd        7   0 /proc/meminfo
    552    systemd-oomd        7   0 /proc/meminfo
# 6) Какой системный вызов использует uname -a? Приведите цитату из man по этому системному вызову, где описывается альтернативное местоположение в /proc, где можно узнать версию ядра и релиз ОС
        системный вызов uname()
        mon@mon-VM:~$ strace uname -a
        ...
        openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
        uname({sysname="Linux", nodename="mon-VM", ...}) = 0
        newfstatat(1, "", {st_mode=S_IFCHR|0620, st_rdev=makedev(0x88, 0x1), ...}, AT_EMPTY_PATH) = 0
        uname({sysname="Linux", nodename="mon-VM", ...}) = 0
        uname({sysname="Linux", nodename="mon-VM", ...}) = 0
        
        для uname ключи -r и -v - для релиза и версии ядра ОС, а -o для версии ОС
        -r, --kernel-release
              print the kernel release
        -v, --kernel-version
              print the kernel version
        -o, --operating-system
              print the operating system
        via /proc/sys/kernel/{ostype, hostname, osrelease, version, domainname}
# 7) Чем отличается последовательность команд через ; и через && в bash? Есть ли смысл использовать в bash &&, если применить set -e
        test делает логический тест выражения после самой команды. в примере test -d /tmp/some_dir даёт FALSE, т.к. пока нет файла /tmp/some_dir, являющегося директорией (-d).
        test -d /tmp/some_dir; echo Hi - последовательное выполнение, команды выполняются независимо от результатов другой. test -d /tmp/some_dir && echo Hi - в этом случае echo выполняется только в случае TRUE по test, т.е. когда файл существует и является директорией.
        
        set -e - Exit immediately if a pipeline (which may consist of a single simple command), a list, or a compound command (see SHELL GRAMMAR above), exits with a non-zero status. То есть, при любом неуспешном выполнении команды, сессия разорвется. Как мне кажется, нет практического смысла использовать set -e вместе с &&.
# 8) Из каких опций состоит режим bash set -euxo pipefail и почему его хорошо было бы использовать в сценариях?
        -e - немедленно прерывает выполнение башем, если любая из команд даёт не успешный (не нулевой) результат выполнения
        -u - определяет необъявленные переменные и параметры (кроме @ и *) как ошибки, завершает с ошибкой (не нулевым статусом)
        -x - все исполняемые команды будут выводится в терминал (трассировка)
        -o pipefail позволяет "отловитЬ" ошибки до пайпа (|)

        Хорошо использоваться в скриптах, т.к легче будет находить ошибки в коде (-e немедленно прерывает; -x отобразит, где именно прервалось; -u "подсветит" опечатки в переменных; -o pipefail отследит ошибки в сложных конструкциях, где много потоков вывода -> ввода
# 9) Используя -o stat для ps, определите, какой наиболее часто встречающийся статус у процессов в системе. В man ps ознакомьтесь (/PROCESS STATE CODES) что значат дополнительные к основной заглавной буквы статуса процессов. Его можно не учитывать при расчете (считать S, Ss или Ssl равнозначными).
    Самый частый S - спящий, ожидающий какого-то события
    Второй по частоте I - фоновые процессы ядра
    mon@mon-VM:~$ ps -ax -o s > ps.txt
    mon@mon-VM:~$ sort ps.txt | uniq -c
     77 I
      1 R
    218 S
    
    дополнительные буквы к основной раскрывают детали процесса. s - лидер сессии, l - многопоточный, + - на форграунде и т.д.