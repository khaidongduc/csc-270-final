# Lab 7: Linked Lists

In this lab you'll have to understand, and then write, a linked-list insertion routine and a traversal routine. The starter program contains a subroutine that builds a singly-linked list of free nodes, along with the appropriate data declarations. The program will assemble but will not do anything useful until you extend it.

Setup
-
Your first task is to "reverse engineer" the code to understand more fully what it does. Trace through the `mknodes` routine in order to understand what it does. Draw a diagram of the heap created by `mknodes`, this will be required for your lab report.

The list consists of nodes of the form
```
|next-ptr|data|
```
where the nodes are obtained from the singly-linked list build by `mknodes`.

Write new()
-
- Design the `new()` subroutine, writing it down on paper, diagramming what it does. This diagram and hand-written code will also be required for your lab report.. When called, it removes the first node from the free list and returns it in `r0`, or returns `NIL` (0) in `r0` if the free list is empty. Callers should check whether it has returned a node. Since this is a "leaf" subroutine, it can use the `r0-r9` registers without fear of another subroutine's changing them.

- Implement your design from above

Insert
-
- Design an `insert()` routine that is passed a number `N` to insert and a pointer to the linked list into which to insert the number. It puts the number in a new node and inserts that node into the linked list so that the list of data values is ordered. It also returns a pointer to the first node in the list, which can be assigned to the program's list variable. This routine will get nodes from the free list, and hence should check to see if new returned a node or `NIL`, and should print the "out of nodes" error message and return or terminate if there are no more nodes. An algorithm is
```
// ------ a node has              \
// | ---|--->a pointer-to-node field 
// ------   a data field             
// | 17 | and it has the type-name: Node   
//------
typedef struct node {
    struct node *next   
    int data;           
    } Node;

insert(int N, Node *listptr)
{
   tmpptr = new Node();
   tmptr.data = N;
   if listptr == Nil or N < listptr.data
   {
      tmpptr.next = listptr
      listptr = tmpptr
   }
   else 
   {
      curptr = listptr
      while curptr.next != Nil and curptr.next.data <= N
      {
          curptr = curptr.next
      }
      tmpptr.next = curptr.next
      curptr.next = tmpptr
   }
   return listptr
}
```
- Implement your design.

Print
-
In order to help debugging, write a print routine that traverses the list after the data are inserted and prints out the data values. It should take only the the list pointer as a parameter.

Putting it Together
-
Finally, complete the main program to call these two routines. Print out a screen dump of your console window to show that the traversal is correct (what is the criterion?) and turn it in with your labeled list diagram and a carefully documented program (the list.asm program with which you start is not fully documented).

Challenge/Flex/Kudos
-
(In the history of Rieffel's CSC270, very few students have ever done this)

Write a `dispose` routine that, given a pointer to a node, a pointer to your linked list, and a pointer to your free list, puts a node back on the free list. `dispose` should return both the new free list and the new linked list. Watch out for edge cases!

Then, write a `delete` routine that, given an integer `N`, and a pointer to your linked list and a pointer to your free list, finds the first occurrence of `N` in the list, disposes of that node, then returns the new list pointer and new free list. If `N` is not in the linked list, nothing should change.

Finally, write a `cleanup` routine that traverses the list of numbers and returns all nodes to the free list.

Hand in:
-
- your diagram from part 1
- your final program, with all working parts
- screenshots to verify successful operation