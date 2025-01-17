
; Crab Shaft save station load point
org $80C995
    db #$A3, #$D1, #$68, #$A4, #$00, #$00, #$00, #$00, #$00, #$02, #$78, #$00, #$60, #$00

; Main Street save station load point
org $80C9A3
    db #$C9, #$CF, #$D8, #$A3, #$00, #$00, #$00, #$01, #$00, #$05, #$78, #$00, #$10, #$00

; Crab Shaft save station map icon location
org $82CA17
    db #$90, #$00, #$50, #$00

; Main Street save station map icon location
org $82CA1B
    db #$58, #$00, #$78, #$00

; Hijack room transition between loading level data and setting up scrolling
org $82E388
    dw hijack_after_load_level_data

; Hijack call to create door closing PLM
org $82E4C9
    JSR hijack_door_closing_plm

org $82F800
print pc, " layout bank82 start"

hijack_after_load_level_data:
{
    LDA $079B : CMP #$D646 : BEQ .pants_room : CMP #$D6FD : BNE .done

    ; Aqueduct Farm Sand Pit needs to be handled before the door scroll
    LDA !sram_room_layout : BIT !ROOM_LAYOUT_AREA_RANDO : BEQ .done
    JSL layout_asm_aqueductfarmsandpit_external

  .done
    JMP $E38E

  .pants_room
    ; Pants Room needs to be handled before the door scroll
    LDA !sram_room_layout : BIT !ROOM_LAYOUT_DASH_RECALL : BEQ .done
    JSL layout_asm_pants_room_external
    JMP $E38E
}

hijack_door_closing_plm:
{
    PHP : PHB
    %ai16()
    LDA $078D : CMP #$A654 : BNE .done
    LDA !sram_room_layout : BIT !ROOM_LAYOUT_AREA_RANDO : BNE .done

    ; Aqueduct Farm Sand Pit should not have a door closing PLM
    ; if using the warp door while Area Rando off
    PLB : PLP : RTS

  .done
    JMP $E8EF
}

print pc, " layout bank82 end"
warnpc $82FA00 ; presets.asm


; East Ocean left door asm pointer
org $838A88
    dw #layout_asm_eastocean

; Green Pirates Shaft bottom-right door asm pointer
org $838C5C
    dw #layout_asm_cutscene_g4skip

; Green Hill Zone top-left door asm pointer
org $838DF4
    dw #layout_asm_greenhillzone

; Green Hill Zone top-right door asm pointer
org $838EA8
    dw #layout_asm_greenhillzone

; Construction Zone left door asm pointer
org $838EB4
    dw #layout_asm_constructionzone

; Green Hill Zone bottom-right door asm pointer
org $838F08
    dw #layout_asm_greenhillzone

; Caterpillar middle-left door asm pointer
org $839094
    ; Use same asm as elevator door, freeing up asm at $BE1A
    dw $BA21

; Caterpillar top-left door asm pointer
org $8390E8
    dw #layout_asm_caterpillar_no_scrolls

; East Tunnel bottom-right door asm pointer
org $839238
    ; Use same asm as bottom-left door
    dw $E345

; Caterpillar near-right door asm pointer
org $839274
    dw #layout_asm_caterpillar_no_scrolls

; Single Chamber top-left door asm pointer
org $83958C
    dw #layout_asm_singlechamber

; Single Chamber near-top-right door asm pointer
org $839610
    dw #layout_asm_singlechamber

; Single Chamber near-middle-right door asm pointer
org $83961C
    dw #layout_asm_singlechamber

; Single Chamber near-bottom-right door asm pointer
org $839640
    dw #layout_asm_singlechamber

; Single Chamber far-top-right door asm pointer
org $839A54
    dw #layout_asm_singlechamber

; East Ocean right door asm pointer
org $83A26E
    dw #layout_asm_eastocean

; Main Street bottom door asm pointer
org $83A33A
    dw #layout_asm_mainstreet

; Crab Tunnel left door asm pointer
org $83A3B2
    dw #layout_asm_crabtunnel

; Main Street middle-right door asm pointer
org $83A3E2
    dw #layout_asm_mainstreet

; Main Street bottom-right door asm pointer
org $83A41E
    dw #layout_asm_mainstreet

; Main Street top-right door asm pointer
org $83A442
    dw #layout_asm_mainstreet

; Main Street hidden door asm pointer
org $83A45A
    dw #layout_asm_mainstreet

; Crab Shaft left door asm pointer
org $83A472
    dw #layout_asm_crabshaft_no_scrolls

; Crab Shaft top door asm pointer
org $83A4EA
    dw #layout_asm_crabshaft_no_scrolls

; Crab Tunnel right door asm pointer
org $83A502
    dw #layout_asm_crabtunnel

; East Tunnel top-right door asm pointer
org $83A51A
    dw #layout_asm_easttunnel_no_scrolls

; West Sand Hall left door asm pointer
org $83A53E
    dw #layout_asm_westsandhall

; West Sand Hall unused door definition
org $83A654
    dw #$D6FD
    db #$00, #$05, #$3E, #$06, #$03, #$00
    dw #$8000
    dw #$0000

; West Sand Hall right door asm pointer
org $83A66A
    dw #layout_asm_westsandhall

; West Sand Hall top sand door asm pointer
org $83A6BE
    dw #layout_asm_westsandhall

; Mother Brain right door asm pointer
org $83AAD2
    dw #layout_asm_mbhp

; Mother Brain left door asm pointer
org $83AAEA
    dw #layout_asm_mbhp

; Magnet Stairs left door asm pointer
org $83AB6E
    dw #layout_asm_magnetstairs

; Magnet Stairs right door asm pointer
org $83AB92
    dw #layout_asm_magnetstairs


; Allow debug save stations to be used
org $848D0C
    AND #$000F

; Ignore bombs for bomb torizo with VARIA tweaks
org $848258
layout_bomb_torizo_finish_crumbling:
    INC $1D27,X : INC $1D27,X
    LDA #$D356 : STA $1CD7,X
    RTS
warnpc $848270

org $84BA50
    dw layout_bomb_grey_door_new_instruction

org $84BA6F
layout_bomb_grey_door_original_instruction:

org $84BA7A
layout_bomb_grey_door_original_skip:

org $84BAD1
layout_bomb_grey_door_new_instruction:
    LDA !sram_room_layout : BIT !ROOM_LAYOUT_VARIA_TWEAKS : BNE layout_bomb_grey_door_original_skip
    BRA layout_bomb_grey_door_original_instruction

layout_bomb_set_room_argument:
{
    LDA !sram_room_layout : BIT !ROOM_LAYOUT_VARIA_TWEAKS : BEQ .end
    LDA #layout_bomb_torizo_start_crumbling : STA $1D21
    LDA #$BA54 : STA $1D75
  .end
    JMP $8899
}
warnpc $84BAF4

org $84D33B
layout_bomb_torizo_crumbling_chozo_preinstruction:
    LDA !sram_room_layout : BIT !ROOM_LAYOUT_VARIA_TWEAKS : BNE layout_bomb_torizo_end_preinstruction
    LDA !SAMUS_ITEMS_COLLECTED : AND #$1000 : BEQ layout_bomb_torizo_end_preinstruction

layout_bomb_torizo_start_crumbling:
    LDA #$0001 : STA $7EDE1C,X
    JMP layout_bomb_torizo_finish_crumbling

layout_bomb_torizo_end_preinstruction:
warnpc $84D356

org $84E53D
    dw layout_bomb_set_room_argument

; Ignore picky chozo in DASH or VARIA tweaks
org $84D18F
layout_picky_chozo:
{
    LDA !sram_room_layout : BIT !ROOM_LAYOUT_DASH_RECALL_OR_VARIA_TWEAKS : BNE .skip_picky_chozo
    LDA !SAMUS_ITEMS_COLLECTED : AND #$0200 : BEQ layout_picky_chozo_end
  .skip_picky_chozo
    ; Shift existing logic nine bytes down
    LDA !SAMUS_COLLISION_DIRECTION : AND #$000F : CMP #$0003 : BNE layout_picky_chozo_end
    LDA !SAMUS_POSE : CMP #$001D : BEQ .start_chozo_event
    CMP #$0079 : BEQ .start_chozo_event : CMP #$007A : BNE layout_picky_chozo_end
  .start_chozo_event
    ; Make up for overridden code
    JSL ih_set_picky_chozo_event_and_enemy_speed
}
warnpc $84D1C1

