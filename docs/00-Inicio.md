---
title: POC Rádio Sagres - Documentação
aliases:
  - Documentação da POC Rádio Sagres
tags:
  - sagres
  - flutter
  - poc
  - documentacao
status: atual
---

# POC Rádio Sagres

> [!abstract] Objetivo
> Centralizar a documentação funcional e técnica da prova de conceito mobile da
> Rádio Sagres AM 730. As notas usam Markdown, propriedades, links internos,
> callouts e Mermaid compatíveis com Obsidian.

## Mapa da documentação

1. [[01-Visao-Geral-e-Requisitos|Visão geral e levantamento de requisitos]]
2. [[02-Arquitetura|Arquitetura e responsabilidades]]
3. [[03-Modelo-de-Dominio|Modelo de domínio]]
4. [[04-Diagramas-UML|Diagramas UML e fluxos]]
5. [[05-Testes-e-Qualidade|Testes e qualidade]]
6. [[06-Execucao-e-Operacao|Execução e operação]]
7. [[07-Decisoes-Limitacoes-e-Evolucao|Decisões, limitações e evolução]]

## Resumo executivo

A POC valida um aplicativo Flutter para Android e iOS capaz de reproduzir o
stream oficial da Sagres, continuar tocando em segundo plano e responder aos
controles de mídia do sistema. A interface possui quatro áreas: Início,
Programação, Notícias e Você.

O rádio é funcional. Programação, notícias e perfil usam dados demonstrativos
para validar navegação, identidade visual e separação arquitetural. Não existe
backend nesta versão.

| Item | Situação |
|---|---|
| Stream ao vivo | Funcional |
| Play, pause e retry | Funcional |
| Segundo plano | Configurado para Android e iOS |
| Ondas e equalizador | Animados apenas durante reprodução |
| Programação | Demonstrativa, em memória |
| Notícias | Demonstrativas, em memória |
| Perfil | Protótipo visual |
| Testes automatizados | Unitários, widgets e E2E |
| Backend | Fora do escopo atual |

> [!info] Fonte do áudio
> `https://cast4.audiostream.com.br:20010/stream`

## Atalhos

- Código principal: `lib/`
- Testes locais: `test/`
- Teste em dispositivo: `integration_test/app_flow_test.dart`
- Instruções rápidas: `README.md`
- Capa da rádio: `assets/images/sagres-cover.jpg`

## Convenções Obsidian

- Abra `docs/` como vault ou inclua o repositório em um vault existente.
- Use a visualização de leitura para renderizar os diagramas Mermaid.
- Os links internos entre notas funcionam sem configuração adicional.
- As propriedades YAML permitem filtrar notas por `tags` e `status`.

---

Relacionados: [[01-Visao-Geral-e-Requisitos]] · [[02-Arquitetura]] ·
[[04-Diagramas-UML]]
