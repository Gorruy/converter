## Найденные ошибки

1. Модуль не отвечает на послыку пакета единичной длины и не поднимает сигнал ast_endofpacket_o

`Error: There is no startofpacket_o after endofpacket_i!!!
Time: 665 ps  Scope: tb_env.Driver.read File: packages/tb_env.sv Line: 211`

2. Модуль завершил выходную транзакции с ast_empty_o = 15, неправильно расчитав: правильным было бы значение 0, и выдал неверные данные из-за этого:

`Error: data sizes dont match!: wr size:         32, rd size:         17
Time: 4105 ps  Scope: tb_env.Scoreboard.run File: packages/tb_env.sv Line: 400`

`wr data:'{23, 76, a5, aa, 00, 00, 00, 00, 41, 44, 7e, e2, 00, 00, 00, 00, b6, 6d, ca, 5e, 00, 00, 00, 00, 72, 07, 3d, 8d, 00, 00, 00, 00}`

`rd data:'{23, 76, a5, aa, 00, 00, 00, 00, 41, 44, 7e, e2, 00, 00, 00, 00, b6}`

3. Модуль, при поддержании сигнала startofpacket во время транзакции даже без сигнала valid_i записывает значения

`Error: data sizes dont match!: wr size:          9, rd size:         58
Time: 2915 ps  Scope: tb_env.Scoreboard.run File: packages/tb_env.sv Line: 452`

`wr data:'{31, d6, 37, 9b, 00, 00, 00, 00, 4a}`

`rd data:'{31, d6, 37, 9b, 00, 00, 00, 00, 5f, ea, 57, 57, 00, 00, 00, 00, 4a, 56, aa, e7, 00, 00, 00, 00, 5f, ea, 57, 57, 00, 00, 00, 00, 4a, 56, aa, e7, 00, 00, 00, 00, 5f, ea, 57, 57, 00, 00, 00, 00, 7f, 45, 53, 38, 00, 00, 00, 00, e1, d1}`