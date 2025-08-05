# Use the official .NET SDK image to build the application
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy the project file and restore dependencies
COPY cartservice.csproj ./

# Install dependencies
RUN dotnet restore

# Copy the rest of the application source code
COPY . ./

# Publish the application as a self-contained deployment for Linux x64
# How it works: donet publish compiles the application and prepares it for deployment
# -c Release: Specifies the build configuration
# -r linux-x64: Targets the Linux x64 runtime
# --self-contained true: Publishes the app as self-contained, including the .NET runtime
# /p:PublishTrimmed=true: Enables trimming to reduce the size of the published app

RUN dotnet publish -c Release -r linux-x64 --self-contained true -o /app/publish

# Use the official ASP.NET Core runtime image to run the application
FROM mcr.microsoft.com/dotnet/runtime-deps:8.0.11-jammy-chiseled AS final

# Set the working directory inside the container
WORKDIR /app

# Copy the published application from the builder stage
COPY --from=builder /app/publish .

# Run as non-root user (UID 65532 is standard in distroless images)
USER 65532
# Expose the port the application listens on
EXPOSE 8080

# Should we add health checks here? Or leave it to orchestration level?

CMD ["./cartservice"]

