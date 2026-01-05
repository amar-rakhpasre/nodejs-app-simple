module.exports = {
  apps: [
    {
      name: "simple-nodejs-app",
      script: "index.js",
      cwd: "/opt/apps/simple-nodejs-app/current",
      env_production: {
        NODE_ENV: "production",
        PORT: 3000
      }
    }
  ]
}
