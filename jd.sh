#!/usr/bin/env bash
## jdmode
### 这是我尝试DIY的一个例子,应修改本脚本中FRUITSHARECODES类型的互助码后编辑 docker-compose.yml 为你自己DIY后的脚本地址再执行 docker-compose up -d
#### 懒得DIY的推荐使用lof的版本： https://github.com/iouAkira/someDockerfile/tree/master/dd_scripts (这也是我学习 jd docker1 代码的地方)

function getmycks(){
    # cookies文件位于维护宿主机 /jdmode/config/config.sh 或容器的 /jd/config/config.sh
    if [[ -s /jd/config/config.sh ]]; then
        grep -qE "pt_key" /jd/config/config.sh && echo 目前 /jd/config/config.sh 中配置了 $(grep -oE "pt_key" /jd/config/config.sh | wc -l) 个账号
    else
        echo 目前 /jd/config/config.sh 中暂未配置账号,将自动生成一个无效账号,待启动成功后记得配置哟
        echo 'mixool="pt_key=AA'${RANDOM}''${RANDOM}''${RANDOM}';pt_pin=jd_'${RANDOM}';"' >/jd/config/config.sh
    fi
}

function getjdclean(){
    cat <<'EOF' >/usr/local/bin/jdclean && chmod +x /usr/local/bin/jdclean
#!/bin/sh
### jdclean 清理

# 清理文件
find /tmp -type f -mtime +1 -delete
find /jd/log -type f -mtime +7 -delete

# 清理进程
if [[ $(date +%H) -eq 23 ]]; then
    kill -9 $(ps -ef | grep "/usr/local/bin/cknode" | head -5 | awk '{print $1}')
fi

EOF
}

