### Git

#### 常用命令
##### 分支
* 查看全部分支 git branch -a
* 查看本地分支 git branch
* 创建本地分支 git branch 分支名称
* 提交本地分支到远端 git push origin 分支名称
* 删除本地分支 git branch -d 分支名称
* 强制删除本地分支 git branch -D 分支名称
* 删除远端分支 git push origin --delete 分支名称
* 合并分支 git merge 分支名称，注意，此语句的意思是将分支（分支名称）合并到当前分支
  * 比如 当前分分支是master， git merge dev就是将dev分支合并到master分支上。
  * 开发步骤如下
    * 切换到develop分支，git pull
    * git merge 你的工作代码分支
    * 此时是不可以合并的，需要组长合并，提交合并请求
    * ops 提交上线工单
