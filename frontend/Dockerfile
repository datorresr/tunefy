# Use the official Node.js 21 image as a base
FROM node:21.6-alpine3.18

# Set the working directory in the container
WORKDIR /app/frontend

# Copy package.json and package-lock.json to the working directory
COPY ./package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the frontend code to the working directory
COPY . .

# Expose port 3000
EXPOSE 3000

# Command to run the frontend server
CMD ["npm", "start"]
