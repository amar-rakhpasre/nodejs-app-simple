FROM node:16

WORKDIRR /app

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 8000

CMD ["npm", "start"]
