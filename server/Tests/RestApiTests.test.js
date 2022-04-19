 const server = require('../testAp');
 const supertest = require('supertest');
 const requestWithSupertest = supertest(server);


describe('Test Endpoints', ()  => {
  beforeAll(done => { //pass a callback to tell jest it is async
    //start the server before any test
    server.listen(3306, () => done());
    })

    //test conversations
    test('Get All Messages', async () => {
      const res = await requestWithSupertest.get('/messages/all');
        expect(res.type).toEqual(expect.stringContaining('json'));
        expect(res.body).toBeInstanceOf(Array);
        expect(res.body[0]).toHaveProperty('_id');

        expect(res.body[0]).toHaveProperty('users');
        expect(res.body[0]['users']).toBeInstanceOf(Array);


        expect(res.body[0]).toHaveProperty('messages');
        expect(res.body[0]['messages']).toBeInstanceOf(Array);
    });


    test('Get Specific Conversation', async () => {
      const res = await requestWithSupertest.get('/messages/all').query({sender: 'morrisjj', recipient: 'morrisjj'});
        expect(res.type).toEqual(expect.stringContaining('json'));
        expect(res.body[0]).toHaveProperty('_id');

        expect(res.body[0]).toHaveProperty('users');
        expect(res.body[0]['users']).toBeInstanceOf(Array);


        expect(res.body[0]).toHaveProperty('messages');
        expect(res.body[0]['messages']).toBeInstanceOf(Array);
    });


    //test students
    test('Get All Student Info', async () => {
      const res = await requestWithSupertest.get('/students/all');
        expect(res.type).toEqual(expect.stringContaining('json'));

        expect(res.body).toBeInstanceOf(Array);

        expect(res.body[0]).toHaveProperty('_id');

        expect(res.body[0]).toHaveProperty('rose-username');
        expect(res.body[0]).toHaveProperty('name');
        expect(res.body[0]).toHaveProperty('status');
        expect(res.body[0]).toHaveProperty('major');
        expect(res.body[0]).toHaveProperty('year');
        expect(res.body[0]).toHaveProperty('__v');

    });

    test('Get Student List Info By Year', async () => {
      const res = await requestWithSupertest.get('/students/list').query({year: '2022'});
        expect(res.type).toEqual(expect.stringContaining('json'));

        expect(res.body).toBeInstanceOf(Array);

        expect(res.body[0]).toHaveProperty('_id');

        expect(res.body[0]).toHaveProperty('rose-username');
        expect(res.body[0]).toHaveProperty('name');
        expect(res.body[0]).toHaveProperty('status');
        expect(res.body[0]).toHaveProperty('major');
        expect(res.body[0]).toHaveProperty('year');
        expect(res.body[0]).toHaveProperty('__v');

    });

    test('Get Student From Email', async () => {
      const res = await requestWithSupertest.post('/students/studentFromEmail').send({
        'rose-username': 'morrisjj',
        })
      .set('Content-Type', 'application/json');;
        expect(res.type).toEqual(expect.stringContaining('json'));


        expect(res.body.message).toHaveProperty('_id');

        expect(res.body.message).toHaveProperty('rose-username');
        expect(res.body.message).toHaveProperty('name');
        expect(res.body.message).toHaveProperty('status');
        expect(res.body.message).toHaveProperty('major');
        expect(res.body.message).toHaveProperty('year');
        expect(res.body.message).toHaveProperty('__v');

    });


    test('Create student', async () => {
      const res = await requestWithSupertest.post('/students/studentFromEmail').send({
        "name": "test user",
    "rose-username": "test-username",
    "year": "2001",
    "major": "CS",
        })
      .set('Content-Type', 'application/json');;
        expect(res.type).toEqual(expect.stringContaining('json'));

        expect(res.body.message).toHaveProperty('_id');
        expect(res.body.message).toHaveProperty('rose-username');
        expect(res.body.message).toHaveProperty('name');
        expect(res.body.message).toHaveProperty('status');
        expect(res.body.message).toHaveProperty('major');
        expect(res.body.message).toHaveProperty('year');
        expect(res.body.message).toHaveProperty('__v');

    });


    test('Check Student exists (true)', async () => {
      const res = await requestWithSupertest.post('/students/checkExist').send({
    "rose-username": "test-username",
        })
      .set('Content-Type', 'application/json');;
        expect(res.type).toEqual(expect.stringContaining('json'));

        expect(res.body.message).toBe(true);
    });

    test('Check Student exists (false)', async () => {
      const res = await requestWithSupertest.post('/students/checkExist').send({
    "rose-username": "fake student who doesn not exist",
        })
      .set('Content-Type', 'application/json');;
        expect(res.type).toEqual(expect.stringContaining('json'));

        expect(res.body.message).toEqual(false);
    });


    //test popups
    test('Get Next Popup Question', async () => {
      const res = await requestWithSupertest.get('/popups/nextQuestion').query({
    "rose-username": "morrisjj",
        })
        expect(res.type).toEqual(expect.stringContaining('json'));

        expect(res.body.message).toBe('has question');

        expect(res.body.question).toHaveProperty('_id');
        expect(res.body.question).toHaveProperty('question');
        expect(res.body.question).toHaveProperty('priority');
        expect(res.body.question).toHaveProperty('quota');
        expect(res.body.question).toHaveProperty('currentAnswers');

        expect(res.body.question.options).toBeInstanceOf(Array);

        expect(res.body.question.optionQuantities).toBeInstanceOf(Array);

    });

    test('Get All Popup Questions', async () => {
      const res = await requestWithSupertest.get('/popups/allQuestions');

        expect(res.body[0]).toHaveProperty('_id');
        expect(res.body[0]).toHaveProperty('question');
        expect(res.body[0]).toHaveProperty('priority');
        expect(res.body[0]).toHaveProperty('quota');
        expect(res.body[0]).toHaveProperty('currentAnswers');

        expect(res.body[0].options).toBeInstanceOf(Array);


    });

  test('Get all popup answers', async () => {
      const res = await requestWithSupertest.get('/popups/allAnswers'); 

        
        expect(res.type).toEqual(expect.stringContaining('json'));


        expect(res.body[0]).toHaveProperty('_id');
        expect(res.body[0]).toHaveProperty('questionID');
        expect(res.body[0]).toHaveProperty('timestamp');
        expect(res.body[0]).toHaveProperty('__v');

        expect(res.body[0].answer).toBeInstanceOf(Array);
    });

  });

  
