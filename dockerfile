# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy solution and project files
COPY START.sln .
COPY START/START.csproj START/
COPY Start.DataAccess/Start.DataAccess.csproj Start.DataAccess/
COPY Start.Models/Start.Models.csproj Start.Models/
COPY Start.Utility/Start.Utility.csproj Start.Utility/

# Restore dependencies
RUN dotnet restore

# Copy everything else and build
COPY . .
WORKDIR /src
RUN dotnet publish -c Release -o /app/publish

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "Start.dll"]
