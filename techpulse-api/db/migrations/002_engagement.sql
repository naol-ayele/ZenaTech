-- Migration: Add engagement columns and like tracking
-- Run this SQL in your PostgreSQL database

-- Add upvotes column to articles table
ALTER TABLE articles ADD COLUMN IF NOT EXISTS upvotes INTEGER DEFAULT 0;

-- Create article_likes table to track anonymous users who liked articles
CREATE TABLE IF NOT EXISTS article_likes (
  id SERIAL PRIMARY KEY,
  article_id UUID NOT NULL,
  anonymous_id VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  CONSTRAINT fk_article_like FOREIGN KEY (article_id) 
    REFERENCES articles(id) ON DELETE CASCADE,
  UNIQUE(article_id, anonymous_id)
);

-- Create index for faster lookups
CREATE INDEX IF NOT EXISTS idx_article_likes_anonymous_id 
  ON article_likes(anonymous_id);

-- Show confirmation
DO $$
BEGIN
  RAISE NOTICE 'Migration: engagement columns added successfully';
END $$;