org $84D1DE
layout_picky_chozo_end:

; Allow spazer blocks to be shot
org $84D014
layout_spazer_block_plm_entry:
    dw layout_spazer_block_plm, $CBB7

org $84D476
layout_spazer_block_plm:
{
    LDX $0DDE : LDA $0C18,X : BIT #$0004 : BEQ .delete_plm
    JMP $CF0C ; Break block
  .delete_plm
    TDC : STA $1C37,Y
    RTS
}
warnpc $84D490

org $94937D
    dw $D040

org $94A024
    dw layout_spazer_block_plm_entry


; Parlor escape setup asm
org $8F919C
    LDA !sram_suppress_flashing : BIT !SUPPRESS_EARTHQUAKE : BNE .parlor_escape_rts
    JMP layout_asm_vanilla_parlor_escape
  .parlor_escape_rts
    RTS
warnpc $8F91A9

; Landing site setup asm
org $8F91BD
    LDA !sram_suppress_flashing : BIT !SUPPRESS_EARTHQUAKE : BNE .scrolling_sky
    JSR layout_asm_vanilla_landing_site_escape
  .scrolling_sky
warnpc $8F91C9

; Crateria Kihunters setup asm
org $8F94B1
    dw layout_asm_crateria_kihunters

; Forgotten Highway Elbow setup asm
org $8F95CD
    dw layout_asm_forgotten_highway_elbow

; Moat setup asm
org $8F9624
    dw #layout_asm_moat

; Red Tower Elevator setup asm
org $8F964F
    dw #layout_asm_redtowerelevator

; Pit Room state check
org $8F9767
    dw #layout_asm_morph_missiles_state_check

; Pit Room Elevator state check
org $8F97C0
    dw #layout_asm_morph_missiles_state_check

; Green Pirates Shaft setup asm
org $8F99E2
    dw #layout_asm_green_pirates_shaft

; Brinstar Pre-Map Room setup asm
org $8F9BC2
    dw #layout_asm_brinstarpremaproom

; Early Supers setup asm
org $8F9BED
    dw #layout_asm_earlysupers

; Dachora setup asm
org $8F9CD8
    dw #layout_asm_dachora

; Big Pink setup asm
org $8F9D3E
    dw #layout_asm_bigpink

; Mission Impossible setup asm
org $8F9E36
    dw #layout_asm_missionimpossible

; Morph Ball Room setup asm
org $8F9EE3
    dw #layout_asm_morphballroom

; Noob bridge setup asm
org $8F9FDF
    dw #layout_asm_noobbridge

; Waterway setup asm
org $8FA0F7
    dw #layout_asm_waterway

; Red Tower setup asm
org $8FA278
    dw #layout_asm_redtower

; Below Spazer setup asm
org $8FA42D
    dw #layout_asm_belowspazer

; Warehouse Kihunters setup asm
org $8FA4FF
    dw #layout_asm_warehousekihunters

; Cathedral Entrance setup asm
org $8FA7D8
    dw #layout_asm_cathedralentrance

; Crocomire Speedway asm pointer
org $8FA948
    dw #layout_asm_crocspeedway

; Crocomire asm pointer
org $8FA9B7
    dw #layout_asm_croc

; Hi-Jump Boots E-Tank setup asm
org $8FAA66
    dw #layout_asm_hjbetank

; Kronic Boost asm pointer
org $8FAE99
    dw #layout_asm_kronicboost

; Acid Statue setup asm
org $8FB20A
    dw #layout_asm_acidstatue

; Caterpillar elevator and middle-left door asm
org $8FBA26
    ; Replace STA with jump to STA
    JMP layout_asm_caterpillar_update_scrolls

; Caterpillar bottom-left door asm
org $8FBE18
    ; Overwrite PLP : RTS with jump
    ; Okay to overwrite $BE1A since we freed up that space
    JMP layout_asm_caterpillar_after_scrolls

; Escape screen shake and explosion main asm
org $8FC124
    ; Start with copy of $8FC131 routine (replacing JSR with inlined version)
    LDA $0A78 : BNE .end_explosion
    LDA $05B6 : AND #$0001 : BNE .end_explosion
    JSL $808111
    PHA : AND #$00FF : CLC : ADC $0911 : STA $12 : PLA
    XBA : AND #$00FF : CLC : ADC $0915 : STA $14
    LSR : LSR : LSR : LSR
    %a8() : PHA : LDA $07A5 : STA $4202
    PLA : STA $4203 : %a16()
    LDA $12 : LSR : LSR : LSR : LSR
    CLC : ADC $4216 : ASL : TAX
    LDA $7F0002,X : AND #$03FF
    CMP #$00FF : BEQ .end_explosion

    ; Jump to earthquake check after explosion
    PEA layout_asm_escape_screen_shake_pea
    JMP $C1A9

  .end_explosion
    JMP layout_asm_escape_screen_shake
warnpc $8FC183

; Tourian escape room 1 setup asm
org $8FC926
    LDA !sram_suppress_flashing : BIT !SUPPRESS_EARTHQUAKE : BNE .tourian_escape_room_1_rts
    JMP layout_asm_vanilla_tourian_escape_room_1
  .tourian_escape_room_1_rts
    RTS
warnpc $8FC933

; Tourian escape room 2 setup asm
org $8FC933
    LDA !sram_suppress_flashing : BIT !SUPPRESS_EARTHQUAKE : BNE .tourian_escape_room_2_rts
    JMP layout_asm_vanilla_tourian_escape_room_2
  .tourian_escape_room_2_rts
    RTS
warnpc $8FC946

; Tourian escape room 3 setup asm
org $8FC946
    LDA !sram_suppress_flashing : BIT !SUPPRESS_EARTHQUAKE : BNE .tourian_escape_room_3_rts
    JMP layout_asm_vanilla_tourian_escape_room_3
  .tourian_escape_room_3_rts
    RTS
warnpc $8FC953

; Tourian escape room 4 setup asm
org $8FC95B
    LDA !sram_suppress_flashing : BIT !SUPPRESS_EARTHQUAKE : BNE .tourian_escape_room_4_rts
    JMP layout_asm_vanilla_tourian_escape_room_4
  .tourian_escape_room_4_rts
    RTS
warnpc $8FC96E

; Bowling setup asm
org $8FC9D2
    dw #layout_asm_bowling

; Wrecked Ship Main setup asm
org $8FCB20
    dw #layout_asm_wreckedshipmain

; Electric Death state check asm
org $8FCBE5
    dw #layout_asm_electric_death_state_check

; Wrecked Ship Energy Tank state check asm
org $8FCC37
    dw #layout_asm_wrecked_ship_energy_tank_state_check

; Wrecked Ship Save setup asm
org $8FCEB4
    dw layout_asm_wreckedshipsave

; Plasma state check asm
org $8FD2B5
    dw #layout_asm_plasma_state_check

; Plasma spark setup asm
org $8FD365
    dw #layout_asm_plasma_spark

; Aqueduct setup asm
org $8FD5CC
    dw #layout_asm_aqueduct

; Butterfly setup asm
org $8FD611
    dw #layout_asm_butterfly

; Botwoon hallway setup asm
org $8FD63C
    dw #layout_asm_botwoon_hallway

; Aqueduct Farm Sand Pit header
org $8FD706
    dw layout_asm_aqueductfarmsandpit_door_list

; Shaktool room setup asm
org $8FD8EF
    dw #layout_asm_shaktool_room

; Halfie Climb setup asm
org $8FD938
    dw #layout_asm_halfie_climb

; Tourian escape room 2 main asm
org $8FDE99
    dw #layout_asm_tourian_escape_room_2

; Tourian escape room 4 main asm
org $8FDEFD
    dw #layout_asm_tourian_escape_room_4

; Ceres Ridley modified state check to support presets
org $8FE0C0
    dw layout_asm_ceres_ridley_room_state_check

; Ceres Ridley room setup asm when timer is not running
org $8FE0DF
    dw layout_asm_ceres_ridley_room_no_timer

