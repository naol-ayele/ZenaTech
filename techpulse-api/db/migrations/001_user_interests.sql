-- Migration: Create user_interests table
-- Run this SQL in your PostgreSQL database to enable anonymous user tracking

-- Create the user_interests table with foreign key reference to categories
CREATE TABLE IF NOT EXISTS user_interests (
  id SERIAL PRIMARY KEY,
  anonymous_id VARCHAR(255) NOT NULL,
  category_id INTEGER NOT NULL,
  interaction_count INTEGER DEFAULT 1,
  last_interacted_at TIMESTAMP DEFAULT NOW(),
  created_at TIMESTAMP DEFAULT NOW(),
  CONSTRAINT fk_category FOREIGN KEY (category_id) 
    REFERENCES categories(id) ON DELETE CASCADE,
  UNIQUE(anonymous_id, category_id)
);

-- Create indexes for faster queries
CREATE INDEX IF NOT EXISTS idx_user_interests_anonymous_id 
  ON user_interests(anonymous_id);
  
CREATE INDEX IF NOT EXISTS idx_user_interests_category_id 
  ON user_interests(category_id);

-- Optional: Create a view to get top interests for an anonymous user
CREATE OR REPLACE VIEW user_top_interests AS
SELECT 
  anonymous_id,
  c.name as category_name,
  interaction_count,
  last_interacted_at
FROM user_interests ui
JOIN categories c ON c.id = ui.category_id
WHERE ui.interaction_count > 0
ORDER BY ui.interaction_count DESC;

-- Show confirmation
DO $$
BEGIN
  RAISE NOTICE 'Migration 001: user_interests table created successfully';
END $$;