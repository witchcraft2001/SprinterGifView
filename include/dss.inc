;-------------------------
;dss functions defines
;file functions
fopen		equ 0x11			;открыть файл
fclose		equ 12h				;закрыть файл
fread		equ 13h
fwrite		equ 14h
move_fp		equ 15h
fgetattr	equ 16h
fgetdt		equ 17h
fsetdt		equ 18h
fcreate		equ 0ah
fcreaten	equ 0bh
chdir		equ 1dh
curdir		equ 1eh
curdisk		equ 2

_IORW		equ 0
_IOREAD		equ 1
_IOWRITE	equ 2

_SEEK_SET = 0				;от начала файла
_SEEK_CUR = 1				;от текущего значения указателя
_SEEK_END = 2				;от конца файла

;command line
DSS_ParseCmdLine = 0x45

;------------------------------------------------------------------------
;B - номер подфункции:
;0 - Разобрать строку;
;1 - Выделить имя диска;
;2 - Выделить директорию;
;3 - Выделить имя файла;
;4 - Выделить расширение файла;
;5 - Выделить имя диска, путь к файлу, имя файла и расширение файла;
;6 - Зарезервирована;
;7 - Выделить параметр командной строки;
;8 - Преобразовать из 11 символьного формата в формат ДОС;
;9 - Преобразовать из формата ДОС в 11 символьный формат;
;------------------------------------------------------------------------
_PRSCMDLN = 0
_GET_DSK = 1
_GET_DIR = 2
_GET_FILENAME = 3
_GET_FILE_EXT = 4
_GET_FULL_FILEPATH = 5
_NOFUNC = 6
_SELECT_ARG = 7
_CONV_TO_DOS = 8
_CONF_FROM_DOS = 9


;memory functions
setwin		equ 38h
setwin1     equ 39h
setwin2		equ 3ah
setwin3		equ 3bh
infomem		equ 3ch
getmem		equ 3dh
setmem		equ 3fh
freemem		equ 3eh
;keyb functions
waitkey		equ 30h
scankey		equ 31h
echokey		equ 32h
quit        equ 41h
getarg		equ 43h
;vmode functions
setvmode	equ 50h
getvmode	equ 51h
selvpage	equ 54h
;screen and text functions
clear_screen	equ 0x56			;отчистить экран
pchar		equ 5bh				;напечатать символ в "A"
pchars		equ 0x5c			;напечатать строку из "HL"
;other
getver		equ 0
systime		equ 21h
;environment
get_evn = 0x46					;получение переменных окружения
_GET_SYS = 0					;получить системное окружение
_GET_VAL = 1					;получить параметры указанной переменной
_SET_ENV = 2					;установить переменную
get_appinfo = 0x47				;получить информацию о процессе
;end dss defines
;-------------------------
;hardware defines
port_y = 0x89					;port for Y coord
_320p = 0x81					;320 pixels mode
rgmod = 0xc9
border = 0xfe
rgscr = 0xe9
rgacc = 0xa9

norm_scr = 0x50
;trans_scr	equ 54h
trans_scr = 00001000b
tmp_scr = 00000100b


e_cache		equ 0fbh
d_cache		equ 7bh
sys_port3c	equ 3ch
sys_port7c	equ 7ch

cpu_w0		equ 82h		;cpu window 0 = addr 0000h
cpu_w1		equ 0a2h	;... 1 = 4000h
cpu_w2		equ 0c2h	;... 2 = 8000h
cpu_w3		equ 0e2h	;... 3 = 0c000h

mmu0 = 0x82			;cpu window 0 = addr 0000h
mmu1 = 0xa2			;... 1 = 4000h
mmu2 = 0xc2			;... 2 = 8000h
mmu3 = 0xe2			;... 3 = 0c000h

sys_page = 0xfe
mode_page = 0xfc
cnf_page = 0x40

;com port
CTC_CHAN0 = 0x10
SIO_DATA_REG_A = 0x18
SIO_CONTROL_A = 0x19
SIO_DATA_REG_B = 0x1a
SIO_CONTROL_B = 0x1b

;lpt port
PIO_DATA_REG_A = 0x1c
PIO_COMMAND_REG_A = 0x1d
PIO_DATA_REG_B = 0x1e
PIO_COMMAND_REG_B = 0x1f

;ISA-8
sc_port = 0x1ffd
isa_dir = 0x9fbd
isa_base_addr = 0xc000


;end hardware defines
;-------------------------
;characters
cr		equ 0dh		;возврат коретки
lf		equ 0ah		;новая строка
tab		equ 9		;символ табуляции
space		equ 20h		;символ пробела
;------------------------
sys_port_on = 0x7c
sys_port_off = 0x3c
d_tbon = 3			; данные для включения turbo
d_tboff = 2			; данные для включения turbo
d_rom16on = 1
d_rom16off = 0
;----------------------
;bios
bios_reset_drive = 0x51		; Сброс контроллера и настройка на диск
bios_rd_sector = 0x55		; Чтение (секторов) с устройства.
bios_wr_sector = 0x56		; Запись (секторов) на устройство.
bios_get_drv_list = 0x5f	; получить список дисковых устройств
bios_get_cursor_coords = 0x8e	; Получить текущее положение (курсора) вывода на экран.
bios_get_mem_pg = 0xc4		; получить физ. номер стр. блока
bios_get_pg_tbl = 0xc5		; get pages table from handle (id_blk)
bios_clear_scr = 0x8d		; очистка экрана, указанием символа заполнения
bios_get_cursor = 0x8e		; узнать полож. курсора
bios_set_cursor = 0x84		; уст. полож. курсора
bios_print_chars = 0x82		; вывод символов на экран с текущего знакоместа без атрибутов
bios_screen_save = 0xb2		; сохранить экран...
bios_screen_restore = 0xb3	; восстановить экран...
bios_screen_get_char = 0xb4	; прочитать (взять) символ с экрана
bios_screen_set_char = 0xb5	; установить символ на экране
bios_screen_move = 0xb7		; перемещение окна (экрана)