; East Tunnel bottom-left and bottom-right door asm
org $8FE34E
    ; Optimize existing logic by one byte
    INC : STA $7ECD24
    ; Overwrite extra byte : PLP : RTS with jump
    JMP layout_asm_easttunnel_after_scrolls

; Caterpillar far-right door asm
org $8FE370
    ; Optimize existing logic by one byte
    INC : STA $7ECD2A
    ; Overwrite extra byte : PLP : RTS with jump
    JMP layout_asm_caterpillar_after_scrolls

; Crab Shaft right door asm
org $8FE39D
    ; Replace STA with jump to STA
    JMP layout_asm_crabshaft_update_scrolls

; Morph and Missiles state check asm
org $8FE640
layout_asm_morph_missiles_state_check:
{
    LDA !sram_room_layout : BIT !ROOM_LAYOUT_ANY_RANDO : BEQ layout_asm_vanilla_morph_missiles_state_check
    BIT !ROOM_LAYOUT_DASH_RECALL : BNE layout_asm_dash_morph_missiles_state_check
    BRA layout_asm_varia_morph_missiles_state_check
}
warnpc $8FE652

org $8FE652
layout_asm_vanilla_morph_missiles_state_check:

org $8FE65F
layout_asm_vanilla_morph_missiles_found:

org $8FE666
layout_asm_vanilla_morph_missiles_not_found:

org $8FE678
layout_asm_dash_morph_missiles_state_check:
{
    LDA !SAMUS_ITEMS_COLLECTED : BNE layout_asm_vanilla_morph_missiles_found
    BRA layout_asm_vanilla_morph_missiles_not_found
}

layout_asm_varia_morph_missiles_state_check:
{
    LDA $7ED820 : BIT #$0001 : BNE layout_asm_vanilla_morph_missiles_found
    BRA layout_asm_vanilla_morph_missiles_not_found
}
warnpc $8FE68A


org $8FEA00
print pc, " layout start"

layout_asm_vanilla_parlor_escape:
{
    LDA #$0018 : STA $183E
    LDA #$FFFF : STA $1840
    RTS
}

layout_asm_vanilla_landing_site_escape:
{
    LDA #$0006 : STA $183E
    LDA #$FFFF : STA $1840
    RTS
}

layout_asm_escape_screen_shake_pea:
    NOP
layout_asm_escape_screen_shake:
{
    LDA !sram_suppress_flashing : BIT !SUPPRESS_EARTHQUAKE : BNE .suppress
    LDA $1840 : ORA #$8000 : STA $1840

  .suppress
    RTS
}

layout_asm_vanilla_tourian_escape_room_1:
{
    LDA #$0012 : STA $183E
    LDA #$FFFF : STA $1840
    RTS
}

layout_asm_vanilla_tourian_escape_room_2:
{
    LDA #$0012 : STA $183E
    STA $07E3 : STZ $07E1
    LDA #$FFFF : STA $1840
    RTS
}

layout_asm_vanilla_tourian_escape_room_3:
{
    LDA #$0015 : STA $183E
    LDA #$FFFF : STA $1840
    RTS
}

layout_asm_vanilla_tourian_escape_room_4:
{
    LDA #$0015 : STA $183E
    STA $07E3 : STZ $07E1
    LDA #$FFFF : STA $1840
    RTS
}

layout_asm_tourian_escape_room_2:
{
    LDA !sram_suppress_flashing : BIT !SUPPRESS_EARTHQUAKE : BNE .suppress
    JMP $E57C

  .suppress
    RTS
}

layout_asm_tourian_escape_room_4:
{
    LDA !sram_suppress_flashing : BIT !SUPPRESS_EARTHQUAKE : BNE .suppress
    JMP $E5A4

  .suppress
    JMP $C183
}

layout_asm_cutscene_g4skip:
{
    LDA !sram_cutscenes : BIT !CUTSCENE_SKIP_G4 : BEQ .done

    ; Verify all four G4 bosses killed
    LDA $7ED828 : BIT #$0100 : BEQ .done
    LDA $7ED82C : BIT #$0001 : BEQ .done
    LDA $7ED82A : AND #$0101 : CMP #$0101 : BNE .done

    ; Set Tourian open
    LDA $7ED820 : ORA #$0400 : STA $7ED820

  .done
    RTS
}

layout_asm_mbhp:
{
    LDA !sram_display_mode : BNE .done
    LDA #!IH_MODE_ROOMSTRAT_INDEX : STA !sram_display_mode
    LDA #!IH_STRAT_MBHP_INDEX : STA !sram_room_strat

  .done
    RTS
}

layout_asm_ceres_ridley_room_state_check:
{
    LDA $0943 : BEQ .no_timer
    LDA $0001,X : TAX
    JMP $E5E6
  .no_timer
    STZ $093F
    INX : INX : INX
    RTS
}

layout_asm_ceres_ridley_room_no_timer:
{
    ; Same as original setup asm, except force blue background
    PHP
    SEP #$20
    LDA #$66 : STA $5D
    PLP
    JSL $88DDD0
    LDA #$0009 : STA $07EB
    RTS
}

layout_asm_magnetstairs:
{
    PHP
    %a16()
    LDA !sram_room_layout : BIT !ROOM_LAYOUT_MAGNET_STAIRS : BEQ layout_asm_magnetstairs_done

    ; Modify graphics to indicate magnet stairs removed
    %a8()
    LDA #$47 : STA $7F01F8 : STA $7F02EA

    ; Convert solid tiles to slope tiles
    LDA #$10 : STA $7F01F9 : STA $7F02EB
    LDA #$53 : STA $7F64FD : STA $7F6576
}

layout_asm_magnetstairs_done:
    PLP
    RTS

layout_asm_greenhillzone:
{
    PHP
    %a16()
    LDA !sram_room_layout : BIT !ROOM_LAYOUT_AREA_RANDO : BEQ layout_asm_magnetstairs_done

    ; Set yellow door as already opened
    LDA $7ED8B6 : ORA #$0001 : STA $7ED8B6

    ; Remove gate and corner tile next to gate
    LDA #$00FF : STA $7F37C8 : STA $7F37CA : STA $7F37CC
    STA $7F38CA : STA $7F39CA : STA $7F3ACA : STA $7F3BCA

    ; Clear gate PLMs and projectiles
    LDA #$0000 : STA $1C83 : STA $1C85 : STA $19B9

    ; Add platform for ease of access to top-right door
    %a8()
    LDA #$6A : STA $7F0F24 : LDA #$6C : STA $7F0F26
    LDA #$81 : STA $7F0F25 : STA $7F0F27

    ; Move corner tiles next to gate up one
    LDA #$78 : STA $7F36CA : LDA #$79 : STA $7F36CC

    ; Normal BTS for gate tiles
    LDA #$00 : STA $7F7FE5 : STA $7F7FE6
    STA $7F8066 : STA $7F80E6 : STA $7F8166 : STA $7F81E6
}

layout_asm_greenhillzone_done:
    PLP
    RTS

layout_asm_morphballroom:
{
    PHP
    %a16()
    LDA !sram_room_layout : BIT !ROOM_LAYOUT_ANY_RANDO : BEQ layout_asm_greenhillzone_done
    BIT !ROOM_LAYOUT_DASH_RECALL : BNE layout_asm_greenhillzone_done
    BIT !ROOM_LAYOUT_AREA_RANDO : BEQ .add_morph_ball

    ; Set grey door as already opened
    LDA $7ED8B6 : ORA #$0002 : STA $7ED8B6

  .add_morph_ball
    ; Add back morph ball item
    JSL $8483D7
    dw $2945, $EF23
}

layout_asm_morphballroom_done:
    PLP
    RTS

layout_asm_constructionzone:
{
    PHP
    %a16()
    LDA !sram_room_layout : BIT !ROOM_LAYOUT_ANY_RANDO : BEQ layout_asm_morphballroom_done
    BIT !ROOM_LAYOUT_DASH_RECALL : BEQ .set_zebes_awake

    ; DASH requires first item to be collected before waking the planet
    LDA $7ED872 : BIT #$0400 : BEQ .done_zebes_awake

  .set_zebes_awake
    LDA $7ED820 : ORA #$0001 : STA $7ED820

  .done_zebes_awake
    ; Set red door as already opened
    LDA $7ED8B6 : ORA #$0004 : STA $7ED8B6
}

