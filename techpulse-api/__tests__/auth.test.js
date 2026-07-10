const request = require('supertest');
const app = require('../server');

jest.mock('../services/notification_service', () => ({
  subscribeToTopic: jest.fn(),
  unsubscribeFromTopic: jest.fn(),
  sendNewArticleNotification: jest.fn(),
}));

jest.mock('../db', () => ({
  query: jest.fn(),
}));

describe('Auth Middleware', () => {
  beforeEach(() => {
    delete process.env.API_KEY;
  });

  it('rejects POST /v1/articles without auth header', async () => {
    process.env.API_KEY = 'test-key';
    const res = await request(app)
      .post('/v1/articles')
      .send({ title: 'Test', category: 'tech', published_date: '2024-01-01' });
    expect(res.status).toBe(401);
  });

  it('rejects POST /v1/articles with wrong API key', async () => {
    process.env.API_KEY = 'test-key';
    const res = await request(app)
      .post('/v1/articles')
      .set('Authorization', 'Bearer wrong-key')
      .send({ title: 'Test', category: 'tech', published_date: '2024-01-01' });
    expect(res.status).toBe(403);
  });

  it('accepts POST /v1/articles with valid API key', async () => {
    process.env.API_KEY = 'test-key';
    const { query } = require('../db');
    query.mockResolvedValue({
      rows: [{
        id: '1',
        title: 'Test',
        category: 'tech',
        published_date: '2024-01-01',
        is_premium: false,
      }],
    });
    const res = await request(app)
      .post('/v1/articles')
      .set('Authorization', 'Bearer test-key')
      .send({ title: 'Test Article', category: 'tech', published_date: '2024-01-01' });
    expect(res.status).toBe(201);
  });
});
