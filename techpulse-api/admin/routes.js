const express = require('express');
const path = require('path');
const fs = require('fs');
const db = require('../db');
const adminAuth = require('./middleware/adminAuth');

const router = express.Router();

// Template helpers
const viewsDir = path.join(__dirname, 'views');
const cache = {};

function loadTemplate(name) {
  if (cache[name]) return cache[name];
  const filePath = path.join(viewsDir, ...name.split('/'));
  cache[name] = fs.readFileSync(filePath, 'utf-8');
  return cache[name];
}

function render(templateName, data) {
  const template = loadTemplate(templateName);

  if (templateName !== 'layout.html') {
    const body = renderPartial(template, data);
    return render('layout.html', { ...data, body, loggedIn: data.loggedIn !== false });
  }

  let html = template;

  // Section blocks ({{#key}}...{{/key}})
  html = html.replace(/\{\{#([\w.]+)\}\}([\s\S]*?)\{\{\/\1\}\}/g, (_, key, content) => {
    const val = resolveValue(data, key);
    if (key === 'article' && val && typeof val === 'object') {
      if (Object.keys(val).length > 0) return renderPartial(content, data);
      return '';
    }
    if (Array.isArray(val)) {
      return val.map(item => renderPartial(content, { ...data, ...item })).join('');
    }
    if (val) return renderPartial(content, data);
    return '';
  });

  // Inverted section blocks ({{^key}}...{{/key}})
  html = html.replace(/\{\{\^([\w.]+)\}\}([\s\S]*?)\{\{\/\1\}\}/g, (_, key, content) => {
    const val = resolveValue(data, key);
    if (Array.isArray(val)) {
      return val.length === 0 ? renderPartial(content, data) : '';
    }
    return val ? '' : renderPartial(content, data);
  });

  // Variables
  html = html.replace(/\{\{(.+?)\}\}/g, (_, key) => {
    const trimmed = key.trim();
    if (trimmed === 'body') return data.body || '';
    const value = resolveValue(data, trimmed);
    return value !== undefined ? escapeHtml(String(value)) : '';
  });

  return html;
}

function renderPartial(template, data) {
  let html = template;

  // Section blocks
  html = html.replace(/\{\{#([\w.]+)\}\}([\s\S]*?)\{\{\/\1\}\}/g, (_, key, content) => {
    const val = resolveValue(data, key);
    if (key === 'article' && val && typeof val === 'object') {
      if (Object.keys(val).length > 0) return renderPartial(content, { ...data, ...val, article: val });
      return '';
    }
    if (Array.isArray(val)) {
      return val.map(item => renderPartial(content, { ...data, ...item })).join('');
    }
    if (val) return renderPartial(content, data);
    return '';
  });

  // Inverted section blocks
  html = html.replace(/\{\{\^([\w.]+)\}\}([\s\S]*?)\{\{\/\1\}\}/g, (_, key, content) => {
    const val = resolveValue(data, key);
    if (Array.isArray(val)) return val.length === 0 ? renderPartial(content, data) : '';
    return val ? '' : renderPartial(content, data);
  });

  // Variables
  html = html.replace(/\{\{(.+?)\}\}/g, (_, key) => {
    const trimmed = key.trim();
    const value = resolveValue(data, trimmed);
    return value !== undefined ? escapeHtml(String(value)) : '';
  });

  return html;
}

function resolveValue(data, path) {
  const parts = path.split('.');
  let value = data;
  for (const part of parts) {
    if (value == null || !Object.prototype.hasOwnProperty.call(value, part)) return undefined;
    value = value[part];
  }
  return value;
}

function escapeHtml(str) {
  return str
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#039;');
}

function normalizeArray(val) {
  return Array.isArray(val) ? val : (val ? [val] : []);
}

// ─── Public: Login ───────────────────────────────────────────────

router.get('/login', (req, res) => {
  if (req.session && req.session.adminLoggedIn) {
    return res.redirect('/admin/articles');
  }
  res.send(render('login.html', { title: 'Login', loggedIn: false }));
});

router.post('/login', (req, res) => {
  const { password } = req.body;
  if (password === process.env.ADMIN_PASSWORD) {
    req.session.adminLoggedIn = true;
    return res.redirect('/admin/articles');
  }
  res.send(render('login.html', { title: 'Login', loggedIn: false, error: 'Invalid password' }));
});

router.get('/logout', (req, res) => {
  req.session.destroy(() => {
    res.redirect('/admin/login');
  });
});

// ─── Protected: Articles CRUD ────────────────────────────────────

router.use(adminAuth);

router.get('/articles', async (req, res) => {
  try {
    const result = await db.query(
      `SELECT a.id, a.title, c.name AS category, a.views, a.published_date
       FROM articles a
       JOIN categories c ON c.id = a.category
       ORDER BY a.published_date DESC, a.created_at DESC`
    );
    const articles = result.rows.map(a => ({
      id: a.id,
      title: a.title,
      category: a.category,
      views: a.views,
      publishedDate: a.published_date ? new Date(a.published_date).toISOString().split('T')[0] : '',
      editUrl: `/admin/articles/${a.id}/edit`,
      deleteUrl: `/admin/articles/${a.id}/delete`,
    }));
    res.send(render('articles/index.html', { title: 'Articles', articles }));
  } catch (err) {
    console.error('Error listing articles:', err);
    res.send(render('articles/index.html', { title: 'Articles', error: 'Failed to load articles' }));
  }
});

router.get('/articles/new', async (req, res) => {
  try {
    const cats = await db.query('SELECT id, name FROM categories ORDER BY name');
    let categories = cats.rows.map(c => ({ id: c.id, name: c.name }));
    if (categories.length === 0) {
      categories = [
        { id: 'programming', name: 'Programming' },
        { id: 'mobile', name: 'Mobile' },
        { id: 'ai', name: 'AI & ML' },
        { id: 'security', name: 'Security' },
        { id: 'cloud', name: 'Cloud' },
      ];
    }
    const today = new Date().toISOString().split('T')[0];
    res.send(render('articles/form.html', { title: 'New Article', categories, isEdit: false, article: { publishedDate: today } }));
  } catch (err) {
    console.error('Error loading new form:', err);
    const fallbackCategories = [
      { id: 'programming', name: 'Programming' },
      { id: 'mobile', name: 'Mobile' },
      { id: 'ai', name: 'AI & ML' },
      { id: 'security', name: 'Security' },
      { id: 'cloud', name: 'Cloud' },
    ];
    const today = new Date().toISOString().split('T')[0];
    res.send(render('articles/form.html', {
      title: 'New Article', categories: fallbackCategories, isEdit: false,
      article: { publishedDate: today }, error: 'DB unavailable — using fallback categories'
    }));
  }
});

router.post('/articles/new', async (req, res) => {
  try {
    const { title, category, content, thumbnail_url, published_date } = req.body;
    const affiliateLabels = normalizeArray(req.body['affiliate_label[]']);
    const affiliateUrls = normalizeArray(req.body['affiliate_url[]']);

    const sanitizedTitle = title ? title.replace(/<[^>]*>/g, '').substring(0, 200).trim() : '';
    const sanitizedCategory = category ? category.replace(/<[^>]*>/g, '').substring(0, 100).trim() : '';

    if (!sanitizedTitle || !sanitizedCategory || !published_date) {
      const affiliateLinks = affiliateLabels.map((_, i) => ({
        label: affiliateLabels[i] || '',
        url: affiliateUrls[i] || '',
      })).filter(l => l.label || l.url);
      const cats = await db.query('SELECT id, name FROM categories ORDER BY name');
      return res.send(render('articles/form.html', {
        title: 'New Article', categories: cats.rows.map(c => ({ id: c.id, name: c.name })),
        isEdit: false, error: 'Title, category, and published date are required.',
        article: { title: sanitizedTitle, content, thumbnailUrl: thumbnail_url, publishedDate: published_date, affiliateLinks }
      }));
    }

    const result = await db.query(
      `INSERT INTO articles (title, category, content, thumbnail_url, published_date, is_premium)
       VALUES ($1, $2, $3, $4, $5, false)
       RETURNING id`,
      [sanitizedTitle, sanitizedCategory, content || '', thumbnail_url || '', published_date]
    );
    const articleId = result.rows[0].id;

    // Insert affiliate links
    if (affiliateLabels.length > 0) {
      for (let i = 0; i < affiliateLabels.length; i++) {
        const label = (affiliateLabels[i] || '').trim();
        const url = (affiliateUrls[i] || '').trim();
        if (label && url) {
          await db.query(
            'INSERT INTO affiliate_links (article_id, label, url) VALUES ($1, $2, $3)',
            [articleId, label, url]
          );
        }
      }
    }

    // Update category article count
    await db.query(
      `UPDATE categories SET article_count = (SELECT COUNT(*) FROM articles WHERE category = $1) WHERE id = $1`,
      [sanitizedCategory]
    );

    res.redirect('/admin/articles?success=Article+created');
  } catch (err) {
    console.error('Error creating article:', err);
    res.send(render('articles/form.html', { title: 'New Article', isEdit: false, error: 'Failed to create article' }));
  }
});

router.get('/articles/:id/edit', async (req, res) => {
  try {
    const { id } = req.params;

    const articleResult = await db.query(
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

    if (articleResult.rows.length === 0) {
      return res.redirect('/admin/articles?error=Article+not+found');
    }

    const a = articleResult.rows[0];
    const article = {
      id: a.id,
      title: a.title,
      category: a.category,
      content: a.content,
      thumbnailUrl: a.thumbnail_url,
      publishedDate: a.published_date ? new Date(a.published_date).toISOString().split('T')[0] : '',
      affiliateLinks: (a.affiliate_links || []).map(l => ({ label: l.label, url: l.url })),
    };

    const cats = await db.query('SELECT id, name FROM categories ORDER BY name');
    const categories = cats.rows.map(c => ({
      id: c.id,
      name: c.name,
      selected: c.id === a.category ? 'selected' : '',
    }));

    res.send(render('articles/form.html', { title: 'Edit Article', categories, isEdit: true, article }));
  } catch (err) {
    console.error('Error loading edit form:', err);
    res.redirect('/admin/articles?error=Failed+to+load+article');
  }
});

router.post('/articles/:id/edit', async (req, res) => {
  try {
    const { id } = req.params;
    const { title, category, content, thumbnail_url, published_date } = req.body;
    const affiliateLabels = normalizeArray(req.body['affiliate_label[]']);
    const affiliateUrls = normalizeArray(req.body['affiliate_url[]']);

    const sanitizedTitle = title ? title.replace(/<[^>]*>/g, '').substring(0, 200).trim() : '';
    const sanitizedCategory = category ? category.replace(/<[^>]*>/g, '').substring(0, 100).trim() : '';

    if (!sanitizedTitle || !sanitizedCategory || !published_date) {
      const affiliateLinks = affiliateLabels.map((_, i) => ({
        label: affiliateLabels[i] || '',
        url: affiliateUrls[i] || '',
      })).filter(l => l.label || l.url);
      const cats = await db.query('SELECT id, name FROM categories ORDER BY name');
      const categories = cats.rows.map(c => ({
        id: c.id,
        name: c.name,
        selected: c.id === sanitizedCategory ? 'selected' : '',
      }));
      return res.send(render('articles/form.html', {
        title: 'Edit Article',
        categories, isEdit: true,
        article: {
          id, title: sanitizedTitle, content,
          thumbnailUrl: thumbnail_url,
          publishedDate: published_date,
          affiliateLinks,
        },
        error: 'Title, category, and published date are required.',
      }));
    }

    // Fetch old category BEFORE the UPDATE so we can adjust counts correctly
    const oldCatResult = await db.query('SELECT category FROM articles WHERE id = $1', [id]);
    const oldCategory = oldCatResult.rows.length > 0 ? oldCatResult.rows[0].category : null;

    await db.query(
      `UPDATE articles SET title = $1, category = $2, content = $3, thumbnail_url = $4, published_date = $5, updated_at = NOW()
       WHERE id = $6`,
      [sanitizedTitle, sanitizedCategory, content || '', thumbnail_url || '', published_date, id]
    );

    // Replace affiliate links
    await db.query('DELETE FROM affiliate_links WHERE article_id = $1', [id]);

    if (affiliateLabels.length > 0) {
      for (let i = 0; i < affiliateLabels.length; i++) {
        const label = (affiliateLabels[i] || '').trim();
        const url = (affiliateUrls[i] || '').trim();
        if (label && url) {
          await db.query(
            'INSERT INTO affiliate_links (article_id, label, url) VALUES ($1, $2, $3)',
            [id, label, url]
          );
        }
      }
    }

    // Update category article count for old and new categories
    const catsToUpdate = [...new Set([oldCategory, sanitizedCategory].filter(Boolean))];
    for (const cat of catsToUpdate) {
      await db.query(
        `UPDATE categories SET article_count = (SELECT COUNT(*) FROM articles WHERE category = $1) WHERE id = $1`,
        [cat]
      );
    }

    res.redirect('/admin/articles?success=Article+updated');
  } catch (err) {
    console.error('Error updating article:', err);
    res.redirect(`/admin/articles/${req.params.id}/edit?error=Failed+to+update+article`);
  }
});

router.post('/articles/:id/delete', async (req, res) => {
  try {
    const { id } = req.params;

    // Get category before delete for count update
    const article = await db.query('SELECT category FROM articles WHERE id = $1', [id]);
    const category = article.rows.length > 0 ? article.rows[0].category : null;

    // Delete (cascades to affiliate_links)
    await db.query('DELETE FROM articles WHERE id = $1', [id]);

    // Update count
    if (category) {
      await db.query(
        `UPDATE categories SET article_count = (SELECT COUNT(*) FROM articles WHERE category = $1) WHERE id = $1`,
        [category]
      );
    }

    res.redirect('/admin/articles?success=Article+deleted');
  } catch (err) {
    console.error('Error deleting article:', err);
    res.redirect('/admin/articles?error=Failed+to+delete+article');
  }
});

module.exports = { router };
