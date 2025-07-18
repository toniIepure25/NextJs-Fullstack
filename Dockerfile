# Use an official Node.js runtime as a base image
FROM node:18-alpine AS builder

# Set the working directory to /app
WORKDIR /

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install app dependencies
RUN npm install

# Bundle app source code
COPY src ./src
COPY public ./public
COPY next.config.js ./
COPY jsconfig.json ./

# Build the application
RUN npm run build

# Production stage
FROM node:18-alpine

WORKDIR /

# Copy production dependencies
COPY --from=builder /app/package*.json ./
RUN npm install --omit=dev

# Copy built application files from the builder stage
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public

# Expose port 3000 for the Next.js application - only expose if needed for internal service communication
# EXPOSE 3000

# Start the Next.js application
CMD ["npm", "start"]