FUNCTION_BLOCK FB_CodeActivation
VAR_INPUT
    xConfirm    : BOOL;     // Confirm button (HMI)
END_VAR
VAR_IN_OUT
    rInputCode  : REAL;     // Entered code — reset to 0 after a match
END_VAR
VAR_OUTPUT
    xOutput1    : BOOL;     // Output 1 active
    xOutput2    : BOOL;     // Output 2 active
    xOutput3    : BOOL;     // Output 3 active
    xOutput4    : BOOL;     // Output 4 active
    xCodeOk     : BOOL;     // Notification: correct code (3 s)
    xCodeError  : BOOL;     // Notification: wrong code (3 s)
END_VAR
VAR
    // Activation codes — set your values here
    rCode1      : REAL := 2134;
    rCode2      : REAL := 3421;
    rCode3      : REAL := 2314;
    rCode4      : REAL := 2341;

    // State counters: 0 = off, 1 = on, 2 → reset to 0 (toggle)
    nCnt1       : INT;
    nCnt2       : INT;
    nCnt3       : INT;
    nCnt4       : INT;

    // Rising edge triggers for each code
    rtOut1      : R_TRIG;
    rtOut2      : R_TRIG;
    rtOut3      : R_TRIG;
    rtOut4      : R_TRIG;

    // Wrong code trigger
    rtWrong     : R_TRIG;

    // Notification timers
    tonOk       : TON;
    tonError    : TON;
END_VAR

// ── Output 1 ──────────────────────────────────────────────────
rtOut1(CLK := xConfirm AND rInputCode = rCode1);
IF rtOut1.Q THEN
    nCnt1      := nCnt1 + 1;
    rInputCode := 0;
END_IF
IF    nCnt1 = 1 THEN xOutput1 := TRUE;
ELSIF nCnt1 = 0 THEN xOutput1 := FALSE;
ELSIF nCnt1 = 2 THEN nCnt1    := 0;
END_IF

// ── Output 2 ──────────────────────────────────────────────────
rtOut2(CLK := xConfirm AND rInputCode = rCode2);
IF rtOut2.Q THEN
    nCnt2      := nCnt2 + 1;
    rInputCode := 0;
END_IF
IF    nCnt2 = 1 THEN xOutput2 := TRUE;
ELSIF nCnt2 = 0 THEN xOutput2 := FALSE;
ELSIF nCnt2 = 2 THEN nCnt2    := 0;
END_IF

// ── Output 3 ──────────────────────────────────────────────────
rtOut3(CLK := xConfirm AND rInputCode = rCode3);
IF rtOut3.Q THEN
    nCnt3      := nCnt3 + 1;
    rInputCode := 0;
END_IF
IF    nCnt3 = 1 THEN xOutput3 := TRUE;
ELSIF nCnt3 = 0 THEN xOutput3 := FALSE;
ELSIF nCnt3 = 2 THEN nCnt3    := 0;
END_IF

// ── Output 4 ──────────────────────────────────────────────────
rtOut4(CLK := xConfirm AND rInputCode = rCode4);
IF rtOut4.Q THEN
    nCnt4      := nCnt4 + 1;
    rInputCode := 0;
END_IF
IF    nCnt4 = 1 THEN xOutput4 := TRUE;
ELSIF nCnt4 = 0 THEN xOutput4 := FALSE;
ELSIF nCnt4 = 2 THEN nCnt4    := 0;
END_IF

// ── Notifications ─────────────────────────────────────────────

// Wrong code: xConfirm pressed but no code matched (and code is not 0)
rtWrong(CLK := xConfirm
    AND rInputCode <> rCode1
    AND rInputCode <> rCode2
    AND rInputCode <> rCode3
    AND rInputCode <> rCode4
    AND rInputCode <> 0);
tonError(IN := rtWrong.Q OR tonError.IN AND NOT tonError.Q, PT := T#3S);
xCodeError := tonError.IN;

// Correct code: any output trigger fired
tonOk(IN := (rtOut1.Q OR rtOut2.Q OR rtOut3.Q OR rtOut4.Q)
    OR tonOk.IN AND NOT tonOk.Q, PT := T#3S);
xCodeOk := tonOk.IN;
