;===============================================================
; setting up some general symbols we use in our code
;================================================================

;============================================================
; symbols
;============================================================

screen_ram      = $3400     ; location of screen ram
init_sid        = $10B6     ; init routine for music
play_sid        = $10BC     ; play music routine
delay_counter   = $90       ; used to time color switch in the border
pra             = $dc00     ; CIA#1 (Port Register A)
prb             = $dc01     ; CIA#1 (Port Register B)
ddra            = $dc02     ; CIA#1 (Data Direction Register A)
ddrb            = $dc03     ; CIA#1 (Data Direction Register B)

smooth 			= $02		;zp address to store control for smooth scroll
screenloc 		= $3798		;This is the line for where the scroll is placed
