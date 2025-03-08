# Use Node.js base image
FROM node:18

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and install dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy all other files
COPY . .

# Expose port 5000 (if your app runs on this port)
EXPOSE 5000

# Start the application
CMD ["node", "Server.js"]