layout_asm_constructionzone_done:
    PLP
    RTS

layout_asm_caterpillar_no_scrolls:
    PHP
    BRA layout_asm_caterpillar_after_scrolls

layout_asm_caterpillar_update_scrolls:
    STA $7ECD26

layout_asm_caterpillar_after_scrolls:
{
    %a16()
    LDA !sram_room_layout : BIT !ROOM_LAYOUT_AREA_RANDO : BEQ layout_asm_constructionzone_done

    ; Decorate gap with blocks
    LDA #$8562 : STA $7F145E : STA $7F1460 : STA $7F151E : STA $7F1520

    ; Fix wall decoration below blocks
    LDA #$8543 : STA $7F157E : LDA #$8522 : STA $7F1580

    ; Create visible gap in wall
    LDA #$00FF : STA $7F14BE : STA $7F14C0

    ; Remove gate and block next to gate
    STA $7F142C : STA $7F142E : STA $7F1430
    STA $7F148E : STA $7F14EE : STA $7F154E : STA $7F15AE

    ; Clear gate PLMs and projectiles
    LDA #$0000 : STA $1C7B : STA $1C7D : STA $19B9

    ; Normal BTS for gate tiles
    %a8()
    LDA #$00 : STA $7F6E17 : STA $7F6E18 : STA $7F6E19
    STA $7F6E48 : STA $7F6E78 : STA $7F6EA8 : STA $7F6ED8
}

layout_asm_caterpillar_done:
    PLP
    RTS

layout_asm_singlechamber:
{
    PHP
    %a16()
    LDA !sram_room_layout : BIT !ROOM_LAYOUT_AREA_RANDO : BEQ layout_asm_caterpillar_done

    ; Move right wall back one to create a ledge
    LDA #$810C : STA $7F06E0 : STA $7F0A9E
    LDA #$8507 : STA $7F07A0 : STA $7F0920
    LDA #$8505 : STA $7F0860 : STA $7F09E0

    ; Clear out the ledge
    LDA #$00FF : STA $7F06DE : STA $7F079E
    STA $7F085E : STA $7F091E : STA $7F09DE

    ; Remove crumble blocks from vertical shaft
    STA $7F05E0 : STA $7F05E2
    STA $7F06A0 : STA $7F06A2 : STA $7F0760 : STA $7F0762

    ; Remove blocks from horizontal shaft
    STA $7F061E : STA $7F0620 : STA $7F0624
    ; Careful with the block that is also a scroll block
    LDA #$30FF : STA $7F0622

    ; Normal BTS for crumble blocks
    %a8()
    LDA #$00 : STA $7F66F1 : STA $7F66F2
    STA $7F6751 : STA $7F6752 : STA $7F67B1 : STA $7F67B2
}

layout_asm_singlechamber_done:
    PLP
    RTS

layout_asm_crabtunnel:
{
    PHP
    %a16()
    LDA !sram_room_layout : BIT !ROOM_LAYOUT_AREA_RANDO_OR_DASH_RECALL : BEQ layout_asm_singlechamber_done
    BIT !ROOM_LAYOUT_DASH_RECALL : BNE layout_asm_crabtunnel_dash

    ; Replace top of gate with slope tiles
    LDA #$1D87 : STA $7F039C : LDA #$1194 : STA $7F039E

    ; Fix tiles to the right of the gate
    LDA #$89A0 : STA $7F03A0 : LDA #$811D : STA $7F0320

    ; Remove remaining gate tiles
    LDA #$00FF : STA $7F041E : STA $7F049E : STA $7F051E : STA $7F059E

    ; Clear gate PLMs and projectiles
    TDC : STA $1C83 : STA $1C85 : STA $19B9

    ; Slope BTS for top of the gate tiles
    %a8()
    LDA #$D2 : STA $7F65CF : LDA #$92 : STA $7F65D0

    ; Normal BTS for remaining gate tiles
    LDA #$00 : STA $7F6610 : STA $7F6650 : STA $7F6690 : STA $7F66D0
    PLP
    RTS
}

layout_asm_crabtunnel_dash:
    ; Remove remaining gate tiles
    LDA #$00FF : STA $7F041E : STA $7F049E : STA $7F051E : STA $7F059E

    ; Change gate PLM to open gate
    LDA #$C826 : STA $1C85
    LDA #$BC13 : STA $1D75

    ; Clear gate projectile
    TDC : STA $19B9

layout_asm_crabtunnel_done:
    PLP
    RTS

layout_asm_easttunnel_no_scrolls:
    PHP

layout_asm_easttunnel_after_scrolls:
{
    %a16()
    LDA !sram_room_layout : BIT !ROOM_LAYOUT_AREA_RANDO : BEQ layout_asm_crabtunnel_done

    ; Clear gate PLMs and projectiles
    LDA #$0000 : STA $1C7B : STA $1C7D : STA $19B9

    ; Remove gate tiles
    LDA #$00FF : STA $7F02AE : STA $7F02B0
    STA $7F032E : STA $7F03AE : STA $7F042E : STA $7F04AE

    ; Remove blocks from vertical shaft
    STA $7F078C : STA $7F088C : STA $7F090C
    STA $7F098C : STA $7F0A0C : STA $7F0A8C
    ; Careful with the block that is also a scroll block
    LDA #$30FF : STA $7F080C

    ; Normal BTS for gate tiles
    %a8()
    LDA #$00 : STA $7F6558 : STA $7F6559
    STA $7F6598 : STA $7F65D8 : STA $7F6618 : STA $7F6658

    ; Decorate vertical shaft
    LDA #$22 : STA $7F070A : STA $7F070E
    STA $7F078A : STA $7F078E : STA $7F080A : STA $7F080E
    STA $7F088A : STA $7F088E : STA $7F090A : STA $7F090E
    STA $7F098A : STA $7F098E : STA $7F0A0A : STA $7F0A0E
    LDA #$85 : STA $7F078B : STA $7F080B : STA $7F088B
    STA $7F090B : STA $7F098B : STA $7F0A0B
    STA $7F0A8A : STA $7F0A8E
    LDA #$8D : STA $7F0A8B
}

layout_asm_easttunnel_done:
    PLP
    RTS

layout_asm_eastocean:
{
    PHP
    %a16()
    LDA !sram_room_layout : BIT !ROOM_LAYOUT_AREA_RANDO : BEQ layout_asm_easttunnel_done

    ; Add platforms for ease of access to right door
    LDA #$8100 : STA $7F4506 : STA $7F4876
    INC : STA $7F4508 : STA $7F4878
    LDA #$8501 : STA $7F450A : STA $7F487A
    DEC : STA $7F450C : STA $7F487C
    LDA #$1120 : STA $7F45E6 : STA $7F4956
    INC : STA $7F45E8 : STA $7F4958
    LDA #$1521 : STA $7F45EA : STA $7F495A
    DEC : STA $7F45EC : STA $7F495C

    ; Slope BTS for platform bottoms
    %a8()
    LDA #$94 : STA $7F86F4 : STA $7F88AC
    INC : STA $7F86F5 : STA $7F88AD
    LDA #$D5 : STA $7F86F6 : STA $7F88AE
    DEC : STA $7F86F7 : STA $7F88AF
}

layout_asm_eastocean_done:
    PLP
    RTS

layout_asm_crabshaft_no_scrolls:
    PHP
    BRA layout_asm_crabshaft_after_scrolls

layout_asm_crabshaft_update_scrolls:
    STA $7ECD26

layout_asm_crabshaft_after_scrolls:
{
    %a16()
    LDA !sram_room_layout : BIT !ROOM_LAYOUT_AREA_RANDO : BEQ layout_asm_eastocean_done

    ; Set green door as already opened
    LDA $7ED8C0 : ORA #$8000 : STA $7ED8C0

    ; Clear space above save station
    LDA #$00FF : STA $7F095C : STA $7F095E

    ; Add save station PLM
    %ai16()
    PHX : LDX #layout_asm_crabshaft_plm_data
    JSL $84846A : PLX
}

layout_asm_crabshaft_done:
    PLP
    RTS

