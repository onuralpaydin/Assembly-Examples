.data
array: .word 5, 10, 3, 8, 20, 3, 8, 25, 6, 1  # Dizi tanımı
Key: .word 5                                # Key değeri
array_size: .word 10                        # Dizi boyutu

.text
main:
    la $t1, array           # $t1, array’in başlangıç adresini alır
    lw $t2, array_size      # $t2, dizi boyutunu yükler
    lw $t3, Key             # $t3, Key değerini yükler
    addi $s0, $0, 0               # $s0, sayacı sıfırla (Key'den küçük değer sayısı)

loop:
    beq $t2, 0, end         # Eğer tüm elemanlar işlendiyse, döngüyü sonlandır
    lw $t4, 0($t1)          # $t4, şu anki dizinin elemanını yükler
    slt $t5, $t4, $t3       # Eğer $t4 < $t3 ise, $t5 = 1, aksi halde $t5 = 0
    beq $t5, 0, skip_increment # Eğer $t4 >= $t3 ise, increment’i atla

increment:
    addi $s0, $s0, 1        # $s0'ı 1 arttır (Key'den küçük bir eleman bulundu)

skip_increment:
    addi $t1, $t1, 4        # Bir sonraki elemanın adresine git
    addi $t2, $t2, -1       # Kalan eleman sayısını bir azalt
    j loop                  # Döngünün başına dön
end:
 li $v0, 1              
    syscall                 # Syscall komutuyla programı sonlandır