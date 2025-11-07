# Evolution API - Azure Web App Deploy

## 🚀 Deploy no Azure Web App

### Pré-requisitos

1. **Azure Database for PostgreSQL** configurado
2. **Redis Cache** no Azure (opcional, mas recomendado)
3. **Azure Web App** com Node.js

### Configuração no Azure Portal

#### 1. Configurar Variáveis de Ambiente (Application Settings)

```bash
# Servidor
SERVER_PORT=8080
NODE_ENV=production
WEBSITES_PORT=8080

# Database (substitua pelos valores do seu Azure Database)
DATABASE_PROVIDER=postgresql
DATABASE_CONNECTION_URI=postgresql://username:password@yourserver.postgres.database.azure.com:5432/evolution_db?schema=evolution_api&sslmode=require

# Outras configurações importantes
LOG_LEVEL=ERROR,WARN,INFO
CORS_ORIGIN=*
DEL_INSTANCE=false

# Cache Redis (se usando Azure Redis Cache)
CACHE_REDIS_ENABLED=true
CACHE_REDIS_URI=redis://your-redis.redis.cache.windows.net:6380
CACHE_REDIS_PASSWORD=your-redis-password
CACHE_REDIS_PREFIX_KEY=evolution

# Configurações de autenticação
AUTHENTICATION_API_KEY=true
AUTHENTICATION_EXPOSE_IN_FETCH_INSTANCES=true
```

#### 2. Configurar Startup Command

No Azure Portal → Configuration → General Settings → Startup Command:
```bash
bash startup.sh
```

#### 3. Deploy via GitHub

1. **Fork** o repositório original
2. **Conecte** seu fork ao Azure Web App
3. **Configure** CI/CD automático

### Arquivos de Configuração Incluídos

- `web.config` - Configuração do IIS para Azure
- `startup.sh` - Script de inicialização
- `deploy.sh` - Script de deploy
- Ajustes no `package.json` para produção

### Comandos Locais para Teste

```bash
# Build da aplicação
npm run build

# Teste local de produção
npm run start:prod

# Deploy do banco (com as variáveis configuradas)
export DATABASE_PROVIDER=postgresql
npm run db:deploy
```

### Solução de Problemas

#### Erro "tsx: not found"
**Causa**: O Azure está tentando executar código TypeScript ao invés do código compilado.

**Solução**:
1. **Fazer build local** antes de fazer deploy:
   ```bash
   npm run build
   ```

2. **Garantir que a pasta `dist/` está sendo enviada** ao Azure:
   - A pasta `dist/` NÃO deve estar no `.gitignore` para Azure
   - Use `.deployignore` para controlar o que enviar ao Azure

3. **Verificar que o `package.json` está correto**:
   ```json
   "scripts": {
     "start": "node dist/main.js",
     "start:prod": "node dist/main.js"
   }
   ```

4. **NÃO use `postinstall`** que tenta fazer build no Azure (o tsx não estará disponível)

#### Outros Problemas Comuns

1. **Erro de conexão com banco**: Verifique a string de conexão e firewall
2. **Timeout na inicialização**: Configure `WEBSITES_CONTAINER_START_TIME_LIMIT=1800`
3. **Erro de memória**: Configure um plano de serviço adequado (B1 ou superior)
4. **Prisma Client não gerado**: O startup.sh tentará gerar automaticamente

### Workflow Recomendado para Deploy

```bash
# 1. Build local (OBRIGATÓRIO antes de fazer deploy)
npm run build

# 2. Testar localmente
npm run start:prod

# 3. Commit e push (certifique-se que dist/ está incluído)
git add dist/
git commit -m "build: update production build"
git push azure main

# 4. Verificar logs no Azure Portal
az webapp log tail --name your-app-name --resource-group your-rg
```

### Monitoramento

- Use Application Insights para logs e métricas
- Configure alertas para erros e performance
- Monitore uso de CPU e memória

## 📝 Checklist de Deploy

- [ ] Azure Database for PostgreSQL criado
- [ ] String de conexão configurada
- [ ] Variáveis de ambiente definidas
- [ ] Startup command configurado
- [ ] Deploy via GitHub conectado
- [ ] Firewall do banco configurado
- [ ] SSL habilitado (recomendado)
- [ ] Monitoring configurado