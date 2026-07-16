---
title: Execução e Operação
aliases:
  - Como executar a POC
tags:
  - sagres
  - operacao
  - linux
  - flutter
status: atual
---

# Execução e operação

## Ambiente validado

| Ferramenta | Versão/Configuração |
|---|---|
| Flutter | 3.44.6 stable |
| Dart | 3.12.2 |
| Android SDK | 36.1 |
| JDK | 21, fornecido pelo Android Studio |
| AVD | `sagres_api35`, Android 15 API 35 |

## Preparar terminal Linux

```bash
source ~/.zshenv
cd /home/matheus/Projetos/instituto_sagres/08_radio/poc-radio
flutter pub get
flutter doctor -v
```

## Iniciar emulador com rede estável

O AVD apresentou falha de DNS ao usar a configuração automática. O comando
validado usa DNS explícito e não salva snapshots:

```bash
emulator @sagres_api35 \
  -dns-server 8.8.8.8,1.1.1.1 \
  -no-snapshot-load \
  -no-snapshot-save
```

Em outro terminal:

```bash
flutter devices
flutter run -d emulator-5554
```

## Comandos durante desenvolvimento

| Tecla | Ação |
|---|---|
| `r` | Hot reload |
| `R` | Hot restart |
| `d` | Desanexar terminal e manter app aberto |
| `q` | Encerrar aplicativo |

## Encerrar

```bash
adb -s emulator-5554 emu kill
```

## Diagnóstico do stream

### Sintoma

```text
UnknownHostException: Unable to resolve host
```

Isso indica DNS/rede do dispositivo, não ausência da permissão no app.

### Verificações

```bash
adb devices -l
adb shell dumpsys package br.org.institutosagres.sagres_radio
adb shell ping -c 1 cast4.audiostream.com.br
adb shell 'toybox nc -z -w 5 cast4.audiostream.com.br 20010'
```

Se necessário, encerre o AVD e reinicie com o comando de DNS explícito acima.

## Build Android

```bash
flutter build apk --debug
```

Saída:

`build/app/outputs/flutter-apk/app-debug.apk`

## Limpeza segura

```bash
flutter clean
rm -rf coverage
```

Esses caminhos são regeneráveis. Não remova `lib/`, `assets/`, `test/`,
`integration_test/`, `android/` ou `ios/`.

## Observabilidade atual

A POC utiliza logs do Flutter, `audio_service` e player nativo. Ainda não existe
telemetria, crash reporting ou métricas de audiência.

---

Anterior: [[05-Testes-e-Qualidade]] · Próximo:
[[07-Decisoes-Limitacoes-e-Evolucao]]
