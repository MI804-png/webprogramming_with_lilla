module.exports = {
  apps: [
    {
      name: 'techcorp-solutions',
      script: 'start.js',
      env: {
        PORT: 3000,
        DB_HOST: 'localhost',
        DB_PORT: 3306,
        DB_USER: 'root',
        DB_PASS: '',
        DB_NAME: 'company_db',
        SESSION_SECRET: 'change_me'
      }
    }
  ]
}