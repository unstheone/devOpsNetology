### Задание
Необходимо создать собственные workflow для двух типов задач: bug и остальные типы задач. Задачи типа bug должны проходить жизненный цикл:

1. Open -> On reproduce.
2. On reproduce -> Open, Done reproduce.
3. Done reproduce -> On fix.
4. On fix -> On reproduce, Done fix.
5. Done fix -> On test.
6. On test -> On fix, Done.
7. Done -> Closed, Open.
![wf_bug.png](img%2Fwf_bug.png)
Остальные задачи должны проходить по упрощённому workflow:

1. Open -> On develop.
2. On develop -> Open, Done develop.
3. Done develop -> On test.
4. On test -> On develop, Done.
5. Done -> Closed, Open.
![wf_all.png](img%2Fwf_all.png)
**Что нужно сделать**

1. Создайте задачу с типом bug, попытайтесь провести его по всему workflow до Done. 
![epic_tasks_move.png](img%2Fepic_tasks_move.png)
2. Создайте задачу с типом epic, к ней привяжите несколько задач с типом task, проведите их по всему workflow до Done. 
3. При проведении обеих задач по статусам используйте kanban.
4. Верните задачи в статус Open.
![epic_tasks_move.png](img%2Fepic_tasks_move.png) 
5. Перейдите в Scrum, запланируйте новый спринт, состоящий из задач эпика и одного бага, стартуйте спринт, проведите задачи до состояния Closed. Закройте спринт.
![sprint_1_done_1.png](img%2Fsprint_1_done_1.png)![sprint_1_done_2.png](img%2Fsprint_1_done_2.png)
6. Если всё отработалось в рамках ожидания — выгрузите схемы workflow для импорта в XML. Файлы с workflow и скриншоты workflow приложите к решению задания.
#### [workflow-all.xml](xml%2Fworkflow-all.xml) and [workflow-bug.xml](xml%2Fworkflow-bug.xml)

