-- oldest incomplete, past due tasks
select
    zr.ztitle as title,
    datetime(zr.zcreationdate + 978307200, 'unixepoch') as creation_date,
    datetime(zr.zduedate + 978307200, 'unixepoch') as due_date
from
    zremcdreminder as zr
inner join zremcdbaselist as zl on zr.zlist = zl.z_pk
where
    zr.zcompleted = 0
    and zr.zmarkedfordeletion = 0
    and (
        due_date is NULL
        or due_date < datetime('now')
    )
    and zl.zname in ('Tasks')
order by
    zr.zduedate asc, zr.zcreationdate asc
limit 20;

-- number of times each task has been completed
select
    ztitle as title,
    count(zcompleted) as times_completed
from zremcdreminder
where
    zcompleted = 1
    and zduedate is not NULL
group by ztitle
having times_completed > 1
order by times_completed desc, zduedate desc;


-- number of times a repeating task has been completed during the last 100
-- days, grouped per week.
with repeating_tasks as (
    select zzr.ztitle as title from
        zremcdobject as zr
    inner join zremcdreminder as zzr on zr.zreminder4 = zzr.z_pk
)
select
    ztitle,
    strftime('%Y-%W', datetime(zduedate + 978307200, 'unixepoch')) as week,
    count(1) as times_completed
from
    zremcdreminder
where
    zduedate is not NULL
    and zcompleted = 1
    and datetime(zduedate + 978307200, 'unixepoch') between
    datetime('now', '-100 days', 'weekday 0') and
    datetime('now', 'weekday 0')
    and zmarkedfordeletion = 0
    and exists (select 1 from repeating_tasks where ztitle = title)
    -- optional, display a subset of tasks
    and ztitle in ('Training')
group by
    week, ztitle
order by
    week desc;

-- all tasks completed in the last week
select
    count(1) times_completed,
    zr.ztitle as title,
    datetime(zr.zcompletiondate + 978307200, 'unixepoch') as completion_date
from
    zremcdreminder as zr
inner join zremcdbaselist as zl on zr.zlist = zl.z_pk
where
    zr.zcompleted = 1
    and zr.zmarkedfordeletion = 0
    and completion_date between datetime('now', 'weekday 0', '-7 day') and datetime('now')
    and zl.zname in ('Tasks')
group by
  zr.ztitle
order by
  times_completed desc;


-- trending # of completed tasks
select
    strftime('%Y-%W', datetime(zcompletiondate + 978307200, 'unixepoch')) as week,
    count(1) as completed
from
    zremcdreminder as zr
inner join zremcdbaselist as zl on zr.zlist = zl.z_pk
where
    zr.zcompleted = 1
    and zr.zmarkedfordeletion = 0
    and datetime(zr.zcompletiondate + 978307200, 'unixepoch') between datetime('now', 'weekday 0', '-100 day') and datetime('now')
    and zl.zname in ('Tasks')
group by
    week
order by
    week desc;


-- tasks for this week, ordered by non-repeating, repeating and priority
with repeating_tasks as (
    select zzr.ztitle as title from
        zremcdobject as zr
    inner join zremcdreminder as zzr on zr.zreminder4 = zzr.z_pk
)
select
    zpriority,
    ztitle,
    datetime(zr.zduedate + 978307200, 'unixepoch') as due_date,
    (select 1 from repeating_tasks rt where rt.title = zr.ztitle) as is_repeating
from
    zremcdreminder zr
where
    due_date between datetime('now', 'weekday 0', '-7 day') and datetime('now', 'weekday 0')
order by
 is_repeating asc, zpriority desc
