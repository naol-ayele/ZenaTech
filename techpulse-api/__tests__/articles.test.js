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

describe('GET /v1/articles', () => {
  it('returns paginated articles', async () => {
    const { query } = require('../db');
    query.mockResolvedValueOnce({
      rows: [
        { id: '1', title: 'Article 1', content: '<p>Hello</p>', category: 'tech', published_date: '2024-01-01', views: 10, upvotes: 2, is_premium: false, thumbnail_url: null, affiliate_links: [] },
      ],
    });
    query.mockResolvedValueOnce({ rows: [{ count: '1' }] });

    const res = await request(app).get('/v1/articles?page=1&limit=20');
    expect(res.status).toBe(200);
    expect(res.body).toHaveProperty('articles');
    expect(res.body).toHaveProperty('pagination');
    expect(res.body.pagination.total).toBe(1);
  });

  it('returns empty array when no articles', async () => {
    const { query } = require('../db');
    query.mockResolvedValueOnce({ rows: [] });
    query.mockResolvedValueOnce({ rows: [{ count: '0' }] });

    const res = await request(app).get('/v1/articles');
    expect(res.status).toBe(200);
    expect(res.body.articles).toEqual([]);
  });
});

describe('GET /v1/articles/trending', () => {
  it('returns trending articles', async () => {
    const { query } = require('../db');
    query.mockResolvedValueOnce({
      rows: [
        { id: '1', title: 'Trending', category: 'tech', views: 100, upvotes: 10, is_premium: false, content: '<p>Hello</p>', thumbnail_url: null, published_date: '2024-01-01', created_at: '2024-01-01', updated_at: '2024-01-01', is_liked: false },
      ],
    });

    const res = await request(app).get('/v1/articles/trending');
    expect(res.status).toBe(200);
    expect(res.body.articles).toHaveLength(1);
  });
});
