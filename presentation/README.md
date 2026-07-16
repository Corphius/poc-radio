# Apresentação comercial da POC

Arquivo principal:

- `Apresentacao_Comercial_POC_Radio_Sagres.pptx`
- `Apresentacao_Comercial_POC_Radio_Sagres.pdf`

A apresentação foi construída em 16:9 com base no `MANUAL DA MARCA.pdf`
fornecido para o projeto. Foram adotados:

- vermelho primário `#983B2E`;
- amarelo primário `#FCAF26`;
- cores secundárias `#F58229`, `#D67430` e `#DD592D`;
- Calibri, fonte indicada pelo manual para aplicações Office;
- ícones de traço simples e cantos arredondados;
- assinatura Sagres AM 730 extraída do próprio manual;
- capturas reais da POC executada em Android 15.

Para regenerar o arquivo:

```bash
python -m venv /tmp/poc-radio-pptx-venv
/tmp/poc-radio-pptx-venv/bin/pip install python-pptx pillow
/tmp/poc-radio-pptx-venv/bin/python presentation/generate_deck.py
```

O arquivo pode ser aberto no PowerPoint, LibreOffice Impress ou importado no
Canva.
