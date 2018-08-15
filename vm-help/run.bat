@echo off
:: VM虚拟机指导指南

echo 1. 创建ubuntu虚拟机，安装ubuntu镜像，如果一切就绪，保持虚拟机运行中，请继续下一步配置虚拟机信息
pause
echo.

echo "请确定VMRUN的位置，如 C:\Program Files (x86)\VMware\VMware VIX"
set /P _vm_run=
echo.

echo "请确定虚拟机文件的位置，如D:\image\dev\dev.vmx"
set /P _vmx_file=
echo.

echo "请确定用户名"
set /P _gu=
echo.

echo "请确定用户密码"
set /P _gp=
echo.

echo 如变量配置正常以及未显示命令不存在，请继续。如异常，请退出。
set _
echo.

if not exist "%_vmx_file%" ( 
	echo 指定虚拟机位置不存在，退出
	pause & exit
)

set "PATH=%_vm_run%;%PATH%"
echo ----vmrun list--------
vmrun list
echo ----------------------

echo set "PATH=%_vm_run%;%PATH%" > env.cmd
echo set "_vmx_file=%_vmx_file%" >> env.cmd
echo set "_gu=%_gu%" >> env.cmd
echo set "_gp=%_gp%" >> env.cmd

pause
::echo.
::echo 正在创建快照 create,请稍候...
::vmrun -T ws snapshot "%_vmx_file%" create
::echo.

call copy.bat
echo 2. 配置共享目录和安装vm-tools
echo 请手动在虚拟机配置始终开启共享文件，并挂载本地目录到虚拟机上
echo 请手动在虚拟机 /tmp 目录下执行install-vm-tool.sh脚本安装 VM-Tool
echo 脚本执行过程中会要求输入用户密码，然后重启
echo 重启完毕后，请继续下一步
pause
echo.
echo 正在创建快照 vm-init,请稍候...
vmrun -T ws snapshot "%_vmx_file%" vm-init
echo.

call copy.bat
echo 3. 执行ubuntu初始化脚本
echo 请手动在 /tmp/ 目录下执行 ubuntu-18.04.sh 脚本
echo 执行完毕请继续
pause
echo.
echo 正在创建快照 ubuntu-init,请稍候...
vmrun -T ws snapshot "%_vmx_file%" ubuntu-init
echo.

echo 4. 生成启动脚本 startup.bat，验证是否启动成功。
echo c:>startup.bat
echo cd %_vm_run% >> startup.bat
echo vmrun -T ws start "%_vmx_file%" nogui >> startup.bat
echo 添加到注册表，配置为开启启动
reg add HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run /v vmware /t REG_SZ /d %cd%\startup.bat /f 
echo 添加结果:
reg query HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run /v vmware
