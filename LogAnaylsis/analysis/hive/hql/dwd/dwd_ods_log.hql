create table if not exists dwd_ods_log as(
    select
     (case when regexp_extract(http_x_forwarded_for,"(.*),(.*),(.*)",3)<>'' then regexp_extract(http_x_forwarded_for,"(.*),(.*),(.*)",1)
          when regexp_extract(http_x_forwarded_for,"(.*),(.*)",2)<>'' then regexp_extract(http_x_forwarded_for,"(.*),(.*)",2)
            when regexp_extract(http_x_forwarded_for,"(.*)",1)<>'' then http_x_forwarded_for
       else '-'
       end )as ip ,
       (case when regexp_extract(http_x_forwarded_for,"(.*),(.*),(.*)",1)<>'' then concat_ws(" ",regexp_extract(http_x_forwarded_for,"(.*),(.*),(.*)",1),regexp_extract(http_x_forwarded_for,"(.*),(.*),(.*)",2))
          when regexp_extract(http_x_forwarded_for,"(.*),(.*)",1)<>'' then regexp_extract(http_x_forwarded_for,"(.*),(.*)",1)
            when regexp_extract(http_x_forwarded_for,"(.*)",1)<>'' then http_x_forwarded_for
       else '-'
       end) as nginx_ip ,
    server_addr,
    server_name,
    remote_addr,
    remote_user,
       from_unixtime(unix_timestamp(time_local,"dd/MMM/yyyy:HH:mm:ss z"),"yyyy-MM-dd HH:mm:ss") log_time_local,
       split(request," ")[0] request_type,
      split(request," ")[1] request_url,
       split(request," ")[2] request_protocol,
       status,
        body_bytes_sent/1024 body_kb_sent,
        http_referer,
       http_user_agent,
       request_time,
       request_length
from ods_log
)
