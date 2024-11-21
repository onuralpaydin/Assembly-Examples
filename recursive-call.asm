.data
alpha: .word 3         # Test için a değişkeni 
beta: .word 5         # Test için b değişkeni 

.text

main:
    # a ve b'yi bellekten yükle
    lw $t0, alpha        # $t0 = a
    lw $t1, beta       # $t1 = b

 # a != b kontrolü
    beq $t0, $t1, add_case  # Eğer a == b ise toplama yap

    # a != b durumunda test fonksiyonunu çağır
    addi $sp, $sp, -8   # Stack pointer'ı 8 byte geri çek (iki 4-byte'lık veri)
    sw $t0, 4($sp)      # a'yı stack'e kaydet
    sw $t1, 0($sp)      # b'yi stack'e kaydet
    jal test            # test fonksiyonuna git
    addi $sp, $sp, 8    # Stack pointer'ı eski haline getir (8 byte geri)

    j end_main          # Programı bitir

add_case:
    add $s7, $t0, $t1   # $s7 = a + b (sonucu $s7'ye kaydet)
    j end_main          # Programı bitir

end_main:
    # Programı sonlandır
    li $v0, 10          # Program sonu için syscall
    syscall

# Test Fonksiyonu
test:
    lw $t0, 4($sp)      # Stack'ten a'yı yükle
    lw $t1, 0($sp)      # Stack'ten b'yi yükle
    slt $t2, $t0, $t1   # $t2 = (a < b) kontrolü
    bne $t2, $0, call_subtract  # Eğer a < b doğruysa subtract çağır

    # a > b durumunda multiply fonksiyonunu çağır
    jal multiply
    jr $ra              # Ana programa geri dön

call_subtract:
    jal subtract        # subtract fonksiyonuna git
    jr $ra              # Ana programa geri dön

# Multiply Fonksiyonu (Döngü ile çarpma işlemi)
multiply:
    lw $t0, 4($sp)      # a'yı yükle
    lw $t1, 0($sp)      # b'yi yükle
    addi $t2, $0, 0  # $t2 = 0 (sonuç için)
    addi $t3, $0, 0  # Döngü sayacı

multiply_loop:
    beq $t3, $t1, multiply_done  # Döngüden çık (b kadar tekrar et)
    add $t2, $t2, $t0            # $t2 += a (sonuç güncelle)
    addi $t3, $t3, 1             # Döngü sayacını artır
    j multiply_loop              # Döngüye devam

multiply_done:
    add $s7, $t2, $0          # Sonuç: $s7 registerina taşındı
    jr $ra                       # Ana programa geri dön

# Subtract Fonksiyonu (Çıkarma işlemi)
subtract:
    lw $t0, 4($sp)      # a'yı yükle
    lw $t1, 0($sp)      # b'yi yükle
    sub $s7, $t0, $t1   # $s7 = a - b (sonuç çıkarma)
    jr $ra              # Ana programa geri dön