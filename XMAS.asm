    processor 6502

BLACK = 0

ATSYNC = $00
ATBLNK = $01
ATWAIT = $02
ATACTL = $04
ATBCTL = $05
ATACOL = $06
ATBCOL = $07
ATSCOL = $09
ATSALA = $10
ATSBLA = $11
ATAWAV = $15
ATADIV = $17
ATAVOL = $19
ATBVOL = $1a
ATADAT = $1b
ATBDAT = $1c
ATSAIN = $20
ATSBIN = $21
ATASEL = $25
ATBSEL = $26
ATMVIN = $2a

TIMER = $284
TIME64 = $296

FRAMEL = $80
FRAMEH = $81
TEMP1 = $82
TEMP2 = $83
TEMP3 = $84
MDUR = $90
ADUR = $91
BDUR = $92
AIDX = $93
BIDX = $94
TOPTIM = $a0
BOTTIM = $a0
PD100K = $e0
PD10K = $e2
PD1K = $e4
PD100 = $e6
PD10 = $e8
PD1 = $ea


;-----------------------------------------------------------
;      User Defined Labels
;-----------------------------------------------------------

Start = $f000
End = $fa0d

    ; SEG     CODE
    ORG     $f000
    RORG    $f000

    sei
    cld
    ldx     #$00
    txa
CLRAM
    sta     0,x
    txs
    inx
    bne     CLRAM
VINT
    lda     TIMER
    bmi     VINT
    sta     ATWAIT
    lda     #2
    sta     ATWAIT
    sta     ATBLNK
    sta     ATWAIT
    sta     ATWAIT
    sta     ATWAIT
    sta     ATSYNC
    sta     ATWAIT
    sta     ATWAIT
    lda     #0
    sta     ATWAIT
    sta     ATSYNC
    lda     #TOPTIM
    sta     TIME64
TOPVI
ENDTOP
    lda     TIMER
    bmi     ENDTOP
    lda     #0
    sta     ATSCOL
    sta     ATWAIT
    sta     ATBLNK
    lda     #$d8
    sta     ATACOL
    sta     ATBCOL
    ldy     #25
DLAY
    sta     ATWAIT
    dey
    bne     DLAY
    sta     ATWAIT
    ldy     #$05
POSA
    dey
    bpl     POSA
    sta     ATSALA
    sta     ATSBLA
    lda     #6
    sta     ATACTL
    sta     ATBCTL
    lda     #$f0
    sta     ATSAIN
    sta     ATWAIT
    sta     ATMVIN
    ldy     #25
PTREE
    sta     ATWAIT
    lda     TREEL,y
    sta     ATADAT
    lda     TREER,y
    sta     ATBDAT
    dey
    bpl     PTREE
    lda     #>WORDS
    ldx     #<MERRY
    jsr     SPIRIT6
    jsr     SCORE
    ldy     #125
DLAY2
    sta     ATWAIT
    dey
    bpl     DLAY2
    jmp     ENDPIC
SPIRIT6
    sta     TEMP1
    lda     #>WORDS
    sta     TEMP2
    stx     TEMP3
    ldy     #5
    ldx     #11
SPR6
    lda     TEMP3
    sta     PD100K,x
    dex
    lda     (TEMP1),y
    sta     PD100K,x
    dex
    dey
    bpl     SPR6
    rts
ENDPIC

BOTVI
    lda     #BOTTIM
    sta     TIME64
ENDBOT
    lda     TIMER
    bmi     ENDBOT
    jmp     VINT

    ORG     $f100
    RORG    $f100
SNDTBL

    ORG     $f180
    RORG    $f180
MAZEB
    .byte   $60
MAZEA
    .byte   $3d,$37,$3d,$33,$3d,$2e,$0f,$11,$13,$11,$13,$16,$17
    .byte   $16,$17,$1a,$3d,$37,$38,$37,$2e,$33,$17,$13,$16
    .byte   $13,$17,$13,$16,$13,$17,$13,$16,$13,$1d,$17,$1a
    .byte   $17,$1d,$17,$1a,$17,$1a,$17,$3d,$0
RNDOVR
    .byte   $0e,$0f,$2e,$33,$37,$33,$1d,$1a,$1d,$1f
    .byte   $3d,$33,$37,$33,$1d,$13,$1a,$13,$17,$13
    .byte   $16,$13,$17,$13,$1a,$13,$1d,0


    org     $f600
    rorg    $f600
SCORE
    sta     ATWAIT
    ldx     #BLACK
    stx     ATSCOL
    lda     #3
    sta     ATWAIT
    sta     ATACTL
    sta     ATBCTL
    sta     ATASEL
    sta     ATBSEL
    lda     #$10
    sta     ATSAIN
    asl
    sta     ATSBIN
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    sta     ATSALA
    sta     ATSBLA
    sta     ATWAIT
    sta     ATMVIN
    lda     #7
    sta     TEMP1
