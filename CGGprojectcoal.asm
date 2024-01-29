                 print macro p1
    lea dx,p1
    mov ah,9
   int 21h
endm  

popregisters macro
    pop dx       
    pop cx
    pop bx
    pop ax
endm  
pushregisters macro
    push ax       
    push bx
    push cx
    push dx
endm

data segment  ;alternative to .data
    ;stores variables and arrays
;declaring strings for use in program
answer db ?,?,?,? 
YourAnswer db ?,?,?,?
bool db 0 
pos db 0 
    
isagain dw 10,13,10,13,9,"       Do you want to play again(y-yes,n-no)?$"
pkey db "To finish press any key...$"   
Title1 dw 10,13,9,"                  cccc    gggg     gggg      "
Title2 dw 10,13,9,"                 c       g       g           "
Title4 dw 10,13,9,"                 c       g   gg  g   gg      "
Title5 dw 10,13,9,"                 c       g    g  g    g      "
Title6 dw 10,13,9,"                  cccc    gggg    gggg      $"
    
guidance1 dw 10,13,10,13,"            Hello, welcome to our colour guessing game!"  
guidance2 dw 10,13,9,"      In this game you will have to guess the secret code." 
guidance3 dw 10,13,10,13,"1. The code consists of 4 different colors."
guidance4 dw 10,13,"2. You can input colors by using the digits between 0 to 5."
guidance5 dw 10,13,"3. You have 9 tries before you lose."
;1 displays the empty smiley face ascii code                                                           
guidance6 dw 10,13,"4. ",1,"-This means one of your colors exists in the pattern but the location is          wrong. " 
;2 displays the full smiley face ascii code 
guidance7 dw 10,13,"   ",2,"-This means one of your colors exists in the pattern with right location."
guidance8 dw 10,13,"5. The secret code can be chosen by computer or by player2 (It's your choice)." 
guidance9 dw "  6. If player 1 fails, then player2 wins by default.$" 
    
start1 dw 10,13,10,13,"Do you want the code to be chosen by player2 (y\n) ? $"
start2 dw 10,13,10,13,"Player2, please input the secret pattern: $"  
start3 dw 10,13,10,13,"When you're ready to start, press any key.$"
    
mone dw 10,13,10,13,'0',". Input your guess: $"
writeanswer dw "     Your score is: $" 
string dw 10,13,"                          Color list: $" 
isMulty db 0  
linedown dw 10,13,10,13,10,13,10,13,"$"
      
won1 dw 10,13,10,13,10,13,9,9,9," W   W  III  N   N  N   N  EEE  RRR    "
won2 dw 10,13,9,9,9,            " W   W   I   NN  N  NN  N  E    R  R   "
won3 dw 10,13,9,9,9,            " W   W   I   N N N  N N N  EEE  RRR    "
won4 dw 10,13,9,9,9,            " W W W   I   N  NN  N  NN  E    R R    "
won5 dw 10,13,9,9,9,            "  W W   III  N   N  N   N  EEE  R  R   $"  
    
won6 dw 10,13,9," PPP   L     AA   Y   Y  EEE  RRR     1      III  SS   TTTTT H  H EEE"
won7 dw 10,13,9," P  P  L    A  A   Y Y   E    R  R   11       I  S       T   H  H E  "
won8 dw 10,13,9," PPP   L    AAAA    Y    EEE  RRR     1       I   S      T   HHHH EEE"
won9 dw 10,13,9," P     L    A  A    Y    E    R R     1       I    S     T   H  H E  "
won0 dw 10,13,9," P     LLL  A  A    Y    EEE  R  R   111     III SS      T   H  H EEE$"
    
