-- Migration 004: Full-text search with combined GIN index
-- Run: psql -d techpulse -f db/migrations/004_fulltext_search.sql

CREATE INDEX IF NOT EXISTS idx_articles_fulltext_search
ON articles
USING gin(to_tsvector('english', coalesce(title, '') || ' ' || coalesce(content, '') || ' ' || coalesce(category, '')));
