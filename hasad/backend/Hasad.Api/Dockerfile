# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy project files and restore dependencies
COPY ["Hasad.Api/Hasad.Api.csproj", "Hasad.Api/"]
COPY ["Hasad.Application/Hasad.Application.csproj", "Hasad.Application/"]
COPY ["Hasad.Infrastructure/Hasad.Infrastructure.csproj", "Hasad.Infrastructure/"]
COPY ["Hasad.Domain/Hasad.Domain.csproj", "Hasad.Domain/"]

RUN dotnet restore "Hasad.Api/Hasad.Api.csproj"

# Copy everything else and build
COPY . .
WORKDIR "/src/Hasad.Api"
RUN dotnet build "Hasad.Api.csproj" -c Release -o /app/build

# Stage 2: Publish
FROM build AS publish
RUN dotnet publish "Hasad.Api.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Stage 3: Final runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
EXPOSE 8080
EXPOSE 8081

# Create directory for uploads
RUN mkdir -p /app/wwwroot/uploads

COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Hasad.Api.dll"]
