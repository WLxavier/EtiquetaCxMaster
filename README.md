# EtiquetaCxMaster

**Relatório para Reimpressão de Etiquetas de Caixa Master**

## Descrição

Este projeto foi desenvolvido para otimizar a reimpressão de etiquetas de caixas master (caixas fechadas de produtos) no ambiente do sistema **Winthor**. Através de um relatório auxiliar, o projeto permite que os funcionários realizem a reimpressão de etiquetas de maneira rápida e prática, eliminando etapas manuais e economizando um tempo significativo no fluxo de trabalho logístico.

### Objetivo

A ferramenta foi criada com o objetivo de facilitar o processo de reimpressão de etiquetas, proporcionando maior agilidade e eficiência operacional. Ela foi desenhada para ser intuitiva, garantindo que qualquer funcionário, independentemente do conhecimento técnico, possa usá-la sem complicações. A reemissão de etiquetas, que antes era um processo moroso e suscetível a erros, se torna muito mais rápida e precisa, otimizando as operações de expedição.

## Funcionalidades

- **Reimpressão Simplificada**: Permite que os funcionários reimprimam etiquetas de caixa master de forma prática, com apenas alguns cliques.
- **Template Personalizado**: O layout das etiquetas é configurado conforme o arquivo `REL8049.RTM`, garantindo que todas as informações importantes estejam bem organizadas e visíveis.
- **Automação de Tarefas**: Reduz a intervenção manual, automatizando o processo de reemissão e proporcionando mais eficiência no setor.

## Estrutura do Projeto

- **ETIQUETA.jpg**: Exemplo visual da etiqueta utilizada no sistema, mostrando o layout e as informações essenciais para a identificação da caixa master.
- **REL8049.RTM**: Arquivo de template que define a estrutura visual da etiqueta no sistema Winthor, adaptando o layout para atender às necessidades do setor de expedição.
- **REL8049.SQL**: Script PL/SQL que realiza a consulta e manipulação dos dados no banco de dados Oracle, extraindo e organizando as informações necessárias para a geração do relatório de etiquetas.

## Tecnologias Utilizadas

- **PL/SQL**: Para manipulação de dados e configuração do relatório no banco de dados Oracle, garantindo a precisão e confiabilidade das informações.
- **Winthor Reporting Tool**: Ferramenta responsável pela configuração visual e integração do relatório ao sistema Winthor.
- **Oracle Database**: Banco de dados relacional onde são executadas as consultas e operações de reimpressão.

## Benefícios do Projeto

- **Agilidade Operacional**: Ao simplificar o processo de reimpressão, o projeto melhora a eficiência do fluxo de trabalho e reduz o tempo de espera dos funcionários.
- **Autonomia e Produtividade**: A ferramenta permite que os funcionários realizem a tarefa sem necessidade de assistência técnica, promovendo maior independência e uma operação mais fluida.
- **Redução de Erros**: Automatizando o processo, minimiza a possibilidade de erros humanos e garante a consistência das informações impressas nas etiquetas.
