Aqui está um exemplo de `README.md` para o seu repositório no GitHub:

---

# Sistema de Apoio Acadêmico

Este projeto foi desenvolvido para implementar uma nova estratégia em uma universidade, com o objetivo de ajudar alunos que estão com desempenho acadêmico abaixo do esperado. O sistema automatiza a identificação de alunos que precisam de suporte, facilitando o acompanhamento por parte dos professores.

## Visão Geral

O sistema monitora as médias de notas dos alunos e, caso a média geral de um aluno fique **abaixo de 7.1**, ele é automaticamente inserido em uma tabela de apoio no banco de dados. Essa funcionalidade permite que os professores identifiquem rapidamente quais alunos precisam de atenção especial para melhorar seu desempenho acadêmico.

## Funcionalidades

- **Monitoramento Automático**: Verifica automaticamente as médias de notas dos alunos após cada inserção ou atualização no banco de dados de provas.
- **Sinalização de Alunos**: Inclui automaticamente os alunos com média geral inferior a 7.1 na tabela de apoio.
- **Suporte Acadêmico**: Facilita a identificação de alunos com dificuldades para que os professores possam oferecer apoio específico.

## Tecnologias Utilizadas

- **Banco de Dados**: SQL Server
- **Triggers**: Utilizados para calcular automaticamente as médias e inserir/remover alunos da tabela de apoio conforme o desempenho acadêmico.
- **Linguagem SQL**: Para a criação e manipulação do banco de dados.

## Como Funciona

1. O sistema calcula a **média geral** de cada aluno com base nas suas notas de provas.
2. Se a média for **inferior a 7.1**, o aluno é inserido na tabela `ApoioAlunos`.
3. Caso a média seja ajustada para um valor maior ou igual a 7.1, o aluno é automaticamente removido da tabela de apoio.


