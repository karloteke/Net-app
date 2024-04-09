FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
WORKDIR /App

# Copia todo el contenido del directorio actual al directorio de trabajo en el contenedor.
COPY . ./

# Restaura las dependencias del proyecto utilizando dotnet restore.
RUN dotnet restore

# Compila y publica la aplicación en modo Release en el directorio "out".
RUN dotnet publish -c Release -o out

# Establece la imagen base para el contenedor como la imagen ASP.NET Core 6.0.
FROM mcr.microsoft.com/dotnet/aspnet:6.0

# Establece el directorio de trabajo dentro del contenedor.
WORKDIR /App

# Copia los archivos publicados desde el contenedor de compilación al directorio de trabajo en el contenedor actual.
COPY --from=build-env /App/out .

# Establece el comando de inicio para el contenedor, que ejecutará la aplicación ASP.NET Core.
ENTRYPOINT ["dotnet", "MyApi.dll"]

# Expone el puerto 8080 del contenedor, permitiendo el acceso a la aplicación desde fuera del contenedor.
EXPOSE 8080