layout_asm_crabshaft_plm_data:
    db #$6F, #$B7, #$0D, #$29, #$09, #$00

layout_asm_mainstreet:
{
    PHP
    %a16()
    LDA !sram_room_layout : BIT !ROOM_LAYOUT_AREA_RANDO : BEQ layout_asm_crabshaft_done

    ; Add save station PLM
    %ai16()
    PHX : LDX #layout_asm_mainstreet_plm_data
    JSL $84846A : PLX
}

layout_asm_mainstreet_done:
    PLP
    RTS

layout_asm_mainstreet_plm_data:
    db #$6F, #$B7, #$18, #$59, #$0A, #$00

layout_asm_crateria_kihunters:
{
    PHP
    %a16()
    LDA !sram_room_layout : BIT !ROOM_LAYOUT_AREA_RANDO : BEQ layout_asm_mainstreet_done

    ; Set yellow door as already opened
    LDA $7ED8B0 : ORA #$4000 : STA $7ED8B0
}

layout_asm_crateria_kihunters_done:
    PLP
    RTS

layout_asm_forgotten_highway_elbow:
{
    PHP
    %a16()
    LDA !sram_room_layout : BIT !ROOM_LAYOUT_AREA_RANDO_OR_DASH_RECALL : BEQ layout_asm_crateria_kihunters_done

    ; Set yellow door as already opened
    LDA $7ED8B0 : ORA #$8000 : STA $7ED8B0
}

layout_asm_forgotten_highway_elbow_done:
    PLP
    RTS

layout_asm_green_pirates_shaft:
{
    PHP
    %a16()
    LDA !sram_room_layout : BIT !ROOM_LAYOUT_AREA_RANDO : BEQ layout_asm_forgotten_highway_elbow_done

    ; Set red door as already opened
    LDA $7ED8B2 : ORA #$4000 : STA $7ED8B2
}

layout_asm_green_pirates_shaft_done:
    PLP
    RTS

layout_asm_bowling:
{
    PHP
    %a16()
    LDA !sram_room_layout : BIT !ROOM_LAYOUT_DASH_RECALL : BEQ layout_asm_green_pirates_shaft_done

    ; Clear speed blocks in front of Wrecked Ship reserve item
    LDA #$00FF : STA $7F053E
    STA $7F05BE : STA $7F05C0 : STA $7F05C4
    STA $7F05C6 : STA $7F05CA : STA $7F05CC
    STA $7F067E : STA $7F0680 : STA $7F0684
    STA $7F0686 : STA $7F068A : STA $7F068C
    STA $7F073E : STA $7F0740 : STA $7F0744
    STA $7F0746 : STA $7F074A : STA $7F074C
}

layout_asm_bowling_done:
    PLP
    RTS

layout_asm_wreckedshipmain:
{
    PHP
    %a16()
    LDA !sram_room_layout : BIT !ROOM_LAYOUT_AREA_RANDO : BEQ layout_asm_bowling_done

    ; Set grey door as already opened
    LDA $7ED8C0 : ORA #$0008 : STA $7ED8C0
}

layout_asm_wreckedshipmain_done:
    PLP
    RTS

layout_asm_electric_death_varia_tweaks_header:
    dl $C4D3EE
    db $05, $30, $05
    dw $9C04, $C1AB, $8BF7, $C1C1, $CC21, $0000, $0000, $C323, $E19E, $C8C7

layout_asm_electric_death_state_check:
{
    LDA !sram_room_layout : BIT !ROOM_LAYOUT_DASH_RECALL_OR_VARIA_TWEAKS : BEQ .end_check
    LDX #layout_asm_electric_death_varia_tweaks_header
  .end_check
    JMP $E5E6
}

layout_asm_wrecked_ship_energy_tank_varia_tweaks_header:
    dl $C4D883
    db $05, $00, $03
    dw $9C14, $C1E7, $8C27, $00C0, $0000, $0000, $0000, $C337, $0000, $C8C7

layout_asm_wrecked_ship_energy_tank_state_check:
{
    LDA !sram_room_layout : BIT !ROOM_LAYOUT_DASH_RECALL_OR_VARIA_TWEAKS : BEQ .end_check
    LDX #layout_asm_wrecked_ship_energy_tank_varia_tweaks_header
  .end_check
    JMP $E5E6
}

layout_asm_wreckedshipsave:
{
    PHP
    %a16()
    LDA !sram_room_layout : BIT !ROOM_LAYOUT_AREA_RANDO_OR_DASH_RECALL : BEQ layout_asm_wreckedshipmain_done

    ; Activate save station
    JSL $8483D7
    dw $0B07, $B76F
}

layout_asm_wreckedshipsave_done:
    PLP
    RTS

layout_asm_plasma_dash_header:
    dl $CB8BD4
    db $0B, $00, $00
    dw $9D94, layout_asm_plasma_dash_enemies, layout_asm_plasma_dash_enemy_set
    dw $00C0, $D2D3, $0000, $0000, $C553, $0000, layout_asm_plasma

layout_asm_plasma_state_check:
{
    LDA !sram_room_layout : BIT !ROOM_LAYOUT_DASH_RECALL : BEQ .end_check
    LDX #layout_asm_plasma_dash_header
  .end_check
    JMP $E5E6
}

layout_asm_plasma:
{
    PHP
    %a16()

    ; Add platform and surrounding decoration
    LDA #$00FF : STA $7F04AE : STA $7F04B4
    STA $7F04EC : STA $7F04EE : STA $7F04F4
    STA $7F051E : STA $7F0520 : STA $7F0522
    STA $7F0530 : STA $7F0532 : STA $7F0534
    STA $7F055E : STA $7F0560 : STA $7F0562
    STA $7F0570 : STA $7F0572 : STA $7F0574
    STA $7F05B0 : STA $7F05B2 : STA $7F05B4
    STA $7F05F0 : STA $7F05F2 : STA $7F05F4
    STA $7F062C : STA $7F062E : STA $7F0630 : STA $7F0632 : STA $7F0634
    STA $7F066C : STA $7F066E : STA $7F0670 : STA $7F0672 : STA $7F0674
    STA $7F06AE : STA $7F06B0 : STA $7F06B2 : STA $7F06B4
    STA $7F06EE : STA $7F06F0 : STA $7F06F2 : STA $7F06F4
    STA $7F072E : STA $7F0730 : STA $7F0732 : STA $7F0734
    STA $7F076E : STA $7F0770 : STA $7F0772 : STA $7F0774
    STA $7F07AE : STA $7F07B0 : STA $7F07B2 : STA $7F07B4
    LDA #$0202 : STA $7F0524
    LDA #$0382 : STA $7F0430 : STA $7F0432
    INC : STA $7F03F0 : STA $7F03F2
    LDA #$0386 : STA $7F0434
    INC : STA $7F03F4
    INC : STA $7F046E : STA $7F04F0
    INC : STA $7F03EE : STA $7F0470
    INC : STA $7F0472
    INC : STA $7F0474 : STA $7F04DE : STA $7F04F2
    INC : STA $7F042E : STA $7F04B0
    INC : STA $7F03B4 : STA $7F04B2
    INC : INC : STA $7F04AC : STA $7F059C
    LDA #$0398 : STA $7F042C : STA $7F051C
    INC : STA $7F046C : STA $7F055C
    LDA #$039C : STA $7F03EC : STA $7F04DC
    LDA #$0602 : STA $7F052E
    LDA #$1212 : STA $7F05A4
    INC : INC : STA $7F0564
    LDA #$1612 : STA $7F05AE
    INC : INC : STA $7F056E
    LDA #$8200 : STA $7F0528 : STA $7F052A
    STA $7F07EE : STA $7F07F0 : STA $7F07F2 : STA $7F07F4
    INC : STA $7F0526
    LDA #$8210 : STA $7F0568 : STA $7F056A
    STA $7F05A6 : STA $7F05A8 : STA $7F05AA : STA $7F05AC
    LDA #$8215 : STA $7F0566
    LDA #$8601 : STA $7F052C
    LDA #$8615 : STA $7F056C
    LDA #$8A07 : STA $7F05E6 : STA $7F05E8
    STA $7F05EA : STA $7F05EC
    LDA #$8A0B : STA $7F05E4
    LDA #$8E0B : STA $7F05EE

    ; Add slope BTS to new platform
    %a8()
    LDA #$1B : STA $7F66B3 : INC : STA $7F66D3
    LDA #$5B : STA $7F66B8 : INC : STA $7F66D8
}

