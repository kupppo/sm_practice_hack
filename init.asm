org $808455      ;hijack, runs as game is starting, JSR to RAM initialization to avoid bad values
    JML ih_init_code


org $81F000
print "init start ", pc
ih_init_code:
    REP #$30
    PHA

    ; We mostly use $7FFB00 and upward, so just zero everything
    LDA #$0000
    LDX #$04FF
  .loop
    STA $7FFB00,X
    DEX : DEX : BPL .loop

    LDA #$0000
    STA !ram_slowdown_mode

    LDA #$0001
    STA !ram_rerandomize

    LDA #$0016 : STA !ram_artificial_lag

    PLA
    JSL $8B9146
    JML $808459

print "init end ", pc