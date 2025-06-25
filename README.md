# Formato de Instruções - Processador Customizado (19 bits)

Este documento descreve como cada instrução do processador é codificada em binário. Todas as instruções possuem **19 bits** e seguem diferentes formatos, conforme seu tipo (acumulador, imediato, salto, etc).

---

## 📌 Formato Geral

| Bits        | Significado         |
|-------------|---------------------|
| [18:15]     | Opcode (4 bits)     |
| [14:0]      | Campos variáveis, dependendo da instrução |

---

## 🦮 Tipos de Instrução

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
[18:15] Opcode = 1100  
[14:11] Registrador destino 
[10:0]  Não utilizado (zeros)
```

#### `MOVAC` (REG -> AC)

```
[18:15] Opcode = 1000  
[14:11] Registrador origem  
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

#### `JUMP`

```
[18:15] Opcode  
[14:8]  Endereço de destino (7 bits)  
[7:0]   Zeros (ou ignorados)
```

#### `BHI` e `BCC`

```
[18:15] Opcode  
[14:7]  Offset  
[6:0]   Zeros (ou ignorados)
```

**Exemplo:**

- `JUMP 20` → `0010 0010100 00000000`

---

### 7. Acesso à RAM (`MOVRAM`, `LOADRAM`)

#### `MOVRAM` (AC → RAM)

```
[18:15] Opcode = 0000  
[14:11] Registrador com o ponteiro do endereço de memória desejado  
[10:2]  Não utilizados (zeros)  
[1]     = 1 (diferencia de NOP)  
[0]     = 0
```

#### `LOADRAM` (RAM → AC)

```
[18:15] Opcode = 0000  
[14:11] Registrador com o ponteiro do endereço de memória desejado 
[10:2]  Não utilizados (zeros)  
[1]     = 0  
[0]     = 1 (diferencia de NOP)
```

---

### 8. Instrução NOP

**Formato:**

```
[18:0] = 0000000000000000000
```

---

## 🗃️ Tabela de Opcodes

| Instrução  | Opcode |
|------------|--------|
| `NOP`      | 0000   |
| `JUMP`     | 0010   |
| `ADD`      | 0001   |
| `SUB`      | 0011   |
| `AND`      | 0101   |
| `CMP`      | 0111   |
| `ADDI`     | 1001   |
| `SUBI`     | 1011   |
| `CLEAR`    | 1101   |
| `CMPI`     | 1111   |
| `LOADAC`   | 0100   |
| `LOADREG`  | 0110   |
| `MVAC`     | 1000   |
| `MVREG`    | 1100   |
| `BHI`      | 1010   |
| `BCC`      | 1110   |
| `MOVRAM`   | 0000¹  |
| `LOADRAM`  | 0000²  |

¹ `instr(1) = 1` e `instr(0) = 0`  
² `instr(1) = 0` e `instr(0) = 1`

---

# ✅ Validação Final do Processador

Esta atividade corresponde à **última entrega da disciplina**, cujo objetivo é validar o funcionamento completo do processador implementado.

## 📋 Descrição da Tarefa

De acordo com o enunciado proposto pelo professor, a tarefa consiste em:

- Implementar o **Crivo de Eratóstenes** via assembly personalizado, populando a RAM com números de 1 a 32 e eliminando múltiplos de 2, 3 e 5.
- Realizar a leitura dos dados restantes da RAM e enviá-los por um pino de saída para visualização.
- Além disso, **implementar um programa que verifique se o número 751 é primo**, utilizando apenas os recursos do processador construído.

---

## 🧐 Estratégia Utilizada

Para a verificação da primalidade de 751:

- Inicializamos registradores com o número **751**, um **divisor** começando de 2, uma **flag de primalidade** (inicialmente 1), e o **limite 28** (\( \sqrt{751} \approx 27{,}4 \)).
- Utilizamos **subtrações sucessivas** para simular uma operação de módulo (resto da divisão).
- Caso algum divisor seja exato, a flag é zerada (indicando que **751 não é primo**).
- Ao final, o valor da flag é movido para o registrador `R8`, utilizado como **registrador de debug**, permitindo a visualização do resultado.

