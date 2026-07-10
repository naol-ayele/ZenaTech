-- Migration: Add performance indexes for better query optimization
-- Run this SQL in your PostgreSQL database

-- ============================================
-- ARTICLES TABLE INDEXES
-- ============================================

-- Index on created_at for "Latest" and "Recent" queries
CREATE INDEX IF NOT EXISTS idx_articles_created_at 
  ON articles(created_at DESC);

-- Composite index on category + published_date for category feeds
CREATE INDEX IF NOT EXISTS idx_articles_category_published 
  ON articles(category, published_date DESC);

-- Index on views for trending queries (descending order for efficient sorting)
CREATE INDEX IF NOT EXISTS idx_articles_views_desc 
  ON articles(views DESC);

-- Index on is_premium for filtering premium content
CREATE INDEX IF NOT EXISTS idx_articles_is_premium 
  ON articles(is_premium);

-- ============================================
-- USER ENGAGEMENT INDEXES
-- ============================================

-- Composite index on user_interests for faster engagement lookups
CREATE INDEX IF NOT EXISTS idx_user_interests_anonymous_category 
  ON user_interests(anonymous_id, category_id);

-- Index on last_interacted_at for recency-based sorting
CREATE INDEX IF NOT EXISTS idx_user_interests_last_interacted 
  ON user_interests(last_interacted_at DESC);

-- ============================================
-- ARTICLE LIKES INDEXES
-- ============================================

-- Index on article_id for faster like counts
CREATE INDEX IF NOT EXISTS idx_article_likes_article_id 
  ON article_likes(article_id);

-- Composite index for checking if user liked article
CREATE INDEX IF NOT EXISTS idx_article_likes_article_user 
  ON article_likes(article_id, anonymous_id);

-- Show confirmation
DO $$
BEGIN
  RAISE NOTICE 'Migration 003: Performance indexes added successfully';
  RAISE NOTICE 'Index Summary:';
  RAISE NOTICE '  - idx_articles_created_at (for Latest queries)';
  RAISE NOTICE '  - idx_articles_category_published (for category feeds)';
  RAISE NOTICE '  - idx_articles_views_desc (for Trending queries)';
  RAISE NOTICE '  - idx_articles_is_premium (for premium filtering)';
  RAISE NOTICE '  - idx_user_interests_anonymous_category (for engagement)';
  RAISE NOTICE '  - idx_user_interests_last_interacted (for recency)';
  RAISE NOTICE '  - idx_article_likes_article_id (for like counts)';
  RAISE NOTICE '  - idx_article_likes_article_user (for user likes)';
END $$;