;============================================================
; sets character pointer to our new custom set, turn off 
; multicolor for characters, then output three lines of text
;============================================================

write_text ;lda $d018
           ;ora #$0e       ; set chars location to $3800 for displaying the custom font
           ;sta $d018      ; Bits 1-3 ($400+512bytes * low nibble value) of $d018 sets char location
           ;               ; $400 + $200*$0E = $3800
           lda $d016      ; turn off multicolor for characters
           and #$ef       ; by cleaing Bit#4 of $D016
           sta $d016

           lda $d018
           ora #$de     ; screen at $3400 - xx11 0100 0000 0000 ($D_)
           sta $d018    ; chars  at $3800 - xx11 1000 0000 0000 ($_E)
           lda #$1b
           sta $d011    ; Clear high bit of $d012, set text mode

           ldx #$00
loop_text  ;lda line1,x      ; read characters from line1 table of text...
           ;sta $3428,x      ; ...and store in screen ram near the center
           ;lda line2,x      ; read characters from line1 table of text...
           ;sta $3478,x      ; ...and put 2 rows below line1
           lda line3,x      ; read characters from line1 table of text...
           sta $3720,x      ; ...and put 2 rows below line1
           inx 
           cpx #$28         ; finished when all 40 cols of a line are processed
           bne loop_text
           rts

