const { Pool } = require('pg');
const { apiCreateUser } = require('./UserTest.bs');

const USER_NAME = 'milan';
const USER_EMAIL = 'milan@hotmail.com';

/*
const pool = new Pool({
  host: 'localhost',
  database: 'auth',
  port: 5432,
  user: 'auth',
  password: 'auth',
});

async function removeUsers() {
  await pool.query('delete from users where user_name = $1', [USER_NAME]); 
}

beforeAll(async () => {
  await removeUsers();
});

afterAll(async () => {
  await removeUsers();
});
*/

describe('create user', () =>  {
  it('creates new user', async () => {
    let res = await apiCreateUser({
      userName: `${USER_NAME}`,
      userEmail: `${USER_EMAIL}`,
      password: 'milan12'
    });
    console.dir(res);
  })
})
