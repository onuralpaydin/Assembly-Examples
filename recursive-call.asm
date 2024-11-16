.data
first: .word 5            # first değişkeni, başlangıç değeri 3
second: .word 3           # second değişkeni, başlangıç değeri 3
result: .word 0           # result değişkeni, başlangıç değeri 0

.text
.globl main               # Ana fonksiyonun global olarak tanımlanması

main:
    lw $t0, first         # $t0 = first
    lw $t1, second        # $t1 = second
    li $v0, 0             # result = 0 (ön tanım)

    bne $t0, $t1, test_call # Eğer first != second ise test fonksiyonuna git
    add $t2, $t0, $t1         # first == second, result = first + second
    j print_result              # Sonucu yazdırmaya git

test_call:
    move $a0, $t0           # $a0 = first (parametre 1)
    move $a1, $t1           # $a1 = second (parametre 2)
    jal test                # test(first, second) çağrısı
    j print_result          # Sonucu yazdırmaya git

print_result:
    # Sonuç yazdırılıyor
    move $a0, $t2           # Sonucu $a0'a taşı
    li $v0, 1               # print_int syscall'ını tetikle
    syscall                 # Syscall komutuyla sonucu yazdır

    li $v0, 10              # Program sonlandırma için syscall
    syscall

# test fonksiyonu
test:
    addi $sp, $sp, -8       # Yığından yer aç (8 byte yer açılıyor)
    sw $ra, 4($sp)          # $ra'yı yığına kaydet
    sw $a0, 0($sp)          # $a0'ı yığına kaydet (first parametresi)

    slt $t2, $a1, $a0       # $t2 = ($a1 < $a0) -> first > second?
    bne $t2, $zero, multiply_call # Eğer first > second, multiply'a git
    jal subtract               # Aksi halde subtract fonksiyonuna git
    j test_end

multiply_call:
    jal multiply               # multiply(first, second) çağrısı

test_end:
    lw $ra, 4($sp)          # $ra'yı yığından geri yükle
    addi $sp, $sp, 8        # Yığını eski haline getir (8 byte geri al)
    jr $ra                  # Ana programa dön

# multiply fonksiyonu
multiply:
    mul $t2, $a0, $a1          # $t2 = first * second
    jr $ra                     # Ana programa dön

# subtract fonksiyonu
subtract:
    sub $t2, $a0, $a1          # $t2 = first - second
    jr $ra                     # Ana programa dön