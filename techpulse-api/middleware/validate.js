function sanitizeString(value, maxLength = 1000) {
  if (typeof value !== 'string') return '';
  const stripped = value.replace(/<[^>]*>/g, '');
  return stripped.substring(0, maxLength).trim();
}

function validateArticleInput(req, res, next) {
  const errors = [];

  if (!req.body.title || typeof req.body.title !== 'string') {
    errors.push('title is required and must be a string');
  } else if (req.body.title.length > 200) {
    errors.push('title must be 200 characters or fewer');
  }

  if (!req.body.category || typeof req.body.category !== 'string') {
    errors.push('category is required and must be a string');
  } else if (req.body.category.length > 100) {
    errors.push('category must be 100 characters or fewer');
  }

  if (!req.body.published_date || typeof req.body.published_date !== 'string') {
    errors.push('published_date is required and must be a string');
  } else if (isNaN(Date.parse(req.body.published_date))) {
    errors.push('published_date must be a valid date string');
  }

  if (req.body.content && typeof req.body.content === 'string' && req.body.content.length > 50000) {
    errors.push('content must be 50000 characters or fewer');
  }

  if (req.body.thumbnail_url && typeof req.body.thumbnail_url === 'string' && req.body.thumbnail_url.length > 500) {
    errors.push('thumbnail_url must be 500 characters or fewer');
  }

  if (errors.length > 0) {
    return res.status(400).json({ error: errors.join('; ') });
  }

  req.body.title = sanitizeString(req.body.title, 200);
  req.body.category = sanitizeString(req.body.category, 100);
  if (req.body.content) {
    req.body.content = req.body.content.substring(0, 50000);
  }

  next();
}

module.exports = { validateArticleInput, sanitizeString };
