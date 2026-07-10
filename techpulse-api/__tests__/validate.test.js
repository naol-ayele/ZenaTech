const { validateArticleInput, sanitizeString } = require('../middleware/validate');

describe('sanitizeString', () => {
  it('strips HTML tags', () => {
    const result = sanitizeString('<script>alert("xss")</script>hello', 100);
    expect(result).toBe('alert("xss")hello');
  });

  it('truncates to max length', () => {
    const result = sanitizeString('a'.repeat(50), 10);
    expect(result).toBe('a'.repeat(10));
    expect(result.length).toBe(10);
  });

  it('returns empty string for non-string input', () => {
    expect(sanitizeString(null)).toBe('');
    expect(sanitizeString(undefined)).toBe('');
    expect(sanitizeString(123)).toBe('');
  });
});

describe('validateArticleInput', () => {
  let mockReq;
  let mockRes;
  let mockNext;

  beforeEach(() => {
    mockReq = {
      body: {
        title: 'Test Article',
        category: 'tech',
        content: '<p>Some content</p>',
        published_date: '2024-01-01',
      },
    };
    mockRes = {
      status: jest.fn().mockReturnThis(),
      json: jest.fn(),
    };
    mockNext = jest.fn();
  });

  it('passes validation for valid input', () => {
    validateArticleInput(mockReq, mockRes, mockNext);
    expect(mockNext).toHaveBeenCalled();
    expect(mockRes.status).not.toHaveBeenCalled();
  });

  it('rejects missing title', () => {
    mockReq.body.title = '';
    validateArticleInput(mockReq, mockRes, mockNext);
    expect(mockRes.status).toHaveBeenCalledWith(400);
    expect(mockRes.json).toHaveBeenCalledWith(
      expect.objectContaining({ error: expect.any(String) }),
    );
  });

  it('rejects missing category', () => {
    mockReq.body.category = '';
    validateArticleInput(mockReq, mockRes, mockNext);
    expect(mockRes.status).toHaveBeenCalledWith(400);
  });

  it('rejects invalid published_date', () => {
    mockReq.body.published_date = 'not-a-date';
    validateArticleInput(mockReq, mockRes, mockNext);
    expect(mockRes.status).toHaveBeenCalledWith(400);
  });

  it('sanitizes title and category', () => {
    mockReq.body.title = '<b>Title</b>';
    mockReq.body.category = '<i>tech</i>';
    validateArticleInput(mockReq, mockRes, mockNext);
    expect(mockReq.body.title).toBe('Title');
    expect(mockReq.body.category).toBe('tech');
    expect(mockNext).toHaveBeenCalled();
  });

  it('rejects title over 200 characters', () => {
    mockReq.body.title = 'a'.repeat(201);
    validateArticleInput(mockReq, mockRes, mockNext);
    expect(mockRes.status).toHaveBeenCalledWith(400);
  });
});
