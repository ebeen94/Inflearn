--- data check
select count(*) from inflearn

--- find distinct number of courses
select count(distinct course_id) from inflearn

--- most popular instructor 
select instructor, sum(enrolled)
from inflearn
group by 1
order by 2 desc

--- most popular category
select distinct regexp_replace(unnest(string_to_array(category, ',')), '\s+', ''), 
        sum(enrolled) as enrolled,
        count(distinct course_id) as avail_courses
from inflearn
group by 1
order by 2 desc


--- update duration to minutes
update inflearn
set duration = case when duration like '%시간%' 
                    then (split_part(duration, '시간',1)::integer) * 60
                    when duration like '%시간%' 
                    then regexp_replace(split_part(duration, '시간',2),'분', '')::integer
                    when duration like '%분'  and duration not like '%시간%' 
                    then regexp_replace(split_part(duration, '분',1),'분', '')::integer end

--- create a CTE with distinct categories and distinct skills for each row
with CTE as(
    select distinct *, 
            regexp_replace(unnest(string_to_array(category, ',')), '\s+', '')as distinct_category, 
            regexp_replace(unnest(string_to_array(skill, ',')), '\s+', '') as distinct_skill
    from inflearn
    where skill != '0'
    and category != '0'
    order by publish_date)
select distinct_skill, sum(enrolled)
from CTE
group by distinct_skill
order by 2 desc

--- export the CTE as csv file for visualization 
COPY(  
select distinct *, 
        regexp_replace(unnest(string_to_array(category, ',')), '\s+', '')as distinct_category, 
        regexp_replace(unnest(string_to_array(skill, ',')), '\s+', '') as distinct_skill
from inflearn
where skill != '0'
and category != '0'
order by publish_date
)
TO '/Users/charlottechoi/projects/inflearn/excel/distinct_data.csv'
DELIMITER
',' CSV HEADER













































