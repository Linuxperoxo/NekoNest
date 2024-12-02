;
;
;
;    /--------------------------------------------O
;    |                                            |
;    |  COPYRIGHT : (c) 2024 per Linuxperoxo.     |
;    |  AUTHOR    : Linuxperoxo                   |
;    |  FILE      : loader.s                      |
;    |  SRC MOD   : 02/12/2024                    |
;    |                                            |
;    O--------------------------------------------/
;    
;
;

BITS 16

SECTION .text
  CLI

  MOV AX, 0xB800
  MOV ES, AX

  ;
  ; Escrita de teste para ver se está funcionando
  ;

  MOV [ES:0x00], byte 'H'
  MOV [ES:0x02], byte 'E'
  MOV [ES:0x04], byte 'L'
  MOV [ES:0x06], byte 'L'
  MOV [ES:0x08], byte 'O'
  MOV [ES:0x0A], byte ','
  MOV [ES:0x0C], byte ' '
  MOV [ES:0x0E], byte 'W'
  MOV [ES:0x10], byte 'O'
  MOV [ES:0x12], byte 'R'
  MOV [ES:0x14], byte 'L'
  MOV [ES:0x16], byte 'D'
  MOV [ES:0x18], byte '!'

  ;
  ; Loop infinito
  ;

  JMP $

TIMES 512 - ($ - $$) DB 0x00
