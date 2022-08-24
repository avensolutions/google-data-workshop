{{ config(materialized='table') }}

with commits as (
    SELECT 
    SUBSTR(commit, 0, 13) as commit_short_sha,
    committer.name as commiter_name,
    committer.date as commit_date,
    message,
    repo_name
    FROM `bigquery-public-data.github_repos.sample_commits` c
)

select * from commits
