; b: source lookup (smp start LSB; smp start MSB; smp end LSB; smp start MSB; deltaN LSB; deltaN MSB)
ADPCMB_PlaySample:

    ;Don't know if we need to push all of these but to be safe..
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

        ;Left right
        ld  de,$11c0
		rst RST_YM_WRITEA

        ;Volume max
        ld  de,$1bff
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

        ;DeltaN uses half of another slot, so always remember to use two slots every PCMB
        ld d,REG_PB_FREQL
        ld e,(ix+4)
        rst RST_YM_WRITEA

        ;High byte of delta n
        ld d,REG_PB_FREQH
        ld e,(ix+5)
        rst RST_YM_WRITEA

        ;Kick off looped playback (assuming we're using PCMB for music of course)
		ld de,$1090
		rst RST_YM_WRITEA

    pop ix
    pop de
    pop hl
    pop bc
    pop af
    ret
