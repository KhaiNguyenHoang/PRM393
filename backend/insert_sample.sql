DO $$ 
DECLARE
    admin_id uuid;
    movie1_id uuid;
    movie2_id uuid;
BEGIN
    SELECT "Id" INTO admin_id FROM users WHERE "UserName" = 'admin@netmu.com' LIMIT 1;
    
    SELECT "Id" INTO movie1_id FROM movies ORDER BY "Title" ASC LIMIT 1;
    SELECT "Id" INTO movie2_id FROM movies ORDER BY "Title" DESC LIMIT 1;

    IF admin_id IS NOT NULL AND movie1_id IS NOT NULL THEN
        -- Insert favorites
        INSERT INTO favorite_movies ("Id", "UserId", "MovieId", "CreatedAt", "UpdatedAt") 
        VALUES (gen_random_uuid(), admin_id, movie1_id, NOW(), NOW()) ON CONFLICT DO NOTHING;
        
        INSERT INTO favorite_movies ("Id", "UserId", "MovieId", "CreatedAt", "UpdatedAt") 
        VALUES (gen_random_uuid(), admin_id, movie2_id, NOW(), NOW()) ON CONFLICT DO NOTHING;

        -- Insert reviews
        INSERT INTO reviews ("Id", "UserId", "MovieId", "Content", "Rating", "CreatedAt", "UpdatedAt") 
        VALUES (gen_random_uuid(), admin_id, movie1_id, 'Phim này cực kỳ lôi cuốn, rất đáng xem!', 5, NOW(), NOW());

        INSERT INTO reviews ("Id", "UserId", "MovieId", "Content", "Rating", "CreatedAt", "UpdatedAt") 
        VALUES (gen_random_uuid(), admin_id, movie2_id, 'Cốt truyện ổn nhưng mạch phim hơi chậm.', 4, NOW(), NOW());
    END IF;
END $$;
