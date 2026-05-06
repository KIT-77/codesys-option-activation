# FB_OptionActivation — CoDeSys ST

Function Block for activating machine options via numeric code input on HMI (e.g. EasyBuilder / Weintek).

---

## How it works

The operator enters a numeric activation code on the HMI screen and presses **Confirm**.  
- If the code matches one of the configured option codes → the option toggles ON/OFF and a **success notification** appears for 3 seconds.  
- If the code does not match any option → an **error notification** appears for 3 seconds.  
- Entering the correct code a second time **disables** the option (toggle behavior).

---

## Interface

### VAR_INPUT
| Variable | Type | Description |
|----------|------|-------------|
| `xConfirm` | `BOOL` | Rising edge triggers code check (HMI confirm button) |

### VAR_IN_OUT
| Variable | Type | Description |
|----------|------|-------------|
| `rInputCode` | `REAL` | Entered activation code — automatically reset to `0` after a match |

### VAR_OUTPUT
| Variable | Type | Description |
|----------|------|-------------|
| `xOption1` | `BOOL` | Option 1 active |
| `xOption2` | `BOOL` | Option 2 active |
| `xOption3` | `BOOL` | Option 3 active |
| `xOption4` | `BOOL` | Option 4 active |
| `xCodeOk` | `BOOL` | Notification: correct code entered (high for 3 s) |
| `xCodeError` | `BOOL` | Notification: wrong code entered (high for 3 s) |

---

## Configuration

Activation codes are defined inside the FB as `VAR`:

```pascal
rCode1 : REAL := 2134;   // Option 1
rCode2 : REAL := 3421;   // Option 2
rCode3 : REAL := 2314;   // Option 3
rCode4 : REAL := 2341;   // Option 4
```

Change these values to your own codes before building.

---

## Usage example

```pascal
// Global / HMI variables
VAR_GLOBAL
    gConfirm    : BOOL;
    gInputCode  : REAL;
    gOpt1       : BOOL;
    gOpt2       : BOOL;
    gOpt3       : BOOL;
    gOpt4       : BOOL;
    gCodeOk     : BOOL;
    gCodeError  : BOOL;
END_VAR

// PLC_PRG
VAR
    fbOptions : FB_OptionActivation;
END_VAR

fbOptions(
    xConfirm   := gConfirm,
    rInputCode := gInputCode,
    xOption1   => gOpt1,
    xOption2   => gOpt2,
    xOption3   => gOpt3,
    xOption4   => gOpt4,
    xCodeOk    => gCodeOk,
    xCodeError => gCodeError
);
```

---

## Toggle logic

| Code entries | State |
|---|---|
| 0 times | Option OFF |
| 1 time | Option ON |
| 2 times | Option OFF (reset) |

---

## Requirements

- CoDeSys V3 (tested on V3.5)
- Standard library: `Standard.library` (R_TRIG, TON)
- HMI: any panel that can write a REAL variable and a BOOL trigger (EasyBuilder / Weintek recommended)

---

## License

MIT
