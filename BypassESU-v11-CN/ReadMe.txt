# Bypass ESU v11

* 一个为Windows 7和Server 2008 R2安装扩展安全更新的项目

* 它由三个功能组成:

- 修复WU引擎以允许接收ESU更新

- 禁止对系统更新（包括.NET 3.5.1）进行ESU资格检查

- 绕过NET验证以进行.NET 4更新（4.5.2至4.8）

______________________________

## 重要笔记:

* 此版本将删除.NET 4 ESU 绕开 的早期版本（如果检测到）。

* 确保未禁用“ Windows Management Instrumentation（winmgmt）”服务

* 使用WU ESU 修复 之后，如果仍然没有提供ESU更新，请尝试:

> 重新启动，然后检查WU

> 停止wuauserv服务，删除文件夹“ C：\ Windows \ SoftwareDistribution”，重新启动，然后检查WU

* 您还可以从Microsoft Update目录手动获取和下载更新。  
https://www.catalog.update.microsoft.com

要跟踪更新的KB编号，请查看官方的“更新历史记录”页面  
https://support.microsoft.com/en-us/help/4009469

或遵循此MDL线程  
https://forums.mydigitallife.net/threads/19461/

* 每个月的ESU更新将（至少）需要上个月的最新扩展SSU  

例如  
2020年4月更新至少需要3月SSU
2020年5月更新至少需要4月SSU  
2020年6月更新至少需要5月SSU
2020年7月更新将需要5月SSU或6月SSU（如果有） 
等等...

* 除非您集成ESU 破解，否则离线不支持ESU更新（您不能将它们集成），它们必须在线安装在实时系统上。

* 将7z包内容提取到具有简单路径的文件夹中，例如 C:\files\BypassESU

* 暂时关闭防病毒保护（如果有），或排除提取的文件夹

______________________________

## 推荐更新

对于Live OS安装，最好在使用BypassESU之前安装以下更新：

- KB4490628: 服务堆栈更新, 2019年三月
x86
http://download.windowsupdate.com/c/msdownload/update/software/secu/2019/03/windows6.1-kb4490628-x86_3cdb3df55b9cd7ef7fcb24fc4e237ea287ad0992.msu
x64
http://download.windowsupdate.com/c/msdownload/update/software/secu/2019/03/windows6.1-kb4490628-x64_d3de52d6987f7c8bdc2c015dca69eac96047c76e.msu

- KB4474419: SHA-2代码签名支持更新，2019年9月
x86
http://download.windowsupdate.com/c/msdownload/update/software/secu/2019/09/windows6.1-kb4474419-v3-x86_0f687d50402790f340087c576886501b3223bec6.msu
x64
http://download.windowsupdate.com/c/msdownload/update/software/secu/2019/09/windows6.1-kb4474419-v3-x64_b5614c6cea5cb4e198717789633dca16308ef79c.msu

- 最新的扩展服务堆栈更新KB4555449（2020年5月）或更高版本
x86
http://download.windowsupdate.com/c/msdownload/update/software/secu/2020/04/windows6.1-kb4555449-x86_36683b4af68408ed268246ee3e89772665572471.msu
x64
http://download.windowsupdate.com/c/msdownload/update/software/secu/2020/04/windows6.1-kb4555449-x64_92202202c3dee2f713f67adf6622851b998c6780.msu

- KB4575903: ESU许可准备软件包（仅通过WU获得更新才需要）
x86
http://download.windowsupdate.com/d/msdownload/update/software/secu/2020/07/windows6.1-kb4575903-x86_5905c774f806205b5d25b04523bb716e1966306d.msu
x64
http://download.windowsupdate.com/d/msdownload/update/software/secu/2020/07/windows6.1-kb4575903-x64_b4d5cf045a03034201ff108c2802fa6ac79459a1.msu

- 更新了Windows Update客户端，至少KB3138612
x86
http://download.windowsupdate.com/d/msdownload/update/software/updt/2016/02/windows6.1-kb3138612-x86_6e90531daffc13bc4e92ecea890e501e807c621f.msu
x64
http://download.windowsupdate.com/d/msdownload/update/software/updt/2016/02/windows6.1-kb3138612-x64_f7b1de8ea7cf8faf57b0138c4068d2e899e2b266.msu

如果您安装了任何“每月质量汇总”或2016年7月更新汇总KB3172605，则两者都已经更新了WUC

如果您安装了2020年1月仅安全更新KB4534314或修复程序更新KB4539602，则两者都已经更新了WUC

______________________________

## 如何使用-Live OS安装

* 安装建议的更新（如果需要，请重新启动）

* 右键单击LiveOS-Setup.cmd，然后单击“以管理员身份运行”  

* 从菜单中，按所需选项的相应数字:

[1] 完全集成 {ESU 破解 + WU ESU 修复 + .NET 4 ESU 绕过}  
最推荐的选择

[2] 安装 ESU 破解
主要用于仅安全更新的用户，这些用户不需要通过WU进行每月汇总

[3] 安装 WU ESU 修复
这仅允许通过WU提供ESU更新

[7] 安装 .NET 4 ESU 绕过  
这允许安装NDP4 ESU更新（手动或通过WU）

* 评论:

- 仅当未同时安装WU ESU 修复 / .NET 4 ESU绕过和/或破解时，才获得选项[1]

- 安装ESU更新后无法卸载ESU 破解，并且在这种情况下不显示选项[5]

- 警告：除非您安装了另一个绕过，否则，如果单独使用选项[3]，则ESU更新安装将失败。

______________________________

## How to Use - Offline Image/Wim Integration

* Wim-Integration.cmd支持两种目标类型以集成BypassESU：

[1] 直接WIM文件（未安装），install.wim或boot.wim

[2] 已挂载的映像目录，或已部署在另一个分区/驱动器上的脱机映像/vhd

___
** 直接WIM文件集成 **

- 将install.wim或boot.wim（其中一个，而不是两个）放在Wim-Integration.cmd旁边，然后以管理员身份运行脚本

- 或者，以管理员身份运行脚本，并在出现提示时输入wim文件的完整路径。

- 从菜单中选择所需的选项（类似于实时设置）

- 关于此方法的注意事项： 

如果它位于install.wim中，它还将为winre.wim集成破解。

它不提供删除破解 / 修复 / .NET 绕过的选项，为此，挂载WiM映像，然后使用第二种方法

___
** 挂载目录/离线映像集成 **

- 手动挂载install.wim或boot.wim的映像  
如果映像已经部署在另一个分区/驱动器/ vhd上，则无需执行此步骤 Z:\

- 无需集成建议的更新，您可以先集成BypassESU

- 右键单击Wim-Integration.cmd，然后单击“以管理员身份运行”

- 输入安装目录或脱机映像驱动器号的正确路径

- 从菜单中选择所需的选项（类似于实时设置）

- 之后，继续集成更新，包括ESU更新

- 手动卸载install.wim / boot.wim映像并提交更改

______________________________

## Credits

* IMI Kurwica  
- mspaintmsi (superUser)  
* abbodi1406 (Project scripts)

## 汉化
荣耀：QQ：1800619
网站：nat.ee
QQ群：6281379
