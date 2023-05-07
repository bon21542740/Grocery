# Base image to use
FROM node:latest


# Install Python
RUN apt-get update && \
   apt-get install -y python


# set a working directory
WORKDIR /src


# Copy across project configuration information
# Install application dependencies
COPY package*.json /src/


# Ask npm to install the dependencies
# RUN npm install -g npm@9.6.6
RUN npm install -g supervisor && npm install && npm install supervisor
RUN npm install express
RUN npm install express-session
RUN npm install pug


# Copy across all our files
COPY . /src


# Expose our application port (3000)
EXPOSE 3000

