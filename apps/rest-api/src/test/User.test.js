const { Pool } = require('pg');
const fetch = require('node-fetch');
const { apiCreateUser } = require('./Test.bs');

const API_URL = 'http://localhost:3200'

const USER_NAME = 'milan';
const USER_EMAIL = 'milan@hotmail.com';

const pool = new Pool({
  host: 'localhost',
  database: 'auth',
  port: 5432,
  user: 'auth',
  password: 'auth',
});

async function removeUsers() {
  let client = await pool.connect();
  await client.query('delete from users where user_name = $1', [USER_NAME]); 
  client.end();
  client.release();
}


describe('create user', () =>  {

  it('creates new user', async () => {
    await removeUsers();
    let res = await apiCreateUser({
      userName: `${USER_NAME}`,
      userEmail: `${USER_EMAIL}`,
      password: 'milan12'
    });
    await removeUsers();
  });

  it('creates new user calling rest', async () => {
    await removeUsers();
    let user = {
      userName: `${USER_NAME}`,
      userEmail: `${USER_EMAIL}`,
      password: 'milan12'
    };
    let result = await fetch(`${API_URL}/create_user`, {
        method: 'post',
        body:    JSON.stringify(user),
        headers: { 'Content-Type': 'application/json' },
    });
    expect(result.ok).toBe(true);
    let body = result.json();
    console.log(body);
    await removeUsers();
  });
})
