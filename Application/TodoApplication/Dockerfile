#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS base
ARG ENV ASPNETCORE_URLS
ENV ENV ASPNETCORE_URLS=http://+:5000
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /src
COPY ["TodoApplication/TodoApplication.csproj", "TodoApplication/"]
RUN dotnet restore "TodoApplication/TodoApplication.csproj"
COPY . .
WORKDIR "/src/TodoApplication"
RUN dotnet build "TodoApplication.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "TodoApplication.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
RUN echo ${ASPNETCORE_URLS}
ENTRYPOINT ["dotnet", "TodoApplication.dll"]