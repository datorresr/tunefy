# Use the official Node.js 21 image as a base
FROM node:21.6-alpine3.18

# Set the working directory in the container
WORKDIR /app/backend

# Copy package.json and package-lock.json to the working directory
COPY ./package*.json ./


# Install dependencies
RUN npm install

# Copy the rest of the backend code to the working directory
COPY . .

# Expose port 3001
EXPOSE 3001

# Command to run the backend server
CMD ["npm", "start"]