function getcknode(){
    # 生成cknode命令
    cat <<'EOF' >/usr/local/bin/cknode && chmod +x /usr/local/bin/cknode
#!/bin/sh
### cknode 1@1-12 /jd/scripts/city.js  # 参数一的@说明：进程数 1 或者 2以上 (表示有多少ck就并发多少进程) @ 自己CK起止位: all 表示全部 5-3 时表示不加入 2-2 时表示仅加入第二个

TMPFILE=$(mktemp) && trap 'rm -f "${TMPFILE}*"' EXIT || exit 1
touch /jd/config/config.sh
####
# 自定义变量 内置助力码 | 重要: 应复制本脚本后按需修改以下 FRUITSHARECODES 等 export 变量的值后 再修改 /jdmode/docker-compose.yml 中 CUSTOM_SHELL_FILE 为你自己DIY后的脚本地址
# 自定义变量 内置助力码 | 后续可能会支持自动获取 /jd/log/xxxx.log 助力码的代码 | 目前请按需修改 | 目前请按需修改 | 目前请按需修改 | 目前请按需修改 | 目前请按需修改 | 目前请按需修改 
export FRUITSHARECODES="f13228268cab4da6b06e5b717f88d854&fa0686c04bb6470bb618567f36dd3fdc&1778471157f54aafbc1c7fdd9d2cc11b&53cd25698f0e4c308db30d5484c091a9&6c992b8533da44889f34e6b8017f9c90&48a0f522f2204f49babee3ee0e70a47f&41e0aa76cf964aa4bf60da6219413432&649644f4aca04e66a45a31df5eabc975&2c9939689d37415f8843fe990a947c8a"
export PETSHARECODES="MTE1NDQ5OTIwMDAwMDAwNDUwOTgyNzc=&MTEyNDI1MTYxMDAwMDAwMDQ3NTY0NjU3&MTE1NDUwMTI0MDAwMDAwMDQ1MTAyOTE3&MTE1NDQ5OTUwMDAwMDAwNDU0NzAxNTU=&MTEzMzI0OTE0NTAwMDAwMDA0NTE3OTM5NQ==&MTEzMzI0OTE0NTAwMDAwMDA0NTE3OTM5Nw==&MTAxNzIyNTU1NDAwMDAwMDA1MDA4ODgwMw=="
export PLANT_BEAN_SHARECODES="d62hypqurndgpiuzr2dom53a2a&k2i4xywcoaprb4iaxruzp6msgm&n6hqjq34lnnspchmemp5qjjfvi&4srjlxwmo6kaocjcf73dq7zqq2lshqafsujmwwa&lo3353pm4j5vum5yfy2eljqrjy&uxkp45y3vv37j33kyynhmowy745ac3f4ijdgqji&7jq2aw5joyku6y3b7asnptyhvofypsaqt7rctqi&2miggtckslgce4qmrglmp6ew6m&2miggtckslgcefnu6nu2yfuwhgcn4rkhc2gfrny"
export DREAM_FACTORY_SHARE_CODES="XHwrdUoKfQ1HcNpX6hFBWg==&nfA3tEazuZa2-thK7HSQNw==&n46IkadZmAEAHpqMBl0psg==&eyq60vBLzkcdgzetzlci-w==&yEJyc1ajvddawYTF87-6tA==&7Xv9C5cr2BjW5Qo2t_BEUg=="
export DDFACTORY_SHARECODES="T00866M3CltOCjVWnYaS5kRrbA&T0156qw6FE9QsBTTIR8CjVWnYaS5kRrbA&T0104qgiGltIqwCjVWnYaS5kRrbA&T0205KkcMldeiiy_VXm9yaR_CjVWnYaS5kRrbA&T0147KEiE0VEpAqffQCjVWnYaS5kRrbA&T0165KQiHkJAsA-GeUitCjVWnYaS5kRrbA&T022vf52QRkc8EnfIRn9lvYJdwCjVWnYaS5kRrbA&T0144qQsHkVAqwOFcgCjVWnYaS5kRrbA&T0224qQsHkVAqwOEeE-qyK5UIwCjVWnYaS5kRrbA"

# cdle 作者脚本支持的变量,自动匹配所有pt_pin
export angryBeanMode="priority"
export angryBeanPins="$(grep -oE "pt_pin=[^;]*" /jd/config/config.sh | cut -d= -f2 | tr "\n" "@" | sed "s/$//")"
export cashHelpPins="$(grep -oE "pt_pin=[^;]*" /jd/config/config.sh | cut -d= -f2 | tr "\n" "@" | sed "s/$//")"
export kois="$(grep -oE "pt_pin=[^;]*" /jd/config/config.sh | cut -d= -f2 | tr "\n" "@" | sed "s/$//")"
export dyjHelpPins="$(grep -oE "pt_pin=[^;]*" /jd/config/config.sh | cut -d= -f2 | tr "\n" "@" | sed "s/$//")"
export earn30Pins="$(grep -oE "pt_pin=[^;]*" /jd/config/config.sh | cut -d= -f2 | tr "\n" "@" | sed "s/$//")"

# cookies位置,可直接使用v4格式的config.sh
config_sh_file="/jd/config/config.sh"
cat $config_sh_file | grep -qE "pt_key" || { echo $config_sh_file 中没有CK; exit 1; }

# vars
[[ $# -ge 2 ]] && { varone="$1"; vartwo="$2"; } || { echo 参数错误; exit 1; }
# 进程数 1 或者 大于1 表示有多少ck就并发多少进程
varone_a=$(echo $varone | cut -d@ -f1)
[[ $varone_a -ge 1 ]] || { echo $varone 参数错误; exit 1; }
# CK起止位置
varone_b=$(echo $varone | cut -d@ -f2)
varone_b_one=$(echo $varone_b | cut -d- -f1)
varone_b_two=$(echo $varone_b | cut -d- -f2)

# 执行文件
filename=$(echo $vartwo | awk -F[/] '{printf $((NF))}')
if [[ -s $vartwo ]]; then
    if [[ -s /jd/scripts/$filename ]]; then
        cmp -s /jd/scripts/$filename $vartwo || cp -f $vartwo /jd/scripts/$filename
    else
        cp -f $vartwo /jd/scripts/$filename
    fi
else
    echo $vartwo is null. && exit 1
fi
vartwo="/jd/scripts/$filename"

# 生成CK列表
if [[ "$varone_b" != "all" ]]; then
    [[ $varone_b_one -ge 0 && $varone_b_two -ge 0 ]] || { echo $varone 参数错误; exit 1; }
    [[ $varone_b_two -ge $varone_b_one ]] && grep -oE "pt_key=.+;pt_pin=[^(\"|\;)]+" $config_sh_file | sed "s/$/&\;/g" | sed -n "${varone_b_one},${varone_b_two}p" >$TMPFILE
else
    grep -oE "pt_key=.+;pt_pin=[^(\"|\;)]+" $config_sh_file | sed "s/$/&\;/g" >$TMPFILE
fi

cknum=$(grep -c "" $TMPFILE)
echo 共有 $cknum CK && [[ $cknum == 0 ]] && exit 0

# log参数
log_name_dir="$(echo ${JD_DIR}/log/$(echo $vartwo | awk -F[/.] '{printf $((NF-1))}'))"
log_name_part_one="$(date +"%Y-%m-%d-%H-%M-%S")-${varone}.log"
mkdir -p $log_name_dir

# conc
if [[ $varone_a -gt 1 ]]; then
    for thisck in $(cat $TMPFILE); do
        { 
            export JD_COOKIE="$thisck" && node $vartwo 2>&1 | tee -a ${log_name_dir}/${log_name_part_one}
        } &
    done
    wait
    echo $cknum CK 并发 $cknum 个任务完成
else
    export JD_COOKIE="$(cat $TMPFILE | tr "\n" "&")" && node $vartwo 2>&1 | tee -a ${log_name_dir}/${log_name_part_one}
    echo $cknum CK 顺序任务完成
fi

echo done.
EOF
}

function author_base(){
    # jd_scripts
    if [[ -s /jd/scripts/package.json ]]; then
        cp -f /jd/scripts/package.json /jd/tmp/scripts_package.json
        cd /jd/scripts && git fetch --all && git reset --hard && git pull --rebase
        status_diff=$(diff /jd/scripts/package.json /jd/tmp/scripts_package.json -w)
        [[ "$status_diff" != "" ]] && npm install --prefix /jd/scripts
        [[ ! -d /jd/scripts/node_modules/async ]] && npm install --prefix /jd/scripts
    else
        rm -rf /jd/scripts
        git clone -b jd_scripts https://github.com/Aaron-lv/sync.git /jd/scripts
        npm install --prefix /jd/scripts
    fi
}

function author_raws(){
    mkdir -p /jd/tmp
    declare -A raws_list
    raws_list=(
[jd_cdle_angryBean.js]="https://raw.githubusercontent.com/cdle/jd_study/main/jd_angryBean.js"
[jd_cdle_earn30.js]="https://raw.githubusercontent.com/cdle/jd_study/main/jd_earn30.js"
[jd_cdle_dyj.js]="https://raw.githubusercontent.com/cdle/jd_study/main/jd_dyj_help.js"
[jd_cdle_angryCash.js]="https://raw.githubusercontent.com/cdle/jd_study/main/jd_angryCash.js"
[jd_cdle_angryKoi.js]="https://raw.githubusercontent.com/cdle/jd_study/main/jd_angryKoi.js"
[jd_cdle_cash_exchange.js]="https://raw.githubusercontent.com/cdle/jd_study/main/jd_cash_exchange.js"
)
    list_name=($(echo ${!raws_list[*]}))
    list_urls=($(echo  ${raws_list[*]}))
    for ((i=0; i<${#raws_list[*]}; i++)); do
        name="${list_name[i]}"
        urls="${list_urls[i]}"
        wget --no-cache --no-check-certificate -qO /jd/tmp/$name $urls
        [[ $? == 0 && -s "/jd/tmp/$name" ]] && cp -f /jd/tmp/$name /jd/scripts/$name || echo /jd/tmp/$name 下载失败 
    done
}

function cronlist_a(){
    # 添加基础仓库任务,替换运行命令为 cknode
    # grep -oE "(^[^#].*\ node\ .*\.js|^#[^\>]*)" /jd/scripts/docker/crontab_list.sh | sed "s/\ node\ \/scripts/\ cknode 1@all\ \/jd\/scripts/g" >/jd/config/cronlist
    # 添加仓库作者 cdle 任务
    cat <<'EOF' >/jd/config/cronlist
0 0 * * * cknode 1@all /jd/scripts/jd_cdle_angryBean.js
0 0 * * * cknode 1@all /jd/scripts/jd_cdle_earn30.js
0 0 * * * cknode 1@all /jd/scripts/jd_cdle_dyj.js
0 0 * * * cknode 1@all /jd/scripts/jd_cdle_angryCash.js
0 0 * * * cknode 1@all /jd/scripts/jd_cdle_angryKoi.js
0 0 * * * cknode 1@all /jd/scripts/jd_cdle_cash_exchange.js
EOF
    # 添加默认任务
    cat <<'EOF' >>/jd/config/cronlist
58 23 * * * jdclean
22 * * * * docker_entrypoint.sh
EOF
}

function main(){
    #
    getmycks
    getjdclean
    getcknode
    #
    author_base
    author_raws
    #
    cronlist_a
    crontab /jd/config/cronlist
}

main
