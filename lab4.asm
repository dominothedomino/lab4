    .ORIG x3000
    
; Name: Lonoehu Wacasey
; Date: 11/12/24
; Lab #4
;

; BLOCK 1
; Register R0 is loaded with m[x6000].
; This will serve as the pointer to the head node of the linked list.
;  

	LDI R4, PTR1

    BR  BLOCK2
PTR1    .FILL   x6000


    
    
; BLOCK 2
; 
; In this block you will prompt the user for the Building Abbreviation and Room Number 
; by printing on the monitor the string “Type the room to be reserved and press Enter: ” 
; and wait for the user to input a string followed by <Enter> (ASCII: x0A). 
; (Assume that there is no case where the user input exceeds the maximum number of characters).

; Check if the user inputs an Enter, whose ASCII code is x0A.
; If it is not Enter, then store the character at the reserved block of memory labeled USERINPUT
; The reserved block of memory is 11 locations (maximum of 10 characters, and null terminator).
; In this block you must also display each character that the user types.

BLOCK2  LEA R0, PROMPT
        PUTS
        
        LEA R1, USERINPUT
        AND R3, R3, #0
        ADD R3, R3, xA
        AND R0, R0, #0  ;R1 = addr[userinput], R3 = 10 for counter, R0 = 0
        
LOOP    AND R2, R2, #0
        GETC
        ADD R2, R0, #-10
        BRZ LOOPEN      ;detects if r0 is x000A, meaning the enter button is pressed and the name of the room is done
        
        STR R0, R1, #0
        OUT
        ADD R1, R1, #1
        ADD R3, R3, #-1     ;if input isnt enter, we store r0 into r1, and shift r1 forward and r3 back one
        BRZ LOOPEN
        BR LOOP             ;if counter is done, max character limit is hit and string is done and stored
        
        
LOOPEN
    AND R0, R0, #0
    STR R0, R1, #0
    BR BLOCK3
    ;CHECKED AND EVERYTHING UP TO THIS POINT WORKS


PROMPT  .STRINGZ    "Type the room to be reserved and press Enter: "  
USERINPUT   .BLKW   xB


; Block 3: In this block you will check if there is a match between the entered 
; user string with an entry in the linked list.
; Your program must search the list of currently available rooms to find a match for the 
; entered Building Abbreviation and Room Number. The list stores all the currently available rooms. 
; You will find a match only if the room is in the list. It is possible to not find a match in the list. 

; If your program finds a match, then it must print out “<Building Abbreviation and Room Number> 
; is currently available!” (eg., “GSB 2.126 is currently available!”)

; Note that if there is a match, it must branch to DONE.
; If there is no match, it must branch to BLOCK4

BLOCK3
    LDR R0, R4, #1      
    LDR R4, R4, #0
    
    JSR STRNGCOMPARE
    ADD R3, R3, #0
    BRZ MATCH           ;R3 is output from the jump, if it is a 0, then a match was detected and we branch to match
    
    ADD R4, R4, #0
    BRZ BLOCK4          ;if R4 (pointer to next node) is x0, then the linked list is done without a match,
                        ;meaning that there is no match and so we must go to block 4 to output no match
                        
    BR BLOCK3           ;if R3 is a 1 and R4 is not a 0, we try to detect a match from the next node
    
    

STRNGCOMPARE
    ST R4, SAVER4
    ST R0, SAVER0
    ST R7, SAVER7       ;saves values of r4, r0, r7
    
    AND R3, R3, #0
    AND R2, R2, #0
    LEA R1, USERINPUT   ;clears r3 and r2, loads r1 with the address of input string
    
JUMPLOOP
    LDR R4, R0, #0
    LDR R5, R1, #0      ;R4 loaded with the first character of the linked list data, r5 loaded with the first
                        ;character of user input
    BRZ DNECHECK        ;if R5, is zero, goes to check if R4 is zero as well
    
    ADD R0, R0, #1
    ADD R1, R1, #1      ;increments R0 and R1 to go to address of next ascii code
    
    NOT R5, R5
    ADD R5, R5, #1
    ADD R2, R4, R5      ;subtracts R5 from R4 to see if they are the same character
    BRZ JUMPLOOP
    BR NOMATCH          ;if not the same, not a match, if the same, then tests next ascii code
    
DNECHECK
    ADD R4, R4, #0      ;if R4 and R5 are both zero, there is a match detected and we exit the jump
    BRZ GOBK
    BR NOMATCH          ;if they aren't both zero, then there is not a match
    
NOMATCH
    ADD R3, R3, #1      ;if there is a no match detected, we output a 1 in R3 from the jump
    BR GOBK
    
GOBK
    LD R4, SAVER4
    LD R0, SAVER0
    LD R7, SAVER7       ;loads R4, R0, and R7 with their previous values and exits with R3 as an output
    RET


SAVER4  .BLKW x1
SAVER0  .BLKW x1
SAVER7  .BLKW x1


MATCH
    LEA R0, USERINPUT
    PUTS                ;Outputs the room number which the user first entered
    LEA R0, MATCHLIST   
    PUTS                ;Outputs the fact that the room number is available
    BR DONE
        
MATCHLIST  .STRINGZ    " is currently available!"

; Block 4: You will enter this block only if there was no match with the linked list. 
; In this block you must print out “<Building Abbreviation and Room Number> is NOT currently available.” 
; (eg., “GSB 2.126 is NOT currently available.”).
;

BLOCK4
    LEA R0, USERINPUT
    PUTS
    LEA R0, NOMATCHTLIST
    PUTS
    BR DONE

NOMATCHTLIST  .STRINGZ    " is NOT currently available."


DONE    HALT
    

    .END

