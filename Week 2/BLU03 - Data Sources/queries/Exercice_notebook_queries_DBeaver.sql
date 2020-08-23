--EX1
select 	id,
	   	name
from 	team
where 	id = 10252;

--EX2
select 	count(height)
from   	player
where  	height > 200;

--EX3
select 	avg(ta.buildupplayspeed)
from   	team_attributes as ta
       	inner join 	team as t
              	on 	ta.team_id = t.id
where 	t.name like 'FC%';

--EX4
select 	id,
       	name
from 	team as t;

select 	count(distinct(m1.home_team_id))
from   	match as m1
	   	full outer 	join match as m2
	  			on 	m1.home_team_id = m2.away_team_id
	  	inner join 	league as l
	  			on 	l.id = m1.league_id
where l.name like 'Italy Serie A';

--EX5
select 	avg(m.away_team_goal) as away_goals,
		c.name
from 	match as m
		inner join 	league as l
				on 	m.league_id = l.id
		inner join 	country as c
				on 	l.country_id = c.id
group by 	c.name
order by 	away_goals desc
limit  	1;

--EX6
select  t.name as name,
		t.short_name as short_name,
		max(m.home_team_goal) as max_goal
from 	team as t
		inner join	match as m
				on	t.id = m.home_team_id
		inner join 	team_attributes as ta
				on 	t.id = ta.team_id 
where 	ta.buildupplaydribbling > 50
group by	t.id
having	avg(m.home_team_goal) > 2
		and count(m.id) > 50
order by	short_name desc;

--EX7

          