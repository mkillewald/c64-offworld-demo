scroll           lda smooth
                 sec
                 sbc #$02 ;Speed of scroll can be edited to how you want it, but don't go too mad :)
                 and #$07 ;We need this to make the variable smooth into something smooth :)
                 sta smooth
                 bcs endscroll 
                 ldx #$00
wrapmessage      lda screenloc+1,x
                 sta screenloc,x
                 inx
                 cpx #$28   ; 40 characters wide
                 bne wrapmessage
read             lda screenloc+$27      ; i belieive screenloc+27 is just a two byte placeholder, could have used any two bytes hee
                                        ; because the two bytes are overwritten first by main.asm, then later on by this routine 
                 cmp #$00               ; Is byte 0 (@) read (end of message)?
                 bne nowrap             ; If not, goto label nowrap

                 ; end of message has been reached, go back to start of message
                 lda #<message          ; init read pointers back to start of message
                 ldy #>message
                 sta read+1
                 sty read+2
                 jmp read

nowrap           sta screenloc+$27      ; place character read from message at far right screen position
                 inc read+1             ; increment character pointer
                 lda read+1             ; get next character       
                 cmp #$00               ; has end of message character (@) been reached?
                 bne endscroll
                 inc read+2
endscroll        rts

message          !scr "greetings!!  a new life awaits you in the offworld colonies!!! "
                 !scr "k1ds3ns4t10n and the kommodore krew present the offworld demo. "
                 !scr "the year is 2017 and it only took me 43 years to get around to "
                 !scr "figuring out how to make one of these. ha!ha! better late than never, right? "
                 !scr "try not to laugh too hard. i know my effects are shit, and my charset sucks. "
                 !scr "the music you hear was created by ole marius petterson of prosonix. i "
                 !scr "ripped it from panoramic designs' judge dredd demo released in 1989. "
                 !scr "                                          "
                 !byte 0