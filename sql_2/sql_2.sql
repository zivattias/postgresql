-- Display a table that contains all the data for all the movies (including to which series the movie is related, and director’s name)

select
	m.id,
	movie_name,
	release_year,
	d.director_name,
	length_in_min,
	s.series_name
from
	movies m
left join series s on
	m.series_id = s.id
left join directors d on
	d.director_id = m.director_id;

-- Display a table that contains series name and amount of movies in the series

select
	series_name,
	count(*)
from
	movies m
left join series s on
	m.series_id = s.id
group by s.series_name
having s.series_name is not null;

-- Display a table that shows director name and amount of movies for this director

select
	director_name,
	count(id) as movies_count
from
	movies m
right join directors d on
	d.director_id = m.director_id
group by d.director_name;

-- Display a table that contains all the directors in the db, amount of movies for each director, and amount of series for each

select
	director_name,
	count(m.id) as movies_count,
	count(distinct(s.id)) as series_count
from
	movies m
left join directors d on
	d.director_id = m.director_id
left join series s on
	s.id = m.series_id
group by
	d.director_name;

--Display all the movies, their series and directors, that have at least 2 movies in the series

--select m.series_id from movies m
--group by m.series_id
--having count(m.series_id) > 2;


select
	m.movie_name,
	d.director_name,
	s.series_name
from
	movies m
left join series s on
	m.series_id = s.id
left join directors d on
	d.director_id = m.director_id
where
	m.series_id in (
	select
		m.series_id
	from
		movies m
	group by
		m.series_id
	having
		count(m.series_id) > 2);

--Display movies that are not part of any series and their directors

select
	movie_name,
	d.director_name
from
	movies
left join directors d on
	d.director_id = movies.director_id
where
	series_id is null;

