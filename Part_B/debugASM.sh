#---------------------
# DEBUG Script
#--------------------

# By Benjamin Boden
# 15/11/12022
# runs the Triangle.asm program, and shows the veriable values to the 
# console

# to use:
# Start GDB debugger into your executible ASM file
# in GDB pass it the comand "source <thisFile.sh>"



# START PROGRAM
echo \n\n			
b last				
		

# START LOGGING:
set pagination off
set logging file example.out
set logging overwrite
set logging on
set prompt

run

# DESPLAY TEXT:
echo ---------------------------------------\n
echo display variables\n
echo \n

# DESPLAY VARIABLES:
x/dw &taMin
x/dw &taMax
x/dw &taSum
x/dw &taAve

echo Volume Values

x/dw &volMin
x/dw &volMax
x/dw &volSum
x/dw &volAve

run
# END DEBUG
echo \n\n

# read the output
i r rdi

set logging off			

quit
