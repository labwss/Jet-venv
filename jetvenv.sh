#!/bin/bash
clear

read -p "Digite o nome do projeto (ex: extrator_uber): " project_name

if [ -z "$project_name" ]; then
    echo "Nome do projeto nao pode ser vazio."
    exit 1
fi

if [ -d "$project_name" ]; then
    echo "A pasta '$project_name' ja existe. Operacao cancelada."
    exit 1
fi

# Verifica python
if ! command -v python3 &> /dev/null; then
    echo "Python3 nao esta instalado."
    exit 1
fi

echo ""
echo "Criando projeto '$project_name'..."

mkdir "$project_name" || { echo "Erro ao criar pasta."; exit 1; }
cd "$project_name" || exit 1

mkdir dados
touch main.py
touch requirements.txt

# Criando e pré-populando o .gitignore
echo "venv/" > .gitignore
echo "__pycache__/" >> .gitignore
echo "*.pyc" >> .gitignore
echo ".env" >> .gitignore

echo "Criando ambiente virtual..."
python3 -m venv venv || { echo "Erro ao criar venv."; exit 1; }

echo "Atualizando o pip..."
venv/bin/python -m pip install --upgrade pip -q

echo ""
echo "Ativando ambiente virtual em um novo shell..."

# Exporta variável para indicar que veio do script (opcional)
export PROJECT_NAME="$project_name"

# Abre novo shell com venv ativo, preservando o ~/.bashrc do usuário
exec bash --rcfile <(echo "
if [ -f ~/.bashrc ]; then source ~/.bashrc; fi
source venv/bin/activate
echo ''
echo 'Ambiente virtual ativado ✔'
echo 'Projeto: $project_name'
echo 'Para sair do ambiente: deactivate'
")
