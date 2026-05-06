FUNCTION_BLOCK FB_OptionActivation
VAR_INPUT
    xConfirm    : BOOL;     // Подтверждение ввода кода (кнопка на HMI)
END_VAR
VAR_IN_OUT
    rInputCode  : REAL;     // Введённый код активации (сбрасывается после совпадения)
END_VAR
VAR_OUTPUT
    xOption1    : BOOL;     // Опция 1 активна
    xOption2    : BOOL;     // Опция 2 активна
    xOption3    : BOOL;     // Опция 3 активна
    xOption4    : BOOL;     // Опция 4 активна
    xCodeOk     : BOOL;     // Уведомление: код введён верно (3 сек)
    xCodeError  : BOOL;     // Уведомление: код введён неверно (3 сек)
END_VAR
VAR
    // Коды активации опций — задаются здесь
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
    rtOpt1      : R_TRIG;
    rtOpt2      : R_TRIG;
    rtOpt3      : R_TRIG;
    rtOpt4      : R_TRIG;

    // Триггер неверного кода
    rtWrong     : R_TRIG;

    // Таймеры уведомлений
    tonOk       : TON;
    tonError    : TON;
END_VAR

// ── Опция 1 ───────────────────────────────────────────────────
rtOpt1(CLK := xConfirm AND rInputCode = rCode1);
IF rtOpt1.Q THEN
    nCnt1      := nCnt1 + 1;
    rInputCode := 0;
END_IF
IF    nCnt1 = 1 THEN xOption1 := TRUE;
ELSIF nCnt1 = 0 THEN xOption1 := FALSE;
ELSIF nCnt1 = 2 THEN nCnt1    := 0;
END_IF

// ── Опция 2 ───────────────────────────────────────────────────
rtOpt2(CLK := xConfirm AND rInputCode = rCode2);
IF rtOpt2.Q THEN
    nCnt2      := nCnt2 + 1;
    rInputCode := 0;
END_IF
IF    nCnt2 = 1 THEN xOption2 := TRUE;
ELSIF nCnt2 = 0 THEN xOption2 := FALSE;
ELSIF nCnt2 = 2 THEN nCnt2    := 0;
END_IF

// ── Опция 3 ───────────────────────────────────────────────────
rtOpt3(CLK := xConfirm AND rInputCode = rCode3);
IF rtOpt3.Q THEN
    nCnt3      := nCnt3 + 1;
    rInputCode := 0;
END_IF
IF    nCnt3 = 1 THEN xOption3 := TRUE;
ELSIF nCnt3 = 0 THEN xOption3 := FALSE;
ELSIF nCnt3 = 2 THEN nCnt3    := 0;
END_IF

// ── Опция 4 ───────────────────────────────────────────────────
rtOpt4(CLK := xConfirm AND rInputCode = rCode4);
IF rtOpt4.Q THEN
    nCnt4      := nCnt4 + 1;
    rInputCode := 0;
END_IF
IF    nCnt4 = 1 THEN xOption4 := TRUE;
ELSIF nCnt4 = 0 THEN xOption4 := FALSE;
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

// Верный код: сработал любой из триггеров опций
tonOk(IN := (rtOpt1.Q OR rtOpt2.Q OR rtOpt3.Q OR rtOpt4.Q)
    OR tonOk.IN AND NOT tonOk.Q, PT := T#3S);
xCodeOk := tonOk.IN;
