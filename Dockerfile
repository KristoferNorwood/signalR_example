# Pull down an image from Docker Hub that includes the .NET core SDK: 
# https://hub.docker.com/_/microsoft-dotnet-core-sdk
# This is so we have all the tools necessary to compile the app.
FROM mcr.microsoft.com/dotnet/sdk:5.0-focal AS build

# Copy the source from your machine onto the container.
WORKDIR /src
COPY ./signalR_example.Api/ .

# Install dependencies. 
# https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet-restore?tabs=netcore2x
RUN dotnet restore "signalR_example.Api.csproj"

# Compile, then pack the compiled app and dependencies into a deployable unit.
# https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet-publish?tabs=netcore21
RUN dotnet publish "signalR_example.Api.csproj" -c Release -o /app/publish

# Pull down an image from Docker Hub that includes the Node JS LTS Version:
FROM node:lts-alpine AS node-build

WORKDIR /node
COPY ./client /node
RUN npm install
RUN npm build

# Pull down an image from Docker Hub that includes only the ASP.NET core runtime:
# https://hub.docker.com/_/microsoft-dotnet-core-aspnet/
# We don't need the SDK anymore, so this will produce a lighter-weight image
# that can still run the app.
FROM mcr.microsoft.com/dotnet/aspnet:5.0-focal AS final
WORKDIR /app
RUN mkdir /app/wwwroot

# Copy the published dotnet app to this new runtime-only container.
COPY --from=build /app/publish .
# Copy the published React app to the container as well
COPY --from=node-build /node/build ./wwwroot

COPY startup.sh .