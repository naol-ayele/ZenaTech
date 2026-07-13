require('dotenv').config();
const { Pool } = require('pg');

let connectionString = process.env.DATABASE_URL || '';
connectionString = connectionString.includes('sslmode=')
  ? connectionString.replace(/sslmode=[^&]+/, 'sslmode=verify-full')
  : connectionString + (connectionString.includes('?') ? '&' : '?') + 'sslmode=verify-full';

const pool = new Pool({
  connectionString,
  max: 20,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 10000,
});

pool.on('error', (err, client) => {
  console.error('Unexpected database error:', err);
});

pool.on('connect', () => {
  console.log('Connected to PostgreSQL database');
});

module.exports = {
  query: (text, params) => pool.query(text, params),
  pool,
};