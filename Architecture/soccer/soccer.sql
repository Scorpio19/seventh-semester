create table users (
    id integer, 
    username text, 
    password text, 
    admin text, 
    total_score integer, 
    created_at text, 
    updated_at text
);

create table polls (
    id integer, 
    status text, 
    matches text, 
    results text, 
    created_at text, 
    updated_at text
);

create table picks (
    id integer, 
    user_id integer, 
    poll_id integer, 
    score integer, 
    expected text, 
    created_at text, 
    updated_at text
);
