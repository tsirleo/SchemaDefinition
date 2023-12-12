# Task_3

## Автомат для сортировки изделий

По конвейерной ленте передвигаются изделия разных цветов и разной высоты. Высота и цвет изделий в двух последних ячейках отслеживаются датчиками. Требуется разработать автомат для сортировки этих изделий по очередям согласно описанию ниже.

## Переменные и предикаты

У некоторых переменных написаны два имени, сначала длинное и затем в скобках короткое. В решении можно использовать любое.

**Входные переменные:**

- ***stop (s)***, домен *{0, 1}*. Временное выключение ленты и сортировщика.
- $color_1$ ($c_1$), домен *{r, g, b}*. Цвет изделия, обнаруженного в последней ячейке ленты: r — красный, g — зелёный, b — синий.
- $height_1$ ($h_1$), домен *{0, 1, 2, 3}*. Высота изделия, обнаруженного в последней ячейке ленты.
- $color_2$ ($c_2$), домен *{r, g, b}*. Цвет изделия, обнаруженного в предпоследней ячейке ленты: r — красный, g — зелёный, b — синий. В решении следует считать, что текущее прочитанное значение $c_2$ совпадает со следующим прочитанным $c_1$ (лента всегда движется корректно).
- $height_2$ ($h_2$), домен *{0, 1, 2, 3}*. Высота изделия, обнаруженного в предпоследней ячейке ленты. В решении следует считать, что текущее прочитанное значение $h_2$ совпадает со следующим прочитанным $h_1$ (лента всегда движется корректно).

**Выходные переменные:**

- ***on***, домен *{0, 1}*. Индикатор включения сортировщика. *on/0* — выключен. *on/1* — включен.
- ***broken (b)***, домен *{0, 1}*. Индикатор поломки сортировщика. *b/0* — исправен. *b/1* — сломан (неисправен).
- ***queue (q)***, домен *{A, B, C}*. Очередь, в которую направлено изделие, бывшее согласно последнему прочитанному символу в последней ячейке ленты (*none* — ни в какую).

**Базовые предикаты (с естественным смыслом):**

- ***x = α***, ***x*** $\neq$ ***α***, где *x* — переменная и *α* — значение из её домена или переменная.
- ***x***, где *x* — переменная с доменом *{0, 1}*(булева).
- ***x > α***, ***x ≥ α***, ***x < α***, ***x ≤ α***, где *x* — переменная с числовым доменом и *α* — значение из этого домена или переменная с числовым доменом.

## Поведение

В начале работы сортировщик включен, исправен, находится в режиме выбора (порядка сортировки). Сортировщик продолжает быть исправным, пока не сказано обратное.

В режиме выбора выдаётся значение ***queue/A***. Если в режиме выбора читается значение ***s/1***, то сортировщик выходит из режима выбора и выполняет следующие действия:

- если на следующем переоходе прочитано значение ***s/0***, то после этого чтения немедленно возвращается в режим выбора;
- если же прочитано ***s/1***, то немедленно выключается и после чтения ещё двух символов немедленно включается и переходит в режим выбора.

Иначе сортировщик после чтения символа переходит в один из режимов сортировки в зависимости от цвета изделия, обнаруженного в последней ячейке ленты во время этого чтения:

- Обнаружено красное изделие. Тогда все идущие красные подряд изделия, начиная с обнаруженного, кроме последнего, последовательно направляются в очереди ***B, C, B, C,...***. При обнаружении последнего красного изделия в этой череде сортировщик немедленно переходит в режим выбора.
- Обнаружено зелёное изделие. Тогда, начиная с этого изделия все подряд идущие зелёные изделия со строго убывающей высотой направляются в очередь ***C***. При обнаружении изделия, следующего за этой чередой зелёных, сортировщик немедленно переходит в режим выбора.
- Обнаружено синее изделие. Тогда обнаруженное изделие направляется в очередь ***A***, после чего чередующиеся зелёные и красные изделия (зелёное, красное, зелёное, красное, ...) направляются в очередь ***B***, и при обнаружении синего изделия сортировщик немедленно переходит в режим выбора. Если чередование зелёных и красных изделий нарушено, то сортировщик становится неисправным.

  Неисправный сортировщик направляет все изделия в очередь ***C*** и остаётся неисправным навсегда.