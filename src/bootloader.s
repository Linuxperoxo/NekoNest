;
;
;
;    /--------------------------------------------O
;    |                                            |
;    |  COPYRIGHT : (c) 2024 per Linuxperoxo.     |
;    |  AUTHOR    : Linuxperoxo                   |
;    |  FILE      : bootloader.s                  |
;    |  SRC MOD   : 29/11/2024                    |
;    |                                            |
;    O--------------------------------------------/
;    
;
;

;
; Como funciona o bootloader?
;
; 1. Inicialização do computador:
;    Quando o computador é ligado, o primeiro código executado é o da BIOS. 
;    A BIOS realiza o processo de inicialização do hardware, realizando verificações e configurando os dispositivos necessários, 
;    como a memória, o teclado, o processador, e os discos.
;
; 2. Localização do MBR:
;    Após a inicialização, a BIOS começa a procurar por um Master Boot Record (MBR) nos discos. O MBR está localizado no primeiro 
;    setor de cada disco (sector 0), que tem 512 bytes. Esse setor contém o código inicial de boot, que é o bootloader, que será 
;    executado em seguida.
;
; 3. Validação do MBR:
;    Quando a BIOS encontra o setor 0, ela verifica os últimos 2 bytes (512º byte), chamados de assinatura do MBR. Esses dois 
;    bytes devem ser **0x55** (no byte 511) e **0xAA** (no byte 512), respectivamente. Essa assinatura é o que indica à BIOS 
;    que o setor contém um código de boot válido.
;
; 4. Carregamento do MBR:
;    Caso a assinatura esteja correta, a BIOS então carrega o conteúdo do MBR para o endereço **0x7C00** na memória. Este é o 
;    endereço padrão onde o bootloader será carregado, e a BIOS então passa o controle para esse endereço, ou seja, ela começa 
;    a execução do código do bootloader.
;
; 5. O que acontece depois?
;    A partir daí, o bootloader pode começar a executar, carregando o sistema operacional ou qualquer outro código necessário 
;    para iniciar o computador.
;
; Em resumo, o processo de boot é o seguinte:
; 1. A BIOS inicializa o hardware.
; 2. A BIOS busca o MBR no disco e valida a assinatura (0x55AA).
; 3. Se a assinatura for válida, a BIOS carrega o MBR para 0x7C00 e passa o controle para o bootloader.
;

bits 16
org 0x7C00

%define BASE_FRAMEBUFFER_ADDRS 0xB800
%define MAX_FRAMEBUFFER_OFFSET 80*25*2
%define DEFAULT_COLOR 0x0F ; Caractere branco com fundo preto

section .text
_start:
  mov ax, BASE_FRAMEBUFFER_ADDRS
  mov es, ax
  xor di, di ; Offset do framebuffer

  .loopcond:
    cmp di, MAX_FRAMEBUFFER_OFFSET
    jz .loopexit

  .loopexec:
    mov [es:di], byte 0x00
    mov [es:di + 1], byte DEFAULT_COLOR
    add di, 2
    jmp .loopcond

  .loopexit:
  
  xor di, di

  cli ; Ignorando interrupções externas

  mov [es:di], byte 'H'
  mov [es:di + 2], byte 'E'
  mov [es:di + 4], byte 'L'
  mov [es:di + 6], byte 'L'
  mov [es:di + 8], byte 'O'
  mov [es:di + 10], byte ','
  mov [es:di + 12], byte ' '
  mov [es:di + 14], byte 'W'
  mov [es:di + 16], byte 'O'
  mov [es:di + 18], byte 'R'
  mov [es:di + 20], byte 'L'
  mov [es:di + 22], byte 'D'
  mov [es:di + 24], byte '!'

  hlt ; Pausando o processador até uma interrupção

times 510 - ($ - $$) db 0 ; Garantindo que o binário tenha 512 bytes como explicado acima
dw 0xAA55 ; Assinatura de boot válido

