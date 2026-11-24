"""检查动手环境：建星禾仿真环境、复位、走 10 步、存一张顶部相机画面。

    uv run python tools/check_env.py

这四步都过，说明仿真包、物理引擎和 GPU 渲染（SAPIEN 走 Vulkan）都能用。画面存到仓库根目录的 `env-check.png`（不进 git），要自己看一眼：
有桌面、方块、料盒和机械臂才算渲对。
"""
import logging
from pathlib import Path

import gymnasium as gym
import matplotlib.image
import so101_sim  # noqa: F401  导入即注册三个场景

logger = logging.getLogger("check_env")

ENV_ID = "SO101PickPlaceCube40-v1"
SEED = 1  # 种子 0 时方块在顶部相机里被机械臂挡住，种子 1 的画面里方块、料盒、机械臂各自分开
STEPS = 10
OUT = Path(__file__).resolve().parents[1] / "env-check.png"


def main() -> None:
    logging.basicConfig(level=logging.INFO, format="%(levelname)s %(message)s")
    env = gym.make(ENV_ID, obs_mode="rgb", control_mode="pd_joint_pos")  # 只要彩色画面（带分割图时台面会渲成黑色）
    obs, _ = env.reset(seed=SEED)
    hold = obs["agent"]["noisy_qpos"]  # pd_joint_pos 的动作是绝对目标：发当前关节角，机械臂保持不动（噪声默认关闭）
    for _ in range(STEPS):
        obs, _, _, _, _ = env.step(hold)
    top = obs["sensor_data"]["top"]["rgb"][0].cpu().numpy()
    matplotlib.image.imsave(OUT, top)
    logger.info("复位并走了 %d 步，顶部相机画面 %s → %s", STEPS, top.shape, OUT)
    env.close()


if __name__ == "__main__":
    main()
