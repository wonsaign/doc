### Nginx 的 nginx.conf 配置详细解析
* 配置样例
  ```
    http {
        include         /etc/nginx/mime.types;#设定mime类型,类型由mime.type文件定义
        default_type    application/octet-stream; #设定日志格式
        access_log      /var/log/nginx/access.log;
        sendfile        on; #sendfile指令指定nginx是否调用sendfile函数（zero copy方式）来输出文件，对于普通应用，必须设为 on,如果用来进行下载等应用磁盘IO重负载应用，可设置为 off，以平衡磁盘与网络I/O处理速度，降低系统的uptime.
    
        keepalive_timeout  65; #连接超时时间
        tcp_nodelay        on;
    
        gzip               on; #开启gzip压缩
        gzip_disable       "MSIE [1-6]\.(?!.*SV1)";

        client_header_buffer_size    1k; #设定请求缓冲
        large_client_header_buffers  4 4k;

        // include     /etc/nginx/conf.d/*.conf;
        // include     /etc/nginx/sites-enabled/*;

        #设定负载均衡的服务器列表
        # 默认:轮询
        upstream mysvr0 {
            server 192.168.9.2x:80;
            server 192.168.9.3x:80;
        }
        # 权重
        upstream mysvr1 {
            #本机上的Squid开启3128端口,weigth参数表示权值，权值越高被分配到的几率越大
            server 192.168.8.1x:3128 weight=5;
            server 192.168.8.2x:80  weight=1;
            server 192.168.8.3x:80  weight=6;
        }
        # ip_hash
        upstream mysvr2 {
            ip_hash;
            server 192.168.7.x:80;
            server 192.168.7.x:80;
        }
        # fair（第三方）按后端服务器的响应时间来分配请求，响应时间短的优先分配。  
        upstream mysvr3 {  
            server 192.168.6.x:80;
            server 192.168.6.x:80;  
            fair;  
        }


        server {
            listen  80; #侦听80端口
            server_name  192.168.8.*; #定义使用192.168.8.*访问
            access_log  logs/www.xx.com.access.log  main; #设定本虚拟主机的访问日志

            #默认请求
            location / {
                root    /root; #定义服务器的默认网站根目录位置
                index   index.php index.html index.htm; #定义首页索引文件的名称

                fastcgi_pass    127.0.0.1:8080/project/;
                fastcgi_param   SCRIPT_FILENAME  $document_root/$fastcgi_script_name; 
                include         /etc/nginx/fastcgi_params;
            }
            location /static {
                # 访问{server_name}:{listen}/static/ 目录时候可以使用两种方式
                # root   /usr/html/;
                alias    /usr/html/static/; #定义服务器静态资源文件位置,注意alias与root的区别
                autoindex on; #动态生成目录树
            }            
            # 反向代理
            location /proxy {
                #Proxy Settings
                proxy_redirect     off;#是否跳转
                proxy_set_header   Host             $host; #请求要转发的host
                proxy_set_header   X-Real-IP        $remote_addr;#请求的远程地址这些在浏览器的header都可看，不一一解释
                proxy_set_header   X-Forwarded-For  $proxy_add_x_forwarded_for;
                proxy_next_upstream error timeout invalid_header http_500 http_502 http_503 http_504;
                proxy_max_temp_file_size 0;
                proxy_connect_timeout      90; #连接前面的服务器超时时间
                proxy_send_timeout         90; #请求转发数据报文的超时时间
                proxy_read_timeout         90; #读取超时时间
                proxy_buffer_size          4k; #缓冲区的大小
                proxy_buffers              4 32k; #
                proxy_busy_buffers_size    64k; #proxy_buffers缓冲区，网页平均在32k以下的
                proxy_temp_file_write_size 64k; #高负荷下缓冲大小（proxy_buffers*2）
                proxy_cookie_path /目标路径 /源路径
            }

            # 定义错误提示页面
            error_page   500 502 503 504 /50x.html;  
                location = /50x.html {
                root   /root;
            }

            #静态文件，nginx自己处理
            location ~ ^/(images|javascript|js|css|flash|media|static)/ {
                root    /var/www/virtual/htdocs;
                expires 30d; #过期30天
            }
            #PHP 脚本请求全部转发到 FastCGI处理. 使用FastCGI默认配置.
            location ~ \.php$ {
                root            /root;
                fastcgi_pass    127.0.0.1:9000;
                fastcgi_index   index.php;
                fastcgi_param   SCRIPT_FILENAME /home/www/www$fastcgi_script_name;
                include         fastcgi_params;
            }
            #设定查看Nginx状态的地址
            location /NginxStatus {
                stub_status             on;
                access_log              on;
                auth_basic              "NginxStatus";
                auth_basic_user_file    conf/htpasswd;
            }
            #禁止访问 .htxxx 文件
            location ~ /\.ht {
                deny all;
            }
        
        }
    }
  ```