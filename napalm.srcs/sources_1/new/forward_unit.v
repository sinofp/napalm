module forward_unit(
                    input [4:0] reg_ra1,
                    input [4:0] reg_ra2
                    input [4:0] reg_wa_alu,
                    input [4:0] reg_wa_mem,
                    input       reg_we_alu, // alu的res要写入寄存器
                    input       reg_we_mem, // mem的rd要写入寄存器
                    output      forward1,
                    output      forward2,
                    )

  assign forward1 = (reg_we_alu & (reg_ra1 != 0) & (reg_ra1 == reg_wa_alu))? 10:
                    (reg_we_mem & (reg_ra1 != 0) & (reg_ra1 == reg_wa_mem))? 01:
                    11

  assign forward2 = (reg_we_alu & (reg_ra1 != 0) & (reg_ra1 == reg_wa_alu))? 10:
                    (reg_we_mem & (reg_ra2 != 0) & (reg_ra1 == reg_wa_mem))? 01:
                    11
endmodule // forward_unit
