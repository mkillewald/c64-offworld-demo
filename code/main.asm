;===================================
; main.asm triggers all subroutines 
; and runs the Interrupt Routine
;===================================

main      sei               ; set interrupt disable flag

          jsr clear_screen  ; clear the screen

          lda #$00
          tax
          tay
          jsr init_sid      ; init music routine
          ldx #$00 
          jsr color_cycle
          jsr write_text    ; write text to screen

          ; initialize sub_scroll
          lda #<message
          ldy #>message
          sta read+1             ; store message address low byte at read label+1
          sty read+2             ; store message address high byte at read label+2  

          ldy #$7f    ; $7f = %01111111
          sty $dc0d   ; Turn off CIAs Timer interrupts ($7f = %01111111)
          sty $dd0d   ; Turn off CIAs Timer interrupts ($7f = %01111111)
          lda $dc0d   ; by reading $dc0d and $dd0d we cancel all CIA-IRQs in queue/unprocessed
          lda $dd0d   ; by reading $dc0d and $dd0d we cancel all CIA-IRQs in queue/unprocessed
          asl $d019   ; ACK VIC interrupts
           
          lda #$01    ; Set Interrupt Request Mask...
          sta $d01a   ; ...we want IRQ by Rasterbeam (%00000001)

          lda #<isr   ; point IRQ Vector to our custom irq routine
          ldx #>isr 
          sta $0314    ; store in $314/$315
          stx $0315   

          lda #$00    ; trigger interrupt at row zero
          sta $d012

          cli         ; clear interrupt disable flag
          jmp *       ; infinite loop


;======================================
; Our custom interrupt service routines 
;======================================

; triggered on line 0
isr       dec $d019         ; acknowledge IRQ / clear register for next interrupt
          ;inc $d020     ; cycle border color
          jsr update_sprite ; move sprite
          jsr play_sid

          lda #$08  ;No scroll section here
          sta $d016    ; x scroll register
          jsr scroll

          lda #<isr2    ; point IRQ Vector to our custom irq routine
          ldx #>isr2 
          sta $0314     ; store in $314/$315
          stx $0315

          lda #$E0      ; trigger next interrupt at line 224
          sta $d012

          pla
          tay
          pla
          tax
          pla
          rti           ; return from interrupt

; triggered on line 224
; update hardware scroll register
isr2      dec $d019     ; acknowledge interrupt

          lda smooth    ; get value(0-7) for smooth scroll
          ora #$08      ; set bit3 for 40 column mode
          sta $d016     ; store into register

          lda #<isr3   ; point IRQ Vector to our custom irq routine
          ldx #>isr3 
          sta $0314    ; store in $314/$315
          stx $0315   

          lda #$F9    ; trigger next interrupt at line 249
          sta $d012

          pla
          tay
          pla
          tax
          pla
          rti          ; return from interrupt

; triggered on line 249
; open bottom border
isr3
          dec $d019

          lda #$00       ; clear potential garbage in $3fff
          sta $3fff

          lda $d011      ; Trick the VIC and open the border
          and #$f7
          sta $d011

          lda #<isr4   ; point IRQ Vector to our custom irq routine
          ldx #>isr4 
          sta $0314    ; store in $314/$315
          stx $0315   

          lda #$FF    ; trigger next interrupt at line 255
          sta $d012

          pla
          tay
          pla
          tax
          pla
          rti  

; triggered on line 255
; open top border
isr4
          dec $d019

          lda $d011      ; Reset bit 3 for the next frame
          ora #$08
          sta $d011

          lda #<isr   ; point IRQ Vector to our custom irq routine
          ldx #>isr 
          sta $0314    ; store in $314/$315
          stx $0315   

          lda #$00    ; trigger next interrupt at row zero
          sta $d012

          pla
          tay
          pla
          tax
          pla
          rti          ; return from interrupt
