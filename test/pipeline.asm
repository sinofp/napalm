.data
var: .word 1000

.text
la $t0, var
lw $t1, ($t0)
nop
add $t2, $t1, $t1
addi $t3, $t1, 2000
lui $t3, 3000
add $t4, $t3, $t2
lb $t4, ($t0)
add $t5, $t4, $t3
addi $t5, $0, 11
sb $t5, ($t0)
sw $t3, ($t0)
