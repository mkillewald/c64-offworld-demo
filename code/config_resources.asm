; load external binaries

address_sprites = $2000	  ; loading address for sprite
address_chars = $3800     ; loading address for charset ($3800: last possible location for the 512bytes in Bank 3)
address_sid = $10A6       ; loading address for sid tune
address_map = $3400       ; loading address for offworld logo character map

* = address_sprites                  
!bin "resources/offworld-sprites.raw"

* = address_sid                                           
;!bin "resources/empty_1000.sid",,$7c+2
!bin "resources/Judge_Dredd_1000.sid",, $7c+2  ; remove header from sid and cut off original loading address 

* = address_chars  
!bin "resources/offworld-chars3.raw"                   

* = address_map
!bin "resources/offworld-map.raw"

