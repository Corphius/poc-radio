---
title: Diagramas UML e Fluxos
aliases:
  - Diagramas da POC
tags:
  - sagres
  - uml
  - mermaid
  - arquitetura
status: atual
---

# Diagramas UML e fluxos

> [!tip] Obsidian
> Os diagramas abaixo usam Mermaid nativo. Abra a nota em modo de leitura para
> renderizá-los.

## Diagrama de casos de uso

O Mermaid não possui uma notação UML de casos de uso nativa; o fluxo abaixo usa
atores e elipses equivalentes, mantendo renderização sem plugins no Obsidian.

```mermaid
flowchart LR
    listener[👤 Ouvinte]
    os[⚙️ Sistema operacional]
    team[👥 Equipe Sagres]

    subgraph app[Aplicativo Sagres]
        play([Ouvir rádio ao vivo])
        pause([Pausar transmissão])
        retry([Tentar novamente])
        navigate([Navegar entre áreas])
        schedule([Consultar programação])
        news([Visualizar notícias])
        profile([Visualizar perfil])
        background([Controlar áudio em segundo plano])
        validate([Validar experiência da POC])
    end

    listener --> play
    listener --> pause
    listener --> retry
    listener --> navigate
    navigate -. inclui .-> schedule
    navigate -. inclui .-> news
    navigate -. inclui .-> profile
    os --> background
    background -. estende .-> play
    team --> validate
```

## Sequência de inicialização

```mermaid
sequenceDiagram
    autonumber
    participant Main as main.dart
    participant Boot as bootstrap
    participant AS as AudioService
    participant Handler as SagresAudioHandler
    participant DI as ProviderScope
    participant UI as SagresApp

    Main->>Boot: bootstrap()
    Boot->>AS: init<SagresAudioHandler>()
    AS->>Handler: criar handler
    Handler-->>Boot: instância pronta
    Boot->>Boot: criar AudioServicePlayerAdapter
    Boot->>DI: override AudioPlayerPort
    DI->>UI: runApp(SagresApp)
```

## Sequência de reprodução bem-sucedida

```mermaid
sequenceDiagram
    autonumber
    actor O as Ouvinte
    participant UI as LiveRadioScreen
    participant C as LiveRadioController
    participant P as AudioPlayerPort
    participant A as AudioServicePlayerAdapter
    participant H as SagresAudioHandler
    participant J as just_audio
    participant S as Stream Sagres
    participant SO as Android/iOS

    O->>UI: toca no botão play
    UI->>C: toggle()
    C->>C: publicar loading
    C->>P: play(LiveStation.sagres)
    P->>A: implementação injetada
    A->>H: playStation(station)
    H->>SO: configurar AudioSession
    H->>J: setUrl(streamUrl)
    J->>S: abrir conexão HTTPS
    S-->>J: áudio MP3 contínuo
    H->>J: play()
    J-->>H: PlayerState(playing)
    H-->>C: PlaybackSnapshot(playing)
    H-->>SO: PlaybackState + controles
    C-->>UI: estado playing
    UI->>UI: iniciar ondas, equalizador e glow
```

## Sequência de pausa

```mermaid
sequenceDiagram
    autonumber
    actor O as Ouvinte
    participant UI as LiveRadioScreen
    participant C as LiveRadioController
    participant P as AudioPlayerPort
    participant H as SagresAudioHandler
    participant J as just_audio

    O->>UI: toca no botão pause
    UI->>C: toggle()
    C->>P: pause()
    P->>H: pause()
    H->>J: pause()
    J-->>H: PlayerState(ready, playing=false)
    H-->>C: PlaybackSnapshot(paused)
    C-->>UI: estado paused
    UI->>UI: parar animações e voltar ao frame inicial
```

## Sequência de falha e retry

```mermaid
sequenceDiagram
    autonumber
    actor O as Ouvinte
    participant UI as LiveRadioScreen
    participant C as LiveRadioController
    participant A as Adapter de áudio
    participant S as Stream / Rede

    O->>UI: toca em play
    UI->>C: play()
    C->>A: play(station)
    A->>S: conectar
    S--xA: DNS, timeout ou stream indisponível
    A--xC: PlaybackFailure
    C->>C: publicar failure + mensagem
    C-->>UI: estado failure
    UI-->>O: exibir erro e Tentar novamente
    O->>UI: toca em Tentar novamente
    UI->>C: play()
    C->>A: nova tentativa
```

## Diagrama de componentes

```mermaid
flowchart TB
    subgraph presentation[Presentation]
        shell[AppShell]
        live[LiveRadioScreen]
        schedule[ScheduleScreen]
        news[NewsScreen]
        profile[ProfileScreen]
    end

    subgraph application[Application]
        controller[LiveRadioController]
        providers[Riverpod Providers]
    end

    subgraph domain[Domain]
        station[LiveStation]
        state[PlaybackSnapshot]
        playerPort[AudioPlayerPort]
        schedulePort[ScheduleRepository]
    end

    subgraph infrastructure[Infrastructure]
        audioAdapter[AudioServicePlayerAdapter]
        audioHandler[SagresAudioHandler]
        scheduleMemory[InMemoryScheduleRepository]
        newsMemory[InMemoryNewsRepository]
    end

    shell --> live
    shell --> schedule
    shell --> news
    shell --> profile
    live --> providers
    providers --> controller
    controller --> playerPort
    audioAdapter -. implementa .-> playerPort
    audioAdapter --> audioHandler
    scheduleMemory -. implementa .-> schedulePort
    live --> scheduleMemory
    schedule --> scheduleMemory
    news --> newsMemory
    controller --> station
    controller --> state
```

## Navegação

```mermaid
flowchart LR
    shell[AppShell / IndexedStack]
    shell --> home[Início / rádio]
    shell --> schedule[Programação]
    shell --> news[Notícias]
    shell --> profile[Você]
```

---

Anterior: [[03-Modelo-de-Dominio]] · Próximo: [[05-Testes-e-Qualidade]]
