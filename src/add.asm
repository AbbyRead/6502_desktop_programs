; Adds two bytes from $00 and $01, stores result in $02
.org $8000
    CLC
    LDA $00
    ADC $01
    STA $02
    RTS
