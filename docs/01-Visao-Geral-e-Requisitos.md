---
title: Visão Geral e Requisitos
aliases:
  - Levantamento de requisitos
tags:
  - sagres
  - requisitos
  - produto
status: atual
---

# Visão geral e levantamento de requisitos

## Problema

A Rádio Sagres precisa validar uma experiência mobile própria para consumo da
transmissão ao vivo, preservando sua identidade visual e permitindo uma futura
evolução para programação, notícias, podcasts e relacionamento com ouvintes.

## Objetivo da POC

Comprovar, com baixo custo e sem backend, que o aplicativo consegue:

- reproduzir o stream oficial em Android e iOS;
- continuar a reprodução em segundo plano;
- representar de forma clara os estados do player;
- manter navegação e identidade visual coerentes;
- isolar plugins e fontes de dados por portas e adaptadores;
- ser validado por testes automatizados.

## Atores

| Ator | Responsabilidade ou interesse |
|---|---|
| Ouvinte | Iniciar, pausar e acompanhar a transmissão |
| Sistema operacional | Controlar mídia, interrupções e segundo plano |
| Servidor de streaming | Entregar áudio MP3 ao vivo |
| Equipe Sagres | Avaliar produto, marca e viabilidade técnica |
| Equipe de desenvolvimento | Evoluir adaptadores e integrações |

## Requisitos funcionais

| ID | Requisito | Prioridade | Situação |
|---|---|---:|---|
| RF-01 | Exibir a estação Sagres AM 730 e seu estado atual | Alta | Implementado |
| RF-02 | Iniciar a transmissão ao vivo por ação do ouvinte | Alta | Implementado |
| RF-03 | Pausar a transmissão ao vivo | Alta | Implementado |
| RF-04 | Exibir os estados ocioso, carregando, tocando, pausado e falha | Alta | Implementado |
| RF-05 | Permitir nova tentativa após falha de conexão | Alta | Implementado |
| RF-06 | Reproduzir áudio em segundo plano | Alta | Implementado |
| RF-07 | Expor controles na notificação/tela bloqueada | Alta | Implementado |
| RF-08 | Animar ondas, equalizador e brilho somente enquanto toca | Média | Implementado |
| RF-09 | Navegar entre Início, Programação, Notícias e Você | Alta | Implementado |
| RF-10 | Exibir uma grade demonstrativa por dia | Média | Implementado |
| RF-11 | Exibir notícias demonstrativas | Baixa | Implementado |
| RF-12 | Exibir um perfil demonstrativo | Baixa | Implementado |
| RF-13 | Destacar o programa correspondente ao horário atual | Média | Implementado |

## Requisitos não funcionais

| ID | Requisito | Evidência atual |
|---|---|---|
| RNF-01 | O domínio não deve depender de plugins Flutter | `AudioPlayerPort` no domínio |
| RNF-02 | A integração de áudio deve ser substituível | `AudioServicePlayerAdapter` |
| RNF-03 | A lógica deve ser testável sem rede | `FakeAudioPlayer` |
| RNF-04 | O app deve suportar Android e iOS | Projetos nativos gerados e configurados |
| RNF-05 | A interface deve comunicar loading e falhas | `LiveRadioState` e `PlaybackSnapshot` |
| RNF-06 | O layout deve ser rolável em telas compactas | `CustomScrollView` e `ListView` |
| RNF-07 | Controles devem possuir semântica básica | Widgets `Semantics` e labels |
| RNF-08 | A suíte local deve passar em ambiente Flutter | `flutter analyze` e `flutter test` |
| RNF-09 | O fluxo crítico deve ser testável em dispositivo | `integration_test/app_flow_test.dart` |
| RNF-10 | A documentação deve funcionar no Obsidian | Markdown, YAML, wikilinks e Mermaid |

## Regras de negócio

- RN-01: apenas uma estação é carregada nesta POC: Sagres AM 730.
- RN-02: comandos de play duplicados são ignorados durante loading ou playing.
- RN-03: pause é enviado ao adaptador somente quando o estado é playing.
- RN-04: uma falha técnica é convertida em mensagem compreensível ao usuário.
- RN-05: animações visuais dependem exclusivamente do estado `playing`.
- RN-06: controles anterior/próximo não executam ações em uma transmissão ao vivo.
- RN-07: programação e notícias devem ser identificadas como demonstrativas.

## Critérios de aceite da POC

- [x] O aplicativo compila para Android.
- [x] O stream MP3 é reproduzido em emulador com rede disponível.
- [x] Play e pause atualizam áudio e interface.
- [x] Erros de rede apresentam retry.
- [x] Ondas, equalizador e botão param ao pausar.
- [x] As quatro áreas são navegáveis.
- [x] Testes unitários e de widgets passam.
- [x] O fluxo E2E passa em emulador Android.
- [x] O domínio não importa `just_audio` ou `audio_service`.

## Fora do escopo

- autenticação e cadastro;
- persistência remota de favoritos;
- downloads e reprodução offline;
- podcasts sob demanda;
- Chromecast e AirPlay;
- push notifications;
- integração real com CMS de notícias ou grade;
- métricas de audiência;
- backend próprio.

---

Anterior: [[00-Inicio]] · Próximo: [[02-Arquitetura]]
