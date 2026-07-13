const express = require('express');
const db = require('../db');
const NotificationService = require('../services/notification_service');
const { authenticateApiKey } = require('../middleware/auth');
const { strictLimiter, moderateLimiter } = require('../middleware/rateLimiter');
const { validateArticleInput } = require('../middleware/validate');

const router = express.Router();

// GET /v1/articles - List articles with pagination
router.get('/articles', async (req, res) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 20;
    const offset = (page - 1) * limit;

    const result = await db.query(
      `SELECT a.*, 
        COALESCE(
          json_agg(
            json_build_object('id', al.id, 'label', al.label, 'url', al.url)
          ) FILTER (WHERE al.id IS NOT NULL), 
          '[]'
        ) as affiliate_links
      FROM articles a
      LEFT JOIN affiliate_links al ON al.article_id = a.id
      GROUP BY a.id
      ORDER BY a.published_date DESC
      LIMIT $1 OFFSET $2`,
      [limit, offset]
    );

    const countResult = await db.query('SELECT COUNT(*) FROM articles');
    const total = parseInt(countResult.rows[0].count);

    const articles = result.rows.map(article => {
      const contentText = article.content ? article.content.replace(/<[^>]*>/g, '') : '';
      const wordCount = contentText.split(/\s+/).filter(w => w.length > 0).length;
      article.reading_time = Math.ceil(wordCount / 200);
      return article;
    });

    res.json({
      articles: articles,
      pagination: {
        page,
        limit,
        total,
        totalPages: Math.ceil(total / limit),
      },
    });
  } catch (error) {
    console.error('Error fetching articles:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// GET /v1/articles/trending - Get trending articles sorted by views
router.get('/articles/trending', async (req, res) => {
  try {
    const limit = parseInt(req.query.limit) || 10;
    const result = await db.query(
      `SELECT a.id, a.title, a.category, a.content, a.thumbnail_url, a.published_date, a.views, a.is_premium, a.created_at, a.updated_at
       FROM articles a
       ORDER BY a.views DESC
       LIMIT $1`,
      [limit]
    );
    const articles = result.rows.map(article => {
      const contentText = article.content ? article.content.replace(/<[^>]*>/g, '') : '';
      const wordCount = contentText.split(/\s+/).filter(w => w.length > 0).length;
      article.reading_time = Math.ceil(wordCount / 200);
      return article;
    });
    res.json({ articles });
  } catch (error) {
    console.error('Error fetching trending:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// GET /v1/articles/:id - Get single article
router.get('/articles/:id', async (req, res) => {
  try {
    const { id } = req.params;
    
    const result = await db.query(
      `SELECT a.*, 
        COALESCE(
          json_agg(
            json_build_object('id', al.id, 'label', al.label, 'url', al.url)
          ) FILTER (WHERE al.id IS NOT NULL), 
          '[]'
        ) as affiliate_links
      FROM articles a
      LEFT JOIN affiliate_links al ON al.article_id = a.id
      WHERE a.id = $1
      GROUP BY a.id`,
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Article not found' });
    }

    const article = result.rows[0];
    const contentText = article.content ? article.content.replace(/<[^>]*>/g, '') : '';
    const wordCount = contentText.split(/\s+/).filter(w => w.length > 0).length;
    const readingTime = Math.ceil(wordCount / 200);
    article.reading_time = readingTime;

    await db.query('UPDATE articles SET views = views + 1 WHERE id = $1', [id]);

    res.json(article);
  } catch (error) {
    console.error('Error fetching article:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// PATCH /v1/articles/:id/view - Increment view count
router.patch('/articles/:id/view', async (req, res) => {
  try {
    const { id } = req.params;
    await db.query('UPDATE articles SET views = views + 1 WHERE id = $1', [id]);
    res.json({ success: true });
  } catch (error) {
    console.error('Error incrementing view:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// GET /v1/categories - List categories
router.get('/categories', async (req, res) => {
  try {
    const result = await db.query(`
      SELECT c.*, 
        (SELECT COUNT(*) FROM articles a WHERE a.category = c.id) as article_count
      FROM categories c
      ORDER BY c.name
    `);

    res.json({ categories: result.rows });
  } catch (error) {
    console.error('Error fetching categories:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// GET /v1/categories/:id/articles - Articles by category
router.get('/categories/:id/articles', async (req, res) => {
  try {
    const { id } = req.params;
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 20;
    const offset = (page - 1) * limit;

    const result = await db.query(
      `SELECT * FROM articles 
      WHERE category = $1 
      ORDER BY published_date DESC
      LIMIT $2 OFFSET $3`,
      [id, limit, offset]
    );

    const countResult = await db.query(
      'SELECT COUNT(*) FROM articles WHERE category = $1',
      [id]
    );
    const total = parseInt(countResult.rows[0].count);

    res.json({
      articles: result.rows,
      category: id,
      pagination: {
        page,
        limit,
        total,
        totalPages: Math.ceil(total / limit),
      },
    });
  } catch (error) {
    console.error('Error fetching category articles:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// GET /v1/search - Search articles
router.get('/search', async (req, res) => {
  try {
    const query = req.query.q || '';
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 20;
    const offset = (page - 1) * limit;

    if (!query.trim()) {
      return res.json({ articles: [], pagination: { page, limit, total: 0, totalPages: 0 } });
    }

    const searchQuery = query.trim();
    const tsQuery = searchQuery.split(/\s+/).filter(Boolean).join(' & ');

    const result = await db.query(
      `SELECT a.*,
        ts_rank(
          to_tsvector('english', coalesce(a.title, '') || ' ' || coalesce(a.content, '') || ' ' || coalesce(a.category, '')),
          to_tsquery('english', $1)
        ) AS rank
      FROM articles a
      WHERE to_tsvector('english', coalesce(a.title, '') || ' ' || coalesce(a.content, '') || ' ' || coalesce(a.category, '')) @@ to_tsquery('english', $1)
      ORDER BY rank DESC, a.views DESC, a.published_date DESC
      LIMIT $2 OFFSET $3`,
      [tsQuery, limit, offset]
    );

    const countResult = await db.query(
      `SELECT COUNT(*) FROM articles 
      WHERE to_tsvector('english', coalesce(title, '') || ' ' || coalesce(content, '') || ' ' || coalesce(category, '')) @@ to_tsquery('english', $1)`,
      [tsQuery]
    );
    const total = parseInt(countResult.rows[0].count);

    res.json({
      articles: result.rows,
      query,
      pagination: {
        page,
        limit,
        total,
        totalPages: Math.ceil(total / limit),
      },
    });
  } catch (error) {
    console.error('Error searching articles:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// POST /v1/users/track-interest - Track user category interest
router.post('/users/track-interest', moderateLimiter, async (req, res) => {
  try {
    const { anonymous_id, category_id } = req.body;

    if (!anonymous_id || !category_id) {
      return res.status(400).json({ error: 'anonymous_id and category_id are required' });
    }

    let categoryIdValue = category_id;
    const categoryLookup = await db.query(
      'SELECT id FROM categories WHERE id = $1 OR LOWER(name) = LOWER($1)',
      [category_id.toString()]
    );
    
    if (categoryLookup.rows.length > 0) {
      categoryIdValue = categoryLookup.rows[0].id;
    } else {
      return res.status(400).json({ error: 'Category not found' });
    }

    const result = await db.query(
      `INSERT INTO user_interests (anonymous_id, category_id, interaction_count, last_interacted_at)
       VALUES ($1, $2, 1, NOW())
       ON CONFLICT (anonymous_id, category_id) 
       DO UPDATE SET 
         interaction_count = user_interests.interaction_count + 1,
         last_interacted_at = NOW()
       RETURNING *`,
      [anonymous_id, categoryIdValue]
    );

    res.json({ success: true, data: result.rows[0] });
  } catch (error) {
    console.error('Error tracking interest:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// POST /v1/notifications/subscribe - Subscribe to push notifications
router.post('/notifications/subscribe', strictLimiter, async (req, res) => {
  try {
    const { deviceToken } = req.body;
    
    if (!deviceToken) {
      return res.status(400).json({ error: 'deviceToken required' });
    }

    const result = await NotificationService.subscribeToTopic(deviceToken);
    res.json(result);
  } catch (error) {
    console.error('Subscribe error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// POST /v1/notifications/unsubscribe - Unsubscribe from push notifications
router.post('/notifications/unsubscribe', strictLimiter, async (req, res) => {
  try {
    const { deviceToken } = req.body;
    
    if (!deviceToken) {
      return res.status(400).json({ error: 'deviceToken required' });
    }

    const result = await NotificationService.unsubscribeFromTopic(deviceToken);
    res.json(result);
  } catch (error) {
    console.error('Unsubscribe error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// POST /v1/articles - Create new article and trigger notification
router.post('/articles', authenticateApiKey, strictLimiter, validateArticleInput, async (req, res) => {
  try {
    const { title, category, content, thumbnail_url, published_date, is_premium, affiliate_links } = req.body;

    const result = await db.query(
      `INSERT INTO articles (title, category, content, thumbnail_url, published_date, is_premium)
       VALUES ($1, $2, $3, $4, $5, $6)
       RETURNING *`,
      [title, category, content, thumbnail_url, published_date, is_premium || false]
    );

    const newArticle = result.rows[0];

    if (affiliate_links && affiliate_links.length > 0) {
      for (const link of affiliate_links) {
        await db.query(
          `INSERT INTO affiliate_links (article_id, label, url) VALUES ($1, $2, $3)`,
          [newArticle.id, link.label, link.url]
        );
      }
    }

    await db.query(
      `UPDATE categories SET article_count = (SELECT COUNT(*) FROM articles WHERE category = $1) WHERE id = $1`,
      [category]
    );

    const notification = await NotificationService.sendNewArticleNotification(newArticle);
    console.log('Notification result:', notification);

    res.status(201).json(newArticle);
  } catch (error) {
    console.error('Error creating article:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

module.exports = router;
