ard_path = /usr/bin/
port = /dev/ttyUSB0
arq = arduino:avr:nano
#arq = arduino:avr:nano:cpu=atmega328old

com: 
	$(ard_path)arduino-cli compile -b $(arq) main.ino
deb: 
	$(ard_path)arduino-cli debug -b $(arq) main.ino
upl: 
	$(ard_path)arduino-cli upload -b $(arq) -p $(port) main.ino
mon: 
	arduino-cli monitor -p $(port) -c baudrate=9600
clr:
	$(ard_path)arduino-cli compile --clean -b $(arq) 
ec:
	@echo $(PATH)