Lose1 dw 10,13,9,9,9,"   L   OO   SS EEE RRR   "
Lose2 dw 10,13,9,9,9,"   L  O  O S   E   R  R  "
Lose3 dw 10,13,9,9,9,"   L  O  O  S  EEE RRR   "
Lose4 dw 10,13,9,9,9,"   L  O  O   S E   R R   "
Lose5 dw 10,13,9,9,9,"   LLL OO  SS  EEE R  R  $"
Lose6 dw 10,13,9," PPP   L     AA   Y   Y  EEE  RRR    222   III   SS   TTTTT  H  H  EEE"
Lose7 dw 10,13,9," P  P  L    A  A   Y Y   E    R  R  2  2    I   S       T    H  H  E  "
Lose8 dw 10,13,9," PPP   L    AAAA    Y    EEE  RRR     2     I    S      T    HHHH  EEE"
Lose9 dw 10,13,9," P     L    A  A    Y    E    R R    2      I     S     T    H  H  E  "
Lose0 dw 10,13,9," P     LLL  A  A    Y    EEE  R  R  2222   III  SS      T    H  H  EEE$"  
ends

stack segment        
    dw   128  dup(0)
ends

code segment
start:
; set segment registers:
    mov ax, data  ;calling data from data segment
    mov ds, ax     ;ds = data segment
    mov es, ax     ;es = extra segment

    
    startofgame:   
   ; mov mone+8,'0'
   ; mov ismulty,0
    call clearscreen         ;wipe the screen clean to print the game     
    
    mov bl,1010b             ; change the color to lightgreen by calling the changecolour procedure that changes the color by bl                          
    call changecolor         
    
                            
      print Title1
              ;print the title  
    
    mov bl,1011b             ;change the color to light cyan by calling the changecolor procedure that changes the color by bl                 
    call changecolor         
                                            ;
   print guidance1          ;print guidance 1-9 
    
    mov bl,1110b             ;change the color to yellow by calling the changecolor procedure that changes the color by bl                              
    call changecolor         
     
  
    print start1
               ;print "Do you want the code to be chosen by player2 (y\n) ?"
    
    isMulti: 
    mov ah,7                ;input your answer without echo
    int 21h                  ;answer in label
                            
    cmp al,'y'               ;check if the answer is y/Y
    je multi 
    cmp al,'Y'
    je multi                ;if the answer is 'y/Y' than move on to "multi version"  
    
    cmp al,'n'               ;     
    jne isMulti              ;if the answer is neither of the two,then input your answer again 
                                
    mov dl,'n'  
    mov ah,2                 ;if the answer is 'n' then print it  
    int 21h                  ;    
     
   ;cmp al,'N'                                               
   ;mov dl,'N'  
   ;mov ah,2                 ;if the answer is 'N' then print it  
   ;int 21h
                            
    call createrandom        ;call the procedure that makes a random code by computer 
    jmp startPlay            ;jump to game start
                            
    multi:
    mov isMulty,1 
     mov ah,2            ;if the answer is yes/1
    mov dl,'y'               ;                ;then print 'y' on the screen
    int 21h                  ;
                            
    print start2             ;print "Player2 ,please input the secret code: "                 ;
    call multiversion        ;call the procedure that reads the secret code by player 2          
    
   ; multi1:
   ; mov isMulty,1            ;if the answer is yes/1
   ; mov dl,'Y'               ;
   ; mov ah,2                 ;then print 'Y' on the screen
   ; int 21h                  ;
                            
    ;lea dx,start2            ;
    ;mov ah,9                 ;print "Player2 ,please input the secret code: "
    ;int 21h                  ;
    ;call multiversion        ;call the procedure that reads the secret code by player 2        
    
    ; start game 
    
    startPlay: 
       
     print start3
            ;print "When you're ready to start, press any key."
                            
    mov ah,7                 ;input any key
    int 21h                  
                            
    call clearscreen         ;call the procedure that cleans the screen
                            
    mov bl,1111b             ;change the color to white by calling the procedure that changes the color by bl     
    call changecolor                                                                                             
    
    lea dx,string
    call printcolorlist      ;call the procedure who print the color list (numbers in colors)
                            
    mov cx,9                 ;for (int i=9; i>=1 ; i--)    
    
    turn:
    inc mone+8               ;mone prints the counter of the turns ( "{0}. Input your guess: ")
                            
    mov bl,1111b             ;change the color to white by calling the procedure that changes the color by bl                              
    call changecolor         ;
                   
      print mone
                 ;print "{0}. Input your guess: "  
    
    call Inputguess          ;call the procedure that reads your answer (player1) 
                            
    mov bl,1111b             ;change the color to white by calling the procedure that changes the color by bl                             
    call changecolor       
                            
     print writeanswer
         ;print "Your score is: "                
                            
    call check               ;call the procedure who check how much bool and how much pos you got 
    
    mov bl,1110b              ;change the color to yellow by calling the procedure that changes the color by bl                             
    call changecolor          
    
    call printcheck          ;call the procedure that prints  for each pos and  for each bool
    cmp bool,4               ;if bool = 4 it means that player1 succeeded to guess the correct code/pattern
    je winner                ;so jump to the final print of "winner"
    loop turn
    
    jmp Lose                 ;if you finish all your turns and the bool is still not equal to 4 it means you have lost 
    
    ; if you win

    winner: 
    call clearScreen         ;call the procedure that clears the screen  
    
      print linedown
            ;The cursor goes four rows down                     
    
    mov bl,0010b             ; change the color to green                            
    call changecolor         ;
                    
    cmp isMulty,0            ; if the game was not in multi version
    je printit1              ; then print only "winner" in printit1
     print won6
                  ; otherwise, if the game was in multi player version   
                             ;then first print :"player1 is the"  then go into 'printit1' label and print 'winner'
    printit1:
      print won1
                  ;print "winner" Every situation of victory
    jmp End                  ;
    
    ;if you lose                
                        
    lose:
    call clearScreen         ;call the procedure that clears the screen
    
     print linedown
            ;The cursor goes four rows down   
    
    mov bl,0100b             ; change the color to red                            
    call changecolor         ;
    
                             ; if the game was not in multi version   
    cmp isMulty,0            ; than print only "loser" in printit2   
    je printit2              ; if the game was in multi player version than: print :"player2 is the winner"
     print lose6
         
                             
   print won1
               ;print the string "player2 is the"    
                             ;print the string " "winner"
    jmp end                  ; after you print the string jump to the end of this game
    
    printit2: 
    mov bl,0100b             ; change the color to red                                
    call changecolor         ;
 
   print lose1
              ;print "loser" 
    
    End: 
    
    mov bl,1110b             ; change colour to yellow
    call changecolor         ;
    
   print isagain
            ;print if they want to play again     
    
    mov ah,1                  ;take user input
    int 21h                   
    
    cmp al,'y'                ;
    je startofgame            ;if they press y/Y then go to start of game again
    cmp al,'Y'                ;
    je startofgame            ;
    
    mov bl,1110b              ;change colour to yellow
    call changecolor          ; 
    
    print pkey
       ;     print "to finish press any key..." in the bottom of the screen ; output string at ds:dx 
         
    mov ah, 7        ; get input of key pressed
    int 21h
    
    mov ax, 4c00h ; stop program. return control to OS
    int 21h 
            
    
    Inputguess proc 
    ;procedure that let you input your answer
    ;and checks it if its diffrent from the other numbers           
   
    mov bp, sp                   ; pointer to returning address whereas
                                     ; the procedure parameters are located below of it
                                                                       
    pushregisters   ;store registers
                                       
                         ;si=source index registers. used to process arrays or strings     
                         ;xor= same=0
                         ;     different=1  
                         ;XORing an operand with itself changes the operand to 0. This is used to clear a register.    
    xor si,si            ;   si = 0            
                                     
    Input1:               ;si=0 here
    call print1          ; This calls the procedure that inputs your answer to the current index            
    call print2          ;This calls the procedure that prints char in the specific color 
                                             
    Input2:              
    mov si,1             ;Adds 1 to the index so now si=1 here
    call print1          ;This calls the procedure that inputs your answer to the current index
    mov al,[5]           ;move 5th position of array's element to al register
    
    cmp al,[4]           ;check if the current number is equal to the last number                   
    je Input2            ;if its equal, make different input again                    
    call print2          ; This calls the procedure that prints char in the specific color
                                             
    Input3:              
    mov si,2             ;Adds 1 to the index so now si=2 here            
    call print1          ; This calls the procedure that inputs your answer to the current index                    
    mov al,[6]           ;move 6th position of array's element to al register
                      
    cmp al,[5]           ;                  
    je Input3            ;check if the current number is equal to the last numbers                
    cmp al,[4]           ;if its equal, make different input again                   
    je Input3            ;
                      
    call print2          ; This calls the procedure that prints char in the specific color                   
                                             
    Input4:
    mov si,3             ;Adds 1 to the index so now si=3 here                  
    call print1          ;This calls the procedure that inputs your answer to the current index  
                      
    mov al,[7]           ;move 7th position of array's element to al register
    cmp al,[6]           ;
    je Input4            ;
    cmp al,[5]           ;check if the current number is equal to the last numbers
    je Input4            ;if its equal, make different input again     
    cmp al,[4]           ;
    je Input4            ;
    
    call print2          ; This calls the procedure that prints char in the specific color
                      
     popregisters          ; restore registers 
                                                                           
    ret                  ; return
    Inputguess endp                          
                                             
    Createrandom proc
    ; The procedure takes four random different numbers 
    ;and puts them in the memory site 
    
    mov bp, sp         ; pointer to returning address whereas
                       ; the procedure parameters are located below of it                                 
                                               
   pushregisters        ;store registers                        
                    
    xor si,si              ; si = 0 (=currentindex)
                                             
    one: 
    call createrand   ; call the procedure
                                             
                                             
    two: 
    mov si,1           ; Add 1 to the Index so si is 1
    call createrand    ; call the procedure that make random number between 0 to 5  
    
    mov al,[1]         ;                    
    cmp al,[0]         ;check if the current number is equal to the last number  
    je two             ;if its equal, make different input again  
                                            
                                             
    three:
    mov si,2           ; Add 1 to the Index so si is 2
    call createrand    ; call the procedure that make random number between 0 to 5
    mov al,[2]         ;
    cmp al,[1]         ;check if the current number is equal to the last numbers
    je three           ;if its equal, make different input again 
    cmp al,[0]         ;
    je three           ;
                                        
    four:
    mov si,3           ; Add 1 to the Index so si is 3                     
    call createrand    ; call the procedure that make random number between 0 to 5   
    
    mov al,[3]         ;
    cmp al,[2]         ;
    je four            ;check if the current number is equal to the last numbers
    cmp al,[1]         ;if its equal, make different input again
    je four            ;
    cmp al,[0]         ;
    je four            ;
                                            
    popregisters           ; restore registers                         
                                            
    ret                ; return 
    Createrandom endp
    
    createrand proc                  
    ; The procedure gets the current index
    ; and creates a random number in the current location
    
    mov bp, sp  ;pointer to returning address whereas
                ;the procedure parameters are located below of it
    
    pushregisters    ; store registers
    
    mov ah,2ch        ;
    int 21h           ;
    mov bl,6          ;
    mov al,dl         ;create random number between 0 to 5
    xor ah,ah         ;and put him into the current location in answer
    div bl            ;
    mov [si],ah       ;
    
  popregisters        ; restore registers       
    
    ret               ; return
    createrand endp
    
    print1 proc  
    ; The procedure gets the current location 
    ; and reads you answer and puts it in the memory site called youranswer     
    
    mov bp, sp            ;   pointer to returning address whereas
                              ;   the procedure parameters are located below of it
  pushregisters            ; store registers
    
    again:                    ; 
    mov ah,7                  ;
    int 21h                   ;
    cmp al,'5'                ;
    jg again                  ;get your answer and check if its correct or wrong
    cmp al,'0'                ;if its greater than 5,try again
    jl again                  ;if its lesser than 0,try again 
    
    mov [4+si],al             ;
    sub [4+si],'0'            ;
    
  popregisters                  ; restore registers
    
    ret                       ; return
    print1 endp
    
    print2 proc 
    ; The procedure get the current location and get the value of youranswer[currentindex]
    ; and print char in the color by the value of bl

    mov bp, sp      ;   pointer to returning address whereas
                    ;   the procedure parameters are located below of it
                    
     pushregisters             ; store registers
    
    mov bl,[4+si]         ;eg if si is 0, we will move 4th element into bl
    add bl,2              ;
    call changecolor      ;
    mov dl,4             ;print diamond in the color you inputted
    mov ah,2              ;
    int 21h               ;
    
  popregisters              ; restore registers
                          
    ret                  ;return
    print2 endp    
    
    check proc
    ; The procedure gets the memory site called youranswer                                                     
    ;and another memory site called answer.                                                                  
    ; The procedure compares the memory sites.                                         
    ;it adds 1 to Pos if one of your colors exist in the original code (your answer) but the location is wrong.             
    ;it adds 1 to Bool if one of your colors exist in the original code (your answer) with right location. 
    ;At the beginning of the procedure bool and pos reset.                                              
      
    mov bp, sp                    ;   pointer to returning address whereas
                                      ;   the procedure parameters are located below of it  
   pushregisters                ; store registers
                                      ;si = current index = 0
    xor si,si                         ; i = 4
    mov cx,4
    mov [9],0                         ;setting loop to run 4 times
    mov [8],0   
    
    checking:
     mov al,[4+si]           
                                      ; for (int i = 4; i > 0; i--)
    cmp al,[si]                       ; {
    je addBool                        ;   if (youranswer[5-i] == answer[5-i])
    jmp next                          ;       bool++;
                                      ;  }
    addBool:
    inc [8]  
                             
    next:                             ;increment by 1
    inc si                            
                                      ; now we know how much colors in
    loop checking                     ; the right location we have
    
    mov cx,4                          ; i = 4
    xor si,si                         ; si = current index = 0
    
    checking1: 
    mov al,[4+si]                     ; for (int i = 4;i > 0; i--){
    inc si                            ;  for (int j = 4;j > 0; j--)
    push cx                           ;  {
    push si                           ;   if (youranswer[5-i] == answer[5-j])
    mov cx,4                          ;      pos++;
    xor si,si                         ;  } }
    checking2:                         
    mov bl,[4+si]                     
                                      
    cmp al,[si]                       ; a memory site consist of colors in right location(bool)
    jne next1                         ;and colors in wrong location(pos). we need
    inc [9]                           ;just the colors in wrong loctaion(pos).
    next1:                            ; so,  pos = pos + bool
    inc si                            ;so, subtract bool from pos
    loop checking2                    ;
    pop si                            ; 
    pop cx                            
    loop checking1                    
    
    mov al,[8]                        ;al = bool 
    sub [9],al                        ;pos -=bool; (now we have just colors in wrong location)
    
 popregisters              ; restore registers  
                          
    ret            ;return
    check endp
    
    clearScreen proc 
    ; The procedure clears the screen
     
    mov bp, sp  ;   pointer to returning address whereas
                    ;   the procedure parameters are located below of it
                    
    pushregisters    
    
    mov ax,03h            ;clears the screen
    int 10h               ; 
     
    popregisters            ; restore registers
                          ; return
    ret
    clearScreen endp
     
    changecolor proc   
    ; The procedure changes the color of the text by bl 
    
    mov bp, sp      ;stack pointer to return the address of the indirect memory address of bp
                                               
    pushregisters     ; store registers
    
    mov cx,0755h    ;change the text color.
    mov ah, 9        ;built in function                 
    mov al,0        ;avod colouring any extra characters    
    int 10h                             
    
   popregisters       ; restore registers
                          
    ret             ; return 
    changecolor endp
    
    multiversion proc
    ; The procedure to let player2 input their secret code (if pleyer1 chooses to play in multi player version)     
    
    mov bp, sp ;   pointer to returning address whereas
                   ;   the procedure parameters are located below of it
    pushregisters
    
    mov ah,2
    mov dl,'*'     ;print asterisk instead of the player2's code/pattern to keep it hidden
    
    InputAns1: 
    call print1        ;procedure that inputs your answer to the current index 
    int 21h           
                                             
    InputAns2: 
    mov si,1                ; Add 1 to the Index so si=1
    call print1             ;procedure that inputs your answer to the current index
    mov al,[4+si]     
    cmp al,[4]              ; check if the current number is equal to the last number                    
    je InputAns2            ; if its equal, try new number 
    int 21h                       
                                                
    InputAns3:
    mov si,2                 ; Adds 1 to the Index so si is 2                   
    call print1             ;procedure that inputs your answer to the current index                 
    mov al,[4+si]           ;                  
    cmp al,[5]              ;                 
    je InputAns3            ;check if the current number is equal to the last numbers             
    cmp al,[4]              ;if its equal, try new number                
    je InputAns3            ;
    int 21h                              
                                                
    InputAns4:
    mov si,3              ; Adds 1 to the Index so si is 3                
    call print1             ;procedure that inputs your answer to the current index                   
    mov al,[4+si]           ;
    cmp al,[6]              ;
    je InputAns4            ;
    cmp al,[5]              ;check if the current number is equal to the last numbers
    je InputAns4            ;if its equal, try new number 
    cmp al,[4]              ;
    je InputAns4            ;
    int 21h
    
    mov cx,4               ;set counter of loop        
    xor si,si              ;reset=0 of the register 
    
    transition:            ;adding stack input from 0 to 4
    mov al,[4+si]          ;now the secret code of player2 available       
    mov [4+si],0           ;in YOURANSWER memory site and now we move
    mov [si],al            ;stack index is coming from stack segment
    inc si                 ;this code to Answer memory site
    loop transition         ;incrementing sp as you input ur answer
            
 popregisters       ; restore registers
                          
    ret             ; return 
    multiversion endp
    
    printCheck proc  
    ; The procedure gets the value of bool and value of pos and  
    ; print  BOOL times and  POS times (in yellow)             
    
    mov bp, sp           ;pointer to returning address whereas
                         ;the procedure parameters are located below of it
     pushregisters           ; store registers
     
    mov cl,[8]               ; i=bool
    mov ah,2                 ; to print the   
    
    cmp [8],0                ;if bool=0 then dont print  
    je nextstep              ;
    mov bl,1110b             ;change the color to yellow                               
    call changecolor         ;
                             
    printscore1: 
    mov dl,2                 ;now the value of dl is  
    int 21h                  ; and it prints  bool times
    loop printscore1         ;
    
    nextstep:
    mov cl,[9]              ;i = pos
    
    cmp [9],0                ; if pos = 0 then then dont print 
    je return                ;   
    
    printscore2: 
    mov dl,1                 ; now the value of dl is  
    int 21h                  ; and it prints  pos times       
    loop printscore2         ;          
    
    return:
  popregisters                ; restore registers                   
                                   
    ret                      ; return 
    printcheck endp
    
    printcolorlist proc
    ; The procedure prints "ColorList: 0 1 2 3 4 5"                             
    ; color by the value of each number      
     
    mov bp, sp           ;   pointer to returning address whereas
                             ;   the procedure parameters are located below of it
     pushregisters             ; store registers
        
    mov ah,9  
    int 21h              ;print "color list:"  
    
    mov cx,6              ;  for (i=cx=6; i>0 ; i-- )
    mov bl,1              ;  {
    mov dl,'0'            ;    sout(dl + ""); (put the color of the value dl); 
                          ;
    printcolor:           ;
    mov ah,2              ;    sout(" ");
    inc bl                ;    dl++
    call changecolor      ;  }
    int 21h               ;
    inc dl                ;
    push dx               ;
    mov dl,' '            ;
    int 21h               ;
    pop dx                ;                    
    loop printcolor       ;
    
  popregisters       ; restore registers
                          
    ret             ; return    
    printcolorlist endp     
       
ends
end start