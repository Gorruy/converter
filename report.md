## Найденные ошибки

1. Модуль проигнорировал приход endofpacket при подаче пакета единичной длины и продолжил записывать данные

`Error: data sizes dont match!: wr size:          8, rd size:         17
Time: 3205 ps  Scope: tb_env.Scoreboard.run File: packages/tb_env.sv Line: 420`

`wr data:'{23, 76, a5, aa, 00, 00, 00, 00}`

`rd data:'{23, 76, a5, aa, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, xx}`

2. Модуль завершил выходную транзакции с ast_empty_o = 15, неправильно расчитав: правильным было бы значение 0, и выдал неверные данные из-за этого:

`Error: data sizes dont match!: wr size:         80, rd size:         65
Time: 175 ps  Scope: tb_env.Scoreboard.run File: packages/tb_env.sv Line: 416`

`wr data:'{16, b1, 73, 18, 00, 00, 00, 00, 1d, c2, cb, 8a, 00, 00, 00, 00, fc, 55, 4e, a6, 00, 00, 00, 00, 8a, f1, d2, 9d, 00, 00, 00, 00, 41, 44, 7e, e2, 00, 00, 00, 00, bb, ae, 56, 84, 00, 00, 00, 00, 14, cb, a9, b0, 00, 00, 00, 00, b5, e7, 4d, 8b, 00, 00, 00, 00, 10, 6e, c5, a3, 00, 00, 00, 00, 72, 07, 3d, 8d, 00, 00, 00, 00}`

`rd data:'{16, b1, 73, 18, 00, 00, 00, 00, 1d, c2, cb, 8a, 00, 00, 00, 00, fc, 55, 4e, a6, 00, 00, 00, 00, 8a, f1, d2, 9d, 00, 00, 00, 00, 41, 44, 7e, e2, 00, 00, 00, 00, bb, ae, 56, 84, 00, 00, 00, 00, 14, cb, a9, b0, 00, 00, 00, 00, b5, e7, 4d, 8b, 00, 00, 00, 00, 10}`

3. Модуль, реагирует на startofpacket без подтверждения

`Error: Error during transaction!! Wrong control signal's values
Time: 6205 ps  Scope: tb_env.Scoreboard.run File: packages/tb_env.sv Line: 426`

`wr data:'{xx}`

`rd data:'{xx}`

`Index:           0`

4. Модуль начинает транзакцию заного при поступлении сигнала startofpacket до завершения предыдущей транзакции.

`Error: data sizes dont match!: wr size:         11, rd size:         27
Time: 7525 ps  Scope: tb_env.Scoreboard.run File: packages/tb_env.sv Line: 416`

`wr data:'{bd, 3d, ac, 34, 00, 00, 00, 00, d7, d0, 6a}`

`rd data:'{bd, 3d, ac, 34, 00, 00, 00, 00, be, 18, f9, 58, 00, 00, 00, 00, eb, 42, 29, 5f, 00, 00, 00, 00, d7, d0, 6a}`