layout_asm_plasma_done:
    PLP
    RTS

layout_asm_plasma_spark:
{
    PHP
    %a16()
    LDA !sram_room_layout : BIT !ROOM_LAYOUT_DASH_RECALL : BEQ layout_asm_plasma_done

    ; Set grey door as already opened
    LDA $7ED8C2 : ORA #$0008 : STA $7ED8C2
}

layout_asm_plasma_spark_done:
    PLP
    RTS

layout_asm_aqueduct:
{
    PHP
    %a16()
    LDA !sram_room_layout : BIT !ROOM_LAYOUT_AREA_RANDO : BEQ layout_asm_plasma_spark_done

    ; Replace power bomb blocks with bomb blocks
    LDA #$F09D : STA $7F1690 : STA $7F18D0
    LDA #$F49D : STA $7F1692 : STA $7F18D2

    ; Replace BTS
    %a8()
    LDA #$04 : STA $7F6F49 : STA $7F6F4A
    STA $7F7069 : STA $7F706A
}

layout_asm_aqueduct_done:
    PLP
    RTS

layout_asm_butterfly:
{
    PHP
    %a16()
    LDA !sram_room_layout : BIT !ROOM_LAYOUT_DASH_RECALL : BEQ layout_asm_aqueduct_done

    ; Set grey door as already opened
    LDA $7ED8C2 : ORA #$0080 : STA $7ED8C2
}

layout_asm_butterfly_done:
    PLP
    RTS

layout_asm_botwoon_hallway:
{
    PHP
    %a16()
    LDA !sram_room_layout : BIT !ROOM_LAYOUT_DASH_RECALL : BEQ layout_asm_botwoon_hallway_done

    ; Convert speed blocks to bomb blocks
    %a8()
    LDA #$F0 : STA $7F05A1 : STA $7F05E3 : STA $7F05ED
    STA $7F0663 : STA $7F06A1 : STA $7F06ED
    LDA #$F3 : STA $7F0621
    LDA #$F8 : STA $7F066D : STA $7F06E3

    ; Use spazer block BTS
    LDA #$09 : STA $7F66D1 : STA $7F66F2 : STA $7F66F7
    STA $7F6711 : STA $7F6732 : STA $7F6737
    STA $7F6751 : STA $7F6772 : STA $7F6777
}

layout_asm_botwoon_hallway_done:
    PLP
    RTS

