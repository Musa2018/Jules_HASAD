# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy project files
COPY ["Hasad.AdminWeb.csproj", "./"]
# Note: Hasad.AdminWeb depends on Hasad.Application
COPY ["../backend/Hasad.Application/Hasad.Application.csproj", "../backend/Hasad.Application/"]
COPY ["../backend/Hasad.Domain/Hasad.Domain.csproj", "../backend/Hasad.Domain/"]

RUN dotnet restore "Hasad.AdminWeb.csproj"

# Copy everything and build
COPY . .
RUN dotnet build "Hasad.AdminWeb.csproj" -c Release -o /app/build

# Stage 2: Publish
FROM build AS publish
RUN dotnet publish "Hasad.AdminWeb.csproj" -c Release -o /app/publish

# Stage 3: Serve with Nginx
FROM nginx:alpine AS final
WORKDIR /usr/share/nginx/html
COPY --from=publish /app/publish/wwwroot .
COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
