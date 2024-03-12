## Найденные ошибки

1. Модуль не отвечает на послыку пакета единичной длины и не поднимает сигнал ast_endofpacket_o

`Error: data sizes dont match!: wr size:          4, rd size:         18
Time: 2895 ps  Scope: tb_env.Scoreboard.run File: packages/tb_env.sv Line: 439`

`wr data:'{5e, 46, e1, 32}`

`rd data:'{69, 66, 8f, a5, 00, 00, 00, 00, 1a, 7b, c2, 76, 00, 00, 00, 00, 4d, 4f}`

2. Модуль завершил выходную транзакции с ast_empty_o = 15, неправильно расчитав: правильным было бы значение 0, и выдал неверные данные из-за этого:

`Error: data sizes dont match!: wr size:         32, rd size:         17
Time: 4105 ps  Scope: tb_env.Scoreboard.run File: packages/tb_env.sv Line: 400`

`wr data:'{23, 76, a5, aa, 00, 00, 00, 00, 41, 44, 7e, e2, 00, 00, 00, 00, b6, 6d, ca, 5e, 00, 00, 00, 00, 72, 07, 3d, 8d, 00, 00, 00, 00}`

`rd data:'{23, 76, a5, aa, 00, 00, 00, 00, 41, 44, 7e, e2, 00, 00, 00, 00, b6}`