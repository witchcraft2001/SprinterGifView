            device zxspectrum128
            include "include\dss.inc"
            include "include\head.inc"

begin:		jp main

            include "include\misc.asm"

main:	    di
            ld (DOSLine+1),ix
            ld hl,cur_dir
            ld c,curdir
            rst 10h
            call InitFile
            ld hl,GifFile
            call GifShow

;выход по Any key
            ei
.loop:	    halt
            ld c,scankey
            rst 10h
            jr z,.loop
            jp quit0

;[]==========================================================[]
GifShow:    ret

InitFile:
DOSLine:	ld hl,0
            ld a,20h
            inc hl
            cp (hl)
            jr c,$-2
            ld a,(hl)
            inc hl
            cp 20h
            jp nz,NoGifName
            ld (rd_err.err_file+1),hl
            call open
            ld (GifHandle),a
            push af
            ld hl,0
            ld ix,0
            ld b,2
            ld c,move_fp
            rst 10h
            pop af
            ex af,af'
            xor a
            or h
            jp nz,FileTooBig
            ld a,l
            cp 2
            jp nc,FileTooBig
            ex af,af'
            push hl
            push ix
            push hl
            push ix
            ld ix,0
            ld hl,0
            ld b,0
            ld c,move_fp
            rst 10h
            pop ix
            pop hl
            call CalcNeedRam
            ld b,a
            ld c,getmem
            rst 10h
            pop de
            pop hl
            jp c,NotEnoughtMemory
            ld (MemoryDescriptor),a

;чтение файла
            ld hl,GifFile
            ld a,(GifHandle)
            push af
            call read
            pop af
            call close
;Проверка формата            
            ld hl,GifFile
            ld de,Gif87a
            ld b,6
            call CheckBytes
            jr nc,.checkResolution
            ld de,Gif89a
            call CheckBytes
            jp c,WrongFile
.checkResolution
;Logical Screen Width
            ld hl,(GifWidth)
            ld bc,320
            sbc hl,bc
            jp nc,ImageSizeTooLarge
            ld hl,(GifHeight)
            ld bc,256
            sbc hl,bc
            jp nc,ImageSizeTooLarge
;Проверка количества цветов
            ld a,(GifColorPaleteInfo)
            ld hl,GifGlobalPallete
            and %10000111
            and a
            jr z,.setImageBegin
            ex hl,de
            res 7,a
            ld hl,6
.loop:      or a
            jr z,.endLoop
            add hl,hl
            dec a
            jr .loop
.endLoop:   add hl,de
.setImageBegin:
            ld (GifImageBegin),hl
.ok         and a
            ret

PrintError:	ld c,pchars			;печатаем
            rst 10h
            ld bc,0FF41h
            rst 10h
            jp $				; привычка...

CheckBytes: push hl
            push de
            push bc
.loop:      ld a,(de)
            cp (hl)
            jr nz,Negative
            inc hl
            inc de
            djnz .loop
            pop bc
            pop de
            pop hl
            and a
            ret
Negative:
            pop bc
            pop de
            pop hl
            scf
            ret

;Подсчет количества страниц, необходимых для загрузки изображения
;вход:
;  HL:IX = размер файла в байтах
;выход:
;   A = количество блоков по 16Кб, если файл меньше 16Кб, то = 0
CalcNeedRam:
            push hl
            push ix
            pop hl
            pop de
            ld bc,#4000
            xor a
.loop:      and a
            sbc hl,bc
            jr nc,.next
            ex af,af'
            ld a,d
            or e
            jr nz,.next1
            ex af,af'
            inc a
            ret
.next1:     ex af,af'
            dec de
.next:      inc a
            jr .loop

FileTooBig: ld hl,FileTooBigMessage
            jp PrintError

NoGifName:	ld hl,Usage
    		jp PrintError

WrongFile:	ld hl,WrongFileMessage
    		jp PrintError

ImageSizeTooLarge:	
            ld hl,ImageSizeTooLargeMessage
    		jp PrintError

NotEnoughtMemory:	
            ld hl,NotEnoughtMemoryMessage
    		jp PrintError

FileTooBigMessage:
            db cr,lf,"Error: File too big!"
            db cr,lf,"This version hasn't supported yet files larger than 128kb",cr,lf
		    db cr,lf,0

WrongFileMessage:
            db cr,lf,"Error: This file is not GIF!",cr,lf
		    db cr,lf,0

ImageSizeTooLargeMessage:
            db cr,lf,"Error: Gif size is too large! Maximum 320x256 size is supported",cr,lf
		    db cr,lf,0

NotEnoughtMemoryMessage:
            db cr,lf,"Error: Not enought memory!",cr,lf
		    db cr,lf,0

Usage:		db cr,lf,"Usage:   gifview.exe <filename>",cr,lf
		    db cr,lf,0

cur_dir_size:	equ 255

GifHandle:  db 0
Gif87a:     db "GIF87a"
Gif89a:     db "GIF89a"

MemoryDescriptor:
            db 0
ColorDensity:
            db 0
GifImageBegin:
            dw 0

cur_dir:	equ ($/80h)*80h+80h

code_end:
            org 0xC000
GifFile:	equ $
GifLogScrDescriptor:    equ GifFile + 6
GifWidth:   equ GifLogScrDescriptor
GifHeight:  equ GifLogScrDescriptor + 2
GifColorPaleteInfo:      equ GifHeight + 2
GifBG:      equ GifColorPaleteInfo + 1
GifR:       equ GifBG + 1
GifGlobalPallete: equ GifR + 1

            savebin "gifview.exe",start_addr,code_end-start_addr