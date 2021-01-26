;-[]------------------------------------------------------------
; misc procedures and functions...
;---------------------------------------------------------------

;-------------------------------------------------------------------------------
;открытие файла
;вход:
;  HL = указатель на строку с именем файла
;выход:
;  A = хэндл, если ошибок нет
;Если ошибка открытия, тогда выход с обработкой ошибки.
open:		ld a,1
		ld (open_err.err_file+1),hl
		ld c,fopen
		rst 10h
		ret nc
		jr open_err

;-------------------------------------------------------------------------------
;закрытие файла
;вход:
;  А = хэндл
close:		ld c,fclose
		rst 10h
		ret

;-------------------------------------------------------------------------------
;чтение файла
;вход:
;  HL = адрес буффера для чтения
;  DE = кол-во читаемых байт
;   A = хэндл
;выход:
;  DE = кол-во прочитанных байт
;   A = код ошибки (0 = всё прочитано, 0FFh = прочитано не всё)
;флаг C = ошибка чтения = выход с обработкой
;перед чтением лучше сделать ld (rd_err.err_file+1),hl
;чтобы заполнить переменную имени файла для обработчика ошибки.
read:		ld c,fread
			rst 10h
			ret
;			ret nc
;			jr rd_err


dir_ret:	ld hl,cur_dir
			ld c,chdir
			rst 10h
			ret

;-------------------------------------------------------------------------------
;3Dh (61) GETMEM (Выделение блока памяти)
;Входные значения:
;B - размер блока в страницах по 16 килобайт
;Выходные значения:
;A - код ошибки, если CF=1
;A - идентификатор блока памяти, если CF=0
gmem:		ld c,getmem
	;		ld b,1
			rst 10h
			jr c,gmem_err
			ret

;3Eh (62) FREEMEM (Освобождение блока памяти)
;Входные значения:
;A - идентификатор блока памяти
;Выходные значения:
;A - код ошибки, если CF=1
fmem:		ld c,freemem
			rst 10h
			ret

;39h (57) SETWIN1 (Подключение страницы памяти в первое окно)
;Входные значения:
;A - идентификатор блока памяти
;B - номер страницы в блоке (0,1,2...)
;C - 39h
;Выходные значения:
;A - код ошибки, если CF=1
;A - номер замещенной страницы, если CF=0
mem_setwin1:
			ld c,setwin1
			rst 10h
			ret

;3Bh (59) SETWIN3 (Подключение страницы памяти в третье окно)
;Входные значения:
;A - идентификатор блока памяти
;B - номер страницы в блоке (0,1,2...)
;Выходные значения:
;A - код ошибки, если CF=1
;A - номер замещенной страницы, если CF=0
mem_setwin3:
			ld c,setwin3
			rst 10h
			ret

; процедура сохранения страницы в указнном окне.
; C = окно (порт)
; HL = куда сохранять.
save_pg:	in a,(c)
			ld (hl),a
			ret

; процедура восстановления страницы в указнном окне.
; C = окно (порт)
; HL = от куда восстановить.
restore_pg:	ld a,(hl)
			out (c),a
			ret


;===============================================================================
; обработчики ошибок
;===============================================================================

; обработка ошибки открытия файла
open_err:	ld hl,open_err_str
			ld c,pchars
			rst 10h
.err_file:	ld hl,0
			ld c,pchars
			rst 10h
			ld hl,crlf0
			ld c,pchars
			rst 10h
			ld a,-1
			jp quit0

open_err_str:	db "Can't open file ", 0
crlf0:		db " ", cr, lf, 0


; обработка ошибки чтения файла
rd_err:
			ld hl,read_err_str
			ld c,pchars
			rst 10h
.err_file:	ld hl,0
			ld c,pchars
			rst 10h
			ld hl,crlf0
			ld c,pchars
			rst 10h
			ld a,-1
			jp quit0

read_err_str:	db "Error: Failed to read file ",0
	


; обработка ошибки запроса памяти
gmem_err:	ld hl,gmem_err_str
			ld c,pchars
			rst 10h
			ld a,-1
			jp quit0
gmem_err_str:	db "PANIC: Can not allocate memory!",cr,lf,0


; обработка ошибки открытия видеорежима
vm_err:		ld hl,vm_err_str
			ld c,pchars
			rst 10h
			ld a,-1
            jp quit0
vm_err_str:	db "PANIC: Unable to set videomode!",cr,lf,0


; обработка ошибкок токенов
;tok_err:
;		ld hl,token_err_str
;		ld c,pchars
;		rst 10h
;.token_ptr:	ld hl,0
;		ld c,pchars
;		rst 10h
;		ld hl,crlf0
;		ld c,pchars
;		rst 10h
;		ld a,-1
;		jp quit0
;token_err_str:	db "PANIC: Unable to find token ",0

quit0:		ld b,a
			ld c,quit
			rst 10h
			jp $			; заглушка


		IFDEF debug
debug_print:		ld c,pchars
			rst 10h
			ret
		ENDIF


		IFDEF debug
dbg_rdspf_str:		db "Loading character...",0
dbg_rdspr_str:		db "Loading stage...",0
dbg_rdpal_str:		db "Loading palette...",0
dbg_ridx_str:		db "Reindexing spf data...",0
dbg_ok_str:		db "OK.",cr,lf,0
dbg_fail_str:		db "FAIL.",cr,lf,0
		ENDIF