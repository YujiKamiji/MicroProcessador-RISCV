# Formato de Instruções - Processador Customizado (19 bits)

Este documento descreve como cada instrução do processador é codificada em binário. Todas as instruções possuem **19 bits** e seguem diferentes formatos, conforme seu tipo (acumulador, imediato, salto, etc).

---

## 📌 Formato Geral

| Bits        | Significado         |
|-------------|---------------------|
| [18:15]     | Opcode (4 bits)     |
| [14:0]      | Campos variáveis, dependendo da instrução |

---

## 🧮 Tipos de Instrução

### 1. Operações com o acumulador (`ADD`, `SUB`, `AND`, `CMP`)

Essas instruções operam entre o acumulador (AC) e um registrador do banco.

**Formato:**

```
[18:15] Opcode  
[14:11] Registrador fonte (a ser operado com o AC)  
[10:0]  Não utilizado (zeros)
```

**Exemplo:**

- `ADD R4` → `0001 0100 00000000000`  
  (AC ← AC + R4)

---

### 2. Operações com imediato (`ADDI`, `SUBI`, `CMPI`)

Essas instruções operam entre o acumulador (AC) e um valor imediato.

**Formato:**

```
[18:15] Opcode  
[14:11] Ignorados (podem ser 0)  
[10:0]  Imediato (unsigned)
```

**Exemplo:**

- `SUBI 1` → `1011 0000 00000000001`  
  (AC ← AC - 1)

---

### 3. Carga de constante no registrador (`LOADREG`)

**Formato:**

```
[18:15] Opcode = 0110  
[14:11] Registrador destino  
[10:0]  Imediato a ser carregado
```

**Exemplo:**

- `LOADREG R3, 5` → `0110 0011 00000000101`

---

### 4. Transferência entre acumulador e registrador (`MOVREG`, `MOVAC`)

#### `MOVREG` (AC -> REG)

```
[18:15] Opcode = 1010  
[14:11] Registrador origem  
[10:0]  Não utilizado (zeros)
```

#### `MOVAC` (REG -> AC)

```
[18:15] Opcode = 1000  
[14:11] Registrador destino  
[10:0]  Não utilizado (zeros)
```

---

### 5. Carga direta no acumulador (`LOADAC`)

**Formato:**

```
[18:15] Opcode = 0100  
[10:0]  Imediato (unsigned)  
[14:11] Ignorados (podem ser 0)
```

---

### 6. Instruções de salto (`JUMP`, `BHI`, `BCC`)

**Formato:**

```
[18:15] Opcode  
[14:8]  Endereço de destino (7 bits)  
[7:0]   Zeros (ou ignorados)
```

**Exemplo:**

- `JUMP 20` → `0010 0010100 00000000`

---

### 7. Instrução NOP

**Formato:**

```
[18:0] = 0000000000000000000
```

---

## 🗃️ Tabela de Opcodes

| Instrução | Opcode |
|----------|--------|
| `NOP`    | 0000   |
| `JUMP`   | 0010   |
| `ADD`    | 0001   |
| `SUB`    | 0011   |
| `AND`    | 0101   |
| `CMP`    | 0111   |
| `ADDI`   | 1001   |
| `SUBI`   | 1011   |
| `CMPI`   | 1111   |
| `LOADAC` | 0100   |
| `LOADREG`| 0110   |
| `MOVAC`  | 1000   |
| `MOVREG` | 1010   |
| `BHI`    | 1100   |
| `BCC`    | 1110   |

---

## 📌 Observações

- O acumulador é o registrador principal para operações aritméticas.
- Os registradores são codificados em 4 bits (de `0000` a `1000`, ou R0 a R8).
- Os imediatos são valores de 11 bits (de `0` a `2047`).
- Instruções que não usam todos os bits devem preencher os restantes com zeros.

## Código em Assembly:

0:  LOADREG R3, 5            ; R3 ← 5
1:  LOADREG R4, 8            ; R4 ← 8
2:  MOVREG R3                ; AC ← R3
3:  ADD R4                   ; AC ← AC + R4  (AC = R3 + R4)
4:  MOVAC R5                 ; R5 ← AC       (R5 = R3 + R4)
5:  MOVREG R5                ; AC ← R5       (prepara para subtrair 1)
6:  SUBI 1                   ; AC ← AC - 1
7:  MOVAC R5                 ; R5 ← AC       (atualiza R5 com R5 - 1)
8:  JUMP 20                  ; Vai para o endereço 20
9:  LOADREG R5, 0            ; (não executado)

20: MOVREG R5                ; AC ← R5
21: MOVAC R3                 ; R3 ← AC       (R3 ← R5)
22: JUMP 2                   ; Volta para somar novamente
23: LOADREG R3, 0            ; (não executado)
