const server = require('../testAp');
const supertest = require('supertest');
const requestWithSupertest = supertest(server);


describe('User Endpoints', ()  => {
  beforeAll(done => { //pass a callback to tell jest it is async
    //start the server before any test
    server.listen(3306, () => done());
})
    test('testGetAllMessages', async () => {
      const res = await requestWithSupertest.get('/messages/all');
        expect(res.type).toEqual(expect.stringContaining('json'));
        expect(res.body).toBeInstanceOf(Array);
        expect(res.body[0]).toHaveProperty('_id');

        expect(res.body[0]).toHaveProperty('users');
        expect(res.body[0]['users']).toBeInstanceOf(Array);


        expect(res.body[0]).toHaveProperty('messages');
        expect(res.body[0]['messages']).toBeInstanceOf(Array);
    });
  
  });