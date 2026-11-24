# Xbotics 具身智能视频课 · 动手代码

具身智能视频课的动手部分：每讲一个文件夹，里面一份 Jupyter notebook，都在星禾 SO-101 仿真（[Xbotics-SO101-Sim](https://github.com/Xbotics-Embodied-AI-club/Xbotics-SO101-Sim)）里运行。

## 每讲的 notebook

| 文件夹与 notebook | 讲次 | 做什么 |
| --- | --- | --- |
| `lecture01-intro/minimal_reach.py` | 第一讲 具身智能导论 | 最小闭环 Demo：从起点每步走一小段，误差小于阈值时停下（纯 Python，不用仿真）；`uv run python lecture01-intro/minimal_reach.py` |
| `lecture02-system-architecture/02-minimal-loop.ipynb` | 第二讲 机器人系统架构 | 最小闭环：读关节、换算两套单位、比例闭环、故意写错单位与顺序、记录回合 |
| `lecture03-body-structure/03-robot-model.ipynb` | 第三讲 机器人本体组成与运动结构 | 读机器人模型（URDF）：关节、转轴与限位；逐个转动关节；关节空间到末端空间 |
| `lecture04-control-kinematics/04-kinematics.ipynb` | 第四讲 机器人控制与运动学 | 正运动学与逆运动学：让夹爪停到方块正上方 |
| `lecture05-action-space/05-action-modes.ipynb` | 第五讲 动作空间与人形机器人 | 两种动作模式、每步上限与最大速度、归一化 |

代码每一行都有中文注释；每一步算出的数都和仿真给的真值（物体、料盒、夹爪中心的位姿，是否夹住）放在一起对答案。notebook 存下的输出（画面、曲线、记录）在同一个文件夹的 `out/` 里。

## 装环境：四步

要一台带 NVIDIA 显卡的 Ubuntu 24.04（已验证），装好 NVIDIA 驱动与 Vulkan 库（仿真的相机画面用显卡渲染）。

```bash
# 1 装 Python 环境管理工具 uv
curl -LsSf https://astral.sh/uv/install.sh | sh
# 2 取课程代码
git clone https://github.com/Xbotics-Embodied-AI-club/Xbotics-Embodied-AI-Video.git
# 3 装好星禾仿真、JupyterLab 与画图工具
cd Xbotics-Embodied-AI-Video && uv sync
# 4 起 JupyterLab
tools/jlab.sh
```

第 3 步按锁文件装到本目录的 `.venv`，每个人装出来的版本都一样，不动系统里已有的 Python；整个环境约 8 GB。
第 4 步起的 JupyterLab 只听本机，浏览器打开它打印的地址；端口与口令缺省是 8899 与 `xbrec`，要换就写 `tools/jlab.sh <端口> <口令>`。
装好以后先检查一遍：`uv run python tools/check_env.py`，它建方块场景、复位、走 10 步，把顶部相机的画面存到 `env-check.png`，画面里有方块、料盒和机械臂就说明仿真与渲染都能用。

## 目录

| 路径 | 内容 |
| --- | --- |
| `pyproject.toml`、`uv.lock` | 环境定义与锁文件：星禾仿真按提交钉在 Xbotics-SO101-Sim 上；torch 用 CUDA 12.8 的轮子 |
| `lectureNN-<名字>/` | 每讲一个文件夹（`NN` 是讲次）：这一讲的 notebook，与它存下的输出 `out/`（也是课件里用的那一份参考结果） |
| `tools/check_env.py` | 环境检查 |
| `tools/jlab.sh` | 起 JupyterLab：`tools/jlab.sh [端口 [口令]]` |

## 维护

- **加一讲**：新建文件夹 `lectureNN-<名字>/`，里面放 `NN-<名字>.ipynb`（`NN` 是讲次），代码每一行带中文注释，输出写到同一个文件夹的 `out/`；提交前清掉 notebook 里的输出。
- **升级仿真**：改 `pyproject.toml` 里 so101-sim 的 `rev`，`uv lock`，把各讲 notebook 从头跑一遍再提交。
- **加依赖**：只在 `pyproject.toml` 里加，`uv lock` 后提交锁文件；各讲共用这一个环境。

## 许可

[MIT](LICENSE)。
