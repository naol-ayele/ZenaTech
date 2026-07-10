function getApiKey() {
  return process.env.API_KEY;
}

function authenticateApiKey(req, res, next) {
  const apiKey = getApiKey();
  if (!apiKey) {
    console.warn('Auth: API_KEY not configured, allowing request');
    return next();
  }

  const authHeader = req.headers.authorization;

  if (!authHeader) {
    return res.status(401).json({ error: 'Missing Authorization header' });
  }

  const parts = authHeader.split(' ');
  if (parts.length !== 2 || parts[0] !== 'Bearer') {
    return res.status(401).json({ error: 'Invalid Authorization format. Use: Bearer <token>' });
  }

  const token = parts[1];

  if (token !== apiKey) {
    return res.status(403).json({ error: 'Invalid API key' });
  }

  next();
}

function optionalAuth(req, res, next) {
  const apiKey = getApiKey();
  if (!apiKey) {
    return next();
  }

  const authHeader = req.headers.authorization;
  if (authHeader) {
    const parts = authHeader.split(' ');
    if (parts.length === 2 && parts[0] === 'Bearer' && parts[1] === apiKey) {
      req.isAuthenticated = true;
    }
  }

  next();
}

module.exports = { authenticateApiKey, optionalAuth };
