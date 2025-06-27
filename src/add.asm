	.org $8000          ; origin (matches load address in C)

	LDA $00           ; Load A
	CLC               ; Clear carry
	ADC $01           ; Add B
	STA $02           ; Store result

	JMP $FFFF         ; Signal end
