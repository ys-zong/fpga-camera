onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+CLK_DIV -L unisims_ver -L unimacro_ver -L secureip -L xil_defaultlib -L xpm -O5 xil_defaultlib.CLK_DIV xil_defaultlib.glbl

do {wave.do}

view wave
view structure
view signals

do {CLK_DIV.udo}

run -all

endsim

quit -force
