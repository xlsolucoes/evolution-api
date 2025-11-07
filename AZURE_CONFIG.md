# Configurações Essenciais para Azure Web App - Evolution API

## Variáveis de Ambiente Obrigatórias

Configure estas variáveis no Azure Portal → Application Settings:

### Sistema
- `NODE_ENV=production`
- `WEBSITES_PORT=8080`
- `SERVER_PORT=8080`
- `WEBSITE_NODE_DEFAULT_VERSION=18-lts`

### Database (CRITICAL - substitua pelos seus valores)
- `DATABASE_PROVIDER=postgresql`
- `DATABASE_CONNECTION_URI=postgresql://username:password@yourserver.postgres.database.azure.com:5432/evolution_db?schema=evolution_api&sslmode=require`
- `DATABASE_CONNECTION_CLIENT_NAME=evolution_exchange`

### Configurações da Aplicação
- `SERVER_URL=https://xl-api-whatsapp.azurewebsites.net`
- `LOG_LEVEL=ERROR,WARN,INFO`
- `CORS_ORIGIN=*`
- `DEL_INSTANCE=false`

### Cache (Opcional - Redis)
- `CACHE_REDIS_ENABLED=false`

### Telemetria
- `TELEMETRY_ENABLED=false`

## Startup Command no Azure

No Azure Portal → Configuration → General Settings → Startup Command:
```
node dist/main.js
```

## Troubleshooting

Se o wwwroot estiver vazio:
1. Verifique se o build foi executado com sucesso no GitHub Actions
2. Verifique se as variáveis de ambiente estão configuradas
3. Verifique os logs do Azure Web App
4. Confirme se o arquivo dist/main.js existe após o deploy