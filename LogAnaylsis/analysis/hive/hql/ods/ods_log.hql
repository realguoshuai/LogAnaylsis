create external table if not exists ods_log(
	http_x_forwarded_for string,
	server_addr string,
	server_name string,
	remote_addr string,
	remote_user string,
	time_local string,
	request string,
	status string,
	body_bytes_sent string,
	http_referer string,
	http_user_agent string,
	request_time string,
	request_length string
)
partitioned by(date_day string)
row format SERDE 'org.apache.hadoop.hive.serde2.RegexSerDe'
with SERDEPROPERTIES(
"input.regex" = "\"(.*)\" \\| \"(.*),(.*)\" \\| \"(.*)\" \"-\" \"(.*)\" \"\\[(.*)\\]\" \"(.*)\" \"(.*)\" \"(.*)\" \"(.*)\" \"(.*)\" (.*) (.*)"
)
location '/log_anaylsis'; -- 分区表不会直接加载这里下的数据文件
alter table ods_log drop partition(date_day='${yyyymmdd}');
alter table ods_log add partition(date_day='${yyyymmdd}') location '/log_anaylsis/${yyyymmdd}';