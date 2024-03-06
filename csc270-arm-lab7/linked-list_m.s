@  Linked structures in assembler       Khai Dong  05 March 2004
@ (removed dependance on in-line constant definitions)
@  This program builds a heap as a singly-linked list of nodes that
@  are then used to build a singly-linked list of numbers.
@       mknodes: builds a linked list of free nodes from an 
@                 unstructured heap space. 
@       new:    (you complete it) returns a node from the free list
@       insert: (you write) inserts an integer into a linked list, in order.
@       print:  (you write) traverses a list and prints its contents neatly

@@ System calls
.equ SVC_Exit, 0x11         @ kill code
.equ SVC_PrInt, 0x6B        @ print int code
.equ SVC_PrStr, 0x69        @ Write a null-ending string 
.equ Stdout, 1              @ stdout code

@@ Node structure
.equ NEXT,  0               @@ offset to next pointer
.equ DATA,  4               @@ offset to data
.equ DATASIZE, 4
.equ NODESIZE, 8            @@ DATA + DATASIZE, bytes per node
.equ NUMNODES, 15           
.equ HEAPSIZE, 120          @@ NODESIZE * NUMNODES
.equ NIL, 0                 @@ for null pointer

        .data
input:  .word -96, 9, -72, 96, -24, 18, -71 @, -96, 9, -72, 96, -24, 18, -71, 87, 21 @@ you add more numbers here  (no more than NUMNODES)
inp_end:
heap:   .space  HEAPSIZE           @ storage for nodes 
spce:   .ascii " \0"
nofree: .ascii "Out of free nodes; terminating program\n\0"


.section .text
.global main

main:   push {lr}
        ldr r0, =heap            @ pass the heap address to mknodes
        mov r1, #HEAPSIZE	 @      and its size
        mov r2, #NODESIZE 	 @      and the size of a node
        bl mknodes

@@@   Insert the values in the input array by calling insert for each one.
@@@   When the insertion is done, store the list pointer in the list variable
@@@   and then call a subroutine to traverse the list and print its contents
@@@   REmov these comment lines before turning in the program.
@       initially our linked list will be empty (nil)
	
	ldr r9, =input   @ start of input
        ldr r8, =inp_end @ end of input
	mov r7, r0       @ presuming r0 contains a pointer to free after mknodes is called
        
        mov r6, r9       @ use r6 as the pointer to the current value in the input
        mov r5, #NIL     @ use r5 as the head of linkedList
while:  cmp r6, r8
        beq done         @ while current pointer is not at the end of input
        
        push {r5-r8}
        
        ldr r0, [r6]     @ load current element of the input into $a0 (N)
        mov r1, r5       @ load current head of linked list into $a1
        mov r2, r7       @ load current free into $a2
        bl insert

        pop {r5-r8}

        mov r5, r0       @ update r5 with new head of linked list
        mov r7, r1       @ update r7 with new pointer to free
        add r6, r6, #4   @ ++ r6
        b while

done:   mov r0, r5

        bl print

        pop {lr}
        mov pc, lr

@ mknodes takes a heap address in a0, its byte-size in a1, and node size in a2
@  and partitions it into a singly-linked list of nodesize
@ (NODESIZE-byte) nodes, pointed to by free.  
@ NOTE:  the list is built with free pointing to the last node in the
@    heap area, which points to the previous one, etc.  The reason for
@    this construction is to be sure that you get nodes by calling
@    "new" rather than by rebuilding the heap yourself!  
@ Register usage:
@ inputs:
@ r0 contains a pointer to the heap
@ r1 contains the heapsize
@ r2 contains the nodesize

@ used registers
@ r4: pointer to block that will become a node
@ r5: pointer to previous block (will become next node)

@ r0: points to the first free node in the heap
mknodes:add r4, r0, r1       @ t0 starts by pointing to the last
        sub r4, r4, r2       @ node-sized block in the heap
        mov r9, r4           @ set output r9 to point to that first node
mkloop: sub r5, r4, r2       @ t1 points to previous node-sized block
        str r5, [r4, #NEXT]  @ link the t0->node to point to t1 node
        mov r4, r5           @ back up t0 by one node
        cmp r4, r0
        bne mkloop           @ repeat if not at heap-start
        mov r8, #NIL
        str r8, [r5, #NEXT]  @ ground node (first block in heap)
        mov r0, r9           @ store r9 into r0 to return
        mov pc, lr           @ return

@ Removes a node from free (passed in via r0), returning a pointer to the node in r0,
@ and a pointer to the new free in $v1
@  (returns NIL if none available)
@ inputs:
@    r0: points to the first "free" node in the heap
@ outputs:
@    r0: the node we have "created" (pulled off the stack from free)
@    r1: the new value of free (we don't want to clobber r0 when we change free, right? right?)
new:    cmp r0, #NIL
        bne new_endif
        mov r0, #NIL
        mov r1, #NIL
        mov pc, lr
new_endif:  
        @ mov  r0, r0 @ uneeded, r0 is already the node we have created
        ldr r1, [r0, #NEXT]
        mov pc, lr


@ insert behaves as described in the lab text
@ inputs:
@	 r0: should contain N
@	 r1: should contain a pointer to our linked list
@	 r2: should contain a pointer to free
@
@ outputs:
@ 	r0 should contain the new pointer to our linked list
@	r1 should contain the new pointer to free
insert:
        cmp r1, #NIL
        beq in_base_if           @ if listptr == NIL
        ldr r4, [r1, #DATA]      @ load listptr->data into r4
        cmp r4, r0
        bge in_base_if           @ if listptr->data >= N
        b in_base_recur

in_base_if:
        push {r0, r1, lr}        @ preserve the arguments and $ra
        mov r0, r2
        bl new                   @ r1 already contains the address to the next free node

        cmp r0, #NIL
        bne in_endif1            @ if $v0 == NIL
                mov r0, #Stdout
                ldr r1, =nofree  @ print nofree error msg 
                svc SVC_PrStr

                svc SVC_Exit     @ and kill the program

        in_endif1:
        @ r0 still store the address to the pointer to the node returned by new()
        mov r9, r0      @ write the node returned by new into r9
        mov r8, r1
        pop {r0, r1, lr}

        str r0, [r9, #DATA]       @ tmp->data = N
        str r1, [r9, #NEXT]       @ tmp->next = listptr ($a1)
        
        mov r0, r9
        mov r1, r8
        mov pc, lr               @ return new pointer to the linked list, 

in_base_recur:
        push {r0, r1, lr}      @ preserve the arguments and $ra
        
        @ r0 is N
        @ r2 is still the pointer to new
        ldr r1, [r1, #NEXT] 
        bl insert

        mov r9, r0      @ copy new head to r9
        mov r8, r1      @ copy new free to r8

        pop {r0, r1, lr} @ restore arguments r0, r1, lr

        @ r9 is currently contains the address returned by insert recursive call
        str r9, [r1, #NEXT]
        mov r0, r1          @ return listptr, stored in r1
        mov r1, r8          @ return new pointer to free 
        mov pc, lr



# print the whole linked list
# inputs:
#	$r0 should contain a pointer to our linked list

print:  
        mov r9, r0
pr_while: 
        cmp r9, #NIL
        beq pr_done   @ while $r9 != NIL
        
        mov r0, #Stdout          
        
        ldr r1, [r9, #DATA]       @ print the data of current node
        svc SVC_PrInt
        
        ldr r1, =spce            @ print space
        svc SVC_PrStr

        ldr r9, [r9, #NEXT]       @ $t0 = $t0->NEXT
        b pr_while

pr_done: mov pc, lr

