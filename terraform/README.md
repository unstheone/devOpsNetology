# devOpsNetology
# terraform .gitignore details:
Следующие типы файлов будут игнорироваться системой контроля версий:
        локальные директории и их содержимое (**.terraform/*);
        файлы состояния (*.tfstate, *.tfstate.*);
        логи отказов (crash.log, crash.*.log); 
        файлы с личными данными (*.tfvarsm, *.tfvars.json);
        override-файлы; 
        файлы конфигурации интерфейса командной строки (.terraformrc, terraform.rc) 

