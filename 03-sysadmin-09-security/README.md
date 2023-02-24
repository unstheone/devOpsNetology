## Задание
1. Установите Bitwarden плагин для браузера. Зарегестрируйтесь и сохраните несколько паролей.
```
Давно пользуюсь LastPass, поэтому не буду ставить Bitwarden. Приложу скриншот от LastPass (1.png), логика такая же.
```
2. Установите Google authenticator на мобильный телефон. Настройте вход в Bitwarden акаунт через Google authenticator OTP.
```
Пользуюсь google authenticator'ом для других критичных аккаунтов. 2.png
```
3. Установите apache2, сгенерируйте самоподписанный сертификат, настройте тестовый сайт для работы по HTTPS.
```
vagrant@vagrant:~$ sudo apt install apache2
vagrant@vagrant:~$ sudo systemctl status apache2
  apache2.service - The Apache HTTP Server
     Loaded: loaded (/lib/systemd/system/apache2.service; enabled; vendor preset: enabled)
     Active: active (running) since Fri 2023-02-24 12:13:18 UTC; 51s ago
vagrant@vagrant:~$ sudo a2enmod ssl
Considering dependency setenvif for ssl:
Module setenvif already enabled
Considering dependency mime for ssl:
Module mime already enabled
Considering dependency socache_shmcb for ssl:
Enabling module socache_shmcb.
Enabling module ssl.
See /usr/share/doc/apache2/README.Debian.gz on how to configure SSL and create self-signed certificates.
To activate the new configuration, you need to run:
  systemctl restart apache2
vagrant@vagrant:~$ sudo systemctl restart apache2
vagrant@vagrant:~$ sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
> -keyout /etc/ssl/private/apache-selfsigned.key \
> -out /etc/ssl/certs/apache-selfsigned.crt \
> -subj "/C=RU/ST=Moscow/L=Moscow/O=Company Name/OU=Org/CN=www.test.com"
Generating a RSA private key
............................+++++
.............+++++
writing new private key to '/etc/ssl/private/apache-selfsigned.key'
vagrant@vagrant:~$ cat /etc/apache2/sites-available/localhost.conf
<VirtualHost *:443>
        ServerName 127.0.0.1
        DocumentRoot /var/www/localhost/
        SSLEngine on
        SSLCertificateFile /etc/ssl/certs/apache-selfsigned.crt
        SSLCertificateKeyFile /etc/ssl/private/apache-selfsigned.key
</VirtualHost>
root@vagrant:/etc/ssl/certs# sudo apache2ctl configtest
AH00558: apache2: Could not reliably determine the server's fully qualified domain name, using 127.0.1.1. Set the 'ServerName' directive globally to suppress this message
Syntax OK
```
4. Проверьте на TLS уязвимости произвольный сайт в интернете (кроме сайтов МВД, ФСБ, МинОбр, НацБанк, РосКосмос, РосАтом, РосНАНО и любых госкомпаний, объектов КИИ, ВПК ... и тому подобное).
```
root@vagrant:/testssl.sh# ./testssl.sh -U --sneaky https://netology.ru

###########################################################
    testssl.sh       3.2rc2 from https://testssl.sh/dev/
    (88763f4 2023-02-20 20:29:14)

      This program is free software. Distribution and
             modification under GPLv2 permitted.
      USAGE w/o ANY WARRANTY. USE IT AT YOUR OWN RISK!

       Please file bugs @ https://testssl.sh/bugs/

###########################################################

 Using "OpenSSL 1.0.2-bad (1.0.2k-dev)" [~183 ciphers]
 on vagrant:./bin/openssl.Linux.x86_64
 (built: "Sep  1 14:03:44 2022", platform: "linux-x86_64")


Testing all IPv4 addresses (port 443): 104.22.40.171 172.67.21.207 104.22.41.171
--------------------------------------------------------------------------------------------------------------------------------------------
 Start 2023-02-24 12:57:52        -->> 104.22.40.171:443 (netology.ru) <<--

 Further IP addresses:   104.22.41.171 172.67.21.207 2606:4700:10::6816:28ab 2606:4700:10::6816:29ab 2606:4700:10::ac43:15cf
 rDNS (104.22.40.171):   --
 Service detected:       HTTP


 Testing vulnerabilities

 Heartbleed (CVE-2014-0160)                not vulnerable (OK), no heartbeat extension
 CCS (CVE-2014-0224)                       not vulnerable (OK)
 Ticketbleed (CVE-2016-9244), experiment.  not vulnerable (OK), no session tickets
 ROBOT                                     not vulnerable (OK)
 Secure Renegotiation (RFC 5746)           OpenSSL handshake didn't succeed
 Secure Client-Initiated Renegotiation     not vulnerable (OK)
 CRIME, TLS (CVE-2012-4929)                not vulnerable (OK)
 BREACH (CVE-2013-3587)                    potentially NOT ok, "gzip" HTTP compression detected. - only supplied "/" tested
                                           Can be ignored for static pages or if no secrets in the page
 POODLE, SSL (CVE-2014-3566)               not vulnerable (OK)
 TLS_FALLBACK_SCSV (RFC 7507)              Downgrade attack prevention supported (OK)
 SWEET32 (CVE-2016-2183, CVE-2016-6329)    VULNERABLE, uses 64 bit block ciphers
 FREAK (CVE-2015-0204)                     not vulnerable (OK)
 DROWN (CVE-2016-0800, CVE-2016-0703)      not vulnerable on this host and port (OK)
                                           make sure you don't use this certificate elsewhere with SSLv2 enabled services, see
                                           https://search.censys.io/search?resource=hosts&virtual_hosts=INCLUDE&q=0579A5707C899759AEBB6D89DE69CBBF3B0044692B1F72DFB92387419F9F720E
 LOGJAM (CVE-2015-4000), experimental      not vulnerable (OK): no DH EXPORT ciphers, no DH key detected with <= TLS 1.2
 BEAST (CVE-2011-3389)                     TLS1: ECDHE-RSA-AES128-SHA AES128-SHA ECDHE-RSA-AES256-SHA AES256-SHA DES-CBC3-SHA
                                           VULNERABLE -- but also supports higher protocols  TLSv1.1 TLSv1.2 (likely mitigated)
 LUCKY13 (CVE-2013-0169), experimental     potentially VULNERABLE, uses cipher block chaining (CBC) ciphers with TLS. Check patches
 Winshock (CVE-2014-6321), experimental    not vulnerable (OK)
 RC4 (CVE-2013-2566, CVE-2015-2808)        no RC4 ciphers detected (OK)


 Done 2023-02-24 12:58:46 [  59s] -->> 104.22.40.171:443 (netology.ru) <<--
```
5. Установите на Ubuntu ssh сервер, сгенерируйте новый приватный ключ. Скопируйте свой публичный ключ на другой сервер. Подключитесь к серверу по SSH-ключу.
```
root@vagrant:/etc/ssl/certs/testssl.sh# ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/root/.ssh/id_rsa):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /root/.ssh/id_rsa
Your public key has been saved in /root/.ssh/id_rsa.pub
The key fingerprint is:
SHA256:Jcdu9gCYlVJRoxqL9YPLTckJFNz5Zq235HuM74tQy2k root@vagrant
The key's randomart image is:
+---[RSA 3072]----+
|     .o++=o      |
|     .o++o .     |
|      *.+.+.     |
|     o O O+ .    |
|    . + So=..    |
|     . + +.=oo   |
|      o . .+E+   |
|           o+.o  |
|            o=+. |
+----[SHA256]-----+
root@vagrant:/etc/ssl/certs/testssl.sh# ssh-copy-id -i .ssh/id_rsa vagrant@127.0.0.1

/usr/bin/ssh-copy-id: ERROR: failed to open ID file '.ssh/id_rsa.pub': No such file
root@vagrant:/etc/ssl/certs/testssl.sh# ssh-copy-id -i ~/.ssh/id_rsa vagrant@127.0.0.1
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/root/.ssh/id_rsa.pub"
The authenticity of host '127.0.0.1 (127.0.0.1)' can't be established.
ECDSA key fingerprint is SHA256:ur64aedNlP6lLuzRFZ6GEZnnwNrI68WIYtARUQe1ius.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
vagrant@127.0.0.1's password:

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'vagrant@127.0.0.1'"
and check to make sure that only the key(s) you wanted were added.
root@vagrant:/etc/ssl/certs/testssl.sh# ssh 'vagrant@127.0.0.1'
Welcome to Ubuntu 20.04.5 LTS (GNU/Linux 5.4.0-135-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Fri 24 Feb 2023 01:06:44 PM UTC

  System load:  0.09               Processes:               140
  Usage of /:   13.5% of 30.34GB   Users logged in:         1
  Memory usage: 32%                IPv4 address for dummy0: 10.2.2.2
  Swap usage:   0%                 IPv4 address for eth0:   10.0.2.15

 * Introducing Expanded Security Maintenance for Applications.
   Receive updates to over 25,000 software packages with your
   Ubuntu Pro subscription. Free for personal use.

     https://ubuntu.com/pro


This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
Last login: Fri Feb 24 12:12:25 2023 from 10.0.2.2
vagrant@vagrant:~$
```
6. Переименуйте файлы ключей из задания 5. Настройте файл конфигурации SSH клиента, так чтобы вход на удаленный сервер осуществлялся по имени сервера.
```
root@vagrant:/home/vagrant# sudo mv ~/.ssh/id_rsa ~/.ssh/id_rsa_test
root@vagrant:/home/vagrant# vi ~/.ssh/config
root@vagrant:/home/vagrant# cat ~/.ssh/config
Host my_server
 HostName 127.0.0.1
 IdentityFile ~/.ssh/id_rsa_test
 User vagrant
root@vagrant:/home/vagrant# ssh my_server
Welcome to Ubuntu 20.04.5 LTS (GNU/Linux 5.4.0-135-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Fri 24 Feb 2023 01:12:28 PM UTC

  System load:  0.07               Processes:               148
  Usage of /:   13.5% of 30.34GB   Users logged in:         1
  Memory usage: 33%                IPv4 address for dummy0: 10.2.2.2
  Swap usage:   0%                 IPv4 address for eth0:   10.0.2.15

 * Introducing Expanded Security Maintenance for Applications.
   Receive updates to over 25,000 software packages with your
   Ubuntu Pro subscription. Free for personal use.

     https://ubuntu.com/pro


This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
Last login: Fri Feb 24 13:06:45 2023 from 127.0.0.1
vagrant@vagrant:~$
```
7. Соберите дамп трафика утилитой tcpdump в формате pcap, 100 пакетов. Откройте файл pcap в Wireshark.
```
vagrant@vagrant:~$ sudo tcpdump -i eth0 -c 100 -w ~/test_dump.pcap
tcpdump: listening on eth0, link-type EN10MB (Ethernet), capture size 262144 bytes
100 packets captured
109 packets received by filter
0 packets dropped by kernel

Скриншот wireshark - 3.png
```