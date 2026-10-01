# 📱 App de Registro de Ponto com Geolocalização e Biometria

> **Avaliação Somativa em Flutter - Recursos de Hardware**  
> **Instituição:** SESI  
> **Tecnologias:** Flutter (Dart 3.13 / Flutter 3.47), Geolocalização (GPS), Biometria (`local_auth`), Firebase & Offline Storage.

---

## 📋 Sumário
- [Recursos do Aplicativo](#-recursos-do-aplicativo)
- [Estrutura do Projeto](#-estrutura-do-projeto)
- [Pré-requisitos](#-pré-requisitos)
- [Passo a Passo para Execução](#-passo-a-passo-para-execução)
- [Guia de Avaliação Rápida (Testando os 100m)](#-guia-de-avaliação-rápida-testando-os-100m)
- [Configuração do Firebase (Opcional)](#-configuração-do-firebase-opcional)
- [Execução dos Testes Automatizados](#-execução-dos-testes-automatizados)

---

## ✨ Recursos do Aplicativo

1. **Autenticação Dupla**:
   - Entrar via **NIF / Email e Senha** (Credenciais de demonstração pré-preenchidas na tela).
   - Entrar via **Biometria / Reconhecimento Facial** com suporte a hardware nativo.
2. **Trava de Geolocalização (Regra dos 100 Metros)**:
   - Cálculo automático da distância exata via GPS até a sede do trabalho.
   - **Status em Tempo Real**: Exibe indicador visual verde (Dentro do Raio) ou vermelho (Fora do Raio).
   - Bloqueio automático do registro caso o funcionário esteja fora dos 100 metros.
3. **Registro Completo de Ponto**:
   - Opções para `ENTRADA`, `SAÍDA ALMOÇO`, `RETORNO ALMOÇO` e `SAÍDA`.
   - Gravação com data, hora, coordenadas GPS (Latitude/Longitude), distância exata e método de autenticação utilizado.
4. **Histórico de Registros**:
   - Consulta detalhada dos pontos batidos com filtro de data e horário.
5. **Modo de Avaliação Prática**:
   - Recurso exclusivo na aba **Configurações** que permite definir com 1 clique a localização GPS atual do avaliador como o local de trabalho, permitindo testar a validação em qualquer lugar!

---

## 🏗️ Estrutura do Projeto

O código-fonte segue a **Clean Architecture** e o padrão **MVVM**:

```text
lib/
├── data/
│   ├── models/         # UserModel, PontoRecordModel, CompanyLocationModel
│   ├── services/       # BiometricService, LocationService, StorageService, FirebaseService
│   └── repositories/   # AuthRepository, PontoRepository, CompanyRepository
├── domain/
│   └── utils/          # DateFormatter, DistanceFormatter
└── ui/
    ├── core/           # Tema Material 3 e Widgets Reutilizáveis
    └── features/
        ├── auth/       # Login e Autenticação
        ├── ponto/      # Registro e Histórico de Pontos
        ├── home/       # Navegação em Abas (BottomNavigationBar)
        └── settings/   # Configurações do Local e Modo Teste
```

---

## 🛠️ Pré-requisitos

Antes de iniciar, certifique-se de ter instalado em seu computador:
*   [Flutter SDK](https://flutter.dev/docs/get-started/install) (versão 3.19 ou superior)
*   [Dart SDK](https://dart.dev/)
*   Dispositivo Físico (Android/iOS) ou Emulador/Simulador configurado com GPS habilitado.

---

## 🚀 Passo a Passo para Execução

1. **Clonar ou Abrir o Projeto**:
   Navegue até a pasta raiz do projeto no terminal.

2. **Obter as Dependências**:
   ```bash
   flutter pub get
   ```

3. **Executar no Dispositivo ou Emulador**:
   ```bash
   flutter run
   ```

---

## 🧪 Guia de Avaliação Rápida (Testando os 100m)

Para testar o aplicativo de forma prática e imediata:

1. **Fazer Login**:
   - Utilize o **NIF**: `100234` e **Senha**: `123456` (ou clique no botão de Biometria).
2. **Definir GPS Atual para Teste**:
   - Vá para a aba **Configurações**.
   - Clique no botão amarelo **`DEFINIR MEU GPS ATUAL COMO EMPRESA`**.
   - O aplicativo definirá sua posição exata como o local de trabalho (0m de distância).
3. **Bater Ponto com Sucesso**:
   - Volte para a aba **Bater Ponto**.
   - Observe que o status ficará verde **DENTRO DO RAIO (0 m)**.
   - Clique em **ENTRADA** para registrar o ponto com confirmação biométrica.
4. **Testar Bloqueio (Fora do Raio)**:
   - Vá em **Configurações** e ajuste o slider do raio para `50m` ou afaste-se da coordenada.
   - Observe o bloqueio automático dos botões caso esteja fora do raio estipulado.

---

## 🔥 Configuração do Firebase (Opcional)

O aplicativo foi construído com arquitetura de **Fallback Local Automático**. Ele funciona 100% offline via `SharedPreferences` se não houver arquivo do Firebase configurado.

Caso deseje vincular o aplicativo a um projeto real no Firebase Console:
1. Acesse o [Firebase Console](https://console.firebase.google.com/) e crie um novo projeto.
2. Adicione os aplicativos Android/iOS:
   - **Android Package Name**: `com.sesi.ponto.ponto_biometrico_app`
3. Baixe o arquivo `google-services.json` e coloque na pasta `android/app/`.
4. No console do Firebase, ative os serviços:
   - **Authentication**: Ativar método E-mail/Senha.
   - **Cloud Firestore**: Criar banco de dados no modo de teste.
5. O aplicativo detectará automaticamente o Firebase e sincronizará os dados em nuvem.

---

## 🧪 Execução dos Testes Automatizados

O projeto conta com uma suíte de testes unitários para validar toda a lógica de negócio e cálculos geográficos.

Para rodar a suíte de testes, execute:
```bash
flutter test
```

**Resultado esperado:**
```text
00:01 +5: All tests passed!
```

---

## 📄 Licença e Entrega

Projeto desenvolvido exclusivamente para a **Avaliação Somativa em Flutter - Recursos de Hardware**. Todos os direitos reservados.
