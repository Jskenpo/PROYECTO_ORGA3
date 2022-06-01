/*
Organización de computadoras y assembler 
PROYECTO 3
CARRITO SEGUIDOR DE LINEA
INTEGRANTES:

@ Description: 
@ turn on pin2 when pressing button on wPi 8
@ and turn of pin2 when pressing button on wPi 4
*/

@ ---------------------------------------
@ ---------------------------------------
@	Data Section
@ ---------------------------------------
	 .data
	 .balign 4	
Intro: 	 .asciz  "Raspberry Pi wiringPi blink test\n"
ErrMsg:	 .asciz	"Setup didn't work... Aborting...\n"
log: .asciz "Sensor detect"
log2: .asciz "Sensor 2 detect"
pinInfrarrojo:	 .int	7					@ pin in pin7 en placa
pinInfrarrojo2:  .int   0					@ pin 11 en la placa
pinMotorUnoA:	 .int   4					@ pin out pin16 en placa
pinMotorUnoB:	 .int   5					@ pin out pin18 en placa
pinMotorDosA:	 .int   24
pinMotorDosB:	 .int   25					
i:	 	 .int	0
INPUT	 =	0
OUTPUT	 =	1
delayMs: .int	10
delayMs2: .int 1
	
@ ---------------------------------------
@	Code Section
@ ---------------------------------------
	
	.text
	.global main
	.extern printf
	.extern wiringPiSetup
	.extern delay
	.extern digitalWrite
	.extern pinMode
	
main:   push 	{ip, lr}	@ push return address + dummy register
				@ for alignment

	bl	wiringPiSetup			// Inicializar librería wiringpi
	mov	r1,#-1					// -1 representa un código de error
	cmp	r0, r1					// verifica si se retornó cod error en r0
	bne	init					// NO error, entonces iniciar programa
	ldr	r0, =ErrMsg				// SI error, 
	bl	printf					// imprimir mensaje y
	b	done					// salir del programa

@------- set pinMode
init:
	
	ldr	r0, =pinInfrarrojo		// coloca el #pin3 wiringpi a r0
	ldr	r0, [r0]
	mov	r1, #INPUT				// lo configura como entrada, r1 = 0
	bl	pinMode 				// llama funcion wiringpi para configurar
	
	ldr	r0, =pinInfrarrojo2		// coloca el #pin3 wiringpi a r0
	ldr	r0, [r0]
	mov	r1, #INPUT				// lo configura como entrada, r1 = 0
	bl	pinMode 				// llama funcion wiringpi para configurar
	
	ldr	r0, =pinMotorUnoA		// coloca el #pin1 wiringpi a r0
	ldr	r0, [r0]
	mov	r1, #OUTPUT				// lo configura como entrada, r1 = 0
	bl	pinMode					// llama funcion wiringpi para configurar
	
	ldr	r0, =pinMotorUnoB		// coloca el #pin wiringpi a r0
	ldr	r0, [r0]
	mov	r1, #OUTPUT				// lo configura como salida, r1 = 1
	bl	pinMode					// llama funcion wiringpi para configurar
	
	ldr	r0, =pinMotorDosA				// coloca el #pin1 wiringpi a r0
	ldr	r0, [r0]
	mov	r1, #OUTPUT				// lo configura como entrada, r1 = 0
	bl	pinMode					// llama funcion wiringpi para configurar
	
	ldr	r0, =pinMotorDosB				// coloca el #pin wiringpi a r0
	ldr	r0, [r0]
	mov	r1, #OUTPUT				// lo configura como salida, r1 = 1
	bl	pinMode					// llama funcion wiringpi para configurar
	
@------- if gpio == 1			// si se activa switch entrada gpio4
try:
	@------- delay(500)	
	ldr	r0, =delayMs
	ldr	r0, [r0]
	bl	delay
	
	ldr	r0, =pinInfrarrojo		// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	bl 	digitalRead				// escribe 1 en pin para activar puerto GPIO
	cmp	r0,#0					// switch NA, por lo que pasa corriente (1) hasta que se presione
	beq	ledOn
	cmpne r0,#1					// si se presiona llama a subrutina ledOn
	beq try

try2:
	@------- delay(250)	
	ldr	r0, =delayMs
	ldr	r0, [r0]
	bl	delay
	
	ldr	r0, =pinInfrarrojo2				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	bl 	digitalRead				// escribe 1 en pin para activar puerto GPIO
	cmp	r0,#0					// switch NA, por lo que pasa corriente (1) hasta que se presione
	beq	ledOn2
	cmpne r0,#1					// si se presiona llama a subrutina ledOn
	beq try


