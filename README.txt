# 🔧 Processador Customizado - 19 Bits

Este projeto implementa um processador simples de 19 bits em VHDL. Ele foi desenvolvido com fins didáticos para estudar arquitetura de computadores, instruções customizadas, controle de fluxo e manipulação de dados com acumulador e registradores.

---

## 📐 Formato da Instrução

Todas as instruções possuem 19 bits, sendo os 4 mais significativos destinados ao opcode e os demais variando conforme o tipo da instrução.

| Bits       | Descrição                 |
|------------|---------------------------|
| [18:15]    | Opcode (4 bits)           |
| [14:0]     | Campos específicos         |

---

## 🧮 Tipos de Instrução

### 1. **Operações entre AC e registradores**  
Instruções como `ADD`, `SUB`, `AND`, `CMP` operam entre o acumulador (AC) e um registrador do banco.

| Bits     | Função                       |
|----------|------------------------------|
| [18:15]  | Opcode                       |
| [14:11]  | Registrador fonte (R0–R8)    |
| [10:0]   | Não utilizado (zeros)        |

📌 Exemplo: `ADD R4` → `0001 0100 00000000000`

---

### 2. **Operações com imediato**  
Instruções como `ADDI`, `SUBI`, `CMPI` operam entre o AC e um valor imediato.

| Bits     | Função                 |
|----------|------------------------|
| [18:15]  | Opcode                 |
| [14:11]  | Ignorados              |
| [10:0]   | Imediato (11 bits)     |

📌 Exemplo: `SUBI 1` → `1011 0000 00000000001`

---

### 3. **Carga em registrador (LOADREG)**  
Carrega um valor imediato diretamente para um registrador.

| Bits     | Função                   |
|----------|--------------------------|
| [18:15]  | Opcode (`0110`)          |
| [14:11]  | Registrador destino      |
| [10:0]   | Imediato (11 bits)       |

📌 Exemplo: `LOADREG R3, 5` → `0110 0011 00000000101`

---

### 4. **Transferência entre AC e registradores**

- **MVAC** → Move de registrador para acumulador  
  📌 `Opcode = 1000`  
  📌 AC ← REG

- **MVREG** → Move do acumulador para registrador  
  📌 `Opcode = 1010`  
  📌 REG ← AC

| Bits     | Função                   |
|----------|--------------------------|
| [18:15]  | Opcode                   |
| [14:11]  | Registrador              |
| [10:0]   | Não utilizados (zeros)   |

---

### 5. **Carga direta no acumulador (LOADAC)**

| Bits     | Função                   |
|----------|--------------------------|
| [18:15]  | Opcode (`0100`)          |
| [10:0]   | Imediato (11 bits)       |
| [14:11]  | Ignorados                |

---

### 6. **Instruções de salto (JUMP, BHI, BCC)**

| Bits     | Função                   |
|----------|--------------------------|
| [18:15]  | Opcode                   |
| [14:8]   | Endereço (7 bits)        |
| [7:0]    | Zeros/ignorado           |

📌 Exemplo: `JUMP 20` → `0010 0010100 00000000`

---

### 7. **NOP**  
Não realiza nenhuma operação.

📌 `0000 0000 00000000000`

---

## 🔢 Tabela de Opcodes

| Instrução | Opcode |
|----------|--------|
| NOP      | 0000   |
| ADD      | 0001   |
| JUMP     | 0010   |
| SUB      | 0011   |
| LOADAC   | 0100   |
| AND      | 0101   |
| LOADREG  | 0110   |
| CMP      | 0111   |
| MVAC     | 1000   |
| ADDI     | 1001   |
| MVREG    | 1010   |
| SUBI     | 1011   |
| BHI      | 1100   |
| BCC      | 1110   |
| CMPI     | 1111   |

---