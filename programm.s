# data
.data

sizePrompt: .asciiz "Enter the number of elements <size>: "
arrayPrint: .asciiz "Array: \n"
spacePrint: .asciiz " "

const1: .float +0.0
const2: .float -1.0
const3: .float +2.0



# code
.globl main
.text

main:

    # Prompt user for input
    li $v0, 4   # print_string in $a0
    la $a0, sizePrompt
    syscall

    # get input via cli
    li $v0, 5   # read_int in $v0
    syscall
    move $a0, $s2 # size in $a0
    move $s2, $v0 # size in $s2

    # create array dynamic
    li $v0, 9 # sbrk address in $v0 (amount in $a0)
    syscall
    move $s1, $v0 # array pointer in $s1

    # call fillArray
    move $a0, $s2 # size in $a0
    move $a1, $s1 # array pointer in $a0
    jal fillArray

    # call printArray
    move $a0, $s2 # size in $a0
    move $a1, $s1 # array pointer in $a1
    jal printArray

    # call sort
    move $a0, $s2 # size in $a0
    move $a1, $s1 # array pointer in $a1
    ### HIER SORT CALLEN



    # call printArray
    move $a0, $s2 # size in $a0
    move $a1, $s1 # array pointer in $a1
    jal printArray

    # programm exit
    li $v0, 10
    syscall



fillArray:

    lwc1 $f0, const1 # laden von +0.0
    swc1 $f0, 0($a1) # speichern von +0.0 an in $a1 mit offset 0

    lwc1 $f0, const2 # laden von -1.0
    addi $a1, $a1, 4 # add 4 um nächsten speicher zu kriegen
    swc1 $f0, 0($a1)

    lwc1 $f1, 0($a1)

    li $t0, 2   # i=2


loop: 
    bge $t0, $a0, endLoop    # beendet loop wenn i > size ist

    ### (arr[i-1] + arr[i-2)

    addi $a1, $a1, 4 # go to next index in array
    subi $t2, $a1, 4 # $t1 - 4 um arr[i-1] zu kriegen
    lwc1 $f0, 0($t2) # arr[i-1]
    subi $t2, $t2, 4 # $t2 - 4 um arr[i-2] zu kriegen
    lwc1 $f1, 0($t2) # arr[i-2]
    add.s $f0, $f0, $f1 # (arr[i-1] + arr[i-2)

    ### pow(-1, i)
    div $t3, $t0, 2 # i/2
    mfhi $t3 # Rest in $f1 schreiben

    beq $t3, $zero, even # Wenn Rest 0 dann Grade sonst Ungrade

odd:
    lwc1 $f1, const1
    sub.s $f0, $f1, $f0 # Negiere $f0
even:
    ### / 2.0
    lwc1 $f1, const3
    div.s $f0, $f0, $f1


    swc1 $f0, 0($a1) # save value at current index in array

    addi $t0, $t0, 1 # i++
    j loop

endLoop:
    jr $ra




printArray:
    move $t0, $a0 # move size in $t0

    # printArray
    li $v0, 4   # print_string in $a0
    la $a0, arrayPrint
    syscall

    li $t1, 0 # i = 0

loop2:
    bge $t1, $t0, endLoop2

    lwc1 $f0, 0($a1)

    # print output
    mov.s $f12, $f0     # move output of f2c into $f12 input register
    li $v0, 2           # load imidiate as code for print_float (print $f12)
    syscall

    # printSpace
    li $v0, 4   # print_string in $a0
    la $a0, spacePrint
    syscall

    addi $a1, $a1, 4 # go to next index in array

    addi $t1, $t1, 1 # i++;
    j loop2

endLoop2:
    jr $ra
