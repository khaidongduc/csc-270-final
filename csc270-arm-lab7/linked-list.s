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
.equ SWI_PrStr, 0x69        @ Write a null-ending string 
.equ Stdout, 1              @ stdout code

@@ Node structure
.equ NEXT,  0               @@ offset to next pointer
.equ DATA,  4               @@ offset to data
.equ DATASIZE, 4
.equ NODESIZE, 8            @@DATA + DATASIZE, bytes per node
.equ NUMNODES, 15           
.equ HEAPSIZE, 120          @@ NODESIZE * NUMNODES
.equ NIL, 0                 @@ for null pointer

        .data
input: .word 5 @@ you add more numbers here  (no more than NUMNODES)
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
@@@   REMOVE these comment lines before turning in the program.

	@initially our linked list will be empty (nil)
	@lw, r0, input
	@li, r1, nil
	@move r2, $v0  @presuming $v0 contains a pointer to free after mknodes is called

done:   pop {lr}
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
new:    mov pc, lr


@insert behaves as described in the lab text
@ inputs:
@	 r0: should contain N
@	 r1: should contain a pointer to our linked list
@	 r2: should contain a pointer to free
@
@ outputs:
@ 	r0 should contain the new pointer to our linked list
@	r1 should contain the new pointer to free

