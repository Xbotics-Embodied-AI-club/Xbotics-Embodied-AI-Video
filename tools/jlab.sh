#!/usr/bin/env bash
# 用本目录的环境起 JupyterLab（脱离终端、只听本机），notebook 目录就是本目录。
#   tools/jlab.sh [端口 [口令]]     端口缺省 8899，口令缺省 xbrec
# 该端口上已经有服务就直接用，不起第二份；30 秒内没有答应（端口被别的服务占着、口令对不上）就报错退出，日志在 .jlab-<端口>.log。
# 字体与字号：调用方设了 JUPYTERLAB_SETTINGS_DIR 就用那份设置（录课时指到放大了字号的设置），没设就用 JupyterLab 的默认。
set -euo pipefail
PORT=${1:-8899}
TOKEN=${2:-xbrec}
if ! [[ $PORT =~ ^[0-9]+$ ]]; then
  echo "ERROR 端口要写数字：$PORT（用法：tools/jlab.sh [端口 [口令]]）" >&2
  exit 2
fi
HERE=$(cd "$(dirname "$0")/.." && pwd)
LOG="$HERE/.jlab-$PORT.log"
URL="http://127.0.0.1:$PORT/lab?token=$TOKEN"
STATUS="http://127.0.0.1:$PORT/api/status?token=$TOKEN"
cd "$HERE"
# 已经在跑就不再起第二份：JupyterLab 遇到端口占用会悄悄换到下一个端口，录屏工具却只认计划里写的那个
if curl -s -o /dev/null --fail "$STATUS"; then
  echo "JupyterLab 已在运行：$URL"
  exit 0
fi
export WANDB_MODE=offline  # 环境里有训练框架时，不去连线上的实验记录服务
setsid nohup uv run --no-sync jupyter lab --no-browser --ip=127.0.0.1 --port="$PORT" --ServerApp.token="$TOKEN" \
  --ServerApp.root_dir="$HERE" --ServerApp.port_retries=0 --LabApp.news_url="" > "$LOG" 2>&1 < /dev/null &
# 等它答应：端口被别的服务占着（口令对不上）时起不来，要在这里报错，不能照样说「已启动」
for _ in $(seq 1 60); do
  if curl -s -o /dev/null --fail "$STATUS"; then
    echo "JupyterLab 已启动：$URL（日志 .jlab-$PORT.log）"
    exit 0
  fi
  sleep 0.5
done
echo "ERROR 30 秒内 JupyterLab 没有在端口 $PORT 上答应，日志末尾：" >&2
tail -n 8 "$LOG" >&2
exit 1
