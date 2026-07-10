-- TechPulse Database Schema

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Categories table
CREATE TABLE IF NOT EXISTS categories (
    id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    icon VARCHAR(50) NOT NULL,
    article_count INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Articles table
CREATE TABLE IF NOT EXISTS articles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(255) NOT NULL,
    category VARCHAR(50) REFERENCES categories(id) ON DELETE SET NULL,
    content TEXT,
    thumbnail_url VARCHAR(500),
    published_date DATE NOT NULL,
    views INTEGER DEFAULT 0,
    is_premium BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Affiliate links table
CREATE TABLE IF NOT EXISTS affiliate_links (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    article_id UUID REFERENCES articles(id) ON DELETE CASCADE,
    label VARCHAR(100) NOT NULL,
    url VARCHAR(500) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_articles_category ON articles(category);
CREATE INDEX IF NOT EXISTS idx_articles_published_date ON articles(published_date);
CREATE INDEX IF NOT EXISTS idx_affiliate_links_article ON affiliate_links(article_id);

-- Insert sample categories
INSERT INTO categories (id, name, icon, article_count) VALUES
    ('programming', 'Programming', 'code', 15),
    ('mobile', 'Mobile', 'phone_android', 12),
    ('ai', 'AI & ML', 'psychology', 20),
    ('security', 'Security', 'security', 8),
    ('cloud', 'Cloud', 'cloud', 10)
ON CONFLICT (id) DO NOTHING;

-- Insert sample articles
INSERT INTO articles (title, category, content, thumbnail_url, published_date, views, is_premium) VALUES
    ('Best Programming Languages in 2026', 'programming', '<p>Programming continues to evolve. Here are the top languages...</p>', 'https://picsum.photos/400/200', '2026-04-01', 1250, false),
    ('Flutter vs React Native: Which is Better?', 'mobile', '<p>Comparing cross-platform frameworks in 2026...</p>', 'https://picsum.photos/401/200', '2026-04-05', 890, true),
    ('AI Tools for Developers', 'ai', '<p>Artificial intelligence is transforming software development...</p>', 'https://picsum.photos/402/200', '2026-04-08', 2100, false),
    ('Web Security Best Practices', 'security', '<p>Protecting your applications from threats...</p>', 'https://picsum.photos/403/200', '2026-04-10', 567, false),
    ('Cloud Computing Trends', 'cloud', '<p>AWS, Azure, and GCP updates for 2026...</p>', 'https://picsum.photos/404/200', '2026-04-11', 432, true)
ON CONFLICT DO NOTHING;

-- Insert sample affiliate links
INSERT INTO affiliate_links (article_id, label, url)
SELECT id, 'Buy Python Books', 'https://amazon.com'
FROM articles WHERE title LIKE '%Programming%'
ON CONFLICT DO NOTHING;

INSERT INTO affiliate_links (article_id, label, url)
SELECT id, 'Try ChatGPT', 'https://chat.openai.com'
FROM articles WHERE title LIKE '%AI%'
ON CONFLICT DO NOTHING;

-- Update category counts
UPDATE categories c
SET article_count = (
    SELECT COUNT(*)::INTEGER FROM articles a WHERE a.category = c.id
);