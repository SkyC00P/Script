@echo off
:: VM�����ָ��ָ��

echo 1. ����ubuntu���������װubuntu�������һ�о�������������������У��������һ�������������Ϣ
pause
echo.

echo "��ȷ��VMRUN��λ�ã��� C:\Program Files (x86)\VMware\VMware VIX"
set /P _vm_run=
echo.

echo "��ȷ��������ļ���λ�ã���D:\image\dev\dev.vmx"
set /P _vmx_file=
echo.

echo "��ȷ���û���"
set /P _gu=
echo.

echo "��ȷ���û�����"
set /P _gp=
echo.

echo ��������������Լ�δ��ʾ������ڣ�����������쳣�����˳���
set _
echo.

if not exist "%_vmx_file%" ( 
	echo ָ�������λ�ò����ڣ��˳�
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
::echo ���ڴ������� create,���Ժ�...
::vmrun -T ws snapshot "%_vmx_file%" create
::echo.

call copy.bat
echo 2. ���ù���Ŀ¼�Ͱ�װvm-tools
echo ���ֶ������������ʼ�տ��������ļ��������ر���Ŀ¼���������
echo ���ֶ�������� /tmp Ŀ¼��ִ��install-vm-tool.sh�ű���װ VM-Tool
echo �ű�ִ�й����л�Ҫ�������û����룬Ȼ������
echo ������Ϻ��������һ��
pause
echo.
echo ���ڴ������� vm-init,���Ժ�...
vmrun -T ws snapshot "%_vmx_file%" vm-init
echo.

call copy.bat
echo 3. ִ��ubuntu��ʼ���ű�
echo ���ֶ��� /tmp/ Ŀ¼��ִ�� ubuntu-18.04.sh �ű�
echo ִ����������
pause
echo.
echo ���ڴ������� ubuntu-init,���Ժ�...
vmrun -T ws snapshot "%_vmx_file%" ubuntu-init
echo.

echo 4. ���������ű� startup.bat����֤�Ƿ������ɹ���
echo c:>startup.bat
echo cd %_vm_run% >> startup.bat
echo vmrun -T ws start "%_vmx_file%" nogui >> startup.bat
echo ��ӵ�ע�������Ϊ��������
reg add HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run /v vmware /t REG_SZ /d %cd%\startup.bat /f 
echo ��ӽ��:
reg query HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run /v vmware
