---
title: Decisões, Limitações e Evolução
tags:
  - sagres
  - decisoes
  - roadmap
  - arquitetura
status: atual
---

# Decisões, limitações e evolução

## Decisões arquiteturais

### Sem backend na POC

**Decisão:** o aplicativo consome o stream HTTPS diretamente.

**Motivo:** o principal risco a validar é reprodução mobile e experiência do
ouvinte. Um backend não agrega valor imediato a esse teste.

### Hexagonal pragmática

**Decisão:** aplicar domínio, portas e adapters por funcionalidade, evitando
pacotes ou abstrações sem uso real.

**Consequência:** o player e a grade podem ser substituídos sem reescrever a UI,
mas telas puramente demonstrativas permanecem simples.

### Dados em memória

**Decisão:** programação e notícias são locais.

**Consequência:** a POC funciona sem CMS, porém não representa conteúdo real e
não deve ser publicada como produto final.

### Animações orientadas pelo estado do áudio

**Decisão:** ondas, equalizador e glow dependem de `PlaybackStatus.playing`.

**Consequência:** não existe divergência entre aparência e reprodução.

## Limitações conhecidas

- apenas uma estação;
- URL embutida no aplicativo;
- grade igual para todos os dias;
- dados editoriais fictícios;
- ações de favorito, compartilhar e microfone são visuais;
- sem casting;
- sem persistência;
- sem telemetria;
- mensagens de falha não distinguem causas técnicas;
- iOS não foi validado em hardware neste ambiente Linux;
- dependência da disponibilidade do servidor externo.

## Quando criar um backend

Um backend Node.js/TypeScript passa a ser indicado quando houver necessidade de:

- alterar URL e metadados sem publicar nova versão;
- servir grade e programa atual reais;
- integrar notícias e podcasts ao CMS;
- autenticar ouvintes;
- persistir favoritos;
- enviar notificações;
- registrar métricas de audiência;
- ocultar ou mediar integrações privadas.

Estrutura sugerida:

```text
backend/src/
├── domain/
├── application/
├── ports/
├── adapters/
│   ├── http/
│   ├── persistence/
│   └── sagres/
└── main/
```

## Roadmap sugerido

### Fase 1 — conteúdo real

- [ ] Confirmar grade oficial e responsáveis.
- [ ] Definir fonte oficial de notícias.
- [ ] Criar configuração remota da estação.
- [ ] Implementar adapters HTTP e cache.

### Fase 2 — experiência do ouvinte

- [ ] Favoritos locais.
- [ ] Compartilhamento real.
- [ ] Podcasts sob demanda.
- [ ] Interrupções de áudio e reconexão automática refinadas.
- [ ] Acessibilidade auditada.

### Fase 3 — plataforma

- [ ] Backend hexagonal em Node.js/TypeScript.
- [ ] Autenticação e perfil real.
- [ ] Push notifications.
- [ ] Métricas e observabilidade.
- [ ] CI/CD Android e iOS.

## Critérios antes de produção

- política de privacidade e termos;
- autorização formal para uso de marca, conteúdo e stream;
- testes em aparelhos Android/iOS reais;
- monitoramento de disponibilidade do stream;
- revisão de bateria e uso de dados;
- tratamento de interrupções, Bluetooth e headset;
- ícones, splash e assinatura de release;
- publicação em lojas e conformidade com políticas.

---

Anterior: [[06-Execucao-e-Operacao]] · Início: [[00-Inicio]]
