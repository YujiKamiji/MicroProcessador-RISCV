# Ferramentas
GHDL=ghdl
GHDLFLAGS=--std=08

# Diretórios com fontes principais
SRC_DIRS = Banc_ULA/banc_reg \
           Banc_ULA/DeMuxes \
           Banc_ULA/registrador \
           Banc_ULA/ULA \
           Banc_ULA \
           FSM \
           Memoria \
           PC \
           UC

# Diretório do Top-Level
TOP_LEVEL = Processador.vhd
TOP_ENTITY = Processador

# Arquivos .vhd exceto testbenches
SOURCES = $(foreach dir,$(SRC_DIRS),$(filter-out %_tb.vhd, $(wildcard $(dir)/*.vhd))) $(TOP_LEVEL)

# Alvo padrão: compilar tudo
all: $(TOP_ENTITY)

# Compila os arquivos
$(TOP_ENTITY):
	$(GHDL) -i $(GHDLFLAGS) $(SOURCES)
	$(GHDL) -m $(GHDLFLAGS) $(TOP_ENTITY)

# Simulação
sim:
	$(GHDL) -r $(TOP_ENTITY) --vcd=wave.vcd

# Limpeza
clean:
	rm -f *.o *.cf *.vcd $(TOP_ENTITY)

