; this isnt actually cycling colors yet

color_cycle
                 lda #$06     ; puts color into color ram
                 sta $d800,x  ; which becomes the foreground color of any text
                 lda #$0e
                 sta $d828,x
                 lda #$03
                 sta $d850,x
                 lda #$03
                 sta $d878,x
                 lda #$0e
                 sta $d8a0,x
                 lda #$06
                 sta $d8c8,x
                 inx
             	 cpx #$28
             	 bne color_cycle         
                 rts

color_table