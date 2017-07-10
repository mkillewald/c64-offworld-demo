;============================================================
; clear screen and turn black
;============================================================

clear_screen     ldx #$00     ; start of loop
                 stx $d020    ; write to border color register
                 stx $d021    ; write to screen color register
clear_loop       lda #$20     ; #$20 is the spacebar screencode
                 ;sta $3400,x  ; fill four areas with 256 spacebar characters
                 sta $3500,x 
                 sta $3600,x 
                 sta $36e8,x 
                 lda #$01     ; puts color white into color ram
                 sta $d800,x  ; which becomes the foreground color of any text
                 sta $d900,x
                 sta $da00,x
                 sta $dae8,x
                 inx         
                 bne clear_loop   
                 rts