ledOn:	
	@------- digitalWrite(pin, 1);		
    ldr r0,=log
    bl puts

	ldr	r0, =pinMotorDosA				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #0					// enciende led
	bl 	digitalWrite			        // escribe 1 en pin para activar puerto GPIO
	
	@------- delay(250)	
	ldr	r0, =delayMs2
	ldr	r0, [r0]
	bl	delay
	
	ldr	r0, =pinMotorDosB				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #0				// apaga led
	bl 	digitalWrite
	
	@------- delay(250)	
	ldr	r0, =delayMs2
	ldr	r0, [r0]
	bl	delay

	ldr	r0, =pinMotorUnoA				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #1					// enciende led
	bl 	digitalWrite			        // escribe 1 en pin para activar puerto GPIO
	
	@------- delay(250)	
	ldr	r0, =delayMs2
	ldr	r0, [r0]
	bl	delay
	
	ldr	r0, =pinMotorUnoB				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #0				// apaga led
	bl 	digitalWrite			        // escribe 1 en pin para activar puerto GPIO
	
	@------- delay(250)	
	ldr	r0, =delayMs2
	ldr	r0, [r0]
	bl	delay
	

	ldr	r0, =pinInfrarrojo				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	bl 	digitalRead				// escribe 1 en pin para activar puerto GPIO
	cmp	r0,#1
	beq	ledOn2
	
	@------- delay(250)	
	ldr	r0, =delayMs
	ldr	r0, [r0]
	bl	delay
	
	b ledOn
	
ledOf:	
	ldr	r0, =pinMotorUnoA				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #0					// enciende led
	bl 	digitalWrite			        // escribe 1 en pin para activar puerto GPIO
	
	@------- delay(250)	
	ldr	r0, =delayMs2
	ldr	r0, [r0]
	bl	delay
	
	ldr	r0, =pinMotorUnoB				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #0				// apaga led
	bl 	digitalWrite			        // escribe 1 en pin para activar puerto GPIO
	
	@------- delay(250)	
	ldr	r0, =delayMs
	ldr	r0, [r0]
	bl	delay
	b try 

ledOn2:	

	ldr r0,=log2
    bl puts

	ldr	r0, =pinMotorUnoA				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #0					// enciende led
	bl 	digitalWrite			        // escribe 1 en pin para activar puerto GPIO
	
	@------- delay(250)	
	ldr	r0, =delayMs2
	ldr	r0, [r0]
	bl	delay
	
	ldr	r0, =pinMotorUnoB				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #0				// apaga led
	bl 	digitalWrite			        // escribe 1 en pin para activar puerto GPIO
	
	@------- delay(250)	
	ldr	r0, =delayMs2
	ldr	r0, [r0]
	bl	delay
	
	@------- digitalWrite(pin, 1) ;		

	ldr	r0, =pinMotorDosA				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #1					// enciende led
	bl 	digitalWrite			        // escribe 1 en pin para activar puerto GPIO
	
	@------- delay(250)	
	ldr	r0, =delayMs2
	ldr	r0, [r0]
	bl	delay
	
	ldr	r0, =pinMotorDosB				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #0				// enciende led
	bl 	digitalWrite			        // escribe 1 en pin para activar puerto GPIO
	
	@------- delay(250)	
	ldr	r0, =delayMs2
	ldr	r0, [r0]
	bl	delay

	ldr	r0, =pinInfrarrojo2				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	bl 	digitalRead				// escribe 1 en pin para activar puerto GPIO
	cmp	r0,#1
	beq	ledOn

	b ledOn2
	
	; ldr	r0, =pinInfrarrojo2				// carga dirección de pin
	; ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	; bl 	digitalRead				// escribe 1 en pin para activar puerto GPIO
	; cmp	r0,#0
	; beq	ledOn2
	; cmpne r0,#1
	; beq ledOf2

ledOf2:	
	ldr	r0, =pinMotorDosA				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #0					// enciende led
	bl 	digitalWrite			        // escribe 1 en pin para activar puerto GPIO
	
	@------- delay(250)	
	ldr	r0, =delayMs
	ldr	r0, [r0]
	bl	delay
	
	ldr	r0, =pinMotorDosB				// carga dirección de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #0				// apaga led
	bl 	digitalWrite			        // escribe 1 en pin para activar puerto GPIO
	
	@------- delay(250)	
	ldr	r0, =delayMs
	ldr	r0, [r0]
	bl	delay
	b try 
	
done:	
        pop 	{ip, pc}	@ pop return address into pc
