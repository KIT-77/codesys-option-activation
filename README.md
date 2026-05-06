# FB_CodeActivation — CoDeSys ST

Universal Function Block for toggling outputs via numeric code input on HMI (e.g. EasyBuilder / Weintek).  
Use it to activate options, modes, access levels, or any feature that requires a numeric unlock code.

---

## How it works

The operator enters a numeric code on the HMI screen and presses **Confirm**.  
- If the code matches one of the configured codes → the corresponding output toggles ON/OFF and a **success notification** appears for 3 seconds.  
- If the code does not match any entry → an **error notification** appears for 3 seconds.  
- Entering the correct code a second time **disables** the output (toggle behavior).

---

## Interface

### VAR_INPUT
| Variable | Type | Description |
|----------|------|-------------|
| `xConfirm` | `BOOL` | Rising edge triggers code check (HMI confirm button) |

### VAR_IN_OUT
| Variable | Type | Description |
|----------|------|-------------|
| `rInputCode` | `REAL` | Entered code — automatically reset to `0` after a match |

### VAR_OUTPUT
| Variable | Type | Description |
|----------|------|-------------|
| `xOutput1` | `BOOL` | Output 1 active |
| `xOutput2` | `BOOL` | Output 2 active |
| `xOutput3` | `BOOL` | Output 3 active |
| `xOutput4` | `BOOL` | Output 4 active |
| `xCodeOk` | `BOOL` | Notification: correct code entered (high for 3 s) |
| `xCodeError` | `BOOL` | Notification: wrong code entered (high for 3 s) |

---

## Configuration

Activation codes are defined inside the FB as `VAR`:

```pascal
rCode1 : REAL := 2134;   // Output 1
rCode2 : REAL := 3421;   // Output 2
rCode3 : REAL := 2314;   // Output 3
rCode4 : REAL := 2341;   // Output 4
```

Change these values to your own codes before building.

---

## Usage example

```pascal
// Global / HMI variables
VAR_GLOBAL
    gConfirm    : BOOL;
    gInputCode  : REAL;
    gOut1       : BOOL;
    gOut2       : BOOL;
    gOut3       : BOOL;
    gOut4       : BOOL;
    gCodeOk     : BOOL;
    gCodeError  : BOOL;
END_VAR

// PLC_PRG
VAR
    fbCode : FB_CodeActivation;
END_VAR

fbCode(
    xConfirm   := gConfirm,
    rInputCode := gInputCode,
    xOutput1   => gOut1,
    xOutput2   => gOut2,
    xOutput3   => gOut3,
    xOutput4   => gOut4,
    xCodeOk    => gCodeOk,
    xCodeError => gCodeError
);
```

---

## Toggle logic

| Code entries | State |
|---|---|
| 0 times | Output OFF |
| 1 time | Output ON |
| 2 times | Output OFF (reset) |

---

## Requirements

- CoDeSys V3 (tested on V3.5)
- Standard library: `Standard.library` (R_TRIG, TON)
- HMI: any panel that can write a REAL variable and a BOOL trigger (EasyBuilder / Weintek recommended)

---

## Author

**Nikita Poliakov** — Automation & Instrumentation Engineer  
2+ years delivering end-to-end control systems for food and meat-processing equipment.  
[LinkedIn](https://www.linkedin.com/in/nikita-poliakov-62a3003b9) | work.nikita@bk.ru

---

## License

MIT
