FUNCTION_BLOCK FB_CodeActivation
VAR_INPUT
    xConfirm    : BOOL;     // Подтверждение ввода кода (кнопка на HMI)
END_VAR
VAR_IN_OUT
    rInputCode  : REAL;     // Введённый код (сбрасывается после совпадения)
END_VAR
VAR_OUTPUT
    xOutput1    : BOOL;     // Выход 1 активен
    xOutput2    : BOOL;     // Выход 2 активен
    xOutput3    : BOOL;     // Выход 3 активен
    xOutput4    : BOOL;     // Выход 4 активен
    xCodeOk     : BOOL;     // Уведомление: код введён верно (3 сек)
    xCodeError  : BOOL;     // Уведомление: код введён неверно (3 сек)
END_VAR
VAR
    // Коды активации — задаются здесь
    rCode1      : REAL := 2134;
    rCode2      : REAL := 3421;
    rCode3      : REAL := 2314;
    rCode4      : REAL := 2341;

    // Счётчики состояний: 0 = выкл, 1 = вкл, 2 → сброс в 0 (toggle)
    nCnt1       : INT;
    nCnt2       : INT;
    nCnt3       : INT;
    nCnt4       : INT;

    // Триггеры совпадения кодов
    rtOut1      : R_TRIG;
    rtOut2      : R_TRIG;
    rtOut3      : R_TRIG;
    rtOut4      : R_TRIG;

    // Триггер неверного кода
    rtWrong     : R_TRIG;

    // Таймеры уведомлений
    tonOk       : TON;
    tonError    : TON;
END_VAR

// ── Выход 1 ───────────────────────────────────────────────────
rtOut1(CLK := xConfirm AND rInputCode = rCode1);
IF rtOut1.Q THEN
    nCnt1      := nCnt1 + 1;
    rInputCode := 0;
END_IF
IF    nCnt1 = 1 THEN xOutput1 := TRUE;
ELSIF nCnt1 = 0 THEN xOutput1 := FALSE;
ELSIF nCnt1 = 2 THEN nCnt1    := 0;
END_IF

// ── Выход 2 ───────────────────────────────────────────────────
rtOut2(CLK := xConfirm AND rInputCode = rCode2);
IF rtOut2.Q THEN
    nCnt2      := nCnt2 + 1;
    rInputCode := 0;
END_IF
IF    nCnt2 = 1 THEN xOutput2 := TRUE;
ELSIF nCnt2 = 0 THEN xOutput2 := FALSE;
ELSIF nCnt2 = 2 THEN nCnt2    := 0;
END_IF

// ── Выход 3 ───────────────────────────────────────────────────
rtOut3(CLK := xConfirm AND rInputCode = rCode3);
IF rtOut3.Q THEN
    nCnt3      := nCnt3 + 1;
    rInputCode := 0;
END_IF
IF    nCnt3 = 1 THEN xOutput3 := TRUE;
ELSIF nCnt3 = 0 THEN xOutput3 := FALSE;
ELSIF nCnt3 = 2 THEN nCnt3    := 0;
END_IF

// ── Выход 4 ───────────────────────────────────────────────────
rtOut4(CLK := xConfirm AND rInputCode = rCode4);
IF rtOut4.Q THEN
    nCnt4      := nCnt4 + 1;
    rInputCode := 0;
END_IF
IF    nCnt4 = 1 THEN xOutput4 := TRUE;
ELSIF nCnt4 = 0 THEN xOutput4 := FALSE;
ELSIF nCnt4 = 2 THEN nCnt4    := 0;
END_IF

// ── Уведомления ───────────────────────────────────────────────

// Неверный код: xConfirm нажат, код не совпал ни с одним и не равен 0
rtWrong(CLK := xConfirm
    AND rInputCode <> rCode1
    AND rInputCode <> rCode2
    AND rInputCode <> rCode3
    AND rInputCode <> rCode4
    AND rInputCode <> 0);
tonError(IN := rtWrong.Q OR tonError.IN AND NOT tonError.Q, PT := T#3S);
xCodeError := tonError.IN;

// Верный код: сработал любой из триггеров
tonOk(IN := (rtOut1.Q OR rtOut2.Q OR rtOut3.Q OR rtOut4.Q)
    OR tonOk.IN AND NOT tonOk.Q, PT := T#3S);
xCodeOk := tonOk.IN;
