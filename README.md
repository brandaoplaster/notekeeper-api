# NoteKeeper API

API REST para gerenciamento de notas desenvolvida com Ruby on Rails.

## Frontend

O frontend desta aplicação está em um repositório separado:

**Repository:** [notekeeper-front](https://github.com/brandaoplaster/notekeeper-front)

```bash
git clone git@github.com:brandaoplaster/notekeeper-front.git
```

A API está configurada para aceitar requisições do frontend rodando em `http://localhost:5173` (configurável via variável `ALLOWED_ORIGINS` no arquivo `.env`).

## Tecnologias

- Ruby 3.4.5
- Rails 8.0.1
- PostgreSQL 17
- Docker & Docker Compose

## Pré-requisitos

- Docker
- Docker Compose

## Configuração do Ambiente

### 1. Clone o repositório

```bash
git clone git@github.com:brandaoplaster/notekeeper-api.git
cd notekeeper-api
```

### 2. Configure as variáveis de ambiente

Crie o arquivo `.env` na raiz do projeto baseado no arquivo `.env-example`:

```bash
cp .env-example .env
```

Edite o arquivo `.env` e configure as variáveis conforme necessário:

```env
DATABASE_USERNAME=postgres
DATABASE_PASSWORD=postgres
DATABASE_HOST=note_db
ALLOWED_ORIGINS=http://localhost:5173
```

**Descrição das variáveis:**

- `DATABASE_USERNAME`: Usuário do banco de dados PostgreSQL
- `DATABASE_PASSWORD`: Senha do banco de dados PostgreSQL
- `DATABASE_HOST`: Host do banco de dados (use `note_db` para Docker)
- `ALLOWED_ORIGINS`: URLs permitidas para CORS (separadas por vírgula se múltiplas)

### 3. Construa e inicie os containers

```bash
docker compose build
docker compose up
```

Ou em modo detached (segundo plano):

```bash
docker compose up -d
```

A aplicação estará disponível em: `http://localhost:3000`

## Comandos Docker Úteis

### Parar os containers

```bash
docker compose down
```

### Ver logs dos containers

```bash
docker compose logs -f
```

### Ver logs de um serviço específico

```bash
docker compose logs -f note
docker compose logs -f note_db
```

### Executar migrations

```bash
docker compose run --rm note bundle exec rails db:migrate
```

### Criar o banco de dados

```bash
docker compose run --rm note bundle exec rails db:create
```

### Resetar o banco de dados

```bash
docker compose run --rm note bundle exec rails db:reset
```

### Executar testes

```bash
docker compose run --rm note bundle exec rspec
```

### Executar console do Rails

```bash
docker compose run --rm note bundle exec rails console
```

### Instalar novas gems

```bash
docker compose run --rm note bundle install
```

### Executar Rubocop

```bash
docker compose run --rm note bundle exec rubocop
```

## Estrutura dos Serviços

### note (Aplicação Rails)

- Porta: 3000
- Dockerfile: `Dockerfile`
- Volumes:
  - Código fonte montado em `/app`
  - Cache de gems em volume nomeado

### note_db (PostgreSQL)

- Porta: 5432
- Imagem: postgres:17
- Volumes:
  - Dados persistidos em volume nomeado `postgres_data`

## Troubleshooting

### Porta 3000 já está em uso

Se a porta 3000 já estiver em uso, você pode alterá-la no arquivo `compose.yml`:

```yaml
ports:
  - "3001:3000"  # Muda para porta 3001 no host
```

### Problemas com permissões

Se encontrar problemas de permissão, ajuste as variáveis `USER_ID` e `GROUP_ID` no arquivo `compose.yml` ou defina-as no arquivo `.env`:

```env
USER_ID=1000
GROUP_ID=1000
```

### Limpar volumes e reconstruir

Se precisar limpar completamente os volumes e reconstruir:

```bash
docker compose down -v
docker compose build --no-cache
docker compose up
```

## Desenvolvimento

O projeto está configurado para desenvolvimento com hot-reload. Qualquer alteração no código será refletida automaticamente na aplicação em execução.

## Testes

Execute a suite de testes com:

```bash
docker compose exec note bundle exec rspec
```

Para executar testes com cobertura:

```bash
docker compose exec note bundle exec rspec --format documentation
```

## Licença

Este projeto está sob a licença MIT.
