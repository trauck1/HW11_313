section .data
    inputBuf db 0x83,0x6A,0x88,0xDE,0x9A,0xC3,0x54,0x9A
    inputLen equ $ - inputBuf

    space db ' '
    newline db 0x0A  

section .bss
    outputBuf resb 80 ; Space for the output

section .text
    global _start

_start:
    mov esi, inputBuf       ; esi points to the start of inputBuf
    mov edi, outputBuf      ; edi points to the start of outputBuf
    mov ecx, inputLen       ; ecx holds the counter

convert:
    mov al, [esi]           
    mov ah, al              ; Copy al to ah
    shr ah, 4               ; Shift upper nibble to lower 4 bits

    cmp ah, 9               ; Compare with 9
    jbe isDigitUpper      ; If less than or equal to 9, it's a digit
    add ah, 'A' - 10        ; If greater than 9, add offset for 'A'-'F'
    jmp upperStore

isDigitUpper:
    add ah, '0'             ; If digit, add offset for '0'

upperStore:
    mov [edi], ah           ; Store the upper hex character in outputBuf
    inc edi                 ; Move outputBuf pointer

    mov ah, al              ; Copy original al to ah
    and ah, 0x0F            ; Mask out the upper nibble

    cmp ah, 9               ; Compare with 9
    jbe isDigitLower      ; If less than or equal to 9, it's a digit
    add ah, 'A' - 10        ; If greater than 9, add offset for 'A'-'F'
    jmp lowerStore

isDigitLower:
    add ah, '0'             ; If digit, add offset for '0'

lowerStore:
    mov [edi], ah           ; Store the lower hex character in outputBuf
    inc edi                 ; Move outputBuf pointer

    mov al, [space]
    mov [edi], al
    inc edi

    inc esi                 ; Move inputBuf pointer
    loop convert       

    mov al, [newline]
    mov [edi], al
    inc edi

    mov edx, edi            ; Copy current outputBuf pointer to edx
    sub edx, outputBuf      ; Subtract the start address to get the length

    mov eax, 4              ; sys_write system call number
    mov ebx, 1              ; File descriptor 1 (stdout)
    mov ecx, outputBuf      ; Pointer to the string to write
    int 0x80                ; Call the kernel

    ; Exit the program
    mov eax, 1              ; sys_exit system call number
    xor ebx, ebx            ; Exit code 0
    int 0x80                ; Call the kernel