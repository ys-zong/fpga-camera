onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc" -t 1ps -L unisims_ver -L unimacro_ver -L secureip -L xil_defaultlib -L xpm -lib xil_defaultlib xil_defaultlib.CLK_DIV xil_defaultlib.glbl

do {wave.do}

view wave
view structure
view signals

do {CLK_DIV.udo}

run -all

quit -force
