
# 说明

为方便使用，本仓库直接把acg-faka的源码放到了acg-faka目录下。

当前源码版本:3.1.0（最新）

# 使用步骤

下载仓库后，进入仓库目录然后执行：

初始设置

```sh
# 先创建相关文件并给予权限
chmod +x backup.sh restore.sh

# 复制环境变量文件然后进行修改
cp .env.sample .env

# 运行
docker compose up -d --build

```

# 注意事项

由于acg-faka是php原生写的，而且使用过程中，上传的资产，下载的插件都在源码目录下。

所以建议在完成初始设置后，开一个私有仓库(fork)，并上传。

这样你的git有两个remote，一个是origin（原始的，只包含源码的），一个是你的私有仓库fork（源码基础上安装的插件，上传的资产）.

这样是为了在更新源码的时候，只合并源码修改到你的fork分支上，从而不破坏已经安装的插件、或者上传的资产。


# 更新Acg-Faka源码

按照注意事项中进行设置后，如果你想更新acg-faka的源码。请按照如下步骤：

1. 新的地方克隆一次本仓库。

2. 然后从[这里](https://github.com/lizhipay/acg-faka)下载最新acg-faka源码，下载后，把源码内容整体（除了.git）copy到acg-faka目录下。然后提交。

3. 在你之前的仓库（包含两个remote那个），获取origin远程的更新（就是获取上一步骤你更新的源码），然后合并origin仓库的源码到你的fork仓库里。这样就在不破坏当前结构的情况下完成了源码更新。

# 自动更新

手动更新容易出错，acg-faka提供自动更新源码，建议使用。

# 问题
一般都是权限问题。
如果更新了源码，记得 chmod -R 777 acg-faka

# 以下是原作者仓库

[https://github.com/luochuanyuewu/acg-faka-docker](https://github.com/luochuanyuewu/acg-faka-docker)