SC4
    ldy     TEMP1
    lda     (PD100K),y
    sta     ATADAT
    sta     ATWAIT
    lda     (PD10K),y
    sta     ATBDAT
    lda     (PD1K),y
    sta     ATADAT
    lda     (PD100),y
    sta     TEMP2
    lda     (PD10),y
    tax
    lda     (PD1),y
    tay
    lda     TEMP2
    sta     ATBDAT
    stx     ATADAT
    sty     ATBDAT
    sty     ATADAT
    dec     TEMP1
    bpl     SC4
    lda     #0
    sta     ATACTL
    sta     ATBCTL
    sta     ATASEL
    sta     ATBSEL
    sta     ATADAT
    sta     ATBDAT
    rts

MUSIC
    ldx     #1
    lda     BDUR,x
    bmi     SOUND
MUS10
    lda     BDUR,x
    bne     MUS50
    ldy     BIDX,x
    bpl     SOUND
    lda     SNDTBL,y
    bne     MUS20
    sta     ATAVOL
    sta     ATBVOL
    lda     #$ff
    sta     MDUR
    sta     ADUR
    sta     BDUR
    jmp     SND99
MUS20
    sta     ATADIV,x
    lsr
    lsr
    lsr
    lsr
    lsr
    tay
    lda     TIMTBL,y
    sta     BDUR,x
    inc     BIDX,x
MUS50
    dec     BDUR,x
    lda     #12
    sta     ATAVOL,x
    lda     #4
    sta     ATAWAV,x
    dex
    bpl     MUS10
    inx
SOUND
    lda     ADUR,x
    bmi     SND85
    ldy     AIDX,x
    bmi     SND85
    lda     SNDTBL,y
    sta     ATAVOL,x
    bne     SND44
    lda     #$ff
    sta     ADUR,x
    jmp     SND85
SND44
    lsr
    lsr
    lsr
    lsr
    sta     ATAWAV,x
    lda     SNDTBL+1,y
    sta     ATADIV,x
    lda     ADUR,x
    bne     SND80
    inc     AIDX,x
    inc     AIDX,x
    lda     SNDTBL+1,y
    lsr
    lsr
    lsr
    lsr
    lsr
    sta     ADUR,x
SND80
    dec     ADUR,x
    dex
SND85
    bpl     SOUND
SND99
    rts
TIMTBL
    .byte   9,18,108
    
    org     $f900
    rorg    $f900
TREER
    .byte   $00,$80,$80,$80,$80
    .byte   $ff,$fe,$fc,$f8,$f0
    .byte   $e0,$f8,$f0,$e0,$c0
    .byte   $80,$e0,$c0,$80,$80
    .byte   0,0,0,0,0,0
TREEL
    .byte   $00,$01,$01,$01,$01
    .byte   $ff,$7f,$3f,$1f,$0f
    .byte   $07,$1f,$0f,$07,$03
    .byte   $01,$07,$03,$01,$01
    .byte   0,0,0,0,0,0
    
WORDS
MERRY
    .byte   <LETM,<LETE,<LETR,<LETR,<LETY,<NULL
XMAS
    .byte   <NULL
FROM
    .byte   <NULL,<LETF,<LETR,<LETO,<LETM,<NULL
INDIV
    .byte   <NULL
DATA2
LETTRS
LETF
LETY
LETM
    .byte   0,$41,$41,$41,$49,$55,$63,$41
LETR
    .byte   0,$43,$46,$4c,$7e,$41,$41,$7e
REVR
    .byte   0,$43,$b9,$b3,$81,$be,$be,$81
SMLR
    .byte   0,$40,$40,$40,$48,$78,$40,$00
LETD
    .byte   0,$78,$44,$44,$44,$44,$44,$78
LETE
    .byte   0,$7e,$40,$40,$78,$40,$40,$7e
REVE
    .byte   0,$7e,$bf,$bf,$87,$bf,$bf,$81
LETX
    .byte   0,$41,$22,$14,$08,$14,$22,$41
REVX
    .byte   0,$be,$dd,$eb,$f7,$eb,$dd,$be
LETT
    .byte   0,$08,$08,$08,$08,$08,$08,$7f
REVT
    .byte   0,$f7,$f7,$f7,$f7,$f7,$80,$ff
LETA
    .byte   0,$44,$44,$44,$7c,$44,$28,$10
REVA
    .byte   0,$bb,$bb,$bb,$7c,$bb,$d7,$ef
LETC
    .byte   0,$7f,$40,$40,$40,$40,$40,$7f
LETL
    .byte   0,$7f,$40,$40,$40,$40,$40,$40
LETO
    .byte   0,$7f,$41,$41,$41,$41,$41,$7f
LPR
    .byte   0,$84,$85,$86,$f7,$94,$94,$f7
LE2
    .byte   0,$b9,$20,$20,$b9,$a1,$a1,$bd
LSE
    .byte   0,$ef,$28,$28,$ee,$08,$08,$ef
LN
    .byte   0,$44,$4c,$4c,$54,$54,$64,$45
LTS
    .byte   0,$47,$40,$40,$47,$44,$44,$f7
LS
    .byte   0,$c0,$40,$40,$c0,$00,$00,$c0
NULL
    .byte   0,0,0,0,0,0,0,0,0,0
LETG
    .byte   $00,$7c,$84,$8e,$80,$80,$84,$7c,0
LETV
    .byte   0,$0c,$0c,$12,$12,$21,$21,$21

    org     $fffc
    rorg    $fffc
    ; DA $3000
    .word   $f000
    ; DA END
    .word   End
