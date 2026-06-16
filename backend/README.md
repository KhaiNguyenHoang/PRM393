# Netmu

## Run database

```bash
docker run --name netmu -e "POSTGRES_USER=admin" -e "POSTGRES_PASSWORD=12345" -p 5432:5432 -d postgres:18.1-alpine3.22
dotnet ef database update
```

## Run project

```bash
dotnet run
```