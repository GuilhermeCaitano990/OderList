
# Aplicação Spring Boot - CRUD de Produtos e Pedidos com RabbitMQ e MySQL

## Descrição

Esta aplicação é uma API desenvolvida com Spring Boot que implementa funcionalidades de CRUD para produtos e pedidos. Ela utiliza RabbitMQ para processamento assíncrono de mudanças de status dos pedidos e MySQL como banco de dados. A aplicação é dockerizada e pronta para ser implantada na AWS.

## Funcionalidades

- CRUD de produtos (nome, descrição, preço).
- CRUD de pedidos (data do pedido, lista de produtos, quantidade, status).
- Mudança de status de pedidos via RabbitMQ.
- Persistência de dados com MySQL.
- Pronta para rodar com Docker.
- Configurada para implantação na AWS usando ECS e RDS.

---

## Pré-requisitos

Certifique-se de ter as seguintes ferramentas instaladas no seu ambiente:

- [Java 17](https://www.oracle.com/java/technologies/javase/jdk17-archive-downloads.html)
- [Maven](https://maven.apache.org/download.cgi)
- [Docker](https://www.docker.com/products/docker-desktop)
- [Docker Compose](https://docs.docker.com/compose/install/)
- [AWS CLI](https://aws.amazon.com/cli/)
- Uma conta AWS configurada

---

## Como rodar a aplicação localmente

### 1. Clonar o repositório

```bash
git clone <URL_DO_REPOSITORIO>
cd <NOME_DO_DIRETÓRIO>
```

### 2. Configurar o MySQL e RabbitMQ com Docker

Um arquivo `docker-compose.yml` está incluído no projeto para configurar o MySQL e o RabbitMQ rapidamente.

- Para iniciar o MySQL e RabbitMQ com Docker, rode o seguinte comando no diretório raiz do projeto:

```bash
docker-compose up
```

Isso iniciará os seguintes serviços:
- MySQL na porta `3306`
- RabbitMQ na porta `5672` e o painel de gerenciamento na porta `15672`

### 3. Configurar o banco de dados MySQL

Certifique-se de que o MySQL esteja rodando e, em seguida, acesse o MySQL:

```bash
mysql -u root -p
```

Crie o banco de dados necessário:

```sql
CREATE DATABASE springdb;
```

### 4. Compilar o projeto com Maven

Depois que o banco de dados estiver configurado, compile e rode a aplicação:

```bash
mvn clean install
```

### 5. Executar a aplicação

Com a aplicação compilada, você pode iniciá-la com:

```bash
mvn spring-boot:run
```

A aplicação será executada na porta padrão `8080`. Você pode acessar a aplicação no navegador ou ferramentas como Postman:

- Produtos: `http://localhost:8080/produtos`
- Pedidos: `http://localhost:8080/pedidos`

---

## Usando Docker para rodar a aplicação

### 1. Criar a imagem Docker

O projeto já inclui um `Dockerfile`. Para construir a imagem Docker da aplicação, execute o seguinte comando na raiz do projeto:

```bash
docker build -t spring-boot-app .
```

### 2. Executar a aplicação com Docker

Depois de construir a imagem, execute a aplicação com o Docker:

```bash
docker run -p 8080:8080 spring-boot-app
```

Agora, a aplicação estará disponível em `http://localhost:8080`.

---

## Utilizando RabbitMQ

RabbitMQ é utilizado para processar as mudanças de status dos pedidos de forma assíncrona.

### Acessando o Painel de Gerenciamento RabbitMQ

Você pode acessar o painel de gerenciamento RabbitMQ em `http://localhost:15672`. Use as seguintes credenciais padrão:

- **Usuário:** guest
- **Senha:** guest

---

## Implantação na AWS

### 1. Configuração do Amazon RDS (MySQL)

1. Acesse o console do Amazon RDS.
2. Crie uma nova instância de banco de dados MySQL.
3. Defina a configuração de acesso público e configure o usuário e senha do banco de dados.
4. Guarde o nome do host, usuário e senha para configuração posterior.

### 2. Configuração do Amazon ECS (Elastic Container Service)

1. **Criar um cluster ECS**: No console do ECS, crie um cluster Fargate.
2. **Definir tarefas ECS**: Crie uma definição de tarefa para rodar a aplicação Docker e configure as variáveis de ambiente:
    - `SPRING_DATASOURCE_URL`: URL de conexão ao banco de dados RDS.
    - `SPRING_DATASOURCE_USERNAME`: Usuário do banco de dados.
    - `SPRING_DATASOURCE_PASSWORD`: Senha do banco de dados.

### 3. Subir a imagem Docker para o Amazon ECR

1. Crie um repositório no Amazon ECR.
2. Faça login no ECR e faça o push da sua imagem Docker local para o ECR:

```bash
aws ecr get-login-password --region <região> | docker login --username AWS --password-stdin <sua-url-ecr>
docker tag spring-boot-app:latest <sua-url-ecr>:latest
docker push <sua-url-ecr>:latest
```

### 4. Executar a tarefa no ECS

1. No ECS, crie um serviço a partir da definição de tarefa.
2. Certifique-se de que o serviço ECS esteja configurado para acessar o banco de dados RDS e a rede esteja configurada corretamente.

---

## Testando a aplicação

### Endpoints disponíveis

- **GET** `/produtos`: Lista todos os produtos.
- **POST** `/produtos`: Cria um novo produto.
- **PUT** `/produtos/{id}`: Atualiza um produto existente.
- **DELETE** `/produtos/{id}`: Deleta um produto existente.

- **GET** `/pedidos`: Lista todos os pedidos.
- **POST** `/pedidos`: Cria um novo pedido.
- **PUT** `/pedidos/{id}/status`: Atualiza o status de um pedido e publica a mensagem no RabbitMQ.
- **DELETE** `/pedidos/{id}`: Deleta um pedido existente.

---

## Referências

- [Spring Boot](https://spring.io/projects/spring-boot)
- [Docker](https://www.docker.com/)
- [AWS ECS](https://aws.amazon.com/ecs/)
- [RabbitMQ](https://www.rabbitmq.com/)