---

## 🔎 Resultado Esperado

- Se o registrador `R8` contiver `1`, significa que **751 é primo** (o esperado).
- Se contiver `0`, significa que foi encontrado um divisor entre 2 e 27.


## 📊 Lógica Geral

1. R0 ← 751
2. R1 ← 2 (divisor)
3. R4 ← 1 (flag: assume que é primo)
4. R5 ← 28 (limite do loop, pois \sqrt{751} ≈ 27.4)
5. Loop para testar se algum divisor de 2 a 27 divide 751:
   - Simula divisão por subtrações sucessivas
   - Se resto for 0, define R4 ← 0 (não é primo)
6. Copia o resultado final para R8

---

## 💻 Código Assembly

```assembly
; Inicializa RAM de 1 a 32
0:  LOADAC 1
1:  MVREG R1
2:  MOVRAM R1
3:  ADDI 1
4:  CMPI 33
5:  BHI 2
6:  JUMP 1

; Zera posições 4,6,...,32 da RAM (teste de escrita)
7:  LOADAC 4
8:  CMPI 33
9:  BHI 7
10: MVREG R1
11: LOADAC 0
12: MOVRAM R1
13: MOVAC R1
14: ADDI 2
15: JUMP 8

16: LOADAC 6
17: CMPI 33
18: BHI 7
19: MVREG R1
20: LOADAC 0
21: MOVRAM R1
22: MOVAC R1
23: ADDI 3
24: JUMP 17

25: LOADAC 10
26: CMPI 33
27: BHI 7
28: MVREG R1
29: LOADAC 0
30: MOVRAM R1
31: MOVAC R1
32: ADDI 5
33: JUMP 26

; Percorre e lê da RAM
34: LOADAC 1
35: CMPI 33
36: BHI 7
37: MVREG R1
38: LOADRAM R1
39: LOADREG R2
40: MOVAC R1
41: ADDI 1
42: JUMP 35

43: NOP

; --- Início da verificação de primalidade de 751 ---

44: LOADREG R0, 751
45: LOADREG R1, 2
46: LOADREG R4, 1       ; assume que é primo
47: LOADREG R5, 28

; loop_divisor:
48: MOVAC R0
49: MVREG R3

; loop_sub:
50: SUB R1
51: BCC 54
52: MVREG R3
53: JUMP 49

; fim_sub:
54: MOVAC R3
55: CMPI 0
56: BHI 60
57: LOADAC 0
58: MVREG R4
59: JUMP 66

; continua:
60: MOVAC R1
61: ADDI 1
62: MVREG R1
63: CMP R5
64: BHI 66
65: JUMP 48

; fim:
66: MOVAC R4
67: MVREG R8     ; resultado (debug)
```

---

## 🔍 Interpretação Final

- O valor final em `R8` indica se 751 é primo:
  - `1` = é primo (nenhum divisor foi encontrado)
  - `0` = não é primo

Esse registrador pode ser lido via sinal de debug ou LED de visualização na FPGA.

---

## 📊 Observação

- O algoritmo pode ser adaptado para verificar outros números bastando alterar a instrução `LOADREG R0, número`.
- Tempo de execução cresce linearmente com o valor testado.


## 📌 Observações

- O acumulador é o registrador principal para operações aritméticas.
- Os registradores são codificados em 4 bits (de `0000` a `1000`, ou R0 a R8).
- Os imediatos são valores de 11 bits (de `0` a `2047`).
- Instruções que não usam todos os bits devem preencher os restantes com zeros.
- Instruções `MOVRAM` e `LOADRAM` utilizam dois bits extras (`instr(1)` e `instr(0)`) para diferenciação, já que compartilham o mesmo opcode `0000`.
