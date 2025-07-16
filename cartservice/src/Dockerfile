FROM mcr.microsoft.com/dotnet/sdk:8.0

WORKDIR /app

COPY cartservice.csproj ./

RUN dotnet restore

COPY . .

RUN dotnet publish -c Release -o out

EXPOSE 7070

CMD ["dotnet", "out/cartservie.dll"]
