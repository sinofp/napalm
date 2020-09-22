addi $t1, $0, 100
addi $t2, $0, 100
addi $t3, $0, 200
addi $t4, $0, 0
addi $t5, $0, -1
##### beq ######
#t0 = 1
beq $t1, $t2, label1_1
addi $t0, $0, 1
addi $t0, $0, 0
label1_1:
nop

#t0 = 0
beq $t1, $t3, label1_2
addi $t0, $0, 1
addi $t0, $0, 0
label1_2:
nop

###################
##### bne ######
#t0 = 0
bne $t1, $t2, label1_3
addi $t0, $0, 1
addi $t0, $0, 0
label1_3:
nop

#t0 = 1
bne $t1, $t3, label1_4
addi $t0, $0, 1
addi $t0, $0, 0
label1_4:
nop

###################
##### bgez ######
#t0 = 1
bgez $t3, label2_1
addi $t0, $0, 1
addi $t0, $0, 0
label2_1:
nop
#t0 = 1
bgez $t4, label2_2
addi $t0, $0, 1
addi $t0, $0, 0
label2_2:
nop
#t0 = 0
bgez $t5, label2_3
addi $t0, $0, 1
addi $t0, $0, 0
label2_3:
nop

###################
##### bgezal ######
#t0 = 1
bgezal $t3, label3_1
addi $t0, $0, 1
addi $t0, $0, 0
label3_1:
nop
#t0 = 1
bgezal $t4, label3_2
addi $t0, $0, 1
addi $t0, $0, 0
label3_2:
nop
#t0 = 0
bgezal $t5, label3_3
addi $t0, $0, 1
addi $t0, $0, 0
label3_3:
nop

###################
##### bgtz ######
#t0 = 1
bgtz $t3, label4_1
addi $t0, $0, 1
addi $t0, $0, 0
label4_1:
nop
#t0 = 0
bgtz $t4, label4_2
addi $t0, $0, 1
addi $t0, $0, 0
label4_2:
nop
#t0 = 0
bgtz $t5, label4_3
addi $t0, $0, 1
addi $t0, $0, 0
label4_3:
nop

###################
##### blez ######
#t0 = 0
blez $t3, label5_1
addi $t0, $0, 1
addi $t0, $0, 0
label5_1:
nop
#t0 = 1
blez $t4, label5_2
addi $t0, $0, 1
addi $t0, $0, 0
label5_2:
nop
#t0 = 1
blez $t5, label5_3
addi $t0, $0, 1
addi $t0, $0, 0
label5_3:
nop

###################
##### bltz ######
#t0 = 0
bltz $t3, label6_1
addi $t0, $0, 1
addi $t0, $0, 0
label6_1:
nop
#t0 = 0
bltz $t4, label6_2
addi $t0, $0, 1
addi $t0, $0, 0
label6_2:
nop
#t0 = 1
bltz $t5, label6_3
addi $t0, $0, 1
addi $t0, $0, 0
label6_3:
nop

###################
##### bltzal ######
#t0 = 0
bltzal $t3, label7_1
addi $t0, $0, 1
addi $t0, $0, 0
label7_1:
nop
#t0 = 0
bltzal $t4, label7_2
addi $t0, $0, 1
addi $t0, $0, 0
label7_2:
nop
#t0 = 1
bltzal $t5, label7_3
addi $t0, $0, 1
addi $t0, $0, 0
label7_3:
nop

###################

# t0 == 0
j label8_1
addi $t0, $0, 1
addi $t0, $0, 0
label8_1:

# t0 == 1
jal label8_2
addi $t0, $0, 0
addi $t0, $0, 1
label8_2:

#addi $t0, $0, 0x00400000
jr $t0
nop


