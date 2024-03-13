## Найденные ошибки

1. Модуль проигнорировал приход endofpacket при подаче пакета единичной длины и продолжил записывать данные

`Error: data sizes dont match!: wr size:          8, rd size:         33
Time: 505 ps  Scope: tb_env.Scoreboard.run File: packages/tb_env.sv Line: 521`

`wr data:'{00, 00, 23, 76, a5, aa, 00, 00, 00, 00}`

`rd data:'{00, 00, 00, 00, 00, 00, 00, 00, 00, xx}`

2. Модуль завершил выходную транзакции с ast_empty_o = 31, неправильно расчитав: правильным было бы значение 0, и выдал неверные данные из-за этого, подобное поведение повторяется для всех транзакций, у которых не должно быть пустых символов на выходе.

`Error: data sizes dont match!: wr size:         64, rd size:         33
Time: 3495 ps  Scope: tb_env.Scoreboard.run File: packages/tb_env.sv Line: 521`

`wr data:'{00, 00, 3f, 74, c0, ec, 00, 00, 00, 00}`

`rd data:'{00, b7, 32, 1e, 39, 00, 00, 00, 00, 8d}`


3. Модуль, реагирует на startofpacket без подтверждения

`Error: Error during transaction!! Wrong control signals values
Time: 805 ps  Scope: tb_env.Scoreboard.run File: packages/tb_env.sv Line: 531`

`wr data:'{xx, xx, xx, xx, xx, xx, xx, xx, xx, xx}`

`rd data:'{xx, xx, xx, xx, xx, xx, xx, xx, xx, xx}`

### Следующие ошибки связаны с тем, что модуль просто пропускает через себя ошибки источника транзакции 

4. Модуль начинает транзакцию заного при поступлении сигнала startofpacket до завершения предыдущей транзакции.

`Error: wrong data!
Time: 2125 ps  Scope: tb_env.Scoreboard.run File: packages/tb_env.sv Line: 539`

`wr data:'{00, 00, 00, d7, 18, cf, 9a, 00, 00, 00}`

`rd data:'{00, 00, 00, d7, 18, cf, 9a, 00, 00, 00}`

`Index:           0`


5. Модуль начинает выдает данные без начала транзакции.

`Error: Error during transaction!! Wrong control signals values
Time: 3005 ps  Scope: tb_env.Scoreboard.run File: packages/tb_env.sv Line: 531`

`wr data:'{xx, xx, xx, xx, xx, xx, xx, xx, xx, xx}`

`rd data:'{xx, xx, xx, xx, xx, xx, xx, xx, xx, xx}`

`Index:           0`
