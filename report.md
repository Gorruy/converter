## Найденные ошибки

1. Модуль не отвечает на послыку пакета единичной длины и не поднимает сигнал ast_endofpacket_o

`Error: There is no startofpacket_o after endofpacket_i!!!
Time: 665 ps  Scope: tb_env.Driver.read File: packages/tb_env.sv Line: 211`

2. Модуль завершил выходную транзакции с ast_empty_o = 15, и выдал неверные данные из-за этого:

`Error: data sizes dont match!: wr size:         16, rd size:          1
Time: 9225 ps  Scope: tb_env.Scoreboard.run File: packages/tb_env.sv Line: 435`

`wr data:'{fe, 96, ab, ad, 00, 00, 00, 00, a9, 37, 39, a2, 00, 00, 00, 00}`

`rd data:'{fe}`