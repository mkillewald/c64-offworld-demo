;============================================================
; Updates horizontal position and Sprite Shape number within 
; animation of Sprite#0 - Sprite moves from right to left
;============================================================
 
update_sprite
spr0x      inc $d000       ; increase X-Coord until zero
           beq spr0x_high  ; switch 9th Bit of X-Coord
           lda $d010
           and #$01
           beq spr0y
           lda $d000
           cmp #$57
           bne spr0y
           lda #$00
           sta $d000
           inc $d027        ; increment sprite0 color
           bne spr0x_high
           inc $d027       ; skip black
spr0x_high lda $d010       ; load 9th Bit
           eor #$01        ; eor against #$01
           sta $d010       ; store into 9th bit

spr0y      lda spr0y_dir    ; in which direction are we moving?
           beq spr0y_down   ; if 0, down

          ; moving up
           ldx spr0y_pos   ; get coord
           dex             ; decrement it
           stx spr0y_pos   ; store it
           stx $d001
           cpx #$67        ; if it's not equal...
           bne spr0_exit

           lda #$00     ; otherwise, change direction
           sta spr0y_dir
           jmp spr0_exit

spr0y_down ldx spr0y_pos    ; this should be familiar
           inx
           stx spr0y_pos
           stx $d001
           cpx #$e0      ; y bottom 
           bne spr0_exit

           lda #$01
           sta spr0y_dir
spr0_exit  rts

spr0y_pos
           !byte $67   ; current x and y coordinate
spr0y_dir
           !byte 0     ; direction: 0 = down-right, 1 = up-left