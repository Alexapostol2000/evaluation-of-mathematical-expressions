%include "io.inc"

extern getAST
extern freeAST

section .data
expression TIMES 1000000 DW 0
var DW 0 
section .bss
    ; La aceasta adresa, scheletul stocheaza radacina arborelui
    root: resd 1
    
section .text
crossing:
    push ebp
    mov ebp, esp
    mov eax, [ebp + 8]
    mov eax, [eax]
    ;pune valoarea in vector
    mov [expression+(edx*4)],eax
    inc edx
    mov esi, [ebp+8]
    mov edi, [esi +4]
;conditie de iesire
    cmp edi, 0
    jz end
    cmp esi, 0
    jz end

;stanga
    mov ecx, [ebp+8]
    mov ebx, [ecx+4]

    push ebx
    call crossing
    pop ebx

;dreapta
    mov ecx, [ebp+8]
    mov ebx, [ecx+8]

    push ebx
    call crossing
    pop ebx

end:
    leave
    ret

;scadere
minus:
    pop eax
    pop edx
    sub eax,edx
    push eax
    jmp cond

;adunare
plus:
    pop eax
    pop edx
    add eax,edx
    push eax
    jmp cond

;inmultire
inmultire:
    pop eax
    pop edx
    imul eax,edx
    xor edx,edx
    push ecx
    xor ecx,ecx
    mov ecx,10
    cdq
    idiv ecx
    pop ecx
    push eax
    jmp cond

;impartire
impartire:
    pop eax
    pop edx
    push ecx
    xor ecx,ecx
    mov ecx,edx
    xor edx,edx
    cdq
    idiv ecx
    xor ecx,ecx
    pop ecx
    imul eax,10
    push eax
    jmp cond

;calculeaza 
calculate:
    mov ecx,edx
    mov ebx,edx
    dec ebx

;intereaza prin string
L1:
    xor edi,edi
    add edi , dword [expression+(ebx*4)] 
    mov edx,[expression+(ebx*4)]
    xor eax,eax
    dec ebx
    dec ecx
    mov edi,[edi]
;verifica daca e minus
cmp edi , 45
    jz minus
;verifica daca e plus
cmp edi , 43
    jz plus
;verifica daca e *
cmp edi , 42
    jz inmultire
;verifica daca e /
cmp edi , 47
    jz impartire

;e numar face atoi ()
Push ebx
Push ecx
xor ecx,ecx
xor ebx,ebx
xor eax,eax
mov ebx,1
jmp create

;conditie de iesire se apeleaza in semne
cond:
cmp ecx,0
jz out
jnz L1

;creeaza un byte din char in int
create:
    mov cl,byte [edx]
    ;verifica daca e negativ
    cmp cl,'-'
    jz negativ
    sub cl,48
    mov byte [var] , cl



add eax , dword [var]
inc edx
jmp convert

;daca are - in fata
negativ:
    mov ebx,-1
    inc edx
    jmp create

;adauga in numarul int
convert:
    imul eax,10
    mov cl,byte [edx]
cmp cl,0
jz final

jmp create

;sfarsitul elementului din string
final:
    imul eax,ebx
    pop ecx
    pop ebx
    push eax
jmp L1

;sfarsitul stringului
out: 
    pop eax
    xor edx,edx
    mov ecx,10
    cdq
    idiv ecx
;afisare rezultat final
PRINT_DEC 4,EAX
leave
ret

global main
main:
    mov ebp, esp; for correct debugging
    ; NU MODIFICATI
    push ebp
    mov ebp, esp

    ; Se citeste arborele si se scrie la adresa indicata mai sus
    call getAST

    ; Implementati rezolvarea aici:

      mov [root], eax
      mov ebx ,[root]
      push ebx
      xor edx,edx
      ;parcurgere arborelui si creerea stringului
      call crossing
      
      ;atoi pe fiecare element din string si efectuarea calculelor
      call calculate
     

    ; NU MODIFICATI
    ; Se elibereaza memoria alocata pentru arbore
    push dword [root]
    call freeAST
    
    xor eax, eax
    leave
    ret