layout_asm_pants_room_external:
{
    ; Open grapple blocks to shaktool
    LDA #$00FF : STA $7F0CCC : STA $7F0CCE : STA $7F0CD0
    STA $7F0CD2 : STA $7F0CD4 : STA $7F0CD6
    STA $7F0D0E : STA $7F0D14 : STA $7F0D16

    ; Replace BTS
    TDC : STA $7F6A69
    RTL

layout_asm_shaktool_room:
{
    ; Restore shaktool PLM linked to PB explosion
    JSL $8483D7
    dw $0000, $B8EB

    PHP
    %a16()
    LDA !sram_room_layout : BIT !ROOM_LAYOUT_DASH_RECALL : BEQ layout_asm_botwoon_hallway_done

    ; Clear shaktool sand
    LDA #$00FF : STA $7F02A2 : STA $7F02A4 : STA $7F02A6 : STA $7F02A8
    STA $7F02AA : STA $7F02AC : STA $7F02AE : STA $7F02B0
    STA $7F02B2 : STA $7F02B4 : STA $7F02B6 : STA $7F02B8
    STA $7F02BA : STA $7F02BC : STA $7F02BE : STA $7F02C0
    STA $7F02C2 : STA $7F02C4 : STA $7F02C6 : STA $7F02C8
    STA $7F02CA : STA $7F02CC : STA $7F02CE : STA $7F02D0
    STA $7F02D2 : STA $7F02D4 : STA $7F02D6 : STA $7F02D8
    STA $7F02DA : STA $7F02DC : STA $7F02DE : STA $7F02E0
    STA $7F02E2 : STA $7F02E4 : STA $7F02E6 : STA $7F02E8
    STA $7F0322 : STA $7F0324 : STA $7F0326 : STA $7F0328
    STA $7F032A : STA $7F032C : STA $7F032E : STA $7F0330
    STA $7F0332 : STA $7F0334 : STA $7F0336 : STA $7F0338
    STA $7F033A : STA $7F033C : STA $7F033E : STA $7F0340
    STA $7F0342 : STA $7F0344 : STA $7F0346 : STA $7F0348
    STA $7F034A : STA $7F034C : STA $7F034E : STA $7F0350
    STA $7F0352 : STA $7F0354 : STA $7F0356 : STA $7F0358
    STA $7F035A : STA $7F035C : STA $7F035E : STA $7F0360
    STA $7F0362 : STA $7F0364 : STA $7F0366 : STA $7F0368
    STA $7F03A2 : STA $7F03A4 : STA $7F03A6 : STA $7F03A8
    STA $7F03AA : STA $7F03AC : STA $7F03AE : STA $7F03B0
    STA $7F03B2 : STA $7F03B4 : STA $7F03B6 : STA $7F03B8
    STA $7F03BA : STA $7F03BC : STA $7F03BE : STA $7F03C0
    STA $7F03C2 : STA $7F03C4 : STA $7F03C6 : STA $7F03C8
    STA $7F03CA : STA $7F03CC : STA $7F03CE : STA $7F03D0
    STA $7F03D2 : STA $7F03D4 : STA $7F03D6 : STA $7F03D8
    STA $7F03DA : STA $7F03DC : STA $7F03DE : STA $7F03E0
    STA $7F03E2 : STA $7F03E4 : STA $7F03E6 : STA $7F03E8
    STA $7F0422 : STA $7F0424 : STA $7F0426 : STA $7F0428
    STA $7F042A : STA $7F042C : STA $7F042E : STA $7F0430
    STA $7F0432 : STA $7F0434 : STA $7F0436 : STA $7F0438
    STA $7F043A : STA $7F043C : STA $7F043E : STA $7F0440
    STA $7F0442 : STA $7F0444 : STA $7F0446 : STA $7F0448
    STA $7F044A : STA $7F044C : STA $7F044E : STA $7F0450
    STA $7F0452 : STA $7F0454 : STA $7F0456 : STA $7F0458
    STA $7F045A : STA $7F045C : STA $7F045E : STA $7F0460
    STA $7F0462 : STA $7F0464 : STA $7F0466 : STA $7F0468
    STA $7F04A2 : STA $7F04A4 : STA $7F04A6 : STA $7F04A8
    STA $7F04AA : STA $7F04AC : STA $7F04AE : STA $7F04B0
    STA $7F04B2 : STA $7F04B4 : STA $7F04B6 : STA $7F04B8
    STA $7F04BA : STA $7F04BC : STA $7F04BE : STA $7F04C0
    STA $7F04C2 : STA $7F04C4 : STA $7F04C6 : STA $7F04C8
    STA $7F04CA : STA $7F04CC : STA $7F04CE : STA $7F04D0
    STA $7F04D2 : STA $7F04D4 : STA $7F04D6 : STA $7F04D8
    STA $7F04DA : STA $7F04DC : STA $7F04DE : STA $7F04E0
    STA $7F04E2 : STA $7F04E4 : STA $7F04E6 : STA $7F04E8
    STA $7F0522 : STA $7F0524 : STA $7F0526 : STA $7F0528
    STA $7F052A : STA $7F052C : STA $7F052E : STA $7F0530
    STA $7F0532 : STA $7F0534 : STA $7F0536 : STA $7F0538
    STA $7F053A : STA $7F053C : STA $7F053E : STA $7F0540
    STA $7F0542 : STA $7F0544 : STA $7F0546 : STA $7F0548
    STA $7F054A : STA $7F054C : STA $7F054E : STA $7F0550
    STA $7F0552 : STA $7F0554 : STA $7F0556 : STA $7F0558
    STA $7F055A : STA $7F055C : STA $7F055E : STA $7F0560
    STA $7F0562 : STA $7F0564 : STA $7F0566 : STA $7F0568
}

layout_asm_shaktool_room_done:
    PLP
    RTS

layout_asm_halfie_climb:
{
    PHP
    %a16()
    LDA !sram_room_layout : BIT !ROOM_LAYOUT_DASH_RECALL : BEQ layout_asm_shaktool_room_done

    ; Set grey door as already opened
    LDA $7ED8C2 : ORA #$1000 : STA $7ED8C2
}

layout_asm_halfie_climb_done:
    PLP
    RTS

layout_asm_aqueductfarmsandpit_door_list:
    dw #$A7D4, #$A534

layout_asm_aqueductfarmsandpit_external:
{
    ; Place door BTS
    %a8()
    LDA #$40 : STA $7F65C0 : LDA #$FF : STA $7F6600
    DEC : STA $7F6640 : DEC : STA $7F6680 : LDA #$01
    STA $7F65C1 : STA $7F6601 : STA $7F6641 : STA $7F6681

    ; Move right wall one to the left
    %a16()
    LDA #$8A09 : STA $7F01FE : LDA #$820E : STA $7F067E
    LDA #$820A : STA $7F027E : STA $7F05FE
    LDA #$8A0B : STA $7F02FE : LDA #$8A07 : STA $7F0300
    LDA #$820B : STA $7F057E : LDA #$8207 : STA $7F0580

    ; Fill in area behind the wall
    LDA #$8210 : STA $7F0200 : STA $7F0280 : STA $7F0600 : STA $7F0680

    ; Place the door
    LDA #$C00C : STA $7F037E : LDA #$9040 : STA $7F0380
    LDA #$D02C : STA $7F03FE : LDA #$9060 : STA $7F0400
    LDA #$D82C : STA $7F047E : LDA #$9860 : STA $7F0480
    LDA #$D80C : STA $7F04FE : LDA #$9840 : STA $7F0500
    RTL
}

layout_asm_westsandhall:
{
    PHP
    %a16()
    LDA !sram_room_layout : BIT !ROOM_LAYOUT_AREA_RANDO : BEQ layout_asm_westsandhall_done

    ; Change left door BTS to previously unused door
    %a8()
    LDA #$02 : STA $7F6582 : STA $7F65C2 : STA $7F6602 : STA $7F6642
}

layout_asm_westsandhall_done:
    PLP
    RTS

layout_asm_crocspeedway:
{
    PHP
    %a16()
    LDA !sram_room_layout : BIT !ROOM_LAYOUT_AREA_RANDO_OR_DASH_RECALL : BEQ layout_asm_westsandhall_done

    ; Set green door as already opened
    LDA $7ED8B8 : ORA #$4000 : STA $7ED8B8
}

layout_asm_crocspeedway_done:
    PLP
    RTS

layout_asm_croc:
{
    PHP
    %a16()
    LDA !sram_room_layout : BIT !ROOM_LAYOUT_AREA_RANDO_OR_DASH_RECALL : BEQ layout_asm_crocspeedway_done

    ; Set grey door as already opened
    LDA $7ED8B8 : ORA #$8000 : STA $7ED8B8
}

layout_asm_croc_done:
    PLP
    RTS

layout_asm_kronicboost:
{
    PHP
    %a16()
    LDA !sram_room_layout : BIT !ROOM_LAYOUT_AREA_RANDO : BEQ layout_asm_croc_done

    ; Set yellow door as already opened
    LDA $7ED8BA : ORA #$0100 : STA $7ED8BA
}

layout_asm_kronicboost_done:
    PLP
    RTS

layout_asm_bigpink:
{
    PHP
    %a16()
    LDA !sram_room_layout : BIT !ROOM_LAYOUT_ANTISOFTLOCK : BEQ layout_asm_kronicboost_done

    ; Clear out path to save room
    LDA #$00FF : STA $7F03F2 : STA $7F03F8 : STA $7F03FA
    STA $7F03FC : STA $7F03FE : STA $7F0400 : STA $7F0402
    STA $7F0404 : STA $7F0406 : STA $7F0408 : STA $7F0492
    STA $7F0496 : STA $7F0498 : STA $7F049A : STA $7F049C
    STA $7F049E : STA $7F04A0 : STA $7F04A2 : STA $7F04A4
    STA $7F04A6 : STA $7F04A8 : STA $7F0542

    ; A small part of the path is decorated
    LDA #$0B24 : STA $7F03F4
    LDA #$0B02 : STA $7F03F6
    LDA #$0B05 : STA $7F0494

    ; Decorate wall above path
    LDA #$8B08 : STA $7F0354 : STA $7F0356 : STA $7F0358
    STA $7F035A : STA $7F035C : STA $7F035E : STA $7F0360
    STA $7F0362 : STA $7F0364 : STA $7F0366

    ; Fade in wall above path
    LDA #$8B28 : STA $7F02B4 : STA $7F02B6 : STA $7F02B8
    STA $7F02BA : STA $7F02BC : STA $7F02BE : STA $7F02C0
    STA $7F02C2 : STA $7F02C4

    ; Decorate the corner
    LDA #$8B17 : STA $7F0368
    LDA #$8B29 : STA $7F02C6

    ; Normal BTS for path replacing scrolls
    %a8()
    LDA #$00 : STA $7F66A1 : STA $7F66A2 : STA $7F66A3

    ; Allow screen scrolling along the path
    LDA #$02 : STA $7ECD21
}

layout_asm_bigpink_done:
    PLP
    RTS

layout_asm_dachora:
{
    PHP
    %a16()
    LDA !sram_room_layout : BIT !ROOM_LAYOUT_ANTISOFTLOCK_OR_DASH_RECALL : BEQ layout_asm_bigpink_done

    ; Use non-respawning speed booster block BTS for dachora pitfall
    %a8()
    LDA #$0F : STA $7F6987 : STA $7F6988 : STA $7F6989
    STA $7F698A : STA $7F698B : STA $7F698C
}

layout_asm_dachora_done:
    PLP
    RTS

layout_asm_moat:
{
    PHP
    %a16()
    LDA !sram_room_layout : BIT !ROOM_LAYOUT_ANTISOFTLOCK_OR_DASH_RECALL : BEQ layout_asm_dachora_done
    BIT !ROOM_LAYOUT_DASH_RECALL : BNE layout_asm_moat_dash

    ; Use shootable blocks on the moat pillar
    %a8()
    LDA #$C0 : STA $7F059F : STA $7F061F
    LDA #$BE : STA $7F05DE
    LDA #$D0 : STA $7F05DF

    ; Set BTS so the top block is 1x2
    LDA #$02 : STA $7F66D0
    LDA #$FF : STA $7F66F0
    PLP
    RTS
}

layout_asm_moat_dash:
    ; Use a single shootable block on the moat pillar
    LDA #$F05F : STA $7F061E

layout_asm_moat_done:
    PLP
    RTS

layout_asm_redtowerelevator:
{
    PHP
    %a16()
    LDA !sram_room_layout : BIT !ROOM_LAYOUT_ANY_RANDO : BEQ layout_asm_moat_done

    ; Set red door as already opened
    LDA $7ED8B2 : ORA #$0001 : STA $7ED8B2
}

layout_asm_redtowerelevator_done:
    PLP
    RTS

layout_asm_missionimpossible:
{
    PHP
    %a16()
    LDA !sram_room_layout : BIT !ROOM_LAYOUT_ANTISOFTLOCK : BEQ layout_asm_redtowerelevator_done

    ; Use shootable block
    %a8()
    LDA #$C0 : STA $7F0687
}

layout_asm_missionimpossible_done:
    PLP
    RTS

layout_asm_noobbridge:
{
    PHP
    %a16()
    LDA !sram_room_layout : BIT !ROOM_LAYOUT_AREA_RANDO : BEQ layout_asm_missionimpossible_done

    ; Set green door as already opened
    LDA $7ED8B6 : ORA #$0008 : STA $7ED8B6
}

layout_asm_noobbridge_done:
    PLP
    RTS

layout_asm_waterway:
{
    PHP
    %a16()
    LDA !sram_room_layout : BIT !ROOM_LAYOUT_DASH_RECALL : BEQ layout_asm_noobbridge_done

    ; Convert speed blocks to bomb blocks
    LDA #$F306 : STA $7F0802 : STA $7F08E2 : STA $7F09C2
    LDA #$F34E : STA $7F0818 : STA $7F0836 : STA $7F083A
    STA $7F083C : STA $7F08F6 : STA $7F08FA : STA $7F0916
    STA $7F0918 : STA $7F091A : STA $7F09D6 : STA $7F09D8
    STA $7F09F6 : STA $7F09F8 : STA $7F09FC : STA $7F09FE : STA $7F0A00
    LDA #$F350 : STA $7F0804 : STA $7F081C : STA $7F0844
    STA $7F08E4 : STA $7F08FC : STA $7F0924
    STA $7F09C4 : STA $7F09DC : STA $7F0A04
    LDA #$F74E : STA $7F081A : STA $7F0838 : STA $7F0914
    STA $7F091C : STA $7F091E : STA $7F0922 : STA $7F09DA
    LDA #$F750 : STA $7F0814 : STA $7F0832 : STA $7F08F4
    STA $7F0912 : STA $7F09D4 : STA $7F09F2
    LDA #$FB4E : STA $7F0816 : STA $7F0840 : STA $7F0842
    STA $7F0920 : STA $7F09F4 : STA $7F09FA : STA $7F0A02
    LDA #$FF4E : STA $7F0834 : STA $7F083E : STA $7F08F8

    ; Use spazer block BTS
    LDA #$0909 : STA $7F6802 : STA $7F680B : STA $7F680C : STA $7F680E
    STA $7F681A : STA $7F681C : STA $7F681E : STA $7F6820 : STA $7F6822
    STA $7F6872 : STA $7F687B : STA $7F687C : STA $7F687E
    STA $7F688A : STA $7F688C : STA $7F688E : STA $7F6890 : STA $7F6892
    STA $7F68E2 : STA $7F68EB : STA $7F68EC : STA $7F68EE
    STA $7F68FA : STA $7F68FC : STA $7F68FE : STA $7F6900 : STA $7F6902
}

layout_asm_waterway_done:
    PLP
    RTS

layout_asm_redtower:
{
    PHP
    %a16()
    LDA !sram_room_layout : BIT !ROOM_LAYOUT_ANTISOFTLOCK_OR_DASH_RECALL : BEQ layout_asm_waterway_done

    ; Create opening along bottom left of red tower
    LDA #$00FF : STA $7F0E66 : STA $7F0E88 : STA $7F0EA6 : STA $7F0EA8
    STA $7F0EC6 : STA $7F0EC8 : STA $7F0ECA : STA $7F0EE8

    ; Decorate opening background
    LDA #$014B : STA $7F0E68 : STA $7F0EAA : LDA #$0169 : STA $7F0E6A
    LDA #$014A : STA $7F0E8A : LDA #$094B : STA $7F0EEA

    ; Move the wall further to the left
    LDA #$8101 : STA $7F0E64 : LDA #$8121 : STA $7F0EC4
    LDA #$8103 : STA $7F0E84 : STA $7F0EA4
    LDA #$8143 : STA $7F0EE6 : LDA #$072D : STA $7F0E86
}

layout_asm_redtower_done:
    PLP
    RTS

layout_asm_belowspazer:
{
    PHP
    %a16()
    LDA !sram_room_layout : BIT !ROOM_LAYOUT_ANTISOFTLOCK_OR_DASH_RECALL : BEQ layout_asm_redtower_done

    ; Use shootable block
    LDA #$C1EB : STA $7F018E
}

layout_asm_belowspazer_done:
    PLP
    RTS

layout_asm_warehousekihunters:
{
    PHP
    %a16()
    LDA !sram_room_layout : BIT !ROOM_LAYOUT_ANTISOFTLOCK : BEQ layout_asm_belowspazer_done

    ; Use shootable block
    %a8()
    LDA #$C5 : STA $7F064F
}

layout_asm_warehousekihunters_done:
    PLP
    RTS

layout_asm_cathedralentrance:
{
    PHP
    %a16()
    LDA !sram_room_layout : BIT !ROOM_LAYOUT_ANTISOFTLOCK_OR_DASH_RECALL : BEQ layout_asm_warehousekihunters_done

    ; Remove protruding ledge
    LDA #$8106 : STA $7F040C
    LDA #$00FF : STA $7F03AC : STA $7F040E : STA $7F0410

    ; Remove slope BTS
    %a8()
    LDA #$00 : STA $7F65B7 : STA $7F6609
}

layout_asm_cathedralentrance_done:
    PLP
    RTS

layout_asm_hjbetank:
{
    PHP
    %a16()
    LDA !sram_room_layout : BIT !ROOM_LAYOUT_ANTISOFTLOCK_OR_DASH_RECALL : BEQ layout_asm_cathedralentrance_done
    BIT !ROOM_LAYOUT_DASH_RECALL : BNE layout_asm_hjbetank_dash

    ; Use one shootable block
    %a8()
    LDA #$C5 : STA $7F015D
    PLP
    RTS
}

layout_asm_hjbetank_dash:
    ; Use multiple shootable blocks
    %a8()
    LDA #$C5 : STA $7F015D
    LDA #$C3 : STA $7F02B5 : STA $7F02B9

layout_asm_hjbetank_done:
    PLP
    RTS

layout_asm_acidstatue:
{
    PHP
    %a16()
    LDA !sram_room_layout : BIT !ROOM_LAYOUT_VARIA_TWEAKS : BEQ layout_asm_hjbetank_done

    ; Add platform
    LDA #$836B : STA $7F049E : STA $7F04A0
    STA $7F04A2 : STA $7F04A4
}

layout_asm_acidstatue_done:
    PLP
    RTS

layout_asm_brinstarpremaproom:
{
    PHP
    %a16()
    LDA !sram_room_layout : BIT !ROOM_LAYOUT_ANTISOFTLOCK : BEQ layout_asm_acidstatue_done

    ; Set grey door as already opened
    LDA $7ED8B4 : ORA #$0020 : STA $7ED8B4
}

layout_asm_brinstarpremaproom_done:
    PLP
    RTS

layout_asm_earlysupers:
{
    PHP
    %a16()
    LDA !sram_room_layout : BIT !ROOM_LAYOUT_ANTISOFTLOCK_OR_DASH_RECALL : BEQ layout_asm_brinstarpremaproom_done
    BIT !ROOM_LAYOUT_DASH_RECALL : BNE layout_asm_earlysupers_dash

    ; Use shootable block on the bridge
    %a8()
    LDA #$C1 : STA $7F08BD

    ; Use shootable blocks on the divider
    STA $7F0935 : STA $7F09F5
    LDA #$D1 : STA $7F0995 : STA $7F0A55

    ; Set BTS to make 1x2 blocks
    LDA #$02 : STA $7F689B : STA $7F68FB
    LDA #$FF : STA $7F68CB : STA $7F692B
    PLP
    RTS
}

layout_asm_earlysupers_dash:
    ; Use shootable block on the bridge
    %a8()
    LDA #$C1 : STA $7F08BD

layout_asm_earlysupers_done:
    PLP
    RTS

print pc, " layout end"


org $A1EBD1
print pc, " layout bankA1 start"

layout_asm_plasma_dash_enemies:
    dw $F693, #$0100, #$0080, #$0000, #$2000, #$0004, #$8001, #$0020
    dw $F693, #$0080, #$01D0, #$0000, #$2000, #$0004, #$8000, #$0030
    dw $F693, #$01B0, #$01D0, #$0000, #$2000, #$0004, #$8001, #$0030
    dw $F393, #$0030, #$0180, #$0000, #$2000, #$0004, #$0000, #$01A0
    dw $F393, #$01D0, #$0130, #$0000, #$2000, #$0004, #$0001, #$01A0
    dw $F693, #$0078, #$0280, #$0000, #$2000, #$0004, #$8001, #$0080
    db #$FF, #$FF, #$06

print pc, " layout bankA1 end"


org $B4F4B8
print pc, " layout bankB4 start"

layout_asm_plasma_dash_enemy_set:
    dw $F693, #$0001, $F393, #$0002
    db #$FF, #$FF, #$00

print pc, " layout bankB4 end"

