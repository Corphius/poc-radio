# Sagres AM 730 — POC Flutter

Prova de conceito mobile para validar a experiência de ouvir a Rádio Sagres ao
vivo em Android e iOS. O áudio usa o stream público exibido na página oficial:

`https://cast4.audiostream.com.br:20010/stream`

Programação, notícias e perfil são dados demonstrativos. Isso é indicado na
interface para não confundir protótipo com integração editorial pronta.

## Documentação

A documentação funcional e técnica completa está em
[`docs/00-Inicio.md`](docs/00-Inicio.md). A pasta pode ser aberta diretamente no
Obsidian e contém levantamento de requisitos, arquitetura, modelo de domínio,
diagramas Mermaid, estratégia de testes, operação e roadmap.

## Escopo validado

- Reprodução, pausa, carregamento, falha e nova tentativa.
- Reprodução em segundo plano e controles de mídia do sistema.
- Navegação entre Início, Programação, Notícias e Você.
- Estrutura hexagonal por funcionalidade.
- Testes unitários, de widgets e fluxo E2E.
- Build Android em APK de debug.

Ficam fora desta POC: autenticação, favoritos reais, downloads, notificações,
casting, podcasts sob demanda e APIs de programação/notícias.

## Arquitetura

Cada funcionalidade separa regras, orquestração, integrações e widgets:

```text
lib/
├── app/                         # bootstrap, tema e composição
├── core/                        # falhas compartilhadas
└── features/
    ├── live_radio/
    │   ├── domain/              # entidades e porta AudioPlayerPort
    │   ├── application/         # LiveRadioController
    │   ├── infrastructure/      # just_audio + audio_service
    │   └── presentation/        # tela e providers
    ├── schedule/                # porta e adaptador em memória
    ├── news/                    # modelos e adaptador em memória
    ├── profile/                 # protótipo visual
    └── shell/                   # navegação principal
```

O domínio não conhece Flutter nem os plugins de áudio. O adaptador
`AudioServicePlayerAdapter` implementa a porta e permite que testes usem um
player determinístico sem acessar rede ou APIs nativas.

## Ambiente Linux

- Flutter 3.44.6 (stable)
- Dart 3.12.2
- Android SDK 36.1
- JDK 21 do Android Studio

O Flutter foi instalado em `/home/matheus/develop/flutter`. As variáveis foram
adicionadas a `~/.zshenv`; abra um novo terminal antes de executar os comandos.

Se o terminal atual ainda não encontrar o comando `flutter`, recarregue o
ambiente:

```bash
source ~/.zshenv
flutter doctor -v
```

O `flutter doctor` deve reconhecer o Flutter, o Android SDK, o JDK e as licenças
Android. A ausência do Chrome não impede a execução desta POC, pois o projeto
tem como alvos Android e iOS.

### Executar no emulador Android

Entre no projeto e restaure as dependências:

```bash
cd /home/matheus/Projetos/instituto_sagres/08_radio/poc-radio
flutter pub get
```

O emulador Android 15 criado nesta máquina se chama `sagres_api35`. Inicie-o
com:

```bash
flutter emulators --launch sagres_api35
```

Espere a janela do Android terminar de inicializar e confirme o identificador
do dispositivo:

```bash
flutter devices
```

Quando aparecer `emulator-5554`, execute a POC:

```bash
flutter run -d emulator-5554
```

Durante a execução, use `r` para hot reload, `R` para hot restart, `d` para
desconectar o terminal mantendo o aplicativo aberto e `q` para encerrar o app.

Se o identificador do emulador for diferente, use o valor mostrado por
`flutter devices` no argumento `-d`.

Para desligar o emulador pela linha de comando:

```bash
adb -s emulator-5554 emu kill
```

### Executar em aparelho Android físico

Ative as opções de desenvolvedor e a depuração USB no aparelho, conecte-o ao
Linux e autorize a chave RSA exibida na tela. Depois execute:

```bash
adb devices -l
flutter devices
flutter run -d <device-id>
```

### Solução rápida de conexão

Se o emulador estiver aberto, mas não aparecer no Flutter:

```bash
adb kill-server
adb start-server
adb devices -l
flutter devices
```

Também é possível iniciar o AVD diretamente pelo Android SDK:

```bash
emulator @sagres_api35
```

## Qualidade e testes

Execute a análise e os testes locais a partir da raiz do projeto:

```bash
flutter analyze
flutter test
flutter test --coverage
```

Com o emulador em execução, rode o fluxo E2E:

```bash
flutter test integration_test/app_flow_test.dart -d emulator-5554
```

Para gerar um APK de debug:

```bash
flutter build apk --debug
```

O artefato será criado em:

`build/app/outputs/flutter-apk/app-debug.apk`

## Próxima evolução

Um backend não é necessário para validar o streaming. Ele passa a fazer sentido
quando a rádio quiser administrar remotamente a URL, fornecer grade e notícias
reais, autenticar ouvintes ou enviar notificações. Nesse cenário, a porta já
permite trocar os adaptadores em memória por clientes HTTP sem alterar a UI.
