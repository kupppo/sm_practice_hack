; Patch out copy protection
org $008000
    db $FF

; Set SRAM size
if !FEATURE_SD2SNES
    org $00FFD8
        db $08 ; 256kb
else
    org $00FFD8
        db $05 ; 64kb
endif

; Skip intro
; $82:EEDF A9 95 A3    LDA #$A395
org $82EEDF
if !FEATURE_PAL
    LDA #$C065
else
    LDA #$C100
endif

; Fix Zebes planet tiling error
org $8C9607
    dw #$0E2F

if !PRESERVE_WRAM_DURING_SPACETIME
org $90AD18
    JMP spacetime_routine
endif

; Skips the waiting time after teleporting
if !FEATURE_PAL
org $90E874
else
org $90E877
endif
    BRA $1F


; Adds frames when unpausing (nmi is turned off during vram transfers)
; $80:A16B 22 4B 83 80 JSL $80834B[$80:834B]
org $80A16B
    JSL hook_unpause


; $82:8BB3 22 69 91 A0 JSL $A09169[$A0:9169]  ; Handles Samus getting hurt?
org $828BB3
    JSL gamemode_end


; Replace unnecessary logic checking controller input to toggle debug CPU brightness
; with logic to collect the v-counter data
org $828AB1
    %a8() : LDA $4201 : ORA #$80 : STA $4201 : %ai16()
    LDA $2137 : LDA $213D : STA !ram_vcounter_data

    ; For efficiency, re-implement the debug brightness logic here
    LDA $0DF4 : BEQ .skip_debug_brightness
    %a8() : LDA $51 : AND #$F0 : ORA #$05 : STA $2100 : %a16()
    BRA .skip_debug_brightness

warnpc $828ADD
org $828ADD       ; Resume original logic
    .skip_debug_brightness


org $CF8BBF       ; Set map scroll beep to high priority
    dw $2A97


; $80:8F24 9C F6 07    STZ $07F6  [$7E:07F6]  ;/
; $80:8F27 8D 40 21    STA $2140  [$7E:2140]  ; APU IO 0 = [music track]
org $808F24
    JSL hook_set_music_track
    NOP #2

; swap Enemy HP to MB HP when entering MB's room
org $83AAD2
    dw #MotherBrainHP


org $8FEA00 ; free space for door asm
print pc, " misc bank8F start"

MotherBrainHP:
{
    LDA !sram_display_mode : BNE .done
    LDA #!IH_MODE_ROOMSTRAT_INDEX : STA !sram_display_mode
    LDA #!IH_STRAT_MBHP_INDEX : STA !sram_room_strat

  .done
    RTS
}

print pc, " misc bank8F end"


org $90F800
print pc, " misc bank90 start"

hook_set_music_track:
{
    STZ $07F6

    PHA
    LDA !sram_music_toggle : BEQ .noMusic
    PLA : STA $2140
    RTL

  .noMusic
    PLA
    RTL
}

hook_unpause:
{
    ; RT room
    LDA !ram_realtime_room : CLC : ADC.w #41 : STA !ram_realtime_room

    ; RT seg
    LDA !ram_seg_rt_frames : CLC : ADC.w #41 : STA !ram_seg_rt_frames
    CMP.w #60 : BCC .done
    SEC : SBC.w #60 : STA !ram_seg_rt_frames

    LDA !ram_seg_rt_seconds : INC : STA !ram_seg_rt_seconds
    CMP.w #60 : BCC .done
    LDA #$0000 : STA !ram_seg_rt_seconds

    LDA !ram_seg_rt_minutes : INC : STA !ram_seg_rt_minutes

  .done
    ; Replace overwritten logic to enable NMI
    JSL $80834B
    RTL
}

gamemode_end:
{
   ; overwritten logic
if !FEATURE_PAL
    JSL $A09179
else
    JSL $A09169
endif

    ; If minimap is disabled or shown, we ignore artificial lag
    LDA $05F7 : BNE .endlag
    LDA !ram_minimap : BNE .endlag

    ; Ignore artifical lag if OOB viewer is active
    LDA !ram_oob_watch_active : BNE .endlag

    ; Artificial lag, multiplied by 16 to get loop count
    ; Each loop takes 5 clock cycles (assuming branch taken)
    ; For reference, 41 loops ~= 1 scanline
    LDA !sram_artificial_lag : BEQ .endlag
    ASL #4 : TAX
  .lagloop
    DEX : BNE .lagloop
  .endlag
    RTL
}

stop_all_sounds:
{
    ; If $05F5 is non-zero, the game won't clear the sounds
    LDA $05F5 : PHA
    LDA #$0000 : STA $05F5
    JSL $82BE17
    PLA : STA $05F5

    ; Makes the game check Samus' health again, to see if we need annoying sound
    LDA #$0000 : STA $0A6A
    RTL
}

if !PRESERVE_WRAM_DURING_SPACETIME
spacetime_routine:
{
    CPY #$0000 : BPL .normal_load_palette

    ; Spacetime, check if Y will cause us to reach WRAM
    TYA : CLC : ADC #(!WRAM_START-$7EC1E0) : CMP #$0000 : BPL .normal_load_palette

    ; It will, so run our own loop
    INX : INX : INY : INY
  .loop_before_wram
    LDA [$00],Y
    STA $7EC1C0,X
    INX : INX : INY : INY
    CPX #(!WRAM_START-$7EC1C0) : BMI .loop_before_wram

    ; Skip over WRAM and resume normal loop
    TXA : CLC : ADC !WRAM_SIZE : TAX
    TYA : CLC : ADC !WRAM_SIZE : TAY
    CPY #$0020 : BMI .normal_load_loop
    RTS

  .normal_load_loop
    LDA [$00],Y
    STA $7EC1C0,X
  .normal_load_palette
    INX : INX : INY : INY
    CPY #$0020 : BMI .normal_load_loop
    RTS
}
endif

print pc, " misc bank90 end"

