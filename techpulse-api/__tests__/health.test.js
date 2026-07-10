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

describe('GET /health', () => {
  it('returns ok status', async () => {
    const res = await request(app).get('/health');
    expect(res.status).toBe(200);
    expect(res.body).toHaveProperty('status', 'ok');
    expect(res.body).toHaveProperty('timestamp');
  });
});
