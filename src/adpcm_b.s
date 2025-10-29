; b: source lookup (smp start LSB; smp start MSB; smp end LSB; smp start MSB; deltaN LSB; deltaN MSB)
ADPCMB_PlaySample:

    push af
    push bc
    push hl
    push de
    push ix    

        ;From FreeM - reset and enable
        ld  de,$1c80
		rst RST_YM_WRITEA
        ld  de,$1c00
		rst RST_YM_WRITEA
        ld  de,$1000
		rst RST_YM_WRITEA

        ;get sample address into ix
        ; Index SFX ADPCM-A list
        ld h,0    ; \
        ld l,b    ; | ofs = new_smp_id
        add hl,hl ; | ofs *= 4
        add hl,hl ; /
        push de
            ld a,(SFXPS_adpcma_table)
            ld e,a
            ld a,(SFXPS_adpcma_table+1)
            ld d,a
            add hl,de
        pop de        

        ;Transfer from HL into IX
        push hl ; - ix = hl
        pop ix  ; /     

        ;Low byte of start address
        ld d,REG_PB_STARTL
        ld e,(ix+0)
        rst RST_YM_WRITEA

        ;High byte of start address
        ld d,REG_PB_STARTH
        ld e,(ix+1)
        rst RST_YM_WRITEA

        ;Low byte of end address
        ld d,REG_PB_ENDL
        ld e,(ix+2)
        rst RST_YM_WRITEA

        ;High byte of end address
        ld d,REG_PB_ENDH
        ld e,(ix+3)
        rst RST_YM_WRITEA

        ;DeltaN + volume + left/right + control bits uses half of another slot, so always remember to use two slots every PCMB
        ld d,REG_PB_FREQL
        ld e,(ix+4)
        rst RST_YM_WRITEA

        ;High byte of delta n
        ld d,REG_PB_FREQH
        ld e,(ix+5)
        rst RST_YM_WRITEA

        ;Volume (ff max)  
        ld d,REG_PB_VOL
        ld e,(ix+6)
        rst RST_YM_WRITEA   

        ;left/right uses ix+7 bits 6/7
        ld d,REG_PB_LRSEL
        ld a,(ix+7)
        and a,$c0 ;Only keep bits 6 and 7
        ld e,a        
		rst RST_YM_WRITEA

        ;if ix+7 has bit 4 set, it'll loop
		ld d,REG_PB_CTRL
        ld a,(ix+7)
        and a,$10 ;Only keep repeat bit
        or a,$80 ;Make sure start bit is set
        ld e,a
		rst RST_YM_WRITEA

    pop ix
    pop de
    pop hl
    pop bc
    pop af
    ret
