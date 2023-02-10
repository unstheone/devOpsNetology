
1. Работа c HTTP через телнет.
- Подключитесь утилитой телнет к сайту stackoverflow.com
`telnet stackoverflow.com 80`
- Отправьте HTTP запрос
```bash
GET /questions HTTP/1.0
HOST: stackoverflow.com
[press enter]
[press enter]
```
*В ответе укажите полученный HTTP код, что он означает?*

        vagrant@vagrant:~$ telnet stackoverflow.com 80
        Trying 151.101.65.69...
        Connected to stackoverflow.com.
        Escape character is '^]'.
        GET /questions HTTP/1.0
        HOST: stackoverflow.com
        
        HTTP/1.1 403 Forbidden
        Connection: close
        Content-Length: 1917
        Server: Varnish
        Retry-After: 0
        Content-Type: text/html
        Accept-Ranges: bytes
        Date: Fri, 10 Feb 2023 06:21:57 GMT
        Via: 1.1 varnish
        X-Served-By: cache-lhr7382-LHR
        X-Cache: MISS
        X-Cache-Hits: 0
        X-Timer: S1676010117.104106,VS0,VE1
        X-DNS-Prefetch-Control: off
        
        <!DOCTYPE html>
        <html>
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
            <title>Forbidden - Stack Exchange</title>
            <style type="text/css">
                        body
                        {
                                color: #333;
                                font-family: 'Helvetica Neue', Arial, sans-serif;
                                font-size: 14px;
                                background: #fff url('img/bg-noise.png') repeat left top;
                                line-height: 1.4;
                        }
                        h1
                        {
                                font-size: 170%;
                                line-height: 34px;
                                font-weight: normal;
                        }
                        a { color: #366fb3; }
                        a:visited { color: #12457c; }
                        .wrapper {
                                width:960px;
                                margin: 100px auto;
                                text-align:left;
                        }
                        .msg {
                                float: left;
                                width: 700px;
                                padding-top: 18px;
                                margin-left: 18px;
                        }
            </style>
        </head>
        <body>
            <div class="wrapper">
                        <div style="float: left;">
                                <img src="https://cdn.sstatic.net/stackexchange/img/apple-touch-icon.png" alt="Stack Exchange" />
                        </div>
                        <div class="msg">
                                <h1>Access Denied</h1>
                                <p>This IP address (x.x.x.x) has been blocked from access to our services. If you believe this to be in error, please contact us at <a href="mailto:team@stackexchange.com?Subject=Blocked%20x.x.x.x%20(Request%20ID%3A%202626234011-LHR)">team@stackexchange.com</a>.</p>
                                <p>When contacting us, please include the following information in the email:</p>
                                <p>Method: block</p>
                                <p>XID: 2626234011-LHR</p>
                                <p>IP: x.x.x.x</p>
                                <p>X-Forwarded-For: </p>
                                <p>User-Agent: </p>
        
                                <p>Time: Fri, 10 Feb 2023 06:21:57 GMT</p>
                                <p>URL: stackoverflow.com/questions</p>
                                <p>Browser Location: <span id="jslocation">(not loaded)</span></p>
                        </div>
                </div>
                <script>document.getElementById('jslocation').innerHTML = window.location.href;</script>
        </body>
        </html>Connection closed by foreign host.

``` на уровне HTTP - 403 Forbidden. Означает что сервер запрос принял, но не авторизировал его. Запретил, по простому.```

2. Повторите задание 1 в браузере, используя консоль разработчика F12.
- откройте вкладку `Network`
- отправьте запрос http://stackoverflow.com
- найдите первый ответ HTTP сервера, откройте вкладку `Headers`
- укажите в ответе полученный HTTP код
- проверьте время загрузки страницы, какой запрос обрабатывался дольше всего?
- приложите скриншот консоли браузера в ответ.

        Сначала HTTP 307 - redirect на другой url, потом HTTP 200 -OK.
        Самый долгий - загрузка основной страницы с её контентом, как раз первый HTTP 200.
        See screentshot1.png
3. Какой IP адрес у вас в интернете?
        ``See screentshot2.png``
4. Какому провайдеру принадлежит ваш IP адрес? Какой автономной системе AS? Воспользуйтесь утилитой `whois`
        ``ISP - MTS, AS8359 ``
    ``` Information related to '195.210.128.0/18AS8359
    
    route:          195.210.128.0/18
    descr:          Mobile TeleSystems PJSC, Moscow division / former COMSTAR Telecommunications
    descr:          RUSSIA
    origin:         AS8359
    mnt-by:         COMSTAR-MNT
    created:        2016-06-04T18:45:35Z
    last-modified:  2016-06-04T18:45:35Z
    source:         RIPE # Filtered ```
5. Через какие сети проходит пакет, отправленный с вашего компьютера на адрес 8.8.8.8? Через какие AS? Воспользуйтесь утилитой `traceroute`
 ```
    vagrant@vagrant:~$ traceroute -IAn 8.8.8.8
    traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets
    1  10.0.2.2 [*]  0.454 ms  0.401 ms  0.393 ms
    2  172.23.0.3 [*]  2.313 ms  4.477 ms  5.264 ms
    3  172.31.63.5 [*]  5.465 ms  5.457 ms  5.702 ms
    4  195.210.132.81 [AS8359]  5.757 ms  6.043 ms  7.585 ms
    5  212.248.28.245 [AS8359]  8.667 ms  8.788 ms  9.311 ms
    6  212.248.28.246 [AS8359]  9.064 ms  3.172 ms  4.267 ms
    7  212.188.31.24 [AS8359]  4.733 ms  6.451 ms  9.337 ms
    8  195.34.50.182 [AS8359]  10.200 ms  10.746 ms  11.339 ms
    9  212.188.56.13 [AS8359]  12.553 ms  13.135 ms  12.274 ms
    10  195.34.53.201 [AS8359]  10.338 ms  10.805 ms  11.372 ms
    11  209.85.149.166 [AS15169]  13.083 ms  12.827 ms  7.125 ms
    12  172.253.68.11 [AS15169]  5.606 ms  6.270 ms  5.885 ms
    13  108.170.250.83 [AS15169]  5.082 ms * *
    14  72.14.234.54 [AS15169]  20.605 ms  21.169 ms  21.127 ms
    15  66.249.95.224 [AS15169]  23.198 ms  24.467 ms  24.996 ms
    16  216.239.47.167 [AS15169]  24.969 ms  26.169 ms  26.146 ms
    17  * * *
    18  * * *
    19  * * *
    20  * * *
    21  * * *
    22  * * *
    23  * * *
    24  * * *
    25  * * *
    26  8.8.8.8 [AS15169/AS263411]  28.444 ms  29.351 ms  31.291 ms

```
7. Повторите задание 5 в утилите `mtr`. На каком участке наибольшая задержка - delay?
```
 Host                                                                                                                                                                   Loss%   Snt   Last   Avg  Best  Wrst StDev
 1. AS???    10.0.2.2                                                                                                                                                    0.0%   104    0.6   1.5   0.4  39.4   5.6
 2. AS???    172.23.0.3                                                                                                                                                  0.0%   104   19.5   5.2   1.8  44.5   7.7
 3. AS???    172.31.63.5                                                                                                                                                 0.0%   104    4.4   4.3   1.9  49.2   5.8
 4. AS8359   195.210.132.81                                                                                                                                              0.0%   104    3.3   6.0   2.4  49.5   8.5
 5. AS8359   212.248.28.245                                                                                                                                              0.0%   104    3.9   5.9   2.9  44.4   7.4
 6. AS8359   212.248.28.246                                                                                                                                              0.0%   104    4.6   4.4   2.5  34.2   4.2
 7. AS8359   212.188.31.24                                                                                                                                               0.0%   104    4.6   6.9   3.3  61.4   9.7
 8. AS8359   195.34.50.182                                                                                                                                               0.0%   104    4.1   5.3   3.2  37.8   4.0
 9. AS8359   212.188.56.13                                                                                                                                              69.9%   104   10.7  10.8   4.0  51.3  11.2
10. AS8359   195.34.53.201                                                                                                                                               0.0%   104    4.6   7.0   3.9  41.0   7.6
11. AS15169  209.85.149.166                                                                                                                                              0.0%   104    5.0   8.3   4.9  46.5   8.0
12. AS15169  172.253.68.11                                                                                                                                               0.0%   104    5.5   7.1   4.5  43.3   6.8
13. AS15169  108.170.250.83                                                                                                                                             34.6%   104    4.8  10.2   3.9  91.7  14.4
14. AS15169  72.14.234.54                                                                                                                                                0.0%   104   20.9  22.6  18.3  52.8   7.8
15. AS15169  66.249.95.224                                                                                                                                               0.0%   104   33.3  24.6  19.5  75.9   9.7
16. AS15169  216.239.47.167                                                                                                                                              0.0%   104   23.0  25.4  22.2  62.0   7.4
17. (waiting for reply)
18. (waiting for reply)
19. (waiting for reply)
20. (waiting for reply)
21. (waiting for reply)
22. (waiting for reply)
23. (waiting for reply)
24. (waiting for reply)
25. (waiting for reply)
26. AS15169  8.8.8.8                                                                                                                                                     0.0%   103   23.9  22.6  21.4  56.5   3.4

```
``Высокие задержки на дальних роутерах, если считать из тех, кто отвечает - 14, 15 и 16. При этом на 9 хопе есть крупные потери пакетов.``
8. Какие DNS сервера отвечают за доменное имя dns.google? Какие A записи? Воспользуйтесь утилитой `dig`
```
vagrant@vagrant:~$ dig dns.google

; <<>> DiG 9.16.1-Ubuntu <<>> dns.google
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 58718
;; flags: qr rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 65494
;; QUESTION SECTION:
;dns.google.                    IN      A

;; ANSWER SECTION:
dns.google.             567     IN      A       8.8.8.8
dns.google.             567     IN      A       8.8.4.4

;; Query time: 28 msec
;; SERVER: 127.0.0.53#53(127.0.0.53)
;; WHEN: Fri Feb 10 07:14:17 UTC 2023
;; MSG SIZE  rcvd: 71
```
`8.8.8.8 и 8.8.4.4`
8. Проверьте PTR записи для IP адресов из задания 7. Какое доменное имя привязано к IP? Воспользуйтесь утилитой `dig`
```
vagrant@vagrant:~$ dig -x 8.8.8.8

; <<>> DiG 9.16.1-Ubuntu <<>> -x 8.8.8.8
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 52706
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 65494
;; QUESTION SECTION:
;8.8.8.8.in-addr.arpa.          IN      PTR

;; ANSWER SECTION:
8.8.8.8.in-addr.arpa.   31227   IN      PTR     dns.google.

;; Query time: 32 msec
;; SERVER: 127.0.0.53#53(127.0.0.53)
;; WHEN: Fri Feb 10 07:18:15 UTC 2023
;; MSG SIZE  rcvd: 73

vagrant@vagrant:~$ dig -x 8.8.4.4

; <<>> DiG 9.16.1-Ubuntu <<>> -x 8.8.4.4
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 26695
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 65494
;; QUESTION SECTION:
;4.4.8.8.in-addr.arpa.          IN      PTR

;; ANSWER SECTION:
4.4.8.8.in-addr.arpa.   28701   IN      PTR     dns.google.

;; Query time: 28 msec
;; SERVER: 127.0.0.53#53(127.0.0.53)
;; WHEN: Fri Feb 10 07:18:18 UTC 2023
;; MSG SIZE  rcvd: 73
```