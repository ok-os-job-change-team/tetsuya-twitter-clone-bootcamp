```mermaid
erDiagram

%% 1:0or多
USERS ||--o{ POSTS : "has many / belongs to"
USERS ||--o{ FAVORITES : "has many / belongs to"
POSTS ||--o{ FAVORITES : "has many / belongs to"

 USERS {
  bigint id PK
  string email
  string password_digest
  datetime created_at
  datetime updated_at
}

POSTS {
  bigint id PK
  bigint user_id FK
  string title
  string content
  datetime created_at
  datetime updated_at
}

FAVORITES {
  bigint id PK
  bigint post_id FK
  bigint user_id FK
  datetime created_at
  datetime updated_at
}
```
