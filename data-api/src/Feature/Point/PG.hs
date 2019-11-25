module Feature.Article.PG where

import ClassyPrelude
import Feature.Article.Types
import Feature.Auth.Types
import Feature.Common.Types
import Platform.PG
import Database.PostgreSQL.Simple.SqlQQ
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.Types


findArticles  :: PG r m
              => Maybe Slug -> Maybe Bool -> Maybe CurrentUser
              -> ArticleFilter -> Pagination
              -> m [Article]
findArticles maySlug mayFollowing mayCurrentUser articleFilter pagination =
  withConn $ \conn -> query conn qry arg
  where
    qry = [sql|
            with profiles as (
              select
                id, name, bio, image, exists(select 1 from followings where user_id = id and followed_by = ?) as following
              from
                users
            ),
            formatted_articles as (
              select 
                articles.id, slug, title, description, body, tags, created_at, updated_at,
                exists(select 1 from favorites where article_id = articles.id and favorited_by = ?) as favorited,
                (select count(1) from favorites where article_id = articles.id) as favorites_count,
                profiles.name as pname, profiles.bio as pbio, profiles.image as pimage, profiles.following as pfollowing
              from
                articles join profiles on articles.author_id = profiles.id
            )
            select
              cast (slug as text), title, description, body, cast (tags as text[]), created_at, updated_at,
              favorited, favorites_count, cast (pname as text), pbio, pimage, pfollowing
            from
              formatted_articles
            where
              -- by slug (for find one)
              coalesce(slug in ?, true) AND
              -- by if user following author (for feed)
              coalesce(pfollowing in ?, true) and
              -- by tag (for normal filter)
              (cast (tags as text[]) @> ?) and
              -- by author (for normal filter)
              coalesce (pname in ?, true) and
              -- by fav by (for normal filter)
              (? is null OR exists(
                select 1 
                from favorites join users on users.id = favorites.favorited_by 
                where article_id = formatted_articles.id and users.name = ?)
              )
            order by id desc
            limit greatest(0, ?) offset greatest(0, ?)
          |]
    curUserId = maybe (-1) snd mayCurrentUser
    arg = ( curUserId, curUserId
          -- ^ 2 slots for current user id
          , In $ maybeToList maySlug
          -- ^ 1 slot for slug
          , In $ maybeToList $ mayFollowing
          -- ^ 1 slot for following
          , PGArray $ maybeToList $ articleFilterTag articleFilter
          -- ^ 1 slot for tags
          , In $ maybeToList $ articleFilterAuthor articleFilter
          -- ^ 1 slot for author
          , articleFilterFavoritedBy articleFilter, articleFilterFavoritedBy articleFilter
          -- ^ 2 slots for favorited by user name
          , paginationLimit pagination, paginationOffset pagination
          -- ^ 2 slot for limit & offset
          )
