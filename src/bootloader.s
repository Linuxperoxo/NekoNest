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
;    Quando o computador é ligado, o primeiro cóDIgo executado é o da BIOS. 
;    A BIOS realiza o procESso de inicialização do hardware, realizando verificações e configurando os DIspositivos necessários, 
;    como a memória, o teclado, o procESsador, e os DIscos.
;
; 2. Localização do MBR:
;    Após a inicialização, a BIOS começa a procurar por um Master Boot Record (MBR) nos DIscos. O MBR EStá localizado no primeiro 
;    setor de cada DIsco (sector 0), que tem 512 bytES. Esse setor contém o código inicial de boot, que é o bootloader, que será 
;    executado em seguida.
;
; 3. Validação do MBR:
;    Quando a BIOS encontra o setor 0, ela verifica os últimos 2 bytES (512º byte), chamados de assinatura do MBR. Esses dois 
;    bytES devem ser **0x55** (no byte 511) e **0xAA** (no byte 512), respectivamente. Essa assinatura é o que inDIca à BIOS 
;    que o setor contém um cóDIgo de boot válido.
;
; 4. Carregamento do MBR:
;    Caso a assinatura ESteja correta, a BIOS então carrega o conteúdo do MBR para o endereço **0x7C00** na memória. Este é o 
;    endereço padrão onde o bootloader será carregado, e a BIOS então passa o controle para ESse endereço, ou seja, ela começa 
;    a execução do cóDIgo do bootloader.
;
; 5. O que acontece depois?
;    A partir daí, o bootloader pode começar a executar, carregando o sistema operacional ou qualquer outro cóDIgo necESsário 
;    para iniciar o computador.
;
; Em rESumo, o processo de boot é o seguinte:
; 1. A BIOS inicializa o hardware.
; 2. A BIOS busca o MBR no DIsco e valida a assinatura (0x55AA).
; 3. Se a assinatura for válida, a BIOS carrega o MBR para 0x7C00 e passa o controle para o bootloader.
;

BITS 16
ORG 0x7C00

%define BASE_FRAMEBUFFER_ADDRS 0xB800
%define MAX_FRAMEBUFFER_OFFSET 80*25*2
%define DEFAULT_COLOR 0x0F ; Caractere branco com fundo preto

SECTION .text
  MOV AX, BASE_FRAMEBUFFER_ADDRS
  MOV ES, AX
  XOR DI, DI ; Offset do framebuffer

  .loopcond:
    CMP DI, MAX_FRAMEBUFFER_OFFSET
    JZ .loopexit

  .loopexec:
    MOV [ES:DI], byte 0x00
    MOV [ES:DI + 1], byte DEFAULT_COLOR
    ADD DI, 2
    JMP .loopcond

  .loopexit:
  
  XOR DI, DI

  CLI ; Ignorando interrupçõES externas

  MOV [ES:DI], byte 'H'
  MOV [ES:DI + 2], byte 'E'
  MOV [ES:DI + 4], byte 'L'
  MOV [ES:DI + 6], byte 'L'
  MOV [ES:DI + 8], byte 'O'
  MOV [ES:DI + 10], byte ','
  MOV [ES:DI + 12], byte ' '
  MOV [ES:DI + 14], byte 'W'
  MOV [ES:DI + 16], byte 'O'
  MOV [ES:DI + 18], byte 'R'
  MOV [ES:DI + 20], byte 'L'
  MOV [ES:DI + 22], byte 'D'
  MOV [ES:DI + 24], byte '!'

  HLT ; Pausando o procESsador até uma interrupção

times 510 - ($ - $$) db 0 ; Garantindo que o binário tenha 512 bytes como explicado acima
DW 0xAA55 ; Assinatura de boot válido

