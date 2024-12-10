select
    *,
    ztitle as title,
    zcompleted as completed,
    zmarkedfordeletion as marked_for_deletion,
    zpriority as priority,
    datetime(zstartdate + 978307200, 'unixepoch') as start_date,
    datetime(zduedate + 978307200, 'unixepoch') as due_date
from
    zremcdreminder
where
    ztitle = 'Limpiar escritorio'
    -- due_date is not NULL
    -- and due_date < datetime('now')
    -- and completed = 0
    -- and marked_for_deletion = 0
ORDER BY
    due_date DESC;

select
    z_pk,
    ztitle1
from
    ZREMCDOBJECT
ORDER BY
    z_pk DESC;

select
    ztitle as title,
    zcompleted as completed,
    zmarkedfordeletion as marked_for_deletion,
    zpriority as priority,
    datetime(zstartdate + 978307200, 'unixepoch') as start_date,
    datetime(zduedate + 978307200, 'unixepoch') as due_date
from
    zremcdreminder
where
    due_date IS NOT NULL
    AND due_date <= datetime('now', 'weekday 6', 'start of day', '+1 day') -- End of the current week
    AND completed = 0
    AND marked_for_deletion = 0
order by
    due_date DESC
LIMIT 10;

select
    ztitle as title,
    zcompleted as completed,
    zmarkedfordeletion as marked_for_deletion,
    zpriority as priority,
    datetime(zstartdate + 978307200, 'unixepoch') as start_date,
    datetime(zduedate + 978307200, 'unixepoch') as due_date
from
    zremcdreminder
where
    due_date IS NOT NULL
    AND due_date <= datetime('now', '+1 day')
    AND completed = 0
    AND marked_for_deletion = 0
ORDER BY
    due_date DESC
LIMIT 10;

select
    *
from
    zremcdreminder
where
    zcompleted = 0
    AND zmarkedfordeletion = 0
ORDER BY
    zduedate asC
LIMIT 10;

-- list all tables
select
    name
from
    sqlite_master
where
    type = 'table'
ORDER BY
    name;

-- information about the table
pragma table_info(zremcdreminder);

pragma table_info(ZREMCDBasELIST);

select
    z_pk,
    zname
from
    zremcdbaselist;

select
    *
from
    zremcdreminder;

select
    *
from
    zremcdbaselist;

select
    zname,
    ztitle
from
    ZREMCDOBJECT;

select
    hex(zreminderidentifier)
from
    ZREMCDDUEDATEDELTAALERT;

select
    lower(substr(hex(zreminderidentifier), 1, 8) || '-' || -- First 8 characters
        substr(hex(zreminderidentifier), 9, 4) || '-' || -- Next 4 characters
        substr(hex(zreminderidentifier), 13, 4) || '-' || -- Next 4 characters
        substr(hex(zreminderidentifier), 17, 4) || '-' || -- Next 4 characters
        substr(hex(zreminderidentifier), 21) -- Last 12 characters
) as uuid
from
    ZREMCDDUEDATEDELTAALERT;

select
    ztitle
from
    zremcdreminder
where
    zidentifier =(
        select
            zreminderidentifier
        from
            ZREMCDDUEDATEDELTAALERT
        LIMIT 1);

select
    *
from
    ZREMCDDUEDATEDELTAALERT
where
    zreminderidentifier = unhex('960A3295A002473AA47309CE9D25C653');

select
    zr.ztitle,
    zd.*
from
    zremcdreminder zr
    JOIN ZREMCDDUEDATEDELTAALERT zd ON zr.zidentifier = zd.zreminderidentifier
where
    ZDUEDATEDELTACOUNT != 0;

select
    *
from
    ZREMCDHasHTAGLABEL;

select
    *
from
    ZREMCDMIGRATIONSTATE;

select
    zzr.ztitle,
    zr.zfrequency,
    zr.ZOCCURRENCECOUNT,
    zr.zinterval,
    zr.z_fok_reminder,
    zr.z_fok_reminder1,
    zr.z_fok_reminder2,
    zr.zreminder,
    zr.zreminder1,
    zr.zreminder2,
    zr.zreminder3,
    zr.zreminder4,
    zr.zreminder5
from
    ZREMCDOBJECT zr
    JOIN zremcdreminder zzr ON zzr.z_pk IN (zr.zreminder, zr.ZREMINDER1, zr.zreminder2, zr.zreminder3, zr.zreminder4, zr.zreminder5)
    -- where
    --    zr.zfrequency is not null
where
    zzr.ztitle = 'Limpiar escritorio'
ORDER BY
    zzr.ztitle DESC
    select
        hex(zidentifier),
        ZREMINDERIDENTIFIER
    from
        zremcdobject
    ORDER BY
        zreminderidentifier DESC;

select * from ZREMCDOBJECT where zfrequency is not null;

select
    count(1)
from
    zremcdreminder;

select
    ztitle,
    z_pk,
    ZCKPARENTREMINDERIDENTIFIER
from
    zremcdreminder
ORDER BY
    ZCKPARENTREMINDERIDENTIFIER DESC
LIMIT 10;

select
    *
from
    ZREMCDACCOUNTLISTDATA;

select
    *
from
    ZREMCDBasELIST;

select
    *
from
    ZREMCDSAVEDREMINDER;

select
    datetime('now'),
    datetime('now', 'weekday 0'),
    datetime('now', '-21 days'),
    datetime('now', '-21 days', 'weekday 0'
)
select
    strftime('%W', datetime('now'));

select
    datetime('now', 'weekday 0');

-- report the % of tasks completed on the given interval
select
    count(
        CasE WHEN zcompleted = 1 THEN
            1
        END) as complete,
    count(
        CasE WHEN zcompleted = 0 THEN
            1
        END) as incomplete,
    round(100.0 * count(
            CasE WHEN zcompleted = 1 THEN
                1
            END) / count(*), 2) as completion_percentage
from
    zremcdreminder
where
    zduedate IS NOT NULL
    AND datetime(zduedate + 978307200, 'unixepoch') >= datetime('now', '-7 days')
    AND datetime(zduedate + 978307200, 'unixepoch') < datetime('now')
    AND zmarkedfordeletion = 0;

-- Report the % of tasks completed for each week in the last 3 weeks
select
    strftime('%Y-%W', datetime(zduedate + 978307200, 'unixepoch')) as week,
    count(
        CasE WHEN zcompleted = 1 THEN
            1
        END) as complete,
    count(
        CasE WHEN zcompleted = 0 THEN
            1
        END) as incomplete,
    round(100.0 * count(
            CasE WHEN zcompleted = 1 THEN
                1
            END) / count(*), 2) as completion_percentage
from
    zremcdreminder
where
    zduedate IS NOT NULL
    AND datetime(zduedate + 978307200, 'unixepoch') >= datetime('now', '-21 days', 'weekday 0')
    AND datetime(zduedate + 978307200, 'unixepoch') < datetime('now', 'weekday 0')
    AND zmarkedfordeletion = 0
GROUP BY
    week
ORDER BY
    week